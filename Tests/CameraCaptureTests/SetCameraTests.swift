import XCTest
@testable import CameraCapture

enum DefaultCameraFactory {
    static func make(dataSource: DataSource,
                     session: CameraSesion,
                     controller: CameraController,
                     flashController: FlashController,
                     zoomController: ZoomController) -> DefaultCamera {
        return DefaultCamera(previewView: UIView(),
                             setCameraUseCase: SetCameraUseCase(cameraSesion: session,
                                                                dataSource: dataSource),
                             retrieveCameraUseCase: RetrieveAvailableCamerasUseCase(dataSource: dataSource),
                             takePhotosUseCase: TakePhotoUseCase(controller: controller,
                                                                 session: session),
                             startCameraUseCase: StartCameraUseCase(session: session),
                             setFlashStateUseCase: SetFlashStateUseCase(flashController: flashController,
                                                                        session: session),
                             setZoomUseCase: SetZoomUseCase(zoomController: zoomController, session: session))
    }
}

final class SetCameraTests: XCTestCase {
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    let dataSource = MockDataSource()
    let cameraController = SpyCameraController()
    var controller: DefaultCamera!
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: cameraController,
                                               flashController: SpyFlashController(),
                                               zoomController: SpyZoomController())
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenCameraIsntSetOnSession_AndCorrectErrorIsThrown() {
        dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                             type: .telephotoCamera,
                                             position: .back,
                                             hasFlash: true,
                                             isFlashOn: false,
                                             zoomOptions: [0.5, 1, 2],
                                             currentZoom: 1.0,
                                             maxZoom: 10,
                                             minZoom: 0.5)]
        do {
            try controller.set("test_id")
        } catch let error {
            XCTAssertEqual(error as! CameraSourcingError, CameraSourcingError.invalidCamera)
        }
        
        XCTAssertEqual(nil, session.chosenCameraId)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesContainCamera_ThenCameraIsSetOnSession() {
        dataSource.camerasToReturn = [Device(id: "test_id",
                                             type: .telephotoCamera,
                                             position: .back,
                                             hasFlash: true,
                                             isFlashOn: false,
                                             zoomOptions: [0.5, 1, 2],
                                             currentZoom: 1.0,
                                             maxZoom: 10,
                                             minZoom: 0.5)]
        try? controller.set("test_id")
        
        XCTAssertEqual("test_id", session.chosenCameraId)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesContainCamera_ThenAllPreviousInputsAreRemovedFromSession() {
        dataSource.camerasToReturn = [Device(id: "test_id",
                                             type: .telephotoCamera,
                                             position: .back,
                                             hasFlash: true,
                                             isFlashOn: true,
                                             zoomOptions: [0.5, 1, 2],
                                             currentZoom: 1.0,
                                             maxZoom: 10,
                                             minZoom: 0.5)]
        try? controller.set("test_id")
        
        XCTAssertEqual(1, session.removeAllInputsCalled)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenAllPreviousInputsArentRemovedFromSession() {
        dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                             type: .telephotoCamera,
                                             position: .back,
                                             hasFlash: true,
                                             isFlashOn: false,
                                             zoomOptions: [0.5, 1, 2],
                                             currentZoom: 1.0,
                                             maxZoom: 10,
                                             minZoom: 0.5)]
        try? controller.set("test_id")
        
        XCTAssertEqual(0, session.removeAllInputsCalled)
    }
}

class SpyCameraSession: CameraSesion {
    
    var hasCamera: Bool
    var hasStarted: Bool
    
    init(hasCamera: Bool, hasStarted: Bool) {
        self.hasCamera = hasCamera
        self.hasStarted = hasStarted
    }
    
    var removeAllInputsCalled: Int = 0
    func removeAllInputs() {
        removeAllInputsCalled += 1
    }
    
    var chosenCameraId: String?
    func addInput(with id: String) {
        chosenCameraId = id
    }
    
    func start(completion: @escaping @MainActor () -> ()) {
        Task {
            await completion()
        }
    }
    
    var spySelectedCamera: CameraCapture.Device?
    var selectedCamera: CameraCapture.Device? {
        return spySelectedCamera
    }
}

class MockDataSource: DataSource {
    func getCamera(with id: String) -> CameraCapture.Device? {
        return camerasToReturn.first(where: { $0.id == id })
    }
    
    var camerasToReturn: [Device] = []
    var cameras: [Device] {
        return camerasToReturn
    }
    
    var selectedCameraToReturn: Device?
    var selectedCamera: Device? {
        return selectedCameraToReturn
    }
}
