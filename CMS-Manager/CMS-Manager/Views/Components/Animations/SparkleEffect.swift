//
//  SparkleEffect.swift
//  CMS-Manager
//
//  ✨ The Sparkle Effect - Where Magic Particles Dance
//
//  "Like tiny stars bursting from the cosmic fountain,
//   these sparkles bring enchantment to every moment of success.
//   They shimmer, they shine, they celebrate life's digital victories
//   with the grace of fireflies on a summer night! 🌟"
//
//  - The Spellbinding Museum Director of Luminous Delights
//

import SwiftUI

// MARK: - ✨ Sparkle Effect

/// 🌟 An animated sparkle burst effect for micro-celebrations
///
/// Features:
/// - Customizable particle count and colors
/// - Radial burst pattern
/// - Smooth fade-out animation
/// - Performance-optimized
/// - Accessibility-friendly
///
/// Usage:
/// ```swift
/// ZStack {
///     YourContent()
///     SparkleEffect(isActive: $showSparkles)
/// }
/// ```
public struct SparkleEffect: View {

    // MARK: - 🎯 Configuration

    /// ✨ Whether sparkles are active
    @Binding var isActive: Bool

    /// 🎨 Sparkle colors
    var colors: [Color] = [.yellow, .orange, .white, .pink, .cyan]

    /// 📊 Number of sparkle particles
    var particleCount: Int = 20

    /// 📏 Maximum sparkle distance from center
    var maxDistance: CGFloat = 80

    /// ⏱️ Animation duration
    var duration: TimeInterval = 0.8

    /// 🎨 Sparkle size range
    var sizeRange: ClosedRange<CGFloat> = 4...10

    // MARK: - 📊 State

    /// 🎊 The sparkle particles
    @State private var particles: [SparkleParticle] = []

    /// 🎬 Animation trigger
    @State private var animationStarted = false

    /// ♿️ Accessibility
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - 🎨 Body

    public var body: some View {
        ZStack {
            if isActive && !reduceMotion {
                ForEach(particles) { particle in
                    SparkleParticleView(
                        particle: particle,
                        isAnimating: animationStarted,
                        duration: duration
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { _, newValue in
            if newValue {
                startSparkles()
            } else {
                stopSparkles()
            }
        }
        .onAppear {
            if isActive {
                startSparkles()
            }
        }
    }

    // MARK: - ✨ Sparkle Control

    /// 🌟 Start the sparkle burst!
    /// Like a firework of joy exploding in slow motion! 🎆
    private func startSparkles() {
        particles.removeAll()
        animationStarted = false

        // 🎭 Generate particles in a radial pattern
        for i in 0..<particleCount {
            // 📐 Calculate angle for even distribution
            let angle = (2 * .pi / Double(particleCount)) * Double(i)

            // 📊 Random distance (closer particles for depth)
            let distance = CGFloat.random(in: maxDistance * 0.3...maxDistance)

            let particle = SparkleParticle(
                angle: angle,
                distance: distance,
                color: colors.randomElement() ?? .yellow,
                size: CGFloat.random(in: sizeRange),
                delay: Double.random(in: 0...0.2)
            )
            particles.append(particle)
        }

        // 🎬 Start animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation {
                animationStarted = true
            }
        }

        // ⏰ Auto-stop after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.3) {
            stopSparkles()
        }
    }

    /// 🛑 Stop sparkles and reset
    private func stopSparkles() {
        animationStarted = false
        particles.removeAll()
        isActive = false
    }
}

// MARK: - ✨ Sparkle Particle Model

/// 🎭 Individual sparkle particle
struct SparkleParticle: Identifiable {
    let id = UUID()
    let angle: Double // Radians
    let distance: CGFloat
    let color: Color
    let size: CGFloat
    let delay: TimeInterval
}

// MARK: - 🎨 Sparkle Particle View

/// 🌟 Renders a single sparkle particle
/// Each sparkle is a tiny performer in our radial ballet! 💫
struct SparkleParticleView: View {
    let particle: SparkleParticle
    let isAnimating: Bool
    let duration: TimeInterval

