import Foundation

class RotateCameraUseCase {
    private let cameraController: CameraController
    
    init(cameraController: CameraController) {
        self.cameraController = cameraController
    }
    
    func rotate(with orientation: CameraOrientation) {
        cameraController.rotate(with: orientation)
    }
}

public enum CameraOrientation {
    case portrait
    case portraitUpsideDown
    case landscapeRight
    case landscapeLeft
}
