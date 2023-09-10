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
        avCaptureSession.sessionPreset = .photo
        let photoOutput = AVCapturePhotoOutput()
        avCaptureSession.addOutput(photoOutput)
        let previewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        let cameraSession = AVCameraSession(captureSession: avCaptureSession)
        let cameraController = AVCameraController(photoOutput: photoOutput)
        let flashController = AVFlashController(session: avCaptureSession)
        let dataSource = AVCaptureDeviceDataSource(captureSession: avCaptureSession)
        let zoomController = AVZoomController(session: avCaptureSession)
        let viewModel = ViewModel(currentZoom: 1)
        let setZoomUseCase = SetZoomUseCase(zoomController: zoomController,
                                            session: cameraSession)
        let retrieveCamerasUseCase = RetrieveAvailableCamerasUseCase(dataSource: dataSource)
        let presenter = DefaultPresenter(setZoomUseCase: setZoomUseCase,
                                         retrieveSelectedCameras: retrieveCamerasUseCase)
        let setCameraUseCase = SetCameraUseCase(cameraSesion: cameraSession,
                                                dataSource: dataSource)
        let previewView = PreviewView(previewLayer: previewLayer,
                                      presenter: presenter,
                                      viewModel: viewModel)
        let takePhotosUseCase = TakePhotoUseCase(controller: cameraController, session: cameraSession)
        let startCameraUseCase = StartCameraUseCase(session: cameraSession)
        let setFlashStateUseCase = SetFlashStateUseCase(flashController: flashController,
                                                      session: cameraSession)
        
        return DefaultCamera(previewView: previewView,
                             setCameraUseCase: setCameraUseCase,
                             retrieveCameraUseCase: retrieveCamerasUseCase,
                             takePhotosUseCase: takePhotosUseCase,
                             startCameraUseCase: startCameraUseCase,
                             setFlashStateUseCase: setFlashStateUseCase,
                             setZoomUseCase: setZoomUseCase)
    }
}


