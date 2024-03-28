import Foundation

class TakePhotoUseCase {
    
    private let controller: CameraController
    private let captureHandler = CaptureHandler()
    private let session: CameraSesion
    private let flashDataSource: FlashDataSource
    
    init(controller: CameraController,
         session: CameraSesion,
         flashDataSource: FlashDataSource) {
        self.controller = controller
        self.session = session
        self.flashDataSource = flashDataSource
    }
    
    func takePhoto(with settings: CameraSettings, completion: @escaping (Result<Data, PhotoCaptureError>) -> ()) {
        guard let selectedCamera = session.selectedCamera else {
            completion(.failure(PhotoCaptureError.noCameraSet))
            return
        }

        if session.hasStarted {
            captureHandler.set(completion)
            controller.takePhoto(with: settings, flashState: flashDataSource.get(deviceId: selectedCamera.id), handler: captureHandler)
        } else {
            completion(.failure(.cameraNotStarted))
        }
    }
}
