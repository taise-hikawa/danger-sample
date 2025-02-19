// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalPackage",
    platforms: [
        .iOS(.v13),
        // Building/Testing for iOS is not yet supported by the SPM.
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Hoge", targets: ["Hoge"])
    ],
    targets: [
        .target(name: "Hoge")
    ]
)
