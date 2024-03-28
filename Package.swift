// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CameraCapture",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "CameraCapture",
            targets: ["CameraCapture"]),
    ],
    targets: [
        .target(
            name: "CameraCapture",
            dependencies: []),
        .testTarget(
            name: "CameraCaptureTests",
            dependencies: ["CameraCapture"]),
    ]
)
