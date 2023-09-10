import AVFoundation

protocol ZoomController {
    func zoom(to value: Double) throws
}

class AVZoomController: ZoomController {
    
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func zoom(to value: Double) throws {
        guard let camera = session.inputs.first as? AVCaptureDeviceInput else {
            throw ZoomError.noSelectedCamera
        }
        
        do {
            let _ = try camera.device.lockForConfiguration()
            
            camera.device.videoZoomFactor = value
            
            camera.device.unlockForConfiguration()
        } catch {
            throw ZoomError.unableToLockCamera
        }

    }
}
