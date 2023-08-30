import XCTest
@testable import Camera

final class StartCameraTests: XCTestCase {
    let session = SpyCameraSession(hasCamera: true, hasStarted: false)
    let cameraController = SpyCameraController()
    var dataSource = MockDataSource()
    var controller: DefaultCamera!
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: cameraController)
    }

    func testWhenCameraIsStarted_ThenCompletionHandlerIsCalled() {
        let expectation = self.expectation(description: "Wait for start to be called.")
        controller.start {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
