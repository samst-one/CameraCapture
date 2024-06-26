import Foundation


/**
    A device that can be used to take a picture with.
*/
public struct Device {
    public let id: String
    public let type: DeviceType
    public let position: DevicePosition
    public let hasFlash: Bool
    public let flashState: FlashState
    public let zoomOptions: [Double]
    public let currentZoom: Double
    public let maxZoom: Double
    public let minZoom: Double
}

/**
    The physical location of the device.
*/
public enum DevicePosition {
    case back
    case front
    case notStated
}

/**
    The type of device. Useful for knowing which camera you're using.
*/
public enum DeviceType {
    case tripleCamera
    case dualCamera
    case dualWideCamera
    case wideAngleCamera
    case telephotoCamera
    case ultraWideCamera
    case unspecified
}

public enum FlashState: Int {
    case on
    case off
    case auto
}
