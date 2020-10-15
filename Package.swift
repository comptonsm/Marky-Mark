// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Marky-Mark",
    platforms: [
        .iOS("10.0"),
    ],
    products: [
        .library(
            name: "markymark",
            targets: ["markymark"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "5.15.0")
    ],
    targets: [
        .target(
            name: "markymark",
            dependencies: ["Kingfisher", "KingfisherSwiftUI"],
            path: "markymark"),
    ],
    swiftLanguageVersions: [.v5]
)
