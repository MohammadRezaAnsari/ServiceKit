// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ServiceKit",
            targets: ["ServiceKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.12.0")),
    ],
    targets: [
        .target(
            name: "ServiceKit",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "ServiceKitTests",
            dependencies: ["ServiceKit"]
        ),
    ]
)
