import XCTest
@testable import CameraCapture

final class TakePhotoTests: XCTestCase {
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    let cameraController = SpyCameraController()
    var dataSource = MockDataSource()
    var controller: DefaultCamera!
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: cameraController,
                                               flashController: SpyFlashController())
    }
    
    func testWhenUserTakesPhoto_AndPhotoIsTakenSuccesfully_ThenCorrectDataIsReturned() {
        controller.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure:
                XCTFail("Should expect success.")
            case .success(let data):
                XCTAssertEqual(data, "test_data".data(using: .utf8))
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndErrorOccurs_ThenErrorIsReturned() {
        cameraController.shouldReturnError = true
        controller.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unknown)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndNoDataIsReturnedFromCapture_ThenErrorIsReturned() {
        cameraController.shouldReturnData = false
        controller.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noImageReturned)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndCameraIsntSet_ThenErrorIsReturned() {
        session.hasCamera = false
        controller.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noCameraSet)
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func testWhenUserTakesPhoto_AndSessionIsntStarted_ThenErrorIsReturned() {
        session.hasStarted = false
        controller.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
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
    
    var shouldReturnError: Bool = false
    var shouldReturnData: Bool = true
    
    func takePhoto(with settings: CameraSettings,
                   handler: CaptureHandler) {
        handler.didCapturePhoto(shouldReturnData ? "test_data".data(using: .utf8) : nil,
                                error: shouldReturnError ? NSError() : nil)
    }
}
