// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "AirView",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AirView",
            targets: ["AirView"]),
    ],
    targets: [
        .target(
            name: "AirView"),
        .testTarget(
            name: "AirViewTests",
            dependencies: ["AirView"]),
    ]
)
