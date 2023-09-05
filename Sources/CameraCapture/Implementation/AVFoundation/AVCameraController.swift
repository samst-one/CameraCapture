import AVFoundation

protocol CameraController {
    func takePhoto(with settings: CameraSettings,
                   handler: CaptureHandler)
}

class AVCameraController: CameraController {
    private let photoOutput: AVCapturePhotoOutput
    private let delegate = AVCaptureDelegate()

    init(photoOutput: AVCapturePhotoOutput) {
        self.photoOutput = photoOutput
    }
    
    func takePhoto(with settings: CameraSettings,
                   handler: CaptureHandler) {
        delegate.set(handler)
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: CameraSettingsToAVSettings.adapt(settings: settings)])
        photoOutput.capturePhoto(with: settings,
                                 delegate: delegate)
    }
}

enum CameraSettingsToAVSettings {
    static func adapt(settings: CameraSettings) -> AVVideoCodecType {
        switch settings.fileType {
        case .hevc:
            return AVVideoCodecType.hevc
        case .jpeg:
            return AVVideoCodecType.jpeg
        }
    }
}
