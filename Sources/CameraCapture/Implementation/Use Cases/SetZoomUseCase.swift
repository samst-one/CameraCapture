import Foundation

class SetZoomUseCase {
    
    private let zoomController: ZoomController
    private var observers: [ZoomObserver] = []
    private let session: CameraSesion
    
    init(zoomController: ZoomController, session: CameraSesion) {
        self.zoomController = zoomController
        self.session = session
    }
    
    func zoomWith(magnificationLevel: Double) throws {
        guard let selectedCamera = session.selectedCamera else {
            return
        }
        
        if magnificationLevel <= (selectedCamera.maxZoom) &&
            magnificationLevel >= (selectedCamera.minZoom){
            do {
                try zoomController.zoom(to: magnificationLevel / 0.5)
            } catch let error as ZoomError {
                throw error
            } catch {
                throw ZoomError.unknownError
            }
        } else {
            throw ZoomError.zoomOutsideOfBounds
        }
        
        for observer in observers {
            observer.didUpdateZoom(to: magnificationLevel)
        }
    }
    
    func zoomWith(scale: Double) throws {
        try zoomWith(magnificationLevel: scale * 0.5)
    }
    
    func add(observer: ZoomObserver) {
        observers.append(observer)
    }
}

enum ZoomError: Error {
    case unknownError
    case unableToLockCamera
    case noSelectedCamera
    case zoomOutsideOfBounds
}
