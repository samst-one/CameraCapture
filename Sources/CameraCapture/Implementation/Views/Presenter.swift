import Foundation

protocol Presenter {
    func didZoomTo(_ scale: CGFloat, previousZoom: Double)
}

class DefaultPresenter: Presenter {
    
    private let setZoomUseCase: SetZoomUseCase
    private let retrieveSelectedCameras: RetrieveAvailableCamerasUseCase
    
    init(setZoomUseCase: SetZoomUseCase,
         retrieveSelectedCameras: RetrieveAvailableCamerasUseCase) {
        self.setZoomUseCase = setZoomUseCase
        self.retrieveSelectedCameras = retrieveSelectedCameras
    }

    func didZoomTo(_ scale: CGFloat, previousZoom: Double) {
        guard let selectedCamera = retrieveSelectedCameras.selectedCamera else {
            return
        }
        do {
            try setZoomUseCase.zoomWith(scale: scale * (selectedCamera.currentZoom / 0.5))
        } catch let error {
            print(error.localizedDescription + "\(scale)")
        }
    }
}
