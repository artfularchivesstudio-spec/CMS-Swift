// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/**
 * 🎭 ArtfulArchivesCore - The Spellbinding Foundation
 *
 * "Where clean architecture meets mystical code organization,
 * weaving together the threads of domain, data, and shared magic
 * into a tapestry of Swift elegance across Apple's cosmos."
 *
 * - The Spellbinding Museum Director of Swift Architecture
 */
let package = Package(
    name: "ArtfulArchivesCore",

    // 🌟 Platform Support - iOS, macOS, and watchOS unite in harmony
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10)
    ],

    // 📦 Products - What we offer to the world
    products: [
        .library(
            name: "ArtfulArchivesCore",
            targets: ["ArtfulArchivesCore"]
        ),
    ],

    // 🌐 Dependencies - The enchanted ingredients from afar
    dependencies: [
        // 📝 swift-markdown-ui - Where markdown transforms into visual beauty
        // "Turning text into art, one render at a time"
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            from: "2.3.0"
        ),

        // 🖼️ Kingfisher - The majestic image loading and caching guardian
        // "Bringing images forth from the ether with grace and speed"
        .package(
            url: "https://github.com/onevcat/Kingfisher",
            from: "7.10.0"
        ),

        // 🔑 KeychainAccess - Keeper of secrets, guardian of tokens
        // "Where sensitive data slumbers in encrypted peace"
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess",
            from: "4.2.0"
        ),

        // 🎬 Lottie - The animation sorcerer supreme
        // "Breathing life into static views with motion and magic"
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            from: "4.3.0"
        ),
    ],

    // 🎯 Targets - The mystical modules of our creation
    targets: [
        // 🌟 The Core Target - Where all magic converges
        .target(
            name: "ArtfulArchivesCore",
            dependencies: [
                // 📝 Markdown rendering powers
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),

                // 🖼️ Image loading enchantment
                "Kingfisher",

                // 🔑 Secure storage spells
                .product(name: "KeychainAccess", package: "KeychainAccess"),

                // 🎬 Animation wizardry
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            // 📂 Path to our source files - organized by layer
            path: "Sources/ArtfulArchivesCore"
        ),

        // 🧪 Test Target - Where we prove our magic works
        // "Even the mightiest spells require verification"
        .testTarget(
            name: "ArtfulArchivesCoreTests",
            dependencies: ["ArtfulArchivesCore"],
            path: "Tests/ArtfulArchivesCoreTests"
        ),
    ]
)
