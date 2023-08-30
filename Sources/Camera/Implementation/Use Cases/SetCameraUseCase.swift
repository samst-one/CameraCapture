import Foundation

class SetCameraUseCase {
    private let cameraSesion: CameraSesion
    private let repo: CameraRepo
    
    init(cameraSesion: CameraSesion,
         repo: CameraRepo) {
        self.cameraSesion = cameraSesion
        self.repo = repo
    }
    
    func set(_ cameraId: String) throws {
        guard repo.getCamera(with: cameraId) != nil else {
            throw CameraSourcingError.invalidCamera
        }
        cameraSesion.removeAllInputs()
        cameraSesion.addInput(with: cameraId)
    }
}

enum CameraSourcingError: Error {
    case invalidCamera
}
