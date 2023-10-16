import AVKit

protocol DataSource {
    var cameras: [Device] { get }
    var selectedCamera: Device? { get }
    func getCamera(with id: String) -> Device?
}

class AVCaptureDeviceDataSource: DataSource {
    
    private let captureSession: AVCaptureSession
    private let flashDataSource: FlashDataSource

    init(captureSession: AVCaptureSession,
         flashDataSource: FlashDataSource) {
        self.captureSession = captureSession
        self.flashDataSource = flashDataSource
    }
    
    var cameras: [Device] {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera,
                                                                                    .builtInDualWideCamera,
                                                                                    .builtInTripleCamera,
                                                                                    .builtInWideAngleCamera,
                                                                                    .builtInTelephotoCamera,
                                                                                    .builtInUltraWideCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        let cameras = deviceDiscoverySession.devices.compactMap { device in
            return AVCaptureDeviceToCameraAdapter.adapt(device: device, flashDataSource: flashDataSource)
        }
        
        return cameras
    }
    
    var selectedCamera: Device? {
        guard let camera = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return nil
        }
        return AVCaptureDeviceToCameraAdapter.adapt(device: camera.device, flashDataSource: flashDataSource)
    }
    
    func getCamera(with id: String) -> Device? {
        return cameras.first(where: { $0.id == id })
    }
}
