// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftELM",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftELM",
            targets: ["SwiftELM"]),
    ],
    targets: [
        .target(
            name: "SwiftELM",
            dependencies: [])
    ]
)
