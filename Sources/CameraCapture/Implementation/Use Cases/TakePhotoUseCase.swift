import Foundation

class TakePhotoUseCase {
    
    private let controller: CameraController
    private let captureHandler = CaptureHandler()
    private let session: CameraSesion
    
    init(controller: CameraController,
         session: CameraSesion) {
        self.controller = controller
        self.session = session
    }
    
    func takePhoto(with settings: CameraSettings, completion: @escaping (Result<Data, PhotoCaptureError>) -> ()) {
        if !session.hasCamera {
            completion(.failure(PhotoCaptureError.noCameraSet))
            return
        }
        if session.hasStarted {
            captureHandler.set(completion)
            controller.takePhoto(with: settings, handler: captureHandler)
        } else {
            completion(.failure(.cameraNotStarted))
        }
    }
}


