import AVFoundation

enum AVCaptureDeviceToCameraAdapter {
    
    static func adapt(device: AVCaptureDevice) -> Device {
        Device(id: device.uniqueID,
               type: self.adapt(device: device.deviceType),
               position: self.adapt(position: device.position),
               hasFlash: device.hasFlash,
               isFlashOn: device.isTorchActive)
    }
    
    private static func adapt(device: AVCaptureDevice.DeviceType?) -> DeviceType {
        guard let device = device else {
            return .unspecified
        }
        switch device {
        case .builtInUltraWideCamera: return .ultraWideCamera
        case .builtInTelephotoCamera: return .telephotoCamera
        case .builtInWideAngleCamera: return .wideAngleCamera
        default: return .unspecified
        }
    }
    
    private static func adapt(position: AVCaptureDevice.Position) -> DevicePosition {
        switch position {
        case .back: return .back
        case .front: return .front
        case .unspecified: return .notStated
        @unknown default: return .notStated
        }
    }
}



