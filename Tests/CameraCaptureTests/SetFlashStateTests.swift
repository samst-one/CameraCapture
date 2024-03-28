import XCTest
@testable import CameraCapture

class SetFlashStateTests: XCTestCase {
    
    let system = System()
    
    func testWhenUserTurnsFlashOn_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOn() {
        system.camera.setFlashState(state: .on)

        XCTAssertTrue(system.flashDataSource.flashDict.isEmpty)
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraHasFlash_ThenTurnFlashOn() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  flashState: .off,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(state: .on)

        XCTAssertEqual(system.flashDataSource.flashDict["selected_id"], .on)
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraDoesntHaveFlash_ThenTurnFlashIsntTurnedOn() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: false,
                                                  flashState: .off,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(state: .on)

        XCTAssertEqual(system.flashDataSource.flashDict["selected_id"], .on)
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOn_ThenTurnFlashOff() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  flashState: .on,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(state: .off)

        XCTAssertEqual(system.flashDataSource.flashDict["selected_id"], .off)
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOff_ThenFlashIsntTurnedOff() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: false,
                                                  flashState: .off,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.setFlashState(state: .off)

        XCTAssertEqual(system.flashDataSource.flashDict["selected_id"], .off)
    }
    
    func testWhenUserTurnsFlashOff_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOff() {
        system.camera.setFlashState(state: .off)

        XCTAssertTrue(system.flashDataSource.flashDict.isEmpty)
    }
}

class SpyFlashDataSource: FlashDataSource {
    
    var flashDict: [String: FlashState] = [: ]

    func get(deviceId: String) -> FlashState {
        return flashDict[deviceId] ?? .off
    }
    
    func set(deviceId: String, state: FlashState) {
        flashDict[deviceId] = state
    }
}
