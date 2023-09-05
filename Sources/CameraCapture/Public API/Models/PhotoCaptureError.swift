/**
    Error that can be returned when taking a photo.
*/
public enum PhotoCaptureError: Error {
    /// Indicates that a camera wasn't set before attempting to take a photo.
    case noCameraSet
    
    /// Indicates that the camera wasn't started before attempting to take a photo.
    case cameraNotStarted
    
    /// Indicates no image was returned when taking a photo.
    case noImageReturned
    
    /// An unknown error..
    case unknown
}
