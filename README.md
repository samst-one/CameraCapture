# Camera
[![A badge showing the current build status on bitrise. Please click to view more](https://app.bitrise.io/app/902437be-6926-4073-a967-0db8438bc21a/status.svg?token=Yt9a9JFHUAEzrS31-1qbCQ&branch=main)](https://app.bitrise.io/app/902437be-6926-4073-a967-0db8438bc21a)
[![A badge showing the Swift Compatibility of the project.](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsamst-one%2FCamera%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/samst-one/Camera)
[![A badge showing the platform compatibility of the project.](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsamst-one%2FCamera%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/samst-one/Camera)

A package for interacting with the cameras in iOS. Developed by [Sam Stone](https://samst.one).

## Overview

A package for interacting with the cameras in iOS, with the following features:
- Displaying the camera preview.
- Taking a picture.
- Setting the camera to take the picture from.

The other aim of this project is to provide a well tested solution to this project, which bases itself on Clean Architecture, pushing technology concerns to the boundaries and testing everything in-between.

The API can be found in the ``Camera`` interface.

## Install

Go to **File > Swift Packages > Add Package Dependency** and add the following URL:

```
https://github.com/samst-one/Camera
```

## Usage

1. First we need to import the camera into our project, we do this by importing the framework

```swift
import Camera
```

2. Next we need to create a ``Camera`` object. The ``Camera`` acts as the API for the package. To create the ``Camera``, we do:

```swift
let camera = CameraFactory.make()
```

3. With the `camera`, we can now access the API. For more of a breakdown of the API, please check out ``Camera``. To get a list of available devices we can use to take a picture, call:
```swift
camera.availableDevices
```

4. Pick a camera from the selection above, and set the camera using the `id` from the `Device` returned. `CameraSourcingError.invalidCamera` will be thrown if camera cannot be found on the current device.

```swift
do {
    try camera.set(camera!.id)
} catch let error {
    print(error)
}
```

5. Set the preview view where you want to display it. Can also be wrapped in a `UIViewRepresentable`.

```swift
let previewView = camera.previewView
view.addSubview(previewView)
```

6. Next we can start the camera. The callback is called when the camera has finished its start up process. This will show the preview in the `previewView`.

```swift
camera.start {
    // Do stuff here
}
```

7. When you're ready to take a photo, call `takePhoto` on the `Camera`. If successful, a `Data` representation of the image will be returned. If an error has occurred, then a ``PhotoCaptureError`` will be returned. 

```swift
camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
    switch result {
    case .success(let data):
        let image = UIImage(data: data) 
        break
    case .failure(let error):
        break
    }
}
```
## Summary

In conclusion, to start up the camera and take a picture, the full code is below:

```swift
let camera = CameraFactory.make()
let selectedDevice = camera.availableDevices.randomElement()

let view = camera.previewView

do {
    try camera.set(camera!.id)
} catch let error {
    print(error)
}

view.addSubview(view)

camera.start {
    camera.takePhoto(with: CameraSettings(fileType: .jpeg)) { result in
        switch result {
        case .success(let data):
            let image = UIImage(data: data)
            break
        case .failure(let error):
            break
        }
    }
}
```

