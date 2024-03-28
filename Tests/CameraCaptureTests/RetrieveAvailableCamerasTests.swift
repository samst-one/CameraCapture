import XCTest
@testable import CameraCapture

final class RetrieveAvailableCameraTests: XCTestCase {
    let system = System()
    
    func testWhenUserRequestsAvailableCameras_ThenCorrectCamerasAreReturned() {
        let camerasToReturn = [Device(id: "id_1", type: .telephotoCamera, position: .back, hasFlash: true, flashState: .off, zoomOptions: [0.5, 1], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5),
                               Device(id: "id_2", type: .ultraWideCamera, position: .front, hasFlash: false, flashState: .off, zoomOptions: [0.5, 1, 2], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5),
                               Device(id: "id_3", type: .wideAngleCamera, position: .front, hasFlash: true, flashState: .on, zoomOptions: [0.5, 1, 2], currentZoom: 1.0, maxZoom: 10, minZoom: 0.5)]

        system.dataSource.camerasToReturn = camerasToReturn
        
        XCTAssertEqual(system.camera.availableDevices, camerasToReturn)
    }
    
    func testWhenUserRequestsSelectedCamera_ThenCorrectCamerasAreReturned() {
        system.dataSource.selectedCameraToReturn = Device(id: "id_1",
                                                          type: .telephotoCamera,
                                                          position: .back,
                                                          hasFlash: true,
                                                          flashState: .off,
                                                          zoomOptions: [0.5, 1, 2],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        XCTAssertEqual(system.camera.selectedCamera, Device(id: "id_1",
                                                            type: .telephotoCamera,
                                                            position: .back,
                                                            hasFlash: true,
                                                            flashState: .off,
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
