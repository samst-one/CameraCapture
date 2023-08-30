import XCTest
@testable import Camera

final class RetrieveAvailableCameraTests: XCTestCase {
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    let cameraController = SpyCameraController()
    var dataSource = MockDataSource()
    var controller: DefaultCamera!
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: cameraController)
    }
    
    func testWhenUserRequestsAvailableCameras_ThenCorrectCamerasAreReturned() {
        dataSource.camerasToReturn = [Device(id: "id_1", type: .telephotoCamera, position: .back),
                                      Device(id: "id_2", type: .ultraWideCamera, position: .front),
                                      Device(id: "id_3", type: .wideAngleCamera, position: .front)]
        
        XCTAssertEqual(controller.availableDevices, [Device(id: "id_1", type: .telephotoCamera, position: .back),
                                                     Device(id: "id_2", type: .ultraWideCamera, position: .front),
                                                     Device(id: "id_3", type: .wideAngleCamera, position: .front)])
    }
    
}

extension Device: Equatable {
    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id &&
        lhs.position == rhs.position &&
        lhs.type == rhs.type
    }
}
