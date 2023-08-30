import AVFoundation

protocol CameraSesion {
    func removeAllInputs()
    func addInput(with id: String)
    func start(completion: @MainActor @escaping () -> ())
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
        captureSession.addInput(captureDeviceInput)
    }
    
    func start(completion: @MainActor @escaping () -> ()) {
        Task {
            captureSession.startRunning()
            await completion()
        }
    }
}
