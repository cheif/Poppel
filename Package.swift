// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Poppel",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Poppel",
            targets: ["Poppel"]),
    ],
    targets: [
        .target(
            name: "Poppel",
            dependencies: [])
    ]
)
