//
//  CustomProgressViews.swift
//  CMS-Manager
//
//  🎡 The Progress Choreographers - Beautiful Loading Animations
//
//  "No more boring spinners! Watch as dots bounce,
//   circles pulse with life, waves undulate gracefully,
//   and gradients sweep across the screen like digital auroras."
//
//  - The Spellbinding Museum Director of Motion Design
//

import SwiftUI

// MARK: - 🎡 Circular Gradient Progress

/// 🎡 A circular spinner with gradient colors
/// Like a mystical portal opening to reveal your content! ✨
struct CircularGradientProgress: View {

    /// 🎨 Size of the spinner
    let size: CGFloat

    /// 🎨 Gradient colors
    let colors: [Color]

    /// 🌀 Rotation angle
    @State private var rotation: Double = 0

    /// 🎡 Create a circular gradient spinner
    /// - Parameters:
    ///   - size: Diameter of the spinner (default: 40)
    ///   - colors: Gradient colors (default: blue to purple)
    init(size: CGFloat = 40, colors: [Color] = [.blue, .purple]) {
        self.size = size
        self.colors = colors
    }

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: colors),
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360)
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            .accessibilityLabel("Loading")
    }
}

// MARK: - 🎪 Dots Loader

/// 🎪 Three bouncing dots animation
/// The classic "typing indicator" - but make it fashion! 💅
struct DotsLoader: View {

    /// 🎨 Size of each dot
    let dotSize: CGFloat

    /// 🎨 Dot color
    let color: Color

    /// 🎪 Animation phase for each dot
    @State private var phase: CGFloat = 0

    /// 🎪 Create a dots loader
    /// - Parameters:
    ///   - dotSize: Size of each dot (default: 8)
    ///   - color: Color of the dots (default: blue)
    init(dotSize: CGFloat = 8, color: Color = .blue) {
        self.dotSize = dotSize
        self.color = color
    }

    var body: some View {
        HStack(spacing: dotSize * 0.75) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(scale(for: index))
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: phase
                    )
            }
        }
        .onAppear {
            phase = 1
        }
        .accessibilityLabel("Loading")
    }

    /// 🎨 Calculate scale for each dot based on phase
    private func scale(for index: Int) -> CGFloat {
        let delay = Double(index) * 0.2
        let adjustedPhase = (phase - delay).truncatingRemainder(dividingBy: 1)
        return 0.5 + (abs(sin(adjustedPhase * .pi)) * 0.5)
    }
}

// MARK: - 🌊 Wave Loader

/// 🌊 Undulating wave animation
/// Like ocean waves washing over the shore of patience! 🏖️
struct WaveLoader: View {

    /// 🎨 Number of bars in the wave
    let barCount: Int

    /// 🎨 Height of each bar
    let barHeight: CGFloat

    /// 🎨 Wave color
    let color: Color

    /// 🌊 Animation phase
    @State private var phase: CGFloat = 0

    /// 🌊 Create a wave loader
    /// - Parameters:
    ///   - barCount: Number of bars (default: 5)
    ///   - barHeight: Maximum height of bars (default: 30)
    ///   - color: Color of the wave (default: blue)
    init(barCount: Int = 5, barHeight: CGFloat = 30, color: Color = .blue) {
        self.barCount = barCount
        self.barHeight = barHeight
        self.color = color
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { index in
                Capsule()
                    .fill(color)
                    .frame(width: 4, height: waveHeight(for: index))
                    .animation(
                        .easeInOut(duration: 0.8)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: phase
                    )
            }
        }
        .frame(height: barHeight)
        .onAppear {
            phase = 1
        }
        .accessibilityLabel("Loading")
    }

    /// 🌊 Calculate wave height for each bar
    private func waveHeight(for index: Int) -> CGFloat {
        let delay = Double(index) * 0.1
        let adjustedPhase = (phase - delay).truncatingRemainder(dividingBy: 1)
        return barHeight * 0.3 + (barHeight * 0.7 * abs(sin(adjustedPhase * .pi)))
    }
}

// MARK: - 💫 Pulse Loader

/// 💫 Pulsing circle animation
/// Breathes in and out like a living thing - or a meditative heartbeat! 🧘
struct PulseLoader: View {

