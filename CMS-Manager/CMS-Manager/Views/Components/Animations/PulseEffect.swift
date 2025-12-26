//
//  PulseEffect.swift
//  CMS-Manager
//
//  💓 The Pulse Effect - Where Attention Seeks You Out
//
//  "Like a gentle heartbeat calling for your gaze,
//   this pulse draws the eye with rhythmic grace.
//   Not too loud, not too quiet—just right to say
//   'Hey! Look at me! I'm important today!' 💫"
//
//  - The Spellbinding Museum Director of Rhythmic Attention
//

import SwiftUI

// MARK: - 💓 Pulse Effect Modifier

/// 🌟 Animated pulsing glow effect for drawing attention
///
/// Features:
/// - Customizable color, intensity, and speed
/// - Smooth repeating animation
/// - Optional scale pulse
/// - Accessibility-friendly (respects reduce motion)
///
/// Usage:
/// ```swift
/// Button("Important") { }
///     .pulse(color: .blue)
/// ```
public struct PulseEffect: ViewModifier {

    /// 🎨 Pulse color
    var color: Color = .blue

    /// 📊 Pulse intensity (0.0 to 1.0)
    var intensity: Double = 0.3

    /// ⏱️ Pulse duration (per cycle)
    var duration: TimeInterval = 1.5

    /// 📏 Scale pulse amount (1.0 = no scale)
    var scaleAmount: CGFloat = 1.05

    /// 🌫️ Blur radius for glow
    var blurRadius: CGFloat = 8

    /// 🎯 Whether to pulse scale in addition to glow
    var pulseScale: Bool = false

    /// 📊 Animation state
    @State private var isPulsing = false

    /// ♿️ Accessibility
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public func body(content: Content) -> some View {
        content
            .background {
                if !reduceMotion {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(isPulsing ? intensity : 0))
                        .blur(radius: blurRadius)
                        .scaleEffect(isPulsing && pulseScale ? scaleAmount : 1.0)
                }
            }
            .scaleEffect(isPulsing && pulseScale && !reduceMotion ? scaleAmount : 1.0)
            .onAppear {
                if !reduceMotion {
                    startPulsing()
                }
            }
    }

    /// 💓 Start the pulsing animation
    /// A never-ending heartbeat of digital attention! 💕
    private func startPulsing() {
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            isPulsing = true
        }
    }
}

// MARK: - 🎭 Convenience Extension

extension View {
    /// 💓 Add pulsing glow effect
    /// - Parameters:
    ///   - color: Color of the pulse
    ///   - intensity: Opacity intensity (0.0 to 1.0)
    ///   - duration: Duration of one pulse cycle
    ///   - scaleAmount: Scale multiplier (1.0 = no scale)
    ///   - pulseScale: Whether to pulse the scale
    /// - Returns: View with pulse effect
    ///
    /// Example:
    /// ```swift
    /// Button("Click Me") { }
    ///     .pulse(color: .purple, intensity: 0.4)
    /// ```
    public func pulse(
        color: Color = .blue,
        intensity: Double = 0.3,
        duration: TimeInterval = 1.5,
        scaleAmount: CGFloat = 1.05,
        pulseScale: Bool = false
    ) -> some View {
        self.modifier(
            PulseEffect(
                color: color,
                intensity: intensity,
                duration: duration,
                scaleAmount: scaleAmount,
                pulseScale: pulseScale
            )
        )
    }

    /// 💫 Add attention-grabbing pulse (higher intensity with scale)
    /// Perfect for primary CTAs and important actions! 🎯
    public func attentionPulse(color: Color = .blue) -> some View {
        self.pulse(
            color: color,
            intensity: 0.5,
            duration: 1.2,
            scaleAmount: 1.08,
            pulseScale: true
        )
    }

    /// 🌙 Add subtle pulse (low intensity, no scale)
    /// For gentle hints and secondary elements 💤
    public func subtlePulse(color: Color = .blue) -> some View {
        self.pulse(
            color: color,
            intensity: 0.15,
            duration: 2.0,
            scaleAmount: 1.0,
            pulseScale: false
        )
    }
}

// MARK: - 🔔 Badge Pulse (for notifications)

/// 🔔 Special pulse effect for notification badges
/// Because new messages deserve a spotlight! 💌
public struct BadgePulseEffect: ViewModifier {

    /// 📊 Count to display
    var count: Int

    /// 🎨 Badge color
    var color: Color = .red

