//
//  ConfettiView.swift
//  CMS-Manager
//
//  🎊 The Confetti View - Where Digital Joy Rains From Above
//
//  "Like mystical celebration falling from the cosmic heavens,
//   each particle dances with its own rhythm and color,
//   creating a symphony of visual delight that makes every
//   success feel like a standing ovation!"
//
//  - The Spellbinding Museum Director of Jubilant Celebrations
//

import SwiftUI

// MARK: - 🎊 Confetti View

/// 🎉 A customizable confetti particle system for celebrations
///
/// Features:
/// - Customizable particle count, colors, and physics
/// - Smooth animations with spring physics
/// - Performance-optimized particle generation
/// - Auto-dismissal support
/// - Accessibility-friendly (respects reduce motion)
///
/// Usage:
/// ```swift
/// ZStack {
///     YourContentView()
///     ConfettiView(isActive: $showConfetti)
/// }
/// ```
public struct ConfettiView: View {

    // MARK: - 🎯 Configuration

    /// ✨ Whether the confetti is currently active
    @Binding var isActive: Bool

    /// 🎨 Available confetti colors
    var colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .mint, .cyan]

    /// 📊 Number of confetti particles
    var particleCount: Int = 150

    /// ⏱️ Duration in seconds before auto-dismissing
    var autoDismissAfter: TimeInterval? = 3.0

    // MARK: - 📊 State

    /// 🎊 The mystical confetti particles dancing across the screen
    @State private var particles: [ConfettiParticle] = []

    /// 🎭 Animation state
    @State private var animationStarted = false

    /// ♿️ Accessibility: Reduce motion preference
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - 🎨 Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 🎊 Only show confetti if active and not reducing motion
                if isActive && !reduceMotion {
                    ForEach(particles) { particle in
                        ConfettiParticleView(
                            particle: particle,
                            geometry: geometry,
                            isAnimating: animationStarted
                        )
                    }
                }
            }
            .allowsHitTesting(false)
            .onChange(of: isActive) { oldValue, newValue in
                if newValue {
                    startConfetti(in: geometry.size)
                } else {
                    stopConfetti()
                }
            }
        }
    }

    // MARK: - 🎊 Confetti Control

    /// 🌟 Start the confetti celebration!
    /// Because every achievement deserves a proper fanfare! 🎺
    private func startConfetti(in size: CGSize) {
        // 🧹 Clear any existing particles
        particles.removeAll()
        animationStarted = false

        // 🎭 Generate new particles across the top of the screen
        for _ in 0..<particleCount {
            let particle = ConfettiParticle(
                x: CGFloat.random(in: 0...size.width),
                y: -50, // Start above the screen
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 6...14),
                rotation: Double.random(in: 0...360),
                speed: Double.random(in: 2...5),
                wobbleAmount: CGFloat.random(in: 20...50),
                rotationSpeed: Double.random(in: 200...800)
            )
            particles.append(particle)
        }

        // 🎬 Start animation with a tiny delay for smooth appearance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation {
                animationStarted = true
            }
        }

        // ⏰ Auto-dismiss if configured
        if let dismissDelay = autoDismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
                stopConfetti()
            }
        }
    }

    /// 🛑 Stop the confetti and clean up
    /// Like curtains closing after a magnificent performance 🎭
    private func stopConfetti() {
        withAnimation(.easeOut(duration: 0.3)) {
            animationStarted = false
        }

        // 🧹 Clean up particles after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            particles.removeAll()
            isActive = false
        }
    }
}

// MARK: - 🎊 Confetti Particle Model

/// 🎭 Individual confetti particle with physics properties
struct ConfettiParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let size: CGFloat
    let rotation: Double
    let speed: Double
    let wobbleAmount: CGFloat
    let rotationSpeed: Double
}

// MARK: - 🎨 Confetti Particle View

/// 🌟 Renders and animates a single confetti particle
/// Each particle is a tiny performer in our celebration ballet! 🩰
struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    let geometry: GeometryProxy
    let isAnimating: Bool

    /// 📊 Animated position and rotation
    @State private var offsetY: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    @State private var currentRotation: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .rotationEffect(.degrees(currentRotation))
            .offset(x: particle.x + offsetX, y: particle.y + offsetY)
            .opacity(isAnimating ? 1 : 0)
            .onAppear {
                // 🎭 Start the falling animation when particle appears
                if isAnimating {
                    startAnimation()
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    startAnimation()
                } else {
                    resetAnimation()
                }
            }
    }

    /// 🎬 Start the particle's dance routine
    /// A carefully choreographed performance of falling, wobbling, and spinning! 💫
    private func startAnimation() {
        // 🌊 Falling animation with wobble
        withAnimation(
            .linear(duration: particle.speed)
        ) {
            offsetY = geometry.size.height + 100
        }

        // 🎪 Wobble animation (side-to-side movement)
        withAnimation(
            .easeInOut(duration: particle.speed / 2)
            .repeatForever(autoreverses: true)
        ) {
            offsetX = particle.wobbleAmount
        }

        // 🎡 Rotation animation
        withAnimation(
            .linear(duration: particle.speed)
        ) {
            currentRotation = particle.rotation + particle.rotationSpeed
        }
    }

    /// 🔄 Reset particle to initial state
    private func resetAnimation() {
        offsetY = 0
        offsetX = 0
        currentRotation = particle.rotation
    }
}

// MARK: - 🎭 Convenience Modifier

extension View {
    /// 🎊 Add confetti celebration to any view
    /// - Parameters:
    ///   - isActive: Binding to control confetti visibility
    ///   - colors: Array of colors for confetti particles
    ///   - particleCount: Number of particles to generate
    ///   - autoDismissAfter: Optional duration before auto-dismissing
    /// - Returns: View with confetti overlay
    ///
    /// Example:
    /// ```swift
    /// YourView()
    ///     .confetti(isActive: $showCelebration)
    /// ```
    public func confetti(
        isActive: Binding<Bool>,
        colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .mint, .cyan],
        particleCount: Int = 150,
        autoDismissAfter: TimeInterval? = 3.0
    ) -> some View {
        self.overlay {
            ConfettiView(
                isActive: isActive,
                colors: colors,
                particleCount: particleCount,
                autoDismissAfter: autoDismissAfter
            )
        }
    }
}

// MARK: - 🧪 Preview

#Preview("Confetti Celebration") {
    struct ConfettiPreview: View {
        @State private var showConfetti = false

        var body: some View {
            VStack(spacing: 30) {
                Text("🎉 Confetti Celebration")
                    .font(.title)
                    .fontWeight(.bold)

                Button("Trigger Confetti") {
                    showConfetti = true
                }
                .buttonStyle(.borderedProminent)

                Button("Stop Confetti") {
                    showConfetti = false
                }
                .buttonStyle(.bordered)
            }
            .confetti(isActive: $showConfetti)
        }
    }

    return ConfettiPreview()
}

#Preview("Custom Colors") {
    struct CustomConfettiPreview: View {
        @State private var showConfetti = true

        var body: some View {
            VStack {
                Text("🌈 Custom Colors")
                    .font(.title)
            }
            .confetti(
                isActive: $showConfetti,
                colors: [.purple, .pink, .mint],
                particleCount: 100
            )
        }
    }

    return CustomConfettiPreview()
}
