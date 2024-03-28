import XCTest
@testable import CameraCapture

final class SetCameraTests: XCTestCase {
    
    let system = System()
    
    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenCameraIsntSetOnSession_AndCorrectErrorIsThrown() {
        system.dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                                    type: .telephotoCamera,
                                                    position: .back,
                                                    hasFlash: true,
                                                    flashState: .off,
                                                    zoomOptions: [0.5, 1, 2],
                                                    currentZoom: 1.0,
                                                    maxZoom: 10,
                                                    minZoom: 0.5)]
        do {
            try system.camera.set("test_id")
        } catch let error {
            XCTAssertEqual(error as! CameraSourcingError, CameraSourcingError.invalidCamera)
        }
        
        XCTAssertEqual(nil, system.session.chosenCameraId)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesContainCamera_ThenCameraIsSetOnSession() {
        system.dataSource.camerasToReturn = [Device(id: "test_id",
                                                    type: .telephotoCamera,
                                                    position: .back,
                                                    hasFlash: true,
                                                    flashState: .off,
                                                    zoomOptions: [0.5, 1, 2],
                                                    currentZoom: 1.0,
                                                    maxZoom: 10,
                                                    minZoom: 0.5)]
        try? system.camera.set("test_id")
        
        XCTAssertEqual("test_id", system.session.chosenCameraId)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesContainCamera_ThenAllPreviousInputsAreRemovedFromSession() {
        system.dataSource.camerasToReturn = [Device(id: "test_id",
                                                    type: .telephotoCamera,
                                                    position: .back,
                                                    hasFlash: true,
                                                    flashState: .on,
                                                    zoomOptions: [0.5, 1, 2],
                                                    currentZoom: 1.0,
                                                    maxZoom: 10,
                                                    minZoom: 0.5)]
        try? system.camera.set("test_id")
        
        XCTAssertEqual(1, system.session.removeAllInputsCalled)
    }
    
    func testWhenUserChoosesCamera_AndRepoDoesntContainCamera_ThenAllPreviousInputsArentRemovedFromSession() {
        system.dataSource.camerasToReturn = [Device(id: "incorrect_test_id",
                                                    type: .telephotoCamera,
                                                    position: .back,
                                                    hasFlash: true,
                                                    flashState: .off,
                                                    zoomOptions: [0.5, 1, 2],
                                                    currentZoom: 1.0,
                                                    maxZoom: 10,
                                                    minZoom: 0.5)]
        try? system.camera.set("test_id")
        
        XCTAssertEqual(0, system.session.removeAllInputsCalled)
    }
    
    func testWhenCameraIsSetSuccessfully_ThenViewIsUpdated() {
        system.dataSource.camerasToReturn = [Device(id: "test_id",
                                                    type: .telephotoCamera,
                                                    position: .back,
                                                    hasFlash: true,
                                                    flashState: .off,
                                                    zoomOptions: [0.5, 1, 2],
                                                    currentZoom: 1.0,
                                                    maxZoom: 10,
                                                    minZoom: 0.5)]
        try? system.camera.set("test_id")
        
        XCTAssertEqual(system.view.setCameraCalled, 1)
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
