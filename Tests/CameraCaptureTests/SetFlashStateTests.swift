import XCTest
@testable import CameraCapture

class SetFlashStateTests: XCTestCase {
    
    let system = System()
    
    func testWhenUserTurnsFlashOn_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOn() {
        system.camera.setFlashState(isOn: true)
        
        XCTAssertTrue(system.flashDataSource.flashDict.isEmpty)
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
        
        XCTAssertTrue(system.flashDataSource.flashDict["selected_id"]!)
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
        
        XCTAssertTrue(system.flashDataSource.flashDict["selected_id"]!)
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
        
        XCTAssertFalse(system.flashDataSource.flashDict["selected_id"]!)
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
        
        XCTAssertFalse(system.flashDataSource.flashDict["selected_id"]!)
    }
    
    func testWhenUserTurnsFlashOff_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOff() {
        system.camera.setFlashState(isOn: false)
        
        XCTAssertTrue(system.flashDataSource.flashDict.isEmpty)
    }
}

class SpyFlashDataSource: FlashDataSource {
    
    var flashDict: [String: Bool] = [: ]
    
    func get(deviceId: String) -> Bool {
        return flashDict[deviceId] ?? false
    }
    
    func set(deviceId: String, isOn: Bool) {
        flashDict[deviceId] = isOn
    }
}
