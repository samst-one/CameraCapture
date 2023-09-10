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
    private let setFlashStateUseCase: SetFlashStateUseCase
    private let setZoomUseCase: SetZoomUseCase
    
    init(previewView: UIView,
         setCameraUseCase: SetCameraUseCase,
         retrieveCameraUseCase: RetrieveAvailableCamerasUseCase,
         takePhotosUseCase: TakePhotoUseCase,
         startCameraUseCase: StartCameraUseCase,
         setFlashStateUseCase: SetFlashStateUseCase,
         setZoomUseCase: SetZoomUseCase) {
        self.previewView = previewView
        self.setCameraUseCase = setCameraUseCase
        self.retrieveCameraUseCase = retrieveCameraUseCase
        self.takePhotosUseCase = takePhotosUseCase
        self.startCameraUseCase = startCameraUseCase
        self.setFlashStateUseCase = setFlashStateUseCase
        self.setZoomUseCase = setZoomUseCase
    }
    
    func set(_ cameraId: String) throws {
        try setCameraUseCase.set(cameraId)
    }

    func takePhoto(with settings: CameraSettings, completion: @escaping (Result<Data, PhotoCaptureError>) -> ()) {
        takePhotosUseCase.takePhoto(with: settings, completion: completion)
    }
    
    func setFlashState(isOn: Bool) {
        setFlashStateUseCase.setFlashState(isOn: isOn)
    }
    
    func start(completion: @MainActor @escaping () -> ()) {
        startCameraUseCase.start(completion: completion)
    }
    
    var selectedCamera: Device? {
        retrieveCameraUseCase.selectedCamera
    }
    
    func zoom(to value: Double) throws {
        try setZoomUseCase.zoomWith(magnificationLevel: value)
    }
    
    func add(zoomObserver: ZoomObserver) {
        setZoomUseCase.add(observer: zoomObserver)
    }
}
