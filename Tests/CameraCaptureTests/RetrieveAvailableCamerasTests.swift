import XCTest
@testable import CameraCapture

final class RetrieveAvailableCameraTests: XCTestCase {
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    let cameraController = SpyCameraController()
    var dataSource = MockDataSource()
    var controller: DefaultCamera!
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: cameraController,
                                               flashController: SpyFlashController(),
                                               zoomController: SpyZoomController())
    }
    
    func testWhenUserRequestsAvailableCameras_ThenCorrectCamerasAreReturned() {
        let camerasToReturn = [Device(id: "id_1", type: .telephotoCamera, position: .back, hasFlash: true, isFlashOn: false, zoomOptions: [0.5, 1], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5),
                               Device(id: "id_2", type: .ultraWideCamera, position: .front, hasFlash: false, isFlashOn: false, zoomOptions: [0.5, 1, 2], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5),
                               Device(id: "id_3", type: .wideAngleCamera, position: .front, hasFlash: true, isFlashOn: true, zoomOptions: [0.5, 1, 2], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5)]
        
        dataSource.camerasToReturn = camerasToReturn
        
        XCTAssertEqual(controller.availableDevices, camerasToReturn)
    }
    
    func testWhenUserRequestsSelectedCamera_ThenCorrectCamerasAreReturned() {
        dataSource.selectedCameraToReturn = Device(id: "id_1",
                                                   type: .telephotoCamera,
                                                   position: .back,
                                                   hasFlash: true,
                                                   isFlashOn: false,
                                                   zoomOptions: [0.5, 1, 2],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
        
        XCTAssertEqual(controller.selectedCamera, Device(id: "id_1",
                                                         type: .telephotoCamera,
                                                         position: .back,
                                                         hasFlash: true,
                                                         isFlashOn: false,
                                                         zoomOptions: [0.5, 1, 2],
                                                         currentZoom: 1.0,
                                                         maxZoom: 10,
                                                         minZoom: 0.5))
    }
    
}

extension Device: Equatable {
    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id &&
        lhs.position == rhs.position &&
        lhs.type == rhs.type
    }
}
