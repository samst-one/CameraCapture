import AVFoundation

protocol CameraSesion {
    func removeAllInputs()
    func addInput(with id: String)
    func start(completion: @MainActor @escaping () -> ())
    var selectedCamera: Device? { get }
    var hasCamera: Bool { get }
    var hasStarted: Bool { get }
}

class AVCameraSession: CameraSesion {
    private let captureSession: AVCaptureSession
    
    var hasStarted: Bool {
        captureSession.isRunning
    }
    
    var hasCamera: Bool {
        captureSession.inputs.count >= 1
    }
    
    var selectedCamera: Device? {
        guard let camera = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return nil
        }
        return AVCaptureDeviceToCameraAdapter.adapt(device: camera.device)
    }
    
    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    func removeAllInputs() {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
    }
    
    func addInput(with id: String) {
        guard let device = AVCaptureDevice(uniqueID: id),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        captureSession.sessionPreset = .high
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
            if captureSession.canSetSessionPreset(.hd4K3840x2160) {
                captureSession.sessionPreset = .hd4K3840x2160
            } else if captureSession.canSetSessionPreset(.hd1920x1080) {
                captureSession.sessionPreset = .hd1920x1080
            } else {
                captureSession.sessionPreset = .high
            }
        }
    }
    
    func start(completion: @MainActor @escaping () -> ()) {
        Task {
            captureSession.startRunning()
            await completion()
        }
    }
}
