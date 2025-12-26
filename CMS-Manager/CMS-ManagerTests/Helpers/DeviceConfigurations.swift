/**
 * 🎭 The Device Configurations Observatory - Where Testing Meets Reality
 *
 * "In the mystical realm of snapshot testing, we must account for every device,
 * every screen size, every pixel density. This cosmic catalog ensures our UI
 * performs its magic across the entire Apple ecosystem."
 *
 * - The Spellbinding Museum Director of Test Devices
 */

import SwiftUI
import SnapshotTesting

// MARK: - 🌟 Device Configuration Magic

/**
 * 📱 The Device Configuration Enum - Our Gallery of Test Subjects
 *
 * Each case represents a physical device configuration we test against.
 * Think of it as casting directors for our UI performance! 🎪
 */
enum DeviceConfiguration {
    case iPhoneSE3rd
    case iPhone13Pro
    case iPhone15Pro
    case iPhone15ProMax
    case iPadPro11
    case iPadPro129

    // 🎨 The Mystical Screen Dimensions
    var viewImageConfig: ViewImageConfig {
        switch self {
        case .iPhoneSE3rd:
            // 📱 The compact champion - testing UI at its coziest!
            return .iPhone13Mini

        case .iPhone13Pro:
            // 📱 The standard bearer - our baseline for most tests
            return .iPhone13Pro

        case .iPhone15Pro:
            // 📱 The modern marvel - Dynamic Island and all!
            return .iPhone13Pro // Using iPhone13Pro as proxy until SnapshotTesting updates

        case .iPhone15ProMax:
            // 📱 The grand stage - where everything gets MORE dramatic
            return .iPhone13ProMax

        case .iPadPro11:
            // 📱 The portable canvas - compact iPad testing
            return .iPadPro11

        case .iPadPro129:
            // 📱 The ultimate masterpiece - our largest stage
            return .iPadPro12_9
        }
    }

    // 🏷️ Human-Readable Names (for that personal touch)
    var displayName: String {
        switch self {
        case .iPhoneSE3rd: return "iPhone SE (3rd gen)"
        case .iPhone13Pro: return "iPhone 13 Pro"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPadPro11: return "iPad Pro 11\""
        case .iPadPro129: return "iPad Pro 12.9\""
        }
    }

    // 📐 The Cosmic Dimensions
    var size: CGSize {
        viewImageConfig.size ?? .zero
    }

    // 🎭 Safe Area Insets (because notches and Dynamic Islands need love too)
    var safeAreaInsets: UIEdgeInsets {
        viewImageConfig.safeArea
    }
}

// MARK: - 🌈 Common Device Sets

extension DeviceConfiguration {
    /**
     * 📱 The Essential iPhone Collection
     * Test against the three most common iPhone form factors
     */
    static var iPhoneEssentials: [DeviceConfiguration] {
        [.iPhoneSE3rd, .iPhone13Pro, .iPhone15ProMax]
    }

    /**
     * 🎨 The Complete iPhone Gallery
     * Every iPhone variation we support
     */
    static var allIPhones: [DeviceConfiguration] {
        [.iPhoneSE3rd, .iPhone13Pro, .iPhone15Pro, .iPhone15ProMax]
    }

    /**
     * 📱 The iPad Collection
     * Both iPad Pro sizes for that spacious testing
     */
    static var iPads: [DeviceConfiguration] {
        [.iPadPro11, .iPadPro129]
    }

    /**
     * 🌟 The Complete Ensemble
     * Every device we test - the full theatrical cast!
     */
    static var all: [DeviceConfiguration] {
        allIPhones + iPads
    }
}

// MARK: - 🎨 Snapshot Strategy Configurations

/**
 * 🔮 Snapshot Strategy - How We Capture the Magic
 *
 * Different strategies for different testing scenarios.
 * Sometimes you need precision, sometimes you need speed! ⚡
 */
struct SnapshotStrategy {
    let precision: Float
    let perceptualPrecision: Float
    let scale: CGFloat?

    /// 🎯 Pixel-perfect precision (default)
    /// When every pixel matters and you're feeling perfectionist
    static let exact = SnapshotStrategy(
        precision: 1.0,
        perceptualPrecision: 1.0,
        scale: nil
    )

    /// 🌊 Relaxed precision
    /// For when minor rendering differences are acceptable
    /// (Looking at you, system fonts that change between OS versions!)
    static let relaxed = SnapshotStrategy(
        precision: 0.98,
        perceptualPrecision: 0.95,
        scale: nil
    )

    /// ⚡ Fast comparison
    /// Lower resolution for quicker test runs
    /// Perfect for CI pipelines that need to zoom! 🏃‍♂️
    static let fast = SnapshotStrategy(
        precision: 0.95,
        perceptualPrecision: 0.90,
        scale: 1.0
    )
}

// MARK: - 🎭 Snapshot Recording Mode

/**
 * 📸 The Recording Booth - Where Snapshots Are Born
 *
 * Set this to control whether we're recording new snapshots
 * or comparing against existing ones.
 */
enum SnapshotMode {
    case record      // 📸 Capture new reference images
    case compare     // 🔍 Verify against existing snapshots

    var isRecording: Bool {
        switch self {
        case .record: return true
        case .compare: return false
        }
    }
}
