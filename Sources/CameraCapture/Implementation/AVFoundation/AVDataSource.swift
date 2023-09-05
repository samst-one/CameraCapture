import AVKit

protocol DataSource {
    var cameras: [Device] { get }
    var selectedCamera: Device? { get }
    func getCamera(with id: String) -> Device?
}

class AVCaptureDeviceDataSource: DataSource {
    
    private let captureSession: AVCaptureSession

    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    var cameras: [Device] {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                                    .builtInTelephotoCamera,
                                                                                    .builtInUltraWideCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        let cameras: [Device] = deviceDiscoverySession.devices.compactMap { device in
            return AVCaptureDeviceToCameraAdapter.adapt(device: device)
        }
        
        return cameras
    }
    
    var selectedCamera: Device? {
        guard let camera = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return nil
        }
        return AVCaptureDeviceToCameraAdapter.adapt(device: camera.device)
    }
    
    func getCamera(with id: String) -> Device? {
        return cameras.first(where: { $0.id == id })
    }
}
