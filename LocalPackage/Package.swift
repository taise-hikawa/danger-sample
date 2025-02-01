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
        .library(name: "Hoge", targets: ["Hoge"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerTarget"])
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        .target(name: "Hoge"),
        .target(
            name: "DangerTarget",
            dependencies: [.product(name: "Danger", package: "swift")]
        )
    ]
)
