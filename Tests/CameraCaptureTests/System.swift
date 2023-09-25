import XCTest
@testable import CameraCapture

class System {
    
    let setCameraUseCase: SetCameraUseCase
    let focusUseCase: FocusUseCase
    let observer: PresenterSetCameraObserver
    let presenter: DefaultPresenter
    let view = SpyView()
    let dataSource = MockDataSource()
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    let cameraController = SpyCameraController()
    let flashController = SpyFlashController()
    let zoomController = SpyZoomController()
    let focusController = SpyFocusController()
    
    var camera: Camera!
    
    init() {
        let setZoomUseCase = SetZoomUseCase(zoomController: zoomController,
                                            dataSource: dataSource)
        let retrieveAvailableCamerasUseCase = RetrieveAvailableCamerasUseCase(dataSource: dataSource)
        focusUseCase = FocusUseCase(focusController: focusController)
        presenter = DefaultPresenter(setZoomUseCase: setZoomUseCase,
                                     retrieveSelectedCameras: retrieveAvailableCamerasUseCase,
                                     focusUseCase: focusUseCase,
                                     rotateCameraUseCase: RotateCameraUseCase(cameraController: cameraController))
        
        observer = PresenterSetCameraObserver(presenter: presenter)
        setCameraUseCase = SetCameraUseCase(cameraSesion: session,
                                            dataSource: dataSource)
        setCameraUseCase.add(observer)
        presenter.set(view)
        
        camera = DefaultCamera(previewView: UIView(),
                               setCameraUseCase: setCameraUseCase,
                               retrieveCameraUseCase: retrieveAvailableCamerasUseCase,
                               takePhotosUseCase: TakePhotoUseCase(controller: cameraController,
                                                                   session: session),
                               startCameraUseCase: StartCameraUseCase(session: session),
                               setFlashStateUseCase: SetFlashStateUseCase(flashController: flashController,
                                                                          session: session),
                               setZoomUseCase: SetZoomUseCase(zoomController: zoomController, dataSource: dataSource))
    }
}

class SpyView: Viewable {
    var setCameraCalled = 0
    func didSetCamera() {
        setCameraCalled += 1
    }
}

class SpyFocusController: FocusController {
    var focusPoint: CGPoint?
    func focus(at point: CGPoint) throws {
        self.focusPoint = point
    }
}
