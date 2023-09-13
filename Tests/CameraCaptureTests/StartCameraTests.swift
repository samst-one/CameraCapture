import XCTest
@testable import CameraCapture

final class StartCameraTests: XCTestCase {
    
    let system = System()
    
    func testWhenCameraIsStarted_ThenCompletionHandlerIsCalled() {
        let expectation = self.expectation(description: "Wait for start to be called.")
        system.camera.start {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
