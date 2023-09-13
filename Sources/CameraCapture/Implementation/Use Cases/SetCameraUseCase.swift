import Foundation

class SetCameraUseCase {
    private let cameraSesion: CameraSesion
    private let dataSource: DataSource
    private var observers: [SetCameraObserver] = []
    
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
        
        for observer in observers {
            observer.didSetCamera()
        }
    }
    
    func add(_ observer: SetCameraObserver) {
        observers.append(observer)
    }
}

protocol SetCameraObserver {
    func didSetCamera()
}

class PresenterSetCameraObserver: SetCameraObserver {
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func didSetCamera() {
        presenter.didSetCamera()
    }
}

enum CameraSourcingError: Error {
    case invalidCamera
}
