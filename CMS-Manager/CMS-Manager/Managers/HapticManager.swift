//
//  HapticManager.swift
//  CMS-Manager
//
//  🎭 The Haptic Manager - Maestro of Tactile Symphonies
//
//  "Like a conductor commanding vibrations through the device,
//   this manager orchestrates haptic feedback that makes
//   every touch feel alive, every interaction sing with
//   physical presence across iOS and macOS realms."
//
//  - The Spellbinding Museum Director of Tactile Feedback
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

// MARK: - 🎭 Haptic Manager

/// 🌟 The orchestrator of tactile feedback - brings touch to life!
/// Supports both iOS (UIFeedbackGenerator) and macOS (NSHapticFeedbackManager)
@MainActor
@Observable
final class HapticManager {

    // MARK: - 🌟 Shared Instance

    /// 🌟 Shared haptic manager instance for convenience
    static let shared = HapticManager()

    // MARK: - 🎨 Generator Storage (iOS only)

    #if os(iOS)
    /// 🎯 Impact generators for different intensities
    private var lightImpactGenerator: UIImpactFeedbackGenerator?
    private var mediumImpactGenerator: UIImpactFeedbackGenerator?
    private var heavyImpactGenerator: UIImpactFeedbackGenerator?
    private var softImpactGenerator: UIImpactFeedbackGenerator?
    private var rigidImpactGenerator: UIImpactFeedbackGenerator?

    /// 🎨 Notification generator for semantic feedback
    private var notificationGenerator: UINotificationFeedbackGenerator?

    /// ✨ Selection generator for picker/toggle interactions
    private var selectionGenerator: UISelectionFeedbackGenerator?
    #endif

    // MARK: - 🔧 Settings

    /// 🌙 Should we respect Reduce Motion accessibility setting?
    private let respectsReduceMotion: Bool

