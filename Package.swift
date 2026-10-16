// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AuroraDS",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [.library(name: "AuroraDS", targets: ["AuroraDS"])],
    targets: [
        .target(name: "AuroraDS"),
        .testTarget(name: "AuroraDSTests", dependencies: ["AuroraDS"]),
    ]
)
