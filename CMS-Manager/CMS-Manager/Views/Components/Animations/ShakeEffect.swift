//
//  ShakeEffect.swift
//  CMS-Manager
//
//  💥 The Shake Effect - When "No" Needs a Physical Form
//
//  "Sometimes the universe says 'not today' and we must convey
//   that message with a gentle wiggle. This shake effect brings
//   personality to rejection, turning validation errors into
//   friendly nudges that say 'try again, dear friend!' 🙅‍♂️"
//
//  - The Spellbinding Museum Director of Kinetic Communication
//

import SwiftUI

// MARK: - 💥 Shake Effect Modifier

/// 🎭 Animated shake effect for validation errors and disabled states
///
/// Features:
/// - Customizable shake intensity and duration
/// - Automatic haptic feedback
/// - Smooth spring-based animation
/// - Accessibility-friendly (respects reduce motion)
///
/// Usage:
/// ```swift
/// TextField("Email", text: $email)
///     .shake(trigger: $invalidEmail)
/// ```
public struct ShakeEffect: ViewModifier {

    /// 🎯 Trigger for shake animation
    @Binding var trigger: Bool

    /// 📊 Shake intensity (distance in points)
    var intensity: CGFloat = 10

    /// ⏱️ Shake duration
    var duration: TimeInterval = 0.5

    /// 🎵 Enable haptic feedback
    var enableHaptic: Bool = true

    /// 📊 Animation state
    @State private var offset: CGFloat = 0

    /// ♿️ Accessibility
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public func body(content: Content) -> some View {
        content
            .offset(x: reduceMotion ? 0 : offset)
            .onChange(of: trigger) { _, shouldShake in
                if shouldShake {
                    performShake()
                }
            }
    }

    /// 💥 Perform the shake animation
    /// A choreographed sequence of left-right movements! 🎭
    private func performShake() {
        guard !reduceMotion else {
            // 🎵 Still provide haptic feedback even with reduced motion
            if enableHaptic {
                HapticManager.shared.error()
            }
            trigger = false
            return
        }

        // 🎵 Haptic feedback for tactile emphasis
        if enableHaptic {
            HapticManager.shared.error()
        }

        // 🎪 The shake dance: left, right, left, right, center!
        let animation = Animation.spring(response: 0.2, dampingFraction: 0.3)

        // 💫 Shake sequence
        withAnimation(animation) {
            offset = -intensity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.2) {
            withAnimation(animation) {
                offset = intensity
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.4) {
            withAnimation(animation) {
                offset = -intensity * 0.7
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.6) {
            withAnimation(animation) {
                offset = intensity * 0.4
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.8) {
            withAnimation(animation) {
                offset = 0
            }
        }

        // 🧹 Reset trigger after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            trigger = false
        }
    }
}

// MARK: - 🎭 Convenience Extension

extension View {
    /// 💥 Add shake animation on trigger
    /// - Parameters:
    ///   - trigger: Binding that triggers the shake
    ///   - intensity: How far to shake (in points)
    ///   - duration: Total duration of shake animation
    ///   - enableHaptic: Whether to trigger haptic feedback
    /// - Returns: View with shake effect
    ///
    /// Example:
    /// ```swift
    /// TextField("Password", text: $password)
    ///     .shake(trigger: $passwordInvalid)
    /// ```
    public func shake(
        trigger: Binding<Bool>,
        intensity: CGFloat = 10,
        duration: TimeInterval = 0.5,
        enableHaptic: Bool = true
    ) -> some View {
        self.modifier(
            ShakeEffect(
                trigger: trigger,
                intensity: intensity,
                duration: duration,
                enableHaptic: enableHaptic
            )
        )
    }

    /// 💥 Convenience shake with count-based trigger
    /// Useful when you want to shake on each validation attempt
    /// - Parameter count: Number of times to trigger (increments trigger shake)
    /// - Returns: View with shake effect
    ///
    /// Example:
    /// ```swift
    /// TextField("Email", text: $email)
    ///     .shakeOnCount($validationAttempts)
    /// ```
    public func shakeOnCount(_ count: Binding<Int>) -> some View {
        ShakeOnCountView(count: count) {
            self
        }
    }
}

// MARK: - 📊 Shake On Count Helper View

/// 🎭 Helper view that triggers shake when count changes
/// Because sometimes we need to shake multiple times! 🎪
struct ShakeOnCountView<Content: View>: View {
    @Binding var count: Int
    @State private var shouldShake = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .shake(trigger: $shouldShake)
            .onChange(of: count) { oldValue, newValue in
                if oldValue != newValue {
                    shouldShake = true
                }
            }
    }
}

// MARK: - 🧪 Preview

#Preview("Shake Demo") {
    struct ShakeDemo: View {
        @State private var shouldShake = false
        @State private var shakeCount = 0

        var body: some View {
            VStack(spacing: 40) {
                Text("💥 Shake Effect")
                    .font(.title)
                    .fontWeight(.bold)

                // 🎯 Shake trigger example
                VStack(spacing: 16) {
                    Text("❌ Invalid Input")
                        .font(.headline)
                        .foregroundStyle(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.opacity(0.1))
                        )
                        .shake(trigger: $shouldShake)

                    Button("Trigger Shake") {
                        shouldShake = true
                    }
                    .buttonStyle(.borderedProminent)
                }

                Divider()

                // 📊 Shake count example
                VStack(spacing: 16) {
                    Text("Count: \(shakeCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.orange.opacity(0.1))
                        )
                        .shakeOnCount($shakeCount)

                    Button("Increment (Shakes)") {
                        shakeCount += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            .padding()
        }
    }

    return ShakeDemo()
}

#Preview("Form Validation") {
    struct FormValidationDemo: View {
        @State private var email = ""
        @State private var password = ""
        @State private var emailInvalid = false
        @State private var passwordInvalid = false

        var body: some View {
            Form {
                Section("Login Form") {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .shake(trigger: $emailInvalid)

                        if emailInvalid {
                            Text("❌ Invalid email address")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .shake(trigger: $passwordInvalid)

                        if passwordInvalid {
                            Text("❌ Password too short")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }

                Button("Submit") {
                    validate()
                }
                .buttonStyle(.borderedProminent)
            }
        }

        func validate() {
            emailInvalid = !email.contains("@")
            passwordInvalid = password.count < 6
        }
    }

    return FormValidationDemo()
}
