import Foundation

class SetFlashStateUseCase {
    
    private let flashController: FlashController
    private let session: CameraSesion
    
    init(flashController: FlashController,
         session: CameraSesion) {
        self.flashController = flashController
        self.session = session
    }
    
    func setFlashState(isOn: Bool) {
        isOn ? turnOn() : turnOff()
    }
    
    private func turnOff() {
        guard let selectedCamera = session.selectedCamera else {
            return
        }
        if selectedCamera.isFlashOn {
            flashController.turnOffFlash(for: selectedCamera.id)
        }
    }
    
    private func turnOn() {
        guard let selectedCamera = session.selectedCamera else {
            return
        }
        if selectedCamera.hasFlash {
            flashController.turnOnFlash(for: selectedCamera.id)
        }
    }
}
