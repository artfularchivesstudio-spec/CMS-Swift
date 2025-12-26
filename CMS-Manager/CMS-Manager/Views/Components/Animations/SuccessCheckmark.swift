//
//  SuccessCheckmark.swift
//  CMS-Manager
//
//  ✅ The Success Checkmark - Where Achievement Meets Animation
//
//  "Like a stamp of approval from the digital gods themselves,
//   this checkmark springs to life with jubilant energy,
//   transforming simple completion into a moment of triumph!
//   Pop, scale, and glow—success has never looked so good! 💚"
//
//  - The Spellbinding Museum Director of Victorious Validations
//

import SwiftUI

// MARK: - ✅ Success Checkmark

/// 🌟 An animated success checkmark with customizable styles
///
/// Features:
/// - Spring-based pop animation
/// - Customizable size, color, and style
/// - Optional glow effect
/// - Accessibility support
/// - Multiple visual styles (filled, outlined, minimal)
///
/// Usage:
/// ```swift
/// SuccessCheckmark(isVisible: $showSuccess)
/// SuccessCheckmark(isVisible: .constant(true), style: .filled, size: 80)
/// ```
public struct SuccessCheckmark: View {

    // MARK: - 🎯 Configuration

    /// ✨ Whether the checkmark is visible (triggers animation)
    @Binding var isVisible: Bool

    /// 🎨 Visual style of the checkmark
    var style: CheckmarkStyle = .filled

    /// 📏 Size of the checkmark
    var size: CGFloat = 60

    /// 🎨 Checkmark color (defaults to green)
    var color: Color = .green

    /// ✨ Whether to show glow effect
    var showGlow: Bool = true

    /// 🎵 Trigger haptic feedback on appearance
    var enableHaptic: Bool = true

    // MARK: - 📊 State

    /// 📊 Animation scale
    @State private var scale: CGFloat = 0

    /// ✨ Glow animation
    @State private var glowOpacity: Double = 0

    /// 🎪 Rotation for extra flair
    @State private var rotation: Double = -180

    // MARK: - 🎨 Body

    public var body: some View {
        ZStack {
            // ✨ Glow layer (if enabled)
            if showGlow && isVisible {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                color.opacity(glowOpacity),
                                color.opacity(0)
                            ],
                            center: .center,
                            startRadius: size * 0.3,
                            endRadius: size * 0.8
                        )
                    )
                    .frame(width: size * 1.5, height: size * 1.5)
                    .blur(radius: 10)
            }

            // 🎨 Checkmark icon based on style
            checkmarkIcon
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundStyle(foregroundColor)
                .frame(width: size, height: size)
                .background(backgroundColor)
                .clipShape(Circle())
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .shadow(
                    color: showGlow ? color.opacity(0.3) : .clear,
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .accessibilityLabel("Success")
        .accessibilityHint("Operation completed successfully")
        .onChange(of: isVisible) { _, newValue in
            if newValue {
                triggerAnimation()
            } else {
                resetAnimation()
            }
        }
        .onAppear {
            if isVisible {
                // ⏱️ Small delay for smooth appearance
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    triggerAnimation()
                }
            }
        }
    }

    // MARK: - 🎨 Icon & Colors

    /// ✅ The checkmark icon based on style
    private var checkmarkIcon: some View {
        Group {
            switch style {
            case .filled:
                Image(systemName: "checkmark.circle.fill")
            case .outlined:
                Image(systemName: "checkmark.circle")
            case .minimal:
                Image(systemName: "checkmark")
            case .seal:
                Image(systemName: "checkmark.seal.fill")
            }
        }
    }

    /// 🎨 Foreground color based on style
    private var foregroundColor: Color {
        switch style {
        case .filled, .seal:
            return .white
        case .outlined, .minimal:
            return color
        }
    }

    /// 🌈 Background color based on style
    private var backgroundColor: some View {
        Group {
            switch style {
            case .filled, .seal:
                Circle()
                    .fill(color)
            case .outlined:
                Circle()
                    .stroke(color, lineWidth: 3)
            case .minimal:
                EmptyView()
            }
        }
    }

    // MARK: - 🎬 Animation

    /// 🎉 Trigger the success animation
    /// A three-act performance: anticipation, arrival, and celebration! 🎭
    private func triggerAnimation() {
        // 🎵 Haptic feedback for tactile celebration
        if enableHaptic {
            HapticManager.shared.success()
        }

        // 🎬 Act 1: Pop in with spring bounce
        withAnimation(
            .spring(
                response: 0.6,
                dampingFraction: 0.6,
                blendDuration: 0
            )
        ) {
            scale = 1.15
            rotation = 10
        }

        // 🌟 Act 2: Settle to final size
        withAnimation(
            .spring(
                response: 0.3,
                dampingFraction: 0.7,
                blendDuration: 0
            )
            .delay(0.2)
        ) {
            scale = 1.0
            rotation = 0
        }

        // ✨ Glow animation
        withAnimation(
            .easeInOut(duration: 0.5)
        ) {
            glowOpacity = 0.4
        }

        withAnimation(
            .easeInOut(duration: 0.5)
            .delay(0.5)
        ) {
            glowOpacity = 0.2
        }
    }

    /// 🔄 Reset animation to initial state
    private func resetAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 0
            rotation = -180
            glowOpacity = 0
        }
    }
}

