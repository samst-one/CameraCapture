/**
    Used to set the settings of the photo that will be taken.
*/
public struct CameraSettings {
    let fileType: FileType
    
    public init(fileType: FileType) {
        self.fileType = fileType
    }
}

/**
    The file type of the image produce when taking a photo.
*/
public enum FileType {
    case jpeg
    case hevc
}
