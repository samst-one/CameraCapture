import Foundation

protocol Presenter {
    func didZoomTo(_ scale: CGFloat)
}

class DefaultPresenter: Presenter {
    
    private let setZoomUseCase: SetZoomUseCase
    private let retrieveSelectedCameras: RetrieveAvailableCamerasUseCase
    
    init(setZoomUseCase: SetZoomUseCase,
         retrieveSelectedCameras: RetrieveAvailableCamerasUseCase) {
        self.setZoomUseCase = setZoomUseCase
        self.retrieveSelectedCameras = retrieveSelectedCameras
    }

    func didZoomTo(_ scale: CGFloat) {
        guard let selectedCamera = retrieveSelectedCameras.selectedCamera else {
            return
        }
        try? setZoomUseCase.zoomWith(magnificationLevel: ZoomScaleToMultiplication.adapt(deviceType: selectedCamera.type,
                                                                                         scale: scale * (ZoomMultiplcationToScale.adapt(deviceType: selectedCamera.type,
                                                                                                                                        multiplier: selectedCamera.currentZoom))))
    }
}
