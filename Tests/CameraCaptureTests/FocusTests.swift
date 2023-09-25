import XCTest
@testable import CameraCapture

class FocusTests: XCTestCase {
    
    func testWhenUseRequestedFocus_ThenFocusIsPastToFocusController() {
        let system = System()
        
        system.presenter.didFocus(at: CGPoint(x: 100, y: 100))
        
        XCTAssertEqual(system.focusController.focusPoint, CGPoint(x: 100, y: 100))
    }
}