    /// 📊 Animation state
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var offsetDistance: CGFloat = 0

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        particle.color,
                        particle.color.opacity(0.5)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: particle.size / 2
                )
            )
            .frame(width: particle.size, height: particle.size)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: cos(particle.angle) * offsetDistance,
                y: sin(particle.angle) * offsetDistance
            )
            .blur(radius: isAnimating ? 0.5 : 0)
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    startAnimation()
                } else {
                    resetAnimation()
                }
            }
    }

    /// 🎬 Animate the sparkle burst
    /// A three-phase performance: appear, travel, fade! 🎭
    private func startAnimation() {
        // 🎪 Phase 1: Pop in
        withAnimation(
            .spring(response: 0.3, dampingFraction: 0.6)
            .delay(particle.delay)
        ) {
            scale = 1.0
            opacity = 1.0
        }

        // 🌊 Phase 2: Travel outward
        withAnimation(
            .easeOut(duration: duration)
            .delay(particle.delay)
        ) {
            offsetDistance = particle.distance
        }

        // ✨ Phase 3: Fade out
        withAnimation(
            .easeOut(duration: duration * 0.5)
            .delay(particle.delay + duration * 0.5)
        ) {
            opacity = 0
            scale = 0.5
        }
    }

    /// 🔄 Reset to initial state
    private func resetAnimation() {
        scale = 0
        opacity = 0
        offsetDistance = 0
    }
}

// MARK: - 🎭 Convenience Modifier

extension View {
    /// ✨ Add sparkle effect overlay
    /// - Parameters:
    ///   - isActive: Binding to control sparkle visibility
    ///   - colors: Array of sparkle colors
    ///   - particleCount: Number of sparkle particles
    ///   - maxDistance: Maximum distance from center
    /// - Returns: View with sparkle overlay
    ///
    /// Example:
    /// ```swift
    /// Button("Success!") { }
    ///     .sparkle(isActive: $showSparkles)
    /// ```
    public func sparkle(
        isActive: Binding<Bool>,
        colors: [Color] = [.yellow, .orange, .white, .pink, .cyan],
        particleCount: Int = 20,
        maxDistance: CGFloat = 80
    ) -> some View {
        self.overlay {
            SparkleEffect(
                isActive: isActive,
                colors: colors,
                particleCount: particleCount,
                maxDistance: maxDistance
            )
        }
    }
}

// MARK: - 🧪 Preview

#Preview("Sparkle Burst") {
    struct SparklePreview: View {
        @State private var showSparkles = false

        var body: some View {
            VStack(spacing: 40) {
                Text("✨ Sparkle Effect")
                    .font(.title)
                    .fontWeight(.bold)

                ZStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)

                    Text("🎉")
                        .font(.system(size: 50))

                    SparkleEffect(isActive: $showSparkles)
                }

                Button(showSparkles ? "Stop" : "Sparkle!") {
                    showSparkles.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    return SparklePreview()
}

#Preview("Custom Colors") {
    struct CustomSparklePreview: View {
        @State private var showSparkles = true

        var body: some View {
            ZStack {
                Circle()
                    .fill(.purple.gradient)
                    .frame(width: 120, height: 120)

                Text("⭐️")
                    .font(.system(size: 60))

                SparkleEffect(
                    isActive: $showSparkles,
                    colors: [.purple, .pink, .mint, .cyan],
                    particleCount: 30,
                    maxDistance: 100
                )
            }
        }
    }

    return CustomSparklePreview()
}

#Preview("Button Sparkle") {
    struct ButtonSparklePreview: View {
        @State private var showSparkles = false

        var body: some View {
            VStack(spacing: 30) {
                Button {
                    showSparkles = true
                } label: {
                    Text("Click for Sparkles! ✨")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .sparkle(isActive: $showSparkles)
            }
        }
    }

    return ButtonSparklePreview()
}
