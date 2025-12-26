//
//  ButtonStyle+Animations.swift
//  CMS-Manager
//
//  🎨 The Animated Button Styles - Where Interactions Come Alive
//
//  "Every tap, every press, every moment of interaction deserves
//   to feel magical! These button styles transform mundane clicks
//   into delightful micro-celebrations, complete with springs,
//   bounces, and haptic hugs. Because buttons should dance! 💃"
//
//  - The Spellbinding Museum Director of Interactive Choreography
//

import SwiftUI

// MARK: - 🎯 Bouncy Button Style

/// 🎪 A button style that bounces when tapped
/// The classic press-and-release with spring physics! 🎾
public struct BouncyButtonStyle: ButtonStyle {

    /// 📊 Scale amount (0.0 to 1.0, where 1.0 = 100%)
    var scaleAmount: CGFloat = 0.95

    /// 🎵 Enable haptic feedback
    var enableHaptic: Bool = true

    /// 🎨 Haptic style
    var hapticStyle: HapticStyle = .light

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed && enableHaptic {
                    triggerHaptic(hapticStyle)
                }
            }
    }

    /// 🎵 Trigger haptic feedback
    private func triggerHaptic(_ style: HapticStyle) {
        switch style {
        case .light:
            HapticManager.shared.lightImpact()
        case .medium:
            HapticManager.shared.mediumImpact()
        case .heavy:
            HapticManager.heavy()
        case .selection:
            HapticManager.selection()
        }
    }
}

// MARK: - 💫 Pulse Button Style

/// 💓 A button style with a subtle pulsing glow
/// Perfect for primary actions that need attention! ✨
public struct PulseButtonStyle: ButtonStyle {

    /// 🎨 Pulse color
    var pulseColor: Color = .blue

    /// 📊 Pulse intensity (0.0 to 1.0)
    var intensity: Double = 0.3

    /// ⏱️ Pulse duration
    var duration: TimeInterval = 1.5

    /// 🎵 Enable haptic on tap
    var enableHaptic: Bool = true

    @State private var isPulsing = false

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(pulseColor.opacity(isPulsing ? intensity : 0))
                    .blur(radius: 8)
                    .scaleEffect(isPulsing ? 1.1 : 0.9)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onAppear {
                startPulsing()
            }
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed && enableHaptic {
                    HapticManager.shared.mediumImpact()
                }
            }
    }

    /// 💓 Start the pulsing animation
    /// Like a digital heartbeat of attention-seeking! 💕
    private func startPulsing() {
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            isPulsing = true
        }
    }
}

// MARK: - 🎊 Celebration Button Style

/// 🎉 A button that celebrates when tapped with sparkles!
/// For those special moments that deserve extra fanfare! 🎆
public struct CelebrationButtonStyle: ButtonStyle {

    @State private var showSparkles = false
    @State private var scale: CGFloat = 1.0

    /// 🎨 Sparkle colors
    var sparkleColors: [Color] = [.yellow, .orange, .pink, .cyan]

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(scale)
            .overlay {
                SparkleEffect(
                    isActive: $showSparkles,
                    colors: sparkleColors,
                    particleCount: 15,
                    maxDistance: 60
                )
            }
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    handlePress()
                } else {
                    handleRelease()
                }
            }
    }

    /// 🎪 Handle button press
    private func handlePress() {
        HapticManager.shared.mediumImpact()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            scale = 0.95
        }
    }

    /// 🎉 Handle button release (trigger celebration!)
    private func handleRelease() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            scale = 1.05
        }

        // ✨ Trigger sparkles
        showSparkles = true

        // 🎭 Return to normal size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }
}

// MARK: - 🎨 Gradient Shift Button Style

/// 🌈 A button with animated gradient that shifts on press
/// For that extra touch of visual pizzazz! 🎨
public struct GradientShiftButtonStyle: ButtonStyle {

    /// 🎨 Gradient colors
    var colors: [Color] = [.blue, .purple]

    /// 📊 Shift intensity
    var shiftAmount: Double = 0.3

    @State private var gradientStart: UnitPoint = .leading
    @State private var gradientEnd: UnitPoint = .trailing

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                LinearGradient(
                    colors: colors,
                    startPoint: gradientStart,
                    endPoint: gradientEnd
                )
                .animation(.easeInOut(duration: 0.3), value: gradientStart)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    handlePress()
                } else {
                    handleRelease()
                }
            }
            .onAppear {
                // 🌊 Subtle gradient animation
                startGradientAnimation()
            }
    }

    /// 🎪 Handle press
    private func handlePress() {
        HapticManager.shared.lightImpact()
        gradientStart = .topLeading
        gradientEnd = .bottomTrailing
    }

    /// 🎭 Handle release
    private func handleRelease() {
        gradientStart = .leading
        gradientEnd = .trailing
    }

    /// 🌊 Animate gradient subtly
    private func startGradientAnimation() {
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            gradientStart = .topLeading
            gradientEnd = .bottomTrailing
        }
    }
}