    /// 🎭 Is haptic feedback currently enabled?
    var isEnabled: Bool {
        #if os(iOS)
        // ✨ Check if user has reduced motion enabled (disable haptics if so)
        if respectsReduceMotion && UIAccessibility.isReduceMotionEnabled {
            return false
        }
        return true
        #elseif os(macOS)
        // 🍎 macOS haptics always respect system preferences
        return true
        #else
        return false
        #endif
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Create a haptic manager
    /// - Parameter respectsReduceMotion: If true, disables haptics when Reduce Motion is on (default: true)
    init(respectsReduceMotion: Bool = true) {
        self.respectsReduceMotion = respectsReduceMotion
        print("🎭 ✨ HAPTIC MANAGER AWAKENS!")

        #if os(iOS)
        // 🎨 Pre-warm the generators for instant feedback
        prepareAllGenerators()
        print("🎨 Haptic generators prepared and ready to vibrate!")
        #elseif os(macOS)
        print("🍎 macOS haptic feedback ready!")
        #endif
    }

    // MARK: - 🔧 Generator Management (iOS)

    #if os(iOS)
    /// 🌟 Prepare all generators for instant response
    /// Call this when you know haptics are about to be needed (like entering a form)
    func prepareAllGenerators() {
        guard isEnabled else { return }

        lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
        mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
        heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
        rigidImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
        notificationGenerator = UINotificationFeedbackGenerator()
        selectionGenerator = UISelectionFeedbackGenerator()

        // 🎯 Prepare them all for zero-latency feedback
        lightImpactGenerator?.prepare()
        mediumImpactGenerator?.prepare()
        heavyImpactGenerator?.prepare()
        softImpactGenerator?.prepare()
        rigidImpactGenerator?.prepare()
        notificationGenerator?.prepare()
        selectionGenerator?.prepare()
    }
    #endif

    // MARK: - 🎯 Impact Feedback

    /// 🌟 Light impact - subtle tap for minor interactions
    /// Perfect for: text field focus, small button taps, minor UI changes
    func lightImpact() {
        guard isEnabled else { return }

        #if os(iOS)
        if lightImpactGenerator == nil {
            lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
            lightImpactGenerator?.prepare()
        }
        lightImpactGenerator?.impactOccurred()
        lightImpactGenerator?.prepare() // 🔄 Prep for next time
        #endif
    }

    /// 🌟 Medium impact - noticeable tap for standard interactions
    /// Perfect for: button presses, list selection, navigation
    func mediumImpact() {
        guard isEnabled else { return }

        #if os(iOS)
        if mediumImpactGenerator == nil {
            mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumImpactGenerator?.prepare()
        }
        mediumImpactGenerator?.impactOccurred()
        mediumImpactGenerator?.prepare()
        #endif
    }

    /// 🌟 Heavy impact - strong tap for important actions
    /// Perfect for: deletion confirmation, publishing, major state changes
    func heavyImpact() {
        guard isEnabled else { return }

        #if os(iOS)
        if heavyImpactGenerator == nil {
            heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
            heavyImpactGenerator?.prepare()
        }
        heavyImpactGenerator?.impactOccurred()
        heavyImpactGenerator?.prepare()
        #endif
    }

    /// 🌟 Soft impact - gentle, cushioned feedback
    /// Perfect for: drag and drop, smooth transitions
    func softImpact() {
        guard isEnabled else { return }

        #if os(iOS)
        if softImpactGenerator == nil {
            softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
            softImpactGenerator?.prepare()
        }
        softImpactGenerator?.impactOccurred()
        softImpactGenerator?.prepare()
        #endif
    }

    /// 🌟 Rigid impact - sharp, crisp feedback
    /// Perfect for: precise adjustments, snap-to-grid, exact positioning
    func rigidImpact() {
        guard isEnabled else { return }

        #if os(iOS)
        if rigidImpactGenerator == nil {
            rigidImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
            rigidImpactGenerator?.prepare()
        }
        rigidImpactGenerator?.impactOccurred()
        rigidImpactGenerator?.prepare()
        #endif
    }

    /// 🎨 Custom intensity impact (0.0 to 1.0)
    /// - Parameter intensity: How strong the impact should be (0.0 = light, 1.0 = heavy)
    func impact(intensity: Double) {
        guard isEnabled else { return }

        #if os(iOS)
        // 🎯 Map intensity to appropriate style
        let clampedIntensity = max(0.0, min(1.0, intensity))

        switch clampedIntensity {
        case 0.0..<0.25:
            lightImpact()
        case 0.25..<0.5:
            softImpact()
        case 0.5..<0.75:
            mediumImpact()
        case 0.75..<0.9:
            rigidImpact()
        default:
            heavyImpact()
        }
        #endif
    }

    // MARK: - 🎨 Notification Feedback (Semantic)

    /// ✨ Success haptic - operation completed successfully
    /// Perfect for: form submission, story published, upload complete
    func success() {
        guard isEnabled else { return }

        #if os(iOS)
        if notificationGenerator == nil {
            notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator?.prepare()
        }
        notificationGenerator?.notificationOccurred(.success)
        notificationGenerator?.prepare()
        print("🎉 ✨ SUCCESS HAPTIC FIRED!")
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        print("🎉 ✨ SUCCESS HAPTIC FIRED! (macOS)")
        #endif
    }

    /// ⚠️ Warning haptic - something needs attention
    /// Perfect for: validation warnings, non-critical errors, confirmation dialogs
    func warning() {
        guard isEnabled else { return }

        #if os(iOS)
        if notificationGenerator == nil {
            notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator?.prepare()
        }
        notificationGenerator?.notificationOccurred(.warning)
        notificationGenerator?.prepare()
        print("⚠️ Warning haptic triggered")
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        print("⚠️ Warning haptic triggered (macOS)")
        #endif
    }

    /// 💥 Error haptic - operation failed
    /// Perfect for: upload failure, network error, validation failure
    func error() {
        guard isEnabled else { return }

        #if os(iOS)
        if notificationGenerator == nil {
            notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator?.prepare()
        }
        notificationGenerator?.notificationOccurred(.error)
        notificationGenerator?.prepare()
        print("💥 😭 ERROR HAPTIC FIRED!")
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        print("💥 😭 ERROR HAPTIC FIRED! (macOS)")
        #endif
    }

    // MARK: - ✨ Selection Feedback

    /// ✨ Selection changed - user picked something from a list/picker
    /// Perfect for: segmented control, picker view, list selection, toggle
    func selection() {
        guard isEnabled else { return }

        #if os(iOS)
        if selectionGenerator == nil {
            selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator?.prepare()
        }
        selectionGenerator?.selectionChanged()
        selectionGenerator?.prepare()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }

    // MARK: - 🎭 Compound Feedback (Special Combos)

    /// 🎉 Celebration - major accomplishment!
    /// Fires a sequence of haptics for extra delight
    /// Perfect for: story published, batch operation complete, achievement unlocked
    func celebrate() {
        guard isEnabled else { return }

        print("🎊 🎉 CELEBRATION HAPTIC SEQUENCE AWAKENS!")

        success()

        // 🎪 Add a cascade of impacts for extra pizzazz
        Task {
            try? await Task.sleep(for: .milliseconds(100))
            lightImpact()

            try? await Task.sleep(for: .milliseconds(100))
            mediumImpact()

            try? await Task.sleep(for: .milliseconds(100))
            lightImpact()
        }
    }

    /// 🌊 Pulse - rhythmic feedback sequence
    /// Perfect for: loading progress, processing indication
    func pulse(count: Int = 3, interval: Duration = .milliseconds(150)) {
        guard isEnabled else { return }

        print("🌊 Pulse haptic sequence starting (\(count) pulses)")

        Task {
            for i in 0..<count {
                softImpact()
                if i < count - 1 {
                    try? await Task.sleep(for: interval)
                }
            }
        }
    }

    /// ⚡️ Quick tap - instant light feedback for rapid interactions
    /// Perfect for: typing feedback, rapid button presses
    func quickTap() {
        guard isEnabled else { return }

        #if os(iOS)
        // 🎯 Use soft impact for quick, non-intrusive feedback
        if softImpactGenerator == nil {
            softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
            softImpactGenerator?.prepare()
        }
        softImpactGenerator?.impactOccurred(intensity: 0.5)
        softImpactGenerator?.prepare()
        #endif
    }

    // MARK: - 🧹 Cleanup

    /// 🌙 Release all generators to save resources
    /// Call this when leaving a screen or when haptics won't be needed for a while
    func cleanup() {
        #if os(iOS)
        lightImpactGenerator = nil
        mediumImpactGenerator = nil
        heavyImpactGenerator = nil
        softImpactGenerator = nil
        rigidImpactGenerator = nil
        notificationGenerator = nil
        selectionGenerator = nil
        print("🌙 Haptic generators released - sweet dreams!")
        #endif
    }
}

// MARK: - 🧪 Mock Haptic Manager

/// 🧪 Mock haptic manager for testing - logs instead of vibrating
@MainActor
final class MockHapticManager {
    var lastHapticType: String?

    func lightImpact() { lastHapticType = "lightImpact" }
    func mediumImpact() { lastHapticType = "mediumImpact" }
    func heavyImpact() { lastHapticType = "heavyImpact" }
    func softImpact() { lastHapticType = "softImpact" }
    func rigidImpact() { lastHapticType = "rigidImpact" }
    func success() { lastHapticType = "success" }
    func warning() { lastHapticType = "warning" }
    func error() { lastHapticType = "error" }
    func selection() { lastHapticType = "selection" }
    func celebrate() { lastHapticType = "celebrate" }
}