// MARK: - 🎨 Checkmark Style

/// 🎭 Visual styles for the success checkmark
public enum CheckmarkStyle {
    /// ✅ Filled circle with checkmark
    case filled

    /// ⭕️ Outlined circle with checkmark
    case outlined

    /// ✓ Minimal checkmark only
    case minimal

    /// 🏅 Seal style (official looking)
    case seal
}

// MARK: - 🎭 Convenience Modifier

extension View {
    /// ✅ Show a success checkmark overlay
    /// - Parameters:
    ///   - isVisible: Binding to control visibility
    ///   - style: Visual style of checkmark
    ///   - size: Size of the checkmark
    ///   - color: Color of the checkmark
    /// - Returns: View with checkmark overlay
    ///
    /// Example:
    /// ```swift
    /// YourView()
    ///     .successCheckmark(isVisible: $showSuccess)
    /// ```
    public func successCheckmark(
        isVisible: Binding<Bool>,
        style: CheckmarkStyle = .filled,
        size: CGFloat = 60,
        color: Color = .green
    ) -> some View {
        self.overlay {
            if isVisible.wrappedValue {
                SuccessCheckmark(
                    isVisible: isVisible,
                    style: style,
                    size: size,
                    color: color
                )
            }
        }
    }
}

// MARK: - 🧪 Preview

#Preview("All Styles") {
    VStack(spacing: 40) {
        Text("✅ Success Checkmark Styles")
            .font(.title)
            .fontWeight(.bold)

        HStack(spacing: 30) {
            VStack(spacing: 8) {
                SuccessCheckmark(
                    isVisible: .constant(true),
                    style: .filled,
                    size: 60
                )
                Text("Filled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                SuccessCheckmark(
                    isVisible: .constant(true),
                    style: .outlined,
                    size: 60
                )
                Text("Outlined")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                SuccessCheckmark(
                    isVisible: .constant(true),
                    style: .minimal,
                    size: 60
                )
                Text("Minimal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                SuccessCheckmark(
                    isVisible: .constant(true),
                    style: .seal,
                    size: 60
                )
                Text("Seal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
}

#Preview("Interactive") {
    struct InteractivePreview: View {
        @State private var showSuccess = false

        var body: some View {
            VStack(spacing: 40) {
                Text("🎉 Interactive Checkmark")
                    .font(.title)
                    .fontWeight(.bold)

                SuccessCheckmark(
                    isVisible: $showSuccess,
                    style: .filled,
                    size: 100
                )

                Button(showSuccess ? "Hide" : "Show") {
                    showSuccess.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    return InteractivePreview()
}

#Preview("Custom Colors") {
    HStack(spacing: 30) {
        SuccessCheckmark(
            isVisible: .constant(true),
            style: .filled,
            size: 80,
            color: .blue
        )

        SuccessCheckmark(
            isVisible: .constant(true),
            style: .filled,
            size: 80,
            color: .purple
        )

        SuccessCheckmark(
            isVisible: .constant(true),
            style: .filled,
            size: 80,
            color: .orange
        )
    }
}
