import AVFoundation

protocol FocusController {
    func focus(at point: CGPoint) throws
}

class AVFocusController: FocusController {
    
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func focus(at point: CGPoint) throws {
        guard let camera = session.inputs.first as? AVCaptureDeviceInput else {
            throw ZoomError.noSelectedCamera
        }
        
        let device = camera.device
        
        guard device.isFocusPointOfInterestSupported, device.isExposurePointOfInterestSupported else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            device.focusPointOfInterest = point
            device.exposurePointOfInterest = point
            
            device.focusMode = .continuousAutoFocus
            device.exposureMode = .continuousAutoExposure
            
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
