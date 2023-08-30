import AVKit

class CaptureHandler {
    private var completionHandler: ((Result<Data, PhotoCaptureError>) -> ())?
    
    func set(_ completionHandler: @escaping (Result<Data, PhotoCaptureError>) -> ()) {
        self.completionHandler = completionHandler
    }
    
    func didCapturePhoto(_ image: Data?, error: Error?) {
        if (error != nil) {
            completionHandler?(.failure(.unknown))
            return
        }
        if let image = image {
            completionHandler?(.success(image))
            return
        }
        completionHandler?(.failure(.noImageReturned))
    }
}
