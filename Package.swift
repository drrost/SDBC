// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDBC",
    products: [
        .library(
            name: "SDBC",
            targets: ["SDBC"]),
    ],
    dependencies: [
        .package(
            name: "ExtensionsFoundation",
            url: "git@github.com:drrost/swift-extensions-foundation.git",
            from: "1.0.0"),
        .package(
            name: "RDError",
            url: "git@github.com:drrost/swift-error.git",
            from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SDBC",
            dependencies: ["ExtensionsFoundation", "RDError"]),
        .testTarget(
            name: "SDBCTests",
            dependencies: [
                "SDBC",
                .product(name: "ExtensionXCTest", package: "ExtensionsFoundation")
            ],
            resources: [
                .process("ResourcesTest")
            ]
        )
    ]
)
