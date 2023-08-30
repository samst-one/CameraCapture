import XCTest
@testable import Camera

enum DefaultCameraFactory {
    static func make(dataSource: DataSource,
                     session: CameraSesion,
                     controller: CameraController) -> DefaultCamera {
        let repo = CameraRepo(dataSource: dataSource)
        return DefaultCamera(previewView: UIView(),
                             setCameraUseCase: SetCameraUseCase(cameraSesion: session,
                                                                repo: repo),
                             retrieveCameraUseCase: RetrieveAvailableCamerasUseCase(repo: repo),
                             takePhotosUseCase: TakePhotoUseCase(controller: controller,
                                                                 session: session),
                             startCameraUseCase: StartCameraUseCase(session: session))
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
                                               controller: cameraController)
    }

    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenCameraIsntSetOnSession_AndCorrectErrorIsThrown() {
        dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                             type: .telephotoCamera,
                                             position: .back)]
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
                                             position: .back)]
        try? controller.set("test_id")
        
        XCTAssertEqual("test_id", session.chosenCameraId)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesContainCamera_ThenAllPreviousInputsAreRemovedFromSession() {
        dataSource.camerasToReturn = [Device(id: "test_id",
                                             type: .telephotoCamera,
                                             position: .back)]
        try? controller.set("test_id")
        
        XCTAssertEqual(1, session.removeAllInputsCalled)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenAllPreviousInputsArentRemovedFromSession() {
        dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                             type: .telephotoCamera,
                                             position: .back)]
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
}

class MockDataSource: DataSource {
    var cameras: [Device] {
        return camerasToReturn
    }
    
    var camerasToReturn: [Device] = []
}
