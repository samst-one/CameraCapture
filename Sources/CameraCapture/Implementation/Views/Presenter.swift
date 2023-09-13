import Foundation

protocol Presenter {
    func didZoomTo(_ scale: CGFloat)
    func didFocus(at point: CGPoint)
    func didSetCamera()
}

class DefaultPresenter: Presenter {
    
    private let setZoomUseCase: SetZoomUseCase
    private let retrieveSelectedCameras: RetrieveAvailableCamerasUseCase
    private let focusUseCase: FocusUseCase
    private var view: Viewable?
    
    init(setZoomUseCase: SetZoomUseCase,
         retrieveSelectedCameras: RetrieveAvailableCamerasUseCase,
         focusUseCase: FocusUseCase) {
        self.setZoomUseCase = setZoomUseCase
        self.retrieveSelectedCameras = retrieveSelectedCameras
        self.focusUseCase = focusUseCase
    }
    
    func set(_ view: Viewable) {
        self.view = view
    }

    func didZoomTo(_ scale: CGFloat) {
        guard let selectedCamera = retrieveSelectedCameras.selectedCamera else {
            return
        }
        try? setZoomUseCase.zoomWith(magnificationLevel: ZoomScaleToMultiplication.adapt(deviceType: selectedCamera.type,
                                                                                         scale: scale * (ZoomMultiplcationToScale.adapt(deviceType: selectedCamera.type,
                                                                                                                                        multiplier: selectedCamera.currentZoom))))
    }
    
    func didFocus(at point: CGPoint) {
        focusUseCase.focus(at: point)
    }
    
    func didSetCamera() {
        view?.didSetCamera()
    }
}
