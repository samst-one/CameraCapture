import UIKit

class DefaultCamera: Camera {
    var previewView: UIView
    var availableDevices: [Device] {
        retrieveCameraUseCase.get()
    }
    private let setCameraUseCase: SetCameraUseCase
    private let retrieveCameraUseCase: RetrieveAvailableCamerasUseCase
    private let takePhotosUseCase: TakePhotoUseCase
    private let startCameraUseCase: StartCameraUseCase
    
    init(previewView: UIView,
         setCameraUseCase: SetCameraUseCase,
         retrieveCameraUseCase: RetrieveAvailableCamerasUseCase,
         takePhotosUseCase: TakePhotoUseCase,
         startCameraUseCase: StartCameraUseCase) {
        self.previewView = previewView
        self.setCameraUseCase = setCameraUseCase
        self.retrieveCameraUseCase = retrieveCameraUseCase
        self.takePhotosUseCase = takePhotosUseCase
        self.startCameraUseCase = startCameraUseCase
    }
    
    func set(_ cameraId: String) throws {
        try setCameraUseCase.set(cameraId)
    }

    func takePhoto(with settings: CameraSettings, completion: @escaping (Result<Data, PhotoCaptureError>) -> ()) {
        takePhotosUseCase.takePhoto(with: settings, completion: completion)
    }
    
    func start(completion: @MainActor @escaping () -> ()) {
        startCameraUseCase.start(completion: completion)
    }
}
