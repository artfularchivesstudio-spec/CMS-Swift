//
//  ParticleSystem.swift
//  CMS-Manager
//
//  ✨ The Particle System - Where Sparkles Dance and Confetti Rains
//
//  "Behold! A symphony of tiny luminous orbs floating through digital space,
//   each particle a pixel of pure joy, cascading like stardust upon
//   our wizard's magical moments of triumph and wonder!"
//
//  - The Spellbinding Museum Director of Particle Physics
//

import SwiftUI

// MARK: - ✨ Particle Model

/// 🌟 A single particle in our mystical particle system
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var size: CGFloat
    var color: Color
    var opacity: Double
    var rotation: Double
    var lifespan: Double // in seconds
}

// MARK: - 🎨 Particle Type

/// 🎭 Different particle effects for different occasions
enum ParticleEffect {
    case sparkles      // ✨ Floating sparkles for analysis
    case confetti      // 🎊 Falling confetti for success
    case success       // 🎉 Bursting success particles
    case shimmer       // 💎 Gentle shimmer effect
    case magic         // 🪄 Magical swirls

    /// 🎨 Get the colors for this particle type
    var colors: [Color] {
        switch self {
        case .sparkles:
            return [.yellow, .orange, .white, .pink]
        case .confetti:
            return [.red, .blue, .green, .yellow, .purple, .orange, .pink, .cyan]
        case .success:
            return [.green, .mint, .teal]
        case .shimmer:
            return [.white, .cyan, .blue]
        case .magic:
            return [.purple, .pink, .blue, .indigo]
        }
    }

    /// 📏 Size range for particles
    var sizeRange: ClosedRange<CGFloat> {
        switch self {
        case .sparkles:
            return 3...8
        case .confetti:
            return 6...12
        case .success:
            return 4...10
        case .shimmer:
            return 2...5
        case .magic:
            return 4...9
        }
    }

    /// ⏱️ Lifespan range in seconds
    var lifespanRange: ClosedRange<Double> {
        switch self {
        case .sparkles:
            return 2...4
        case .confetti:
            return 3...5
        case .success:
            return 1.5...3
        case .shimmer:
            return 2...3
        case .magic:
            return 2.5...4
        }
    }
}

// MARK: - 🎪 Particle Emitter View

/// 🌟 The Particle Emitter - Creates and animates a swarm of particles
///
/// Usage:
/// ```swift
/// ParticleEmitterView(
///     effect: .confetti,
///     particleCount: 100,
///     emissionDuration: 2.0
/// )
/// ```
struct ParticleEmitterView: View {
    let effect: ParticleEffect
    let particleCount: Int
    let emissionDuration: Double

    @State private var particles: [Particle] = []
    @State private var isEmitting = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(particle: particle)
                }
            }
            .onAppear {
                startEmission(in: geometry.size)
            }
        }
        .allowsHitTesting(false) // Particles should not intercept touches
    }

    // MARK: - 🎬 Emission Logic

    /// 🚀 Start emitting particles
    private func startEmission(in size: CGSize) {
        isEmitting = true

        // 🎭 Generate initial particles
        for _ in 0..<particleCount {
            let particle = createParticle(in: size)
            particles.append(particle)
        }

        // ⏱️ Stop emission after duration
        Task {
            try? await Task.sleep(nanoseconds: UInt64(emissionDuration * 1_000_000_000))
            await MainActor.run {
                isEmitting = false

                // 🧹 Clean up particles after they fade
                Task {
                    try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
                    await MainActor.run {
                        particles.removeAll()
                    }
                }
            }
        }
    }

    /// 🎨 Create a single particle with randomized properties
    private func createParticle(in size: CGSize) -> Particle {
        // 🎯 Random starting position based on effect type
        let position = effect == .confetti
            ? CGPoint(x: CGFloat.random(in: 0...size.width), y: -20) // Start above screen
            : CGPoint(x: size.width / 2, y: size.height / 2) // Start from center

        // 🌊 Random velocity
        let velocity = effect == .confetti
            ? CGVector(dx: CGFloat.random(in: -50...50), dy: CGFloat.random(in: 100...300))
            : CGVector(dx: CGFloat.random(in: -100...100), dy: CGFloat.random(in: -100...100))

        return Particle(
            position: position,
            velocity: velocity,
            size: CGFloat.random(in: effect.sizeRange),
            color: effect.colors.randomElement() ?? .blue,
            opacity: 1.0,
            rotation: Double.random(in: 0...360),
            lifespan: Double.random(in: effect.lifespanRange)
        )
    }
}

// MARK: - 🎭 Individual Particle View

/// ✨ A single animated particle
private struct ParticleView: View {
    let particle: Particle

    @State private var position: CGPoint
    @State private var opacity: Double
    @State private var rotation: Double

    init(particle: Particle) {
        self.particle = particle
        self._position = State(initialValue: particle.position)
        self._opacity = State(initialValue: particle.opacity)
        self._rotation = State(initialValue: particle.rotation)
    }

    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .position(position)
            .onAppear {
                animateParticle()
            }
    }

    /// 🎬 Animate the particle through its lifecycle
    private func animateParticle() {
        // 🌊 Movement animation
        withAnimation(
            .linear(duration: particle.lifespan)
        ) {
            position.x += particle.velocity.dx * CGFloat(particle.lifespan) / 100
            position.y += particle.velocity.dy * CGFloat(particle.lifespan) / 100
        }

        // 🌀 Rotation animation
        withAnimation(
            .linear(duration: particle.lifespan)
            .repeatCount(1, autoreverses: false)
        ) {
            rotation += 360 * particle.lifespan
        }

        // 👻 Fade out near end of lifespan
        Task {
            try? await Task.sleep(nanoseconds: UInt64(particle.lifespan * 0.7 * 1_000_000_000))
            await MainActor.run {
                withAnimation(.easeOut(duration: particle.lifespan * 0.3)) {
                    opacity = 0
                }
            }
        }
    }
}

// MARK: - 🎪 Convenience Modifiers

extension View {
    /// 🎊 Add confetti celebration to this view
    /// - Parameter isActive: Whether to show confetti
    /// - Returns: View with confetti overlay
    func confettiCelebration(isActive: Bool) -> some View {
        self.overlay {
            if isActive {
                ParticleEmitterView(
                    effect: .confetti,
                    particleCount: 100,
                    emissionDuration: 2.0
                )
            }
        }
    }

    /// ✨ Add sparkle particles around this view
    /// - Parameter isActive: Whether to show sparkles
    /// - Returns: View with sparkle overlay
    func sparkleEffect(isActive: Bool) -> some View {
        self.overlay {
            if isActive {
                ParticleEmitterView(
                    effect: .sparkles,
                    particleCount: 30,
                    emissionDuration: 3.0
                )
            }
        }
    }

    /// 🎉 Add success burst animation
    /// - Parameter trigger: Value to trigger the burst
    /// - Returns: View with success burst overlay
    func successBurst<T: Hashable>(trigger: T) -> some View {
        self.overlay {
            ParticleEmitterView(
                effect: .success,
                particleCount: 50,
                emissionDuration: 1.0
            )
            .id(trigger) // Recreate when trigger changes
        }
    }
}
