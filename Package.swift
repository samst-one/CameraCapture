// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Camera",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Camera",
            targets: ["Camera"]),
    ],
    targets: [
        .target(
            name: "Camera",
            dependencies: []),
        .testTarget(
            name: "CameraTests",
            dependencies: ["Camera"]),
    ]
)
