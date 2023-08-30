import AVKit

protocol DataSource {
    var cameras: [Device] { get }
}

class AVCaptureDeviceDataSource: DataSource {
    var cameras: [Device] {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                                    .builtInTelephotoCamera,
                                                                                    .builtInUltraWideCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        let cameras: [Device] = deviceDiscoverySession.devices.compactMap { device in
            guard let type = AVDeviceTypeToCameraTypeAdapter.adapt(device: device.deviceType) else { return nil }
            return Device(id: device.uniqueID,
                          type: type,
                          position: AVPositionToCameraPositionAdapter.adapt(position: device.position))
        }
        
        return cameras
    }
}
