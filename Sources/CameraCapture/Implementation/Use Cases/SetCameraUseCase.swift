import Foundation

class SetCameraUseCase {
    private let cameraSesion: CameraSesion
    private let dataSource: DataSource
    
    init(cameraSesion: CameraSesion,
         dataSource: DataSource) {
        self.cameraSesion = cameraSesion
        self.dataSource = dataSource
    }
    
    func set(_ cameraId: String) throws {
        guard dataSource.getCamera(with: cameraId) != nil else {
            throw CameraSourcingError.invalidCamera
        }
        cameraSesion.removeAllInputs()
        cameraSesion.addInput(with: cameraId)
    }
}

enum CameraSourcingError: Error {
    case invalidCamera
}
