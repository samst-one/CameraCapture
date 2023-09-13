import XCTest
@testable import CameraCapture

class SetFlashStateTests: XCTestCase {
    
    let system = System()
    
    func testWhenUserTurnsFlashOn_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOn() {
        system.camera.setFlashState(isOn: true)
        
        XCTAssertNil(system.flashController.flashOnDeviceId)
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraHasFlash_ThenTurnFlashOn() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: false,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(isOn: true)
        
        XCTAssertEqual(system.flashController.flashOnDeviceId, "selected_id")
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraDoesntHaveFlash_ThenTurnFlashIsntTurnedOn() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: false,
                                                  isFlashOn: false,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(isOn: true)
        
        XCTAssertNil(system.flashController.flashOnDeviceId)
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOn_ThenTurnFlashOff() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: true,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(isOn: false)
        
        XCTAssertEqual(system.flashController.flashOffDeviceId, "selected_id")
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOff_ThenFlashIsntTurnedOff() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: false,
                                                  isFlashOn: false,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(isOn: false)
        
        XCTAssertNil(system.flashController.flashOffDeviceId)
    }
    
    func testWhenUserTurnsFlashOff_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOff() {
        system.camera.setFlashState(isOn: false)
        
        XCTAssertNil(system.flashController.flashOffDeviceId)
    }
}

class SpyFlashController: FlashController {
    var flashOffDeviceId: String?
    func turnOffFlash(for deviceId: String) {
        flashOffDeviceId = deviceId
    }
    
    var flashOnDeviceId: String?
    func turnOnFlash(for deviceId: String) {
        flashOnDeviceId = deviceId
    }
}
