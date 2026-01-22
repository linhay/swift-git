// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGit",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "SwiftGit", targets: ["SwiftGit"])
    ],
    dependencies: [
        .package(url: "https://github.com/linhay/STFilePath.git", from: "1.2.4")
    ],
    targets: [
        .target(
            name: "SwiftGit",
            dependencies: [
                .product(name: "STFilePath", package: "STFilePath")
            ],
            resources: [
                .copy("Resource/git-instance.bundle")
            ]),
        // Example target removed — no Examples/ directory present in this tree.
        .testTarget(
            name: "SwiftGitTests",
            dependencies: [
                "SwiftGit",
                .product(name: "STFilePath", package: "STFilePath"),
            ]),
    ]
)
