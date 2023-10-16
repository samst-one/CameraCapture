import UIKit
import AVFoundation

/**
 Factory for producing ``Camera``.
 
 This factory produces the public API for this package via the ``make()`` function. The API is in the ``Camera`` object.
*/
public enum CameraFactory {
    
    /**
     Produces the public API for the `Camera`package.
     
     This function returns the API for the `Camera` package in the form of the ``Camera``.
     */
    public static func make() -> Camera {
        let avCaptureSession = AVCaptureSession()
        
        let photoOutput = AVCapturePhotoOutput()
        avCaptureSession.addOutput(photoOutput)
        let previewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        previewLayer.videoGravity = .resizeAspect
        let flashDataSource = DefaultFlashDataSource()
        let cameraSession = AVCameraSession(captureSession: avCaptureSession, flashDataSource: flashDataSource)
        let cameraController = AVCameraController(photoOutput: photoOutput)
        let dataSource = AVCaptureDeviceDataSource(captureSession: avCaptureSession, flashDataSource: flashDataSource)
        let zoomController = AVZoomController(session: avCaptureSession)
        let setZoomUseCase = SetZoomUseCase(zoomController: zoomController,
                                            dataSource: dataSource)
        let retrieveCamerasUseCase = RetrieveAvailableCamerasUseCase(dataSource: dataSource)
        let presenter = DefaultPresenter(setZoomUseCase: setZoomUseCase,
                                         retrieveSelectedCameras: retrieveCamerasUseCase,
                                         focusUseCase: FocusUseCase(focusController: AVFocusController(session: avCaptureSession)),
                                         rotateCameraUseCase: RotateCameraUseCase(cameraController: cameraController))
        let setCameraUseCase = SetCameraUseCase(cameraSesion: cameraSession,
                                                dataSource: dataSource)
        let previewView = PreviewView(previewLayer: previewLayer,
                                      presenter: presenter)
        let takePhotosUseCase = TakePhotoUseCase(controller: cameraController, session: cameraSession, flashDataSource: flashDataSource)
        let startCameraUseCase = StartCameraUseCase(session: cameraSession)
        let setFlashStateUseCase = SetFlashStateUseCase(session: cameraSession,
                                                        dataSource: flashDataSource)
        presenter.set(previewView)
        
        let setCameraObserver = PresenterSetCameraObserver(presenter: presenter)
        setCameraUseCase.add(setCameraObserver)
        
        return DefaultCamera(previewView: previewView,
                             setCameraUseCase: setCameraUseCase,
                             retrieveCameraUseCase: retrieveCamerasUseCase,
                             takePhotosUseCase: takePhotosUseCase,
                             startCameraUseCase: startCameraUseCase,
                             setFlashStateUseCase: setFlashStateUseCase,
                             setZoomUseCase: setZoomUseCase)
    }
}


