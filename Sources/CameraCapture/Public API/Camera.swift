import UIKit

/**
 The public API of the `Camera` package.
 
 This is the public API of the `Camera` package. All  interactions for this module should happen through here.
 */

public protocol Camera {
    
    /**
     The camera preview.
     
     This is the view the camera preview will be displayed on. Adding this to your view will show the output from the camera.
     */
    var previewView: UIView { get }
    
    /**
     Gets avaialable cameras.
     
     Provides a list of availble cameras from the device for you to choose from. Refer to ``Device`` for more information.
     */
    var availableDevices: [Device] { get }
    
    /**
     Starts the camera.
     
     This function starts the camera, and shows the preview of the camera on the `previewView` above providing a camera has been set (see ``set(_:)`` below.
     
     - Parameter completion: Called once the camera has started. Called on the main thread.
     */
    func start(completion: @MainActor @escaping () -> ())
    
    /**
     Sets the camera.
     
     This function sets the desired camera and shows the preview of the camera on the `previewView` above. User ``availableDevices`` to get a list of cameras available for this device.
     
     - Throws: `CameraSourcingError.invalidCamera` if camera cannot be found on the current device.
     - Parameter cameraId: The `id` of the ``Camera`` you wish to display on the preview layer.
     */
    func set(_ cameraId: String) throws
    
    /**
     Takes a photo with the camera.
     
     This function attempts to take a photo and returns either an error or the data of the image captured. The date can be used to turn into a `UIImage` with the below:
     
     let image = UIImage(data: data)
     
     - Parameters:
     - settings:  Used to provide settings for the photo. Refer to ``CameraSettings`` for more information.
     - completion:  Called when the photo has been taken. Returns a `Result` type which either includes the `data` of the image in the case of a succesful photo being taken, or an `PhotoCaptureError` if an error has occured.
     */
    func takePhoto(with settings: CameraSettings, completion: @escaping (Result<Data, PhotoCaptureError>) -> ())
    
    func setFlashState(isOn: Bool)
    
    var selectedCamera: Device? { get }
    
    func zoom(to value: Double) throws
    
    func add(zoomObserver: ZoomObserver)
        
}
