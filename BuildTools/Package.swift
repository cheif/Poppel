// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BuildTools",
    products: [
        .executable(
            name: "componentBuilderGenerator",
            targets: ["ComponentBuilderGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.1")
    ],
    targets: [
        .target(
            name: "ComponentBuilderGenerator",
            dependencies: ["Stencil"]
        )
    ]
)
