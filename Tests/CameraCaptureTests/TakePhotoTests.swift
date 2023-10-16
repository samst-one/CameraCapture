import XCTest
@testable import CameraCapture

final class TakePhotoTests: XCTestCase {
    let system = System()
    
    
    func testWhenUserTakesPhoto_AndPhotoIsTakenSuccesfully_ThenCorrectDataIsReturned() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: true,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        
        system.camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure:
                XCTFail("Should expect success.")
            case .success(let data):
                XCTAssertEqual(data, "test_data".data(using: .utf8))
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndErrorOccurs_ThenErrorIsReturned() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: true,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        system.cameraController.shouldReturnError = true
        system.camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unknown)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndNoDataIsReturnedFromCapture_ThenErrorIsReturned() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: true,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        system.cameraController.shouldReturnData = false
        system.camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noImageReturned)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndCameraIsntSet_ThenErrorIsReturned() {
        system.session.hasCamera = false
        system.camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noCameraSet)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndSessionIsntStarted_ThenErrorIsReturned() {
        system.session.spySelectedCamera = Device(id: "selected_id",
                                                  type: .telephotoCamera,
                                                  position: .back,
                                                  hasFlash: true,
                                                  isFlashOn: true,
                                                  zoomOptions: [0.5, 1, 2],
                                                  currentZoom: 1.0,
                                                  maxZoom: 10,
                                                  minZoom: 0.5)
        system.session.hasStarted = false
        system.camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .cameraNotStarted)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
}

class SpyCameraController: CameraController {
    
    var currentRotation: CameraCapture.CameraOrientation?
    func rotate(with orientation: CameraCapture.CameraOrientation) {
        currentRotation = orientation
    }
    
    var shouldReturnError: Bool = false
    var shouldReturnData: Bool = true
    
    func takePhoto(with settings: CameraCapture.CameraSettings, flashOn: Bool, handler: CameraCapture.CaptureHandler) {
        handler.didCapturePhoto(shouldReturnData ? "test_data".data(using: .utf8) : nil,
                                error: shouldReturnError ? NSError() : nil)
    }
}
