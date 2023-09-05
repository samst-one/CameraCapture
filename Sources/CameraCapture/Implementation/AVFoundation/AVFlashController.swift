import AVFoundation

protocol FlashController {
    func turnOnFlash(for deviceId: String)
    func turnOffFlash(for deviceId: String)
}

class AVFlashController: FlashController {
    
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func turnOnFlash(for deviceId: String) {
        guard let camera = getDevice(for: deviceId) else { return }
        
        let _ = try? camera.lockForConfiguration()
        let _ = try? camera.setTorchModeOn(level: 1.0)
        
        camera.unlockForConfiguration()
    }
    
    func turnOffFlash(for deviceId: String) {
        guard let camera = getDevice(for: deviceId) else { return }
        
        let _ = try? camera.lockForConfiguration()
        camera.torchMode = AVCaptureDevice.TorchMode.off

        camera.unlockForConfiguration()
    }
    
    private func getDevice(for deviceId: String) -> AVCaptureDevice? {
        guard let input = AVCaptureDevice(uniqueID: deviceId),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: input) else {
            return nil
        }
        return captureDeviceInput.device
    }
}
