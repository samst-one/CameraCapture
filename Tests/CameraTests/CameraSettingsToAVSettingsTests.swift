import XCTest
@testable import Camera

class CameraSettingsToAVSettingsTests: XCTestCase {
    
    func testAdaptions() {
        XCTAssertEqual(CameraSettingsToAVSettings.adapt(settings: CameraSettings(fileType: .hevc)), .hevc)
        XCTAssertEqual(CameraSettingsToAVSettings.adapt(settings: CameraSettings(fileType: .jpeg)), .jpeg)
    }
}