// MARK: - 🚨 Shake Button Style (for errors)

/// 💥 A button that shakes when disabled/invalid
/// "Nope, not this time!" *wiggle wiggle* 🙅‍♂️
public struct ShakeButtonStyle: ButtonStyle {

    /// 🚨 Whether to trigger shake
    var shouldShake: Bool

    @State private var shakeOffset: CGFloat = 0

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(x: shakeOffset)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: shouldShake) { _, newValue in
                if newValue {
                    performShake()
                }
            }
    }

    /// 💥 Perform the shake animation
    /// A gentle "no thank you" in motion form! 🙅
    private func performShake() {
        HapticManager.error()

        let animation = Animation.spring(response: 0.2, dampingFraction: 0.3)

        withAnimation(animation) {
            shakeOffset = -10
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(animation) {
                shakeOffset = 10
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(animation) {
                shakeOffset = -5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(animation) {
                shakeOffset = 0
            }
        }
    }
}

// MARK: - 🎵 Haptic Style Enum

/// 🎵 Haptic feedback styles
public enum HapticStyle {
    case light
    case medium
    case heavy
    case selection
}

// MARK: - 🎭 Convenience Extensions

extension ButtonStyle where Self == BouncyButtonStyle {
    /// 🎪 Apply bouncy button style
    public static var bouncy: BouncyButtonStyle {
        BouncyButtonStyle()
    }

    /// 🎪 Apply bouncy button style with custom scale
    public static func bouncy(scale: CGFloat, haptic: HapticStyle = .light) -> BouncyButtonStyle {
        BouncyButtonStyle(scaleAmount: scale, hapticStyle: haptic)
    }
}

extension ButtonStyle where Self == PulseButtonStyle {
    /// 💓 Apply pulse button style
    public static var pulse: PulseButtonStyle {
        PulseButtonStyle()
    }

    /// 💓 Apply pulse with custom color
    public static func pulse(color: Color, intensity: Double = 0.3) -> PulseButtonStyle {
        PulseButtonStyle(pulseColor: color, intensity: intensity)
    }
}

extension ButtonStyle where Self == CelebrationButtonStyle {
    /// 🎉 Apply celebration button style
    public static var celebration: CelebrationButtonStyle {
        CelebrationButtonStyle()
    }

    /// 🎉 Apply celebration with custom sparkle colors
    public static func celebration(colors: [Color]) -> CelebrationButtonStyle {
        CelebrationButtonStyle(sparkleColors: colors)
    }
}

extension ButtonStyle where Self == GradientShiftButtonStyle {
    /// 🌈 Apply gradient shift style
    public static var gradientShift: GradientShiftButtonStyle {
        GradientShiftButtonStyle()
    }

    /// 🌈 Apply gradient with custom colors
    public static func gradientShift(colors: [Color]) -> GradientShiftButtonStyle {
        GradientShiftButtonStyle(colors: colors)
    }
}

// MARK: - 🧪 Preview

#Preview("All Button Styles") {
    ScrollView {
        VStack(spacing: 30) {
            Text("🎨 Animated Button Styles")
                .font(.title)
                .fontWeight(.bold)

            // 🎪 Bouncy
            VStack(spacing: 8) {
                Text("Bouncy")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Tap Me!") { }
                    .buttonStyle(.bouncy)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 💓 Pulse
            VStack(spacing: 8) {
                Text("Pulse")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Primary Action") { }
                    .buttonStyle(.pulse(color: .purple))
                    .padding()
                    .background(Color.purple)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 🎉 Celebration
            VStack(spacing: 8) {
                Text("Celebration")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Success!") { }
                    .buttonStyle(.celebration)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 🌈 Gradient Shift
            VStack(spacing: 8) {
                Text("Gradient Shift")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Fancy Button") { }
                    .buttonStyle(.gradientShift(colors: [.pink, .purple, .blue]))
                    .padding()
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
}

#Preview("Interactive Buttons") {
    struct InteractivePreview: View {
        @State private var count = 0
        @State private var shouldShake = false

        var body: some View {
            VStack(spacing: 40) {
                Text("Tap Counter: \(count)")
                    .font(.title)
                    .fontWeight(.bold)

                Button("+1") {
                    count += 1
                }
                .buttonStyle(.celebration(colors: [.green, .mint, .cyan]))
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Button("Reset") {
                    count = 0
                }
                .buttonStyle(.bouncy(scale: 0.9, haptic: .medium))
                .padding()
                .background(Color.orange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    return InteractivePreview()
}
