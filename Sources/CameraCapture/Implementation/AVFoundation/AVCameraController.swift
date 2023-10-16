import AVFoundation

protocol CameraController {
    func takePhoto(with settings: CameraSettings,
                   flashOn: Bool,
                   handler: CaptureHandler)
    func rotate(with orientation: CameraOrientation)
}

class AVCameraController: CameraController {
    
    private let photoOutput: AVCapturePhotoOutput
    private let delegate = AVCaptureDelegate()

    init(photoOutput: AVCapturePhotoOutput) {
        self.photoOutput = photoOutput
    }
    
    func takePhoto(with settings: CameraSettings,
                   flashOn: Bool,
                   handler: CaptureHandler) {
        delegate.set(handler)
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: CameraSettingsToAVSettings.adapt(settings: settings)])
        settings.flashMode = flashOn ? .on : .off
        photoOutput.capturePhoto(with: settings,
                                 delegate: delegate)
        
    }
    
    func rotate(with orientation: CameraOrientation) {
        photoOutput.connection(with: .video)?.videoOrientation = CameraOrientationToAVSettings.adapt(orientation: orientation)
    }
}

enum CameraOrientationToAVSettings {
    static func adapt(orientation: CameraOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portrait
        }
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
