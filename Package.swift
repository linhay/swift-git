// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGit",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "SwiftGit", targets: ["SwiftGit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/linhay/Stem.git", .upToNextMajor(from: "1.0.9")),
    ],
    targets: [
        .target(
            name: "SwiftGit",
            resources: [
                .process("Resource/git-instance.bundle")
            ]),
        .testTarget(
            name: "SwiftGitTests",
            dependencies: [
                "SwiftGit",
                .product(name: "Stem", package: "Stem")
            ]),
    ]
)
