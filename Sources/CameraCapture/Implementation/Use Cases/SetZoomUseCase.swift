import Foundation

class SetZoomUseCase {
    
    private let zoomController: ZoomController
    private var observers: [ZoomObserver] = []
    private let dataSource: DataSource
    
    init(zoomController: ZoomController, dataSource: DataSource) {
        self.zoomController = zoomController
        self.dataSource = dataSource
    }
    
    func zoomWith(magnificationLevel: Double) throws {
        guard let selectedCamera = dataSource.selectedCamera else {
            throw ZoomError.noSelectedCamera
        }
        
        if magnificationLevel <= (selectedCamera.maxZoom) &&
            magnificationLevel >= (selectedCamera.minZoom){
            do {
                try zoomController.zoom(to: ZoomMultiplcationToScale.adapt(deviceType: selectedCamera.type, multiplier: magnificationLevel))
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
