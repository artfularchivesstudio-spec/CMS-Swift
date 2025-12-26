//
//  ShimmerModifier.swift
//  CMS-Manager
//
//  ✨ The Shimmer Alchemist - Magical Gradient Sweeps
//
//  "Watch as light dances across placeholders,
//   a diagonal sweep of hope that says 'content is coming soon,'
//   making waiting feel less like waiting and more like anticipation."
//
//  - The Spellbinding Museum Director of Loading Experiences
//

import SwiftUI

// MARK: - ✨ Shimmer Modifier

/// ✨ Applies a diagonal shimmer animation to any view
/// The mystical gradient sweep that makes waiting delightful!
struct ShimmerModifier: ViewModifier {

    // MARK: - 🌟 State

    /// 🌀 Animation phase for the shimmer sweep
    @State private var phase: CGFloat = 0

    // MARK: - 🎨 Properties

    /// 🎨 Animation speed (duration in seconds)
    let duration: Double

    /// 🎨 Whether to reduce motion for accessibility
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// 🎨 Color scheme for adaptive colors
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
                    // 🌊 Animated shimmer gradient sweep
                    GeometryReader { geometry in
                        LinearGradient(
                            stops: gradientStops,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .rotationEffect(.degrees(-45))
                        .frame(
                            width: geometry.size.width * 2,
                            height: geometry.size.height * 2
                        )
                        .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                        .blendMode(.overlay)
                    }
                    .clipped()
                    .onAppear {
                        // 🎬 Start the mystical shimmer animation
                        withAnimation(
                            .linear(duration: duration)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = 1
                        }
                    }
                } else {
                    // ♿ Reduced motion: Static subtle overlay
                    Color.white.opacity(colorScheme == .dark ? 0.05 : 0.1)
                        .blendMode(.overlay)
                }
            }
    }

    // MARK: - 🎨 Gradient Configuration

    /// 🎨 Gradient stops for the shimmer effect
    /// Base → Highlight → Base creates the sweep
    private var gradientStops: [Gradient.Stop] {
        let highlightColor = Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4)

        return [
            .init(color: .clear, location: 0),
            .init(color: highlightColor, location: 0.5),
            .init(color: .clear, location: 1)
        ]
    }
}

// MARK: - 🎨 View Extension

extension View {
    /// ✨ Apply shimmer animation to any view
    /// - Parameter duration: Animation duration (default: 1.5s)
    /// - Returns: View with shimmer overlay
    func shimmer(duration: Double = 1.5) -> some View {
        modifier(ShimmerModifier(duration: duration))
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Shimmer Boxes") {
    VStack(spacing: 20) {
        // 🎨 Different sized shimmer boxes
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(white: 0.9))
            .frame(height: 100)
            .shimmer()

        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.9))
                .frame(width: 80, height: 80)
                .shimmer()

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(white: 0.9))
                    .frame(height: 16)
                    .shimmer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(white: 0.9))
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
                    .shimmer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(white: 0.9))
                    .frame(height: 14)
                    .frame(width: 120)
                    .shimmer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
