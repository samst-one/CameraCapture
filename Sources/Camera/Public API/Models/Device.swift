import Foundation

/**
    A device that can be used to take a picture with.
*/
public struct Device {
    public let id: String
    public let type: DeviceType
    public let position: DevicePosition
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
    case wideAngleCamera
    case telephotoCamera
    case ultraWideCamera
}


