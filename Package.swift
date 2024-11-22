// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGit",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "SwiftGit", targets: ["SwiftGit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/linhay/Stem.git", from: "2.0.3"),
        .package(url: "https://github.com/linhay/STFilePath.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "SwiftGit",
            dependencies: [
                .product(name: "Stem", package: "Stem")
            ],
            resources: [
                .copy("Resource/git-instance.bundle"),
            ]),
        .testTarget(
            name: "SwiftGitTests",
            dependencies: [
                "SwiftGit",
                .product(name: "Stem", package: "Stem"),
                .product(name: "STFilePath", package: "STFilePath")
            ]),
    ]
)
