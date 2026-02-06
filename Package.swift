// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGit",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "SwiftGit", targets: ["SwiftGit"]),
        .library(name: "SwiftGitArm64", targets: ["SwiftGit", "SwiftGitResourcesArm64"]),
        .library(name: "SwiftGitX86_64", targets: ["SwiftGit", "SwiftGitResourcesX86_64"]),
        .library(name: "SwiftGitUniversal", targets: ["SwiftGit", "SwiftGitResourcesUniversal"]),
    ],
    dependencies: [
        .package(url: "https://github.com/linhay/SKProcessRunner.git", from: "0.0.2"),
        .package(url: "https://github.com/linhay/STFilePath.git", from: "1.3.1"),
    ],
    targets: [
        .target(
            name: "SwiftGit",
            dependencies: [
                .product(name: "STFilePath", package: "STFilePath"),
                .product(name: "SKProcessRunner", package: "SKProcessRunner"),
            ]),
        .target(
            name: "SwiftGitResourcesArm64",
            dependencies: ["SwiftGit"],
            resources: [
                .copy("Resource/git-instance.bundle")
            ]),
        .target(
            name: "SwiftGitResourcesX86_64",
            dependencies: ["SwiftGit"],
            resources: [
                .copy("Resource/git-instance.bundle")
            ]),
        .target(
            name: "SwiftGitResourcesUniversal",
            dependencies: ["SwiftGit"],
            resources: [
                .copy("Resource/git-instance.bundle")
            ]),
        // Example target removed — no Examples/ directory present in this tree.
        .testTarget(
            name: "SwiftGitTests",
            dependencies: [
                "SwiftGit",
                .product(name: "STFilePath", package: "STFilePath"),
                .product(name: "SKProcessRunner", package: "SKProcessRunner"),
            ]),
    ]
)
