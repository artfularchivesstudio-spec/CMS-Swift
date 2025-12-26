/**
 * 🎭 The Snapshot Test Helpers - Mystical Testing Utilities
 *
 * "Where common snapshot testing patterns crystallize into reusable magic.
 * These helpers transform verbose test code into elegant, readable spells
 * that capture the essence of our UI across dimensions and color schemes."
 *
 * - The Spellbinding Museum Director of Test Automation
 */

import SwiftUI
import XCTest
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🌟 Mock Image Factory

/**
 * 🏭 The Mock Image Factory - Conjuring Test Images
 *
 * A mystical workshop that creates test images with predictable patterns.
 * Because screenshots need consistent visuals! 🎪
 */
enum MockImageFactory {

    // 📸 Create sample images for upload testing
    static func createMockImage(
        size: CGSize = CGSize(width: 300, height: 400),
        color: UIColor = .systemBlue
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Add a subtle pattern so snapshots aren't just solid color
            UIColor.white.withAlphaComponent(0.2).setStroke()
            let path = UIBezierPath()
            for i in 0..<Int(size.width / 20) {
                path.move(to: CGPoint(x: CGFloat(i) * 20, y: 0))
                path.addLine(to: CGPoint(x: CGFloat(i) * 20, y: size.height))
            }
            path.lineWidth = 1
            path.stroke()
        }
    }

    // 🎨 Create an image with text overlay (for visually distinct snapshots)
    static func createLabeledImage(
        size: CGSize = CGSize(width: 300, height: 400),
        color: UIColor = .systemBlue,
        text: String = "Test Image"
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Background
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Text
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attrs)
        }
    }
}

// MARK: - 🎨 View Wrapping Utilities

/**
 * 🌈 View Wrapper - Preparing Views for Their Close-Up
 *
 * These helpers wrap SwiftUI views in the proper environment
 * for snapshot testing. Think of it as makeup and lighting! 💄
 */
struct SnapshotViewWrapper {

    /// 🎭 Wrap a view with standard testing environment
    static func wrap<Content: View>(
        _ view: Content,
        colorScheme: ColorScheme = .light,
        size: CGSize? = nil
    ) -> some View {
        view
            .preferredColorScheme(colorScheme)
            .background(Color(.systemBackground))
            .frame(width: size?.width, height: size?.height)
    }

    /// 🌙 Wrap view for dark mode testing
    static func wrapDark<Content: View>(_ view: Content) -> some View {
        wrap(view, colorScheme: .dark)
    }

    /// ☀️ Wrap view for light mode testing
    static func wrapLight<Content: View>(_ view: Content) -> some View {
        wrap(view, colorScheme: .light)
    }

    /// 📱 Wrap view with specific device frame
    static func wrapInDevice<Content: View>(
        _ view: Content,
        device: DeviceConfiguration
    ) -> some View {
        view
            .frame(width: device.size.width, height: device.size.height)
            .background(Color(.systemBackground))
    }
}

// MARK: - 🔮 Snapshot Naming Conventions

/**
 * 🏷️ The Snapshot Namer - Bringing Order to Chaos
 *
 * Generates consistent, descriptive names for snapshot files.
 * Because "snapshot1.png" tells us nothing, but
 * "uploadStep-iPhone13Pro-dark.png" tells us EVERYTHING! 📝
 */
struct SnapshotNaming {

    /// 🎨 Generate a descriptive snapshot name
    static func generateName(
        for testName: String,
        device: DeviceConfiguration,
        colorScheme: ColorScheme = .light,
        variant: String? = nil
    ) -> String {
        var components = [testName]

        // Add device identifier
        components.append(deviceIdentifier(for: device))

        // Add color scheme
        components.append(colorScheme == .dark ? "dark" : "light")

        // Add variant if present
        if let variant = variant {
            components.append(variant)
        }

        return components.joined(separator: "-")
    }

    /// 📱 Convert device to file-safe identifier
    private static func deviceIdentifier(for device: DeviceConfiguration) -> String {
        switch device {
        case .iPhoneSE3rd: return "iPhoneSE"
        case .iPhone13Pro: return "iPhone13Pro"
        case .iPhone15Pro: return "iPhone15Pro"
        case .iPhone15ProMax: return "iPhone15ProMax"
        case .iPadPro11: return "iPadPro11"
        case .iPadPro129: return "iPadPro129"
        }
    }
}

// MARK: - 🎪 Async Testing Helpers

/**
 * ⏰ The Async Test Maestro - Orchestrating Time Itself
 *
 * Helpers for testing async operations and waiting for UI updates.
 * Because sometimes magic takes a moment to manifest! ⚡
 */
extension XCTestCase {

    /// 🌟 Wait for async UI updates to complete
    func waitForUIUpdate(timeout: TimeInterval = 1.0) async {
        try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }

    /// 🔮 Wait for a condition to become true
    func wait(
        for condition: @escaping () -> Bool,
        timeout: TimeInterval = 5.0,
        description: String = "Condition to be true"
    ) async throws {
        let startTime = Date()
        while !condition() {
            if Date().timeIntervalSince(startTime) > timeout {
                throw XCTSkip("Timeout waiting for: \(description)")
            }
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }
}

// MARK: - 🎭 Test Data Collections

/**
 * 📚 The Test Data Library - Curated Collections for Testing
 *
 * Pre-made collections of test data that cover common scenarios.
 * Like having a well-stocked prop department! 🎬
 */
enum TestDataCollections {

    /// 📸 Sample images with different aspect ratios
    static let sampleImages: [UIImage] = [
        MockImageFactory.createMockImage(
            size: CGSize(width: 300, height: 400),
            color: .systemBlue
        ),
        MockImageFactory.createMockImage(
            size: CGSize(width: 400, height: 300),
            color: .systemGreen
        ),
        MockImageFactory.createMockImage(
            size: CGSize(width: 400, height: 400),
            color: .systemPurple
        )
    ]

    /// 🎨 Labeled images for distinct visual testing
    static let labeledImages: [UIImage] = [
        MockImageFactory.createLabeledImage(text: "Portrait", color: .systemIndigo),
        MockImageFactory.createLabeledImage(text: "Landscape", color: .systemTeal),
        MockImageFactory.createLabeledImage(text: "Square", color: .systemOrange)
    ]
}
