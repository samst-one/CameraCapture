import AVFoundation
import UIKit

class AVCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private var handler: CaptureHandler?

    func set(_ handler: CaptureHandler) {
        self.handler = handler
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        handler?.didCapturePhoto(photo.fileDataRepresentation(with: Customizer(photo: photo)), error: error)
    }
    
    class Customizer: NSObject, AVCapturePhotoFileDataRepresentationCustomizer {
        
        private let photo: AVCapturePhoto
        
        init(photo: AVCapturePhoto) {
            self.photo = photo
        }
        
        func replacementMetadata(for photo: AVCapturePhoto) -> [String : Any]? {
            return photo.metadata
        }
    }
}
