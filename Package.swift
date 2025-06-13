// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "eLogger",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "elogger-iOS", targets: ["eLogger"]),
    ],
    targets: [
        .binaryTarget(
            name: "eLogger",
            path: "eLogger.xcframework"
        ),
    ]
)