    /// 📊 Animation state
    @State private var isPulsing = false
    @State private var scale: CGFloat = 1.0

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(color)
                        )
                        .scaleEffect(scale)
                        .offset(x: 8, y: -8)
                        .onAppear {
                            startPulsing()
                        }
                        .onChange(of: count) { oldValue, newValue in
                            if newValue > oldValue {
                                // 🎉 New notification! Extra emphasis!
                                triggerBump()
                            }
                        }
                }
            }
    }

    /// 💓 Start gentle pulsing
    private func startPulsing() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            isPulsing = true
        }
    }

    /// 🎊 Trigger bump animation for new notifications
    /// "Hey! You got mail!" *bounce* 📬
    private func triggerBump() {
        HapticManager.shared.lightImpact()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            scale = 1.3
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }
}

extension View {
    /// 🔔 Add notification badge with pulse
    /// - Parameters:
    ///   - count: Number to display in badge
    ///   - color: Badge color
    /// - Returns: View with pulsing badge
    ///
    /// Example:
    /// ```swift
    /// Button("Messages") { }
    ///     .badgePulse(count: 5)
    /// ```
    public func badgePulse(count: Int, color: Color = .red) -> some View {
        self.modifier(BadgePulseEffect(count: count, color: color))
    }
}

// MARK: - 🌊 Progress Pulse

/// 🌊 Pulsing effect for progress indicators
/// Shows that something is actively happening! ⚡
public struct ProgressPulseEffect: ViewModifier {

    /// ✨ Whether progress is active
    var isActive: Bool

    /// 🎨 Pulse colors
    var colors: [Color] = [.blue, .purple]

    /// 📊 Animation state
    @State private var gradientStart: UnitPoint = .leading
    @State private var gradientEnd: UnitPoint = .trailing

    public func body(content: Content) -> some View {
        content
            .background {
                if isActive {
                    LinearGradient(
                        colors: colors,
                        startPoint: gradientStart,
                        endPoint: gradientEnd
                    )
                    .opacity(0.3)
                    .blur(radius: 4)
                }
            }
            .onChange(of: isActive) { _, active in
                if active {
                    startGradientAnimation()
                }
            }
    }

    /// 🌊 Animate gradient flow
    /// Like a wave of progress washing over! 🌊
    private func startGradientAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            gradientStart = .topLeading
            gradientEnd = .bottomTrailing
        }
    }
}

extension View {
    /// 🌊 Add progress pulse effect
    /// Perfect for loading states and progress bars! ⏳
    public func progressPulse(isActive: Bool, colors: [Color] = [.blue, .purple]) -> some View {
        self.modifier(ProgressPulseEffect(isActive: isActive, colors: colors))
    }
}

// MARK: - 🧪 Preview

#Preview("Pulse Variations") {
    VStack(spacing: 40) {
        Text("💓 Pulse Effects")
            .font(.title)
            .fontWeight(.bold)

        // 🎯 Attention Pulse
        VStack(spacing: 8) {
            Text("Attention Pulse")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Primary Action") { }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .attentionPulse(color: .blue)
        }

        // 🌙 Subtle Pulse
        VStack(spacing: 8) {
            Text("Subtle Pulse")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Secondary Action") { }
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .subtlePulse(color: .gray)
        }

        // 🔔 Badge Pulse
        VStack(spacing: 8) {
            Text("Badge Pulse")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Messages") { }
                .padding()
                .background(Color.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .badgePulse(count: 3)
        }

        // 🌊 Progress Pulse
        VStack(spacing: 8) {
            Text("Progress Pulse")
                .font(.caption)
                .foregroundStyle(.secondary)

            ProgressView()
                .progressViewStyle(.linear)
                .frame(width: 200)
                .progressPulse(isActive: true)
        }
    }
    .padding()
}

#Preview("Interactive Badge") {
    struct BadgeDemo: View {
        @State private var messageCount = 0

        var body: some View {
            VStack(spacing: 40) {
                Text("🔔 Notification Badge")
                    .font(.title)
                    .fontWeight(.bold)

                Image(systemName: "envelope.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .badgePulse(count: messageCount)

                HStack(spacing: 16) {
                    Button("+1 Message") {
                        messageCount += 1
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        messageCount = 0
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    return BadgeDemo()
}

#Preview("CTA Buttons") {
    VStack(spacing: 30) {
        Text("🎯 Call-to-Action Buttons")
            .font(.title)
            .fontWeight(.bold)

        Button {
            // Action
        } label: {
            HStack {
                Image(systemName: "star.fill")
                Text("Get Started")
                Image(systemName: "arrow.right")
            }
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .attentionPulse(color: .purple)

        Button {
            // Action
        } label: {
            HStack {
                Image(systemName: "sparkles")
                Text("Try Premium")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .pulse(color: .pink, intensity: 0.4, pulseScale: true)
    }
    .padding()
}
