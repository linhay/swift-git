// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "git-scm",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "git-scm",
            targets: ["git-scm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/linhay/Stem.git", .upToNextMajor(from: "1.0.9")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "git-scm",
            dependencies: []),
        .testTarget(
            name: "git-scmTests",
            dependencies: [
                "git-scm",
                .product(name: "Stem", package: "Stem")
            ]),
    ]
)
