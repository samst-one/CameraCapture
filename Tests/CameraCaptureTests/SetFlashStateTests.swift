import XCTest
@testable import CameraCapture

class SetFlashStateTests: XCTestCase {
    
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    var controller: DefaultCamera!
    let flashController = SpyFlashController()
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: MockDataSource(),
                                               session: session,
                                               controller: SpyCameraController(),
                                               flashController: flashController)
    }
    
    func testWhenUserTurnsFlashOn_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOn() {
        controller.setFlashState(isOn: true)
        
        XCTAssertNil(flashController.flashOnDeviceId)
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraHasFlash_ThenTurnFlashOn() {
        session.spySelectedCamera = Device(id: "selected_id",
                                           type: .telephotoCamera,
                                           position: .back,
                                           hasFlash: true,
                                           isFlashOn: false)
        
        controller.setFlashState(isOn: true)
        
        XCTAssertEqual(flashController.flashOnDeviceId, "selected_id")
    }
    
    func testWhenUserTurnsFlashOn_AndSelectedCameraDoesntHaveFlash_ThenTurnFlashIsntTurnedOn() {
        session.spySelectedCamera = Device(id: "selected_id",
                                           type: .telephotoCamera,
                                           position: .back,
                                           hasFlash: false,
                                           isFlashOn: false)
        
        controller.setFlashState(isOn: true)
        
        XCTAssertNil(flashController.flashOnDeviceId)
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOn_ThenTurnFlashOff() {
        session.spySelectedCamera = Device(id: "selected_id",
                                           type: .telephotoCamera,
                                           position: .back,
                                           hasFlash: true,
                                           isFlashOn: true)
        
        controller.setFlashState(isOn: false)
        
        XCTAssertEqual(flashController.flashOffDeviceId, "selected_id")
    }
    
    func testWhenUserTurnsFlashOff_AndSelectedCameraFlashIsOff_ThenFlashIsntTurnedOff() {
        session.spySelectedCamera = Device(id: "selected_id",
                                           type: .telephotoCamera,
                                           position: .back,
                                           hasFlash: false,
                                           isFlashOn: false)
        
        controller.setFlashState(isOn: false)
        
        XCTAssertNil(flashController.flashOffDeviceId)
    }
    
    func testWhenUserTurnsFlashOff_AndThereIsNoSelectedCamera_ThenFlashIsntTurnedOff() {
        controller.setFlashState(isOn: false)
        
        XCTAssertNil(flashController.flashOffDeviceId)
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