    /// 🎨 Size of the circle
    let size: CGFloat

    /// 🎨 Pulse color
    let color: Color

    /// 💫 Animation scale
    @State private var scale: CGFloat = 0.5

    /// 💫 Animation opacity
    @State private var opacity: Double = 1

    /// 💫 Create a pulse loader
    /// - Parameters:
    ///   - size: Diameter of the circle (default: 60)
    ///   - color: Color of the pulse (default: blue)
    init(size: CGFloat = 60, color: Color = .blue) {
        self.size = size
        self.color = color
    }

    var body: some View {
        ZStack {
            // 🌟 Inner solid circle
            Circle()
                .fill(color)
                .frame(width: size * 0.4, height: size * 0.4)

            // 💫 Outer pulsing ring
            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: size * scale, height: size * scale)
                .opacity(opacity)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(
                .easeOut(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                scale = 1.0
                opacity = 0
            }
        }
        .accessibilityLabel("Loading")
    }
}

// MARK: - 📊 Linear Progress with Gradient

/// 📊 A linear progress bar with gradient sweep
/// Perfect for showing actual progress percentages! 📈
struct GradientLinearProgress: View {

    /// 📊 Current progress (0.0 to 1.0)
    let progress: Double

    /// 🎨 Gradient colors
    let colors: [Color]

    /// 🎨 Height of the progress bar
    let height: CGFloat

    /// 📊 Create a gradient linear progress bar
    /// - Parameters:
    ///   - progress: Progress value (0.0 to 1.0)
    ///   - colors: Gradient colors (default: blue to purple)
    ///   - height: Height of the bar (default: 6)
    init(
        progress: Double,
        colors: [Color] = [.blue, .purple],
        height: CGFloat = 6
    ) {
        self.progress = progress
        self.colors = colors
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Color.gray.opacity(0.2))

                // Progress fill with gradient
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)

                // ✨ Shimmer overlay on the progress
                if progress > 0 && progress < 1 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                        .shimmer(duration: 2.0)
                }
            }
        }
        .frame(height: height)
        .accessibilityValue("\(Int(progress * 100)) percent complete")
    }
}

// MARK: - 🎯 Circular Progress with Percentage

/// 🎯 Circular progress indicator with percentage text
/// Shows both visual and numeric progress - double the satisfaction! 📊
struct CircularPercentageProgress: View {

    /// 📊 Current progress (0.0 to 1.0)
    let progress: Double

    /// 🎨 Size of the circle
    let size: CGFloat

    /// 🎨 Progress color
    let color: Color

    /// 🎯 Create a circular percentage progress
    /// - Parameters:
    ///   - progress: Progress value (0.0 to 1.0)
    ///   - size: Diameter of the circle (default: 60)
    ///   - color: Color of the progress (default: blue)
    init(progress: Double, size: CGFloat = 60, color: Color = .blue) {
        self.progress = progress
        self.size = size
        self.color = color
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)

            // Percentage text
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.25, weight: .semibold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: progress)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Progress: \(Int(progress * 100)) percent")
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Custom Progress Views") {
    ScrollView {
        VStack(spacing: 40) {
            VStack(spacing: 12) {
                Text("Circular Gradient Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                CircularGradientProgress()
            }

            VStack(spacing: 12) {
                Text("Dots Loader")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                DotsLoader()
            }

            VStack(spacing: 12) {
                Text("Wave Loader")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                WaveLoader()
            }

            VStack(spacing: 12) {
                Text("Pulse Loader")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                PulseLoader()
            }

            VStack(spacing: 12) {
                Text("Gradient Linear Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                VStack(spacing: 16) {
                    GradientLinearProgress(progress: 0.3)
                    GradientLinearProgress(progress: 0.65)
                    GradientLinearProgress(progress: 0.9)
                }
                .frame(maxWidth: 300)
            }

            VStack(spacing: 12) {
                Text("Circular Percentage Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 24) {
                    CircularPercentageProgress(progress: 0.25)
                    CircularPercentageProgress(progress: 0.5)
                    CircularPercentageProgress(progress: 0.75)
                }
            }
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}
