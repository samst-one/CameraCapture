import XCTest
@testable import CameraCapture

class AdaptionTests: XCTestCase {
    
    func testScaleToMultiplication() {
        XCTAssertEqual(ZoomScaleToMultiplication.adapt(deviceType: .dualCamera, scale: 2), 2.22)
        XCTAssertEqual(ZoomScaleToMultiplication.adapt(deviceType: .tripleCamera, scale: 2), 1)
        XCTAssertEqual(ZoomScaleToMultiplication.adapt(deviceType: .dualWideCamera, scale: 2), 1)
        XCTAssertEqual(ZoomScaleToMultiplication.adapt(deviceType: .wideAngleCamera, scale: 3), 3)
    }
    
    func testMultiplicationToScale() {
        XCTAssertEqual(ZoomMultiplcationToScale.adapt(deviceType: .dualCamera, multiplier: 2), 1.8018018018018016)
        XCTAssertEqual(ZoomMultiplcationToScale.adapt(deviceType: .tripleCamera, multiplier: 2), 4)
        XCTAssertEqual(ZoomMultiplcationToScale.adapt(deviceType: .dualWideCamera, multiplier: 2), 4)
        XCTAssertEqual(ZoomMultiplcationToScale.adapt(deviceType: .wideAngleCamera, multiplier: 2), 2)
    }
}
