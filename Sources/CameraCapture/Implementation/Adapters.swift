import AVFoundation

enum AVCaptureDeviceToCameraAdapter {
    
    static func adapt(device: AVCaptureDevice) -> Device {
        var zoomOptions: [Double] = []
        
        switch device.deviceType {
        case .builtInDualWideCamera, .builtInTripleCamera:
            zoomOptions.append(0.5)
            zoomOptions.append(contentsOf: device.virtualDeviceSwitchOverVideoZoomFactors.map { $0.doubleValue * 0.5 })
            break
        case .builtInDualCamera:
            zoomOptions.append(1.0)
            zoomOptions.append(contentsOf: device.virtualDeviceSwitchOverVideoZoomFactors.map { $0.doubleValue * 1.11 })
            break
        default:
            break
        }
        
        return Device(id: device.uniqueID,
                      type: self.adapt(device: device.deviceType),
                      position: self.adapt(position: device.position),
                      hasFlash: device.hasTorch,
                      isFlashOn: device.isTorchActive,
                      zoomOptions: zoomOptions,
                      currentZoom: device.videoZoomFactor * 0.5,
                      maxZoom: min(device.maxAvailableVideoZoomFactor * 0.5, 10),
                      minZoom: device.minAvailableVideoZoomFactor * 0.5)
    }
    
    private static func adapt(device: AVCaptureDevice.DeviceType?) -> DeviceType {
        guard let device = device else {
            return .unspecified
        }
        switch device {
        case .builtInUltraWideCamera: return .ultraWideCamera
        case .builtInTelephotoCamera: return .telephotoCamera
        case .builtInWideAngleCamera: return .wideAngleCamera
        case .builtInDualCamera: return .dualCamera
        case .builtInDualWideCamera: return .dualWideCamera
        case .builtInTripleCamera: return .tripleCamera
        default:
            return .unspecified
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



