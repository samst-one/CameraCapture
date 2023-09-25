import XCTest
@testable import CameraCapture

class RotateCameraUseCaseTests: XCTestCase {
    
    func testWhenViewRotates_ThenCameraOrientationIsUpdated() {
        let system = System()
        system.presenter.didRotateCamera(with: .landscapeLeft)
        XCTAssertEqual(system.cameraController.currentRotation, .landscapeLeft)
    }
    
}
