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
        previewLayer.videoGravity = .resizeAspect
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        
        let cameraSession = AVCameraSession(captureSession: avCaptureSession)
        let cameraController = AVCameraController(photoOutput: photoOutput)
        let dataSource = AVCaptureDeviceDataSource()
        let cameraRepo = CameraRepo(dataSource: dataSource)
        let setCameraUseCase = SetCameraUseCase(cameraSesion: cameraSession,
                                                repo: cameraRepo)
        let previewView = PreviewView(previewLayer: previewLayer)
        let retrieveCamerasUseCase = RetrieveAvailableCamerasUseCase(repo: cameraRepo)
        let takePhotosUseCase = TakePhotoUseCase(controller: cameraController, session: cameraSession)
        let startCameraUseCase = StartCameraUseCase(session: cameraSession)
        
        return DefaultCamera(previewView: previewView,
                             setCameraUseCase: setCameraUseCase,
                             retrieveCameraUseCase: retrieveCamerasUseCase,
                             takePhotosUseCase: takePhotosUseCase,
                             startCameraUseCase: startCameraUseCase)
    }
}


