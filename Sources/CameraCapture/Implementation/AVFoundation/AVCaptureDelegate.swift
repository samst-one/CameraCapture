import AVFoundation

class AVCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private var handler: CaptureHandler?

    func set(_ handler: CaptureHandler) {
        self.handler = handler
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        handler?.didCapturePhoto(photo.fileDataRepresentation(), error: error)
    }
}
