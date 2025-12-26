//
//  HapticViewModifiers.swift
//  CMS-Manager
//
//  🎭 Haptic View Modifiers - Enchanted Touch Extensions
//
//  "Like invisible sprites adding tactile magic to every interaction,
//   these modifiers make SwiftUI come alive with vibrations,
//   turning cold glass into a responsive, living canvas."
//
//  - The Spellbinding Museum Director of Tactile UX
//

import SwiftUI

// MARK: - 🎭 Haptic Feedback View Modifier

/// 🌟 A view modifier that triggers haptic feedback on tap
struct HapticFeedbackModifier: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🎭 The haptic manager
    let hapticManager: HapticManager

    /// 🎨 The type of haptic to trigger
    let feedbackType: HapticFeedbackType

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        triggerHaptic()
                    }
            )
    }

    // MARK: - 🌟 Helpers

    /// ✨ Trigger the appropriate haptic
    private func triggerHaptic() {
        switch feedbackType {
        case .light:
            hapticManager.lightImpact()
        case .medium:
            hapticManager.mediumImpact()
        case .heavy:
            hapticManager.heavyImpact()
        case .soft:
            hapticManager.softImpact()
        case .rigid:
            hapticManager.rigidImpact()
        case .success:
            hapticManager.success()
        case .warning:
            hapticManager.warning()
        case .error:
            hapticManager.error()
        case .selection:
            hapticManager.selection()
        }
    }
}

// MARK: - 🎨 Haptic Feedback Type

/// 🎨 The types of haptic feedback available
enum HapticFeedbackType {
    case light      // 🌟 Subtle tap
    case medium     // 🌟 Standard tap
    case heavy      // 🌟 Strong tap
    case soft       // 🌟 Gentle cushioned
    case rigid      // 🌟 Sharp crisp
    case success    // ✅ Success notification
    case warning    // ⚠️ Warning notification
    case error      // ❌ Error notification
    case selection  // ✨ Selection changed
}

// MARK: - 🎭 Success Haptic Modifier

/// 🎉 A modifier that triggers success haptic when a condition becomes true
struct SuccessHapticModifier: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🎭 The haptic manager
    let hapticManager: HapticManager

    /// ✅ Should we trigger the success haptic?
    let trigger: Bool

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    hapticManager.success()
                }
            }
    }
}

// MARK: - 🎭 Error Haptic Modifier

/// 💥 A modifier that triggers error haptic when an error appears
struct ErrorHapticModifier: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🎭 The haptic manager
    let hapticManager: HapticManager

    /// ❌ The error to watch (triggers haptic when error appears)
    let error: (any Error)?

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .onChange(of: error?.localizedDescription) { _, newValue in
                if newValue != nil {
                    hapticManager.error()
                }
            }
    }
}

// MARK: - 🎭 State Change Haptic Modifier

/// ✨ A modifier that triggers haptic when any value changes
struct StateChangeHapticModifier<Value: Equatable>: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🎭 The haptic manager
    let hapticManager: HapticManager

    /// 📊 The value to watch
    let value: Value

    /// 🎨 The type of haptic
    let feedbackType: HapticFeedbackType

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .onChange(of: value) { _, _ in
                switch feedbackType {
                case .light:
                    hapticManager.lightImpact()
                case .medium:
                    hapticManager.mediumImpact()
                case .heavy:
                    hapticManager.heavyImpact()
                case .soft:
                    hapticManager.softImpact()
                case .rigid:
                    hapticManager.rigidImpact()
                case .success:
                    hapticManager.success()
                case .warning:
                    hapticManager.warning()
                case .error:
                    hapticManager.error()
                case .selection:
                    hapticManager.selection()
                }
            }
    }
}

// MARK: - 🎨 View Extensions

/// ✨ Convenient haptic feedback extensions for any View
extension View {

    // MARK: - 🎯 Basic Haptic Feedback

    /// 🌟 Add haptic feedback on tap
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - type: The type of haptic feedback (default: .light)
    /// - Returns: Modified view with haptic feedback
    func hapticFeedback(_ manager: HapticManager, type: HapticFeedbackType = .light) -> some View {
        modifier(HapticFeedbackModifier(hapticManager: manager, feedbackType: type))
    }

    // MARK: - 🎨 Semantic Haptics

    /// ✅ Trigger success haptic when condition becomes true
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - trigger: When this becomes true, haptic fires
    /// - Returns: Modified view
    func successHaptic(_ manager: HapticManager, trigger: Bool) -> some View {
        modifier(SuccessHapticModifier(hapticManager: manager, trigger: trigger))
    }

