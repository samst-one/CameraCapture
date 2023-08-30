import XCTest
@testable import Camera

class AVDeviceTypeToCameraTypeAdapterTests: XCTestCase {
    
    func testAdaption() {
        XCTAssertEqual(AVDeviceTypeToCameraTypeAdapter.adapt(device: .builtInTelephotoCamera),
                       .telephotoCamera)
        XCTAssertEqual(AVDeviceTypeToCameraTypeAdapter.adapt(device: .builtInUltraWideCamera),
                       .ultraWideCamera)
        XCTAssertEqual(AVDeviceTypeToCameraTypeAdapter.adapt(device: .builtInWideAngleCamera),
                       .wideAngleCamera)
        XCTAssertNil(AVDeviceTypeToCameraTypeAdapter.adapt(device: .builtInMicrophone))
    }
    
}
