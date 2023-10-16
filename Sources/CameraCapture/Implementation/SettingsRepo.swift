import Foundation

protocol FlashDataSource {
    func get(deviceId: String) -> Bool
    func set(deviceId: String, isOn: Bool)
}

class DefaultFlashDataSource: FlashDataSource {
    
    func get(deviceId: String) -> Bool {
        UserDefaults.standard.bool(forKey: "camera_flash")
    }
    
    func set(deviceId: String, isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "camera_flash")
    }
}