    /// ❌ Trigger error haptic when error appears
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - error: When this becomes non-nil, haptic fires
    /// - Returns: Modified view
    func errorHaptic(_ manager: HapticManager, error: (any Error)?) -> some View {
        modifier(ErrorHapticModifier(hapticManager: manager, error: error))
    }

    /// ⚠️ Trigger warning haptic when condition becomes true
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - trigger: When this becomes true, haptic fires
    /// - Returns: Modified view
    func warningHaptic(_ manager: HapticManager, trigger: Bool) -> some View {
        self.onChange(of: trigger) { _, newValue in
            if newValue {
                manager.warning()
            }
        }
    }

    // MARK: - 📊 State-Based Haptics

    /// ✨ Trigger haptic when a value changes
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - value: The value to watch for changes
    ///   - type: The type of haptic (default: .selection)
    /// - Returns: Modified view
    func hapticOnChange<Value: Equatable>(
        _ manager: HapticManager,
        of value: Value,
        type: HapticFeedbackType = .selection
    ) -> some View {
        modifier(StateChangeHapticModifier(hapticManager: manager, value: value, feedbackType: type))
    }

    // MARK: - 🎯 Quick Impact Shortcuts

    /// 🌟 Light impact haptic on tap
    func lightHaptic(_ manager: HapticManager) -> some View {
        hapticFeedback(manager, type: .light)
    }

    /// 🌟 Medium impact haptic on tap
    func mediumHaptic(_ manager: HapticManager) -> some View {
        hapticFeedback(manager, type: .medium)
    }

    /// 🌟 Heavy impact haptic on tap
    func heavyHaptic(_ manager: HapticManager) -> some View {
        hapticFeedback(manager, type: .heavy)
    }

    /// ✨ Selection haptic on tap
    func selectionHaptic(_ manager: HapticManager) -> some View {
        hapticFeedback(manager, type: .selection)
    }
}

// MARK: - 🎭 Button Extensions

/// 🎨 Haptic feedback extensions specifically for Buttons
extension View {

    /// 🎯 Standard button haptic (selection feedback)
    /// Perfect for most button interactions
    func buttonHaptic(_ manager: HapticManager) -> some View {
        selectionHaptic(manager)
    }

    /// ✅ Positive action button haptic (light impact)
    /// Perfect for: save, submit, confirm, add
    func positiveActionHaptic(_ manager: HapticManager) -> some View {
        lightHaptic(manager)
    }

    /// ⚠️ Destructive action button haptic (medium impact)
    /// Perfect for: delete, remove, cancel (destructive actions)
    func destructiveActionHaptic(_ manager: HapticManager) -> some View {
        mediumHaptic(manager)
    }

    /// 🎉 Primary action button haptic (medium impact)
    /// Perfect for: publish, send, create (main CTAs)
    func primaryActionHaptic(_ manager: HapticManager) -> some View {
        mediumHaptic(manager)
    }
}

// MARK: - 🎭 Toggle Extensions

/// ✨ Haptic feedback for Toggle controls
struct ToggleHapticModifier: ViewModifier {

    // MARK: - 🏺 Properties

    let hapticManager: HapticManager
    @Binding var isOn: Bool

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .onChange(of: isOn) { _, _ in
                hapticManager.selection()
            }
    }
}

extension View {
    /// ✨ Add haptic feedback to a Toggle
    /// - Parameters:
    ///   - manager: The haptic manager
    ///   - isOn: The binding that tracks toggle state
    /// - Returns: Modified view
    func toggleHaptic(_ manager: HapticManager, isOn: Binding<Bool>) -> some View {
        modifier(ToggleHapticModifier(hapticManager: manager, isOn: isOn))
    }
}

// MARK: - 🎭 TextField Extensions

/// 🌟 Haptic feedback for TextField focus
struct TextFieldHapticModifier: ViewModifier {

    // MARK: - 🏺 Properties

    let hapticManager: HapticManager
    @FocusState private var isFocused: Bool

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { _, newValue in
                if newValue {
                    hapticManager.lightImpact()
                }
            }
    }
}

extension View {
    /// 🌟 Add haptic feedback when TextField gains focus
    /// - Parameter manager: The haptic manager
    /// - Returns: Modified view
    func textFieldFocusHaptic(_ manager: HapticManager) -> some View {
        modifier(TextFieldHapticModifier(hapticManager: manager))
    }
}
