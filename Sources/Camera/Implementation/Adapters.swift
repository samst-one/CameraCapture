import AVFoundation

enum AVDeviceTypeToCameraTypeAdapter {
    
    static func adapt(device: AVCaptureDevice.DeviceType) -> DeviceType? {
        switch device {
        case .builtInUltraWideCamera: return .ultraWideCamera
        case .builtInTelephotoCamera: return .telephotoCamera
        case .builtInWideAngleCamera: return .wideAngleCamera
        default: return nil
        }
    }
}

enum AVPositionToCameraPositionAdapter {
    static func adapt(position: AVCaptureDevice.Position) -> DevicePosition {
        switch position {
        case .back: return .back
        case .front: return .front
        case .unspecified: return .notStated
        @unknown default: return .notStated
        }
    }
}
