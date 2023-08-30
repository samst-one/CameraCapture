import XCTest
@testable import Camera

class AVPositionToCameraPositionAdapterTests: XCTestCase {
    
    func testAdaption() {
        XCTAssertEqual(AVPositionToCameraPositionAdapter.adapt(position: .back),
                       .back)
        XCTAssertEqual(AVPositionToCameraPositionAdapter.adapt(position: .front),
                       .front)
        XCTAssertEqual(AVPositionToCameraPositionAdapter.adapt(position: .unspecified),
                       .notStated)
    }
}
