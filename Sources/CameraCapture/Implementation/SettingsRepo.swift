import Foundation

protocol FlashDataSource {
    func get(deviceId: String) -> FlashState
    func set(deviceId: String, state: FlashState)
}

class DefaultFlashDataSource: FlashDataSource {
    
    func get(deviceId: String) -> FlashState {
        FlashState(rawValue: UserDefaults.standard.integer(forKey: "camera_flash")) ?? .off
    }
    
    func set(deviceId: String, state: FlashState) {
        UserDefaults.standard.set(state.rawValue, forKey: "camera_flash")
    }
}
