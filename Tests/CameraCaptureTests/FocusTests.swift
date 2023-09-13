import XCTest
@testable import CameraCapture

class FocusTests: XCTestCase {
    
    func testWhenUseRequestedFocus_ThenFocusIsPastToFocusController() {
        let dataSource = MockDataSource()
        let focusController = SpyFocusController()
        let presenter = DefaultPresenter(setZoomUseCase: SetZoomUseCase(zoomController: SpyZoomController(),
                                                                        dataSource: dataSource),
                                         retrieveSelectedCameras: RetrieveAvailableCamerasUseCase(dataSource: dataSource),
                                         focusUseCase: FocusUseCase(focusController: focusController))
        
        presenter.didFocus(at: CGPoint(x: 100, y: 100))
        
        XCTAssertEqual(focusController.focusPoint, CGPoint(x: 100, y: 100))
    }
}


