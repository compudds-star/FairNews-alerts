// swift-tools-version:5.9
// Builds the FairNews alert job from the app repository, which the workflow
// checks out at app/: the shared news engine (FairNews/Core) plus AlertJob.
import PackageDescription

let package = Package(
    name: "alertjob",
    platforms: [.macOS(.v13)],
    dependencies: [
        // CryptoKit's API for Linux (signing the APNs token); macOS uses CryptoKit.
        .package(url: "https://github.com/apple/swift-crypto.git", "3.0.0"..<"4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "alertjob",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux])),
            ],
            path: "app",
            // Article text extraction is app-only and uses Apple's NaturalLanguage.
            exclude: ["FairNews/Core/ArticleText.swift"],
            sources: ["FairNews/Core", "AlertJob"]
        ),
    ]
)
