//
//  AnalyzingStepView.swift
//  CMS-Manager
//
//  🔍 The Analyzing Step - Where AI Gazes Upon Your Art
//
//  "Behold, as the great artificial intelligence contemplates your masterpiece!
//   It sees patterns, colors, emotions... and conjures tales from the ether."
//
//  - The Spellbinding Museum Director of AI Visions
//

import SwiftUI

/// 🔍 Analyzing Step View - Step 2 of the Story Wizard
///
/// Features:
/// - Lottie animation for processing state
/// - Progress percentage display with animated counter
/// - Shimmer loading effect for text
/// - Animated sparkle particles
/// - Cancel capability
/// - Accessibility support
public struct AnalyzingStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The view model orchestrating this magic
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 State

    /// ✨ Animation state for sparkles
    @State private var sparkleOffsets: [CGSize] = Array(repeating: .zero, count: 12)

    /// 🌊 Shimmer animation phase
    @State private var shimmerPhase: CGFloat = 0

    /// 🎯 Pulse animation scale
    @State private var pulseScale: CGFloat = 1.0

    /// 🔄 Rotation angle for the analysis ring
    @State private var rotationAngle: Double = 0

    /// 🎊 Show celebration when complete
    @State private var showCelebration = false

    /// 🎉 Trigger for success burst
    @State private var successTrigger = false

    // MARK: - 🎨 Body

    public var body: some View {
        ZStack {
            VStack(spacing: 32) {
                // 📜 Header Section
                headerSection

                Spacer()

                // 🎭 Main Animation Area
                mainAnimationArea

                Spacer()

                // 📊 Progress Details
                progressDetailsSection

                // 🚫 Cancel Button
                cancelButton
            }
            .padding(.horizontal, 24)
        }
        .overlay {
            // ✨ Sparkle effect when analyzing
            if viewModel.analysisProgress > 0 && viewModel.analysisProgress < 1.0 {
                SparkleEffect(
                    isActive: .constant(true),
                    colors: [.purple, .pink, .cyan],
                    particleCount: 8,
                    maxDistance: 60
                )
            }
        }
        .confetti(isActive: $showCelebration)
        .onAppear {
            // 🎬 Start the animations!
            withAnimation(
                .linear(duration: 2.0)
                .repeatForever(autoreverses: false)
            ) {
                rotationAngle = 360
            }

            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.1
            }

            withAnimation(
                .linear(duration: 3)
                .repeatForever(autoreverses: false)
            ) {
                shimmerPhase = 1
            }

            // ✨ Animate sparkles
            for i in sparkleOffsets.indices {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 1.5...2.5))
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.1)
                ) {
                    sparkleOffsets[i] = CGSize(
                        width: CGFloat.random(in: -30...30),
                        height: CGFloat.random(in: -30...30)
                    )
                }
            }
        }
        .onChange(of: viewModel.analysisProgress) { oldValue, newValue in
            // 🎉 Trigger celebration when reaching 100%
            if oldValue < 1.0 && newValue >= 1.0 {
                triggerCelebration()
            }
        }
    }

    // MARK: - 📜 Header Section

    /// 🎭 The title and description
    private var headerSection: some View {
        VStack(spacing: 12) {
            // 🎨 Icon
            ZStack {
                // 🌟 Background Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.purple.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 100, height: 100)

                // 🧠 Brain Icon
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            // 📝 Title
            Text("Analyzing Your Artwork")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            // 📖 Description
            Text("Our AI is examining your image to generate a captivating story")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    // MARK: - 🎭 Main Animation Area

    /// ✨ The central visual experience
    private var mainAnimationArea: some View {
        ZStack {
            // 🌌 Background gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .purple.opacity(0.1),
                            .blue.opacity(0.05),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 320, height: 320)

            // 🔄 Rotating Analysis Ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .purple.opacity(0.8),
                            .pink.opacity(0.6),
                            .blue.opacity(0.4),
                            .purple.opacity(0.1)
                        ],
                        center: .center
                    ),
                    lineWidth: 6
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(rotationAngle))
                .blur(radius: 2)

            // 📊 Inner Progress Ring
            Circle()
                .trim(from: 0, to: viewModel.analysisProgress)
                .stroke(
                    LinearGradient(
                        colors: [.purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 160, height: 160)
                .rotationEffect(.degrees(-90))
                .shadow(color: .purple.opacity(0.3), radius: 8)

            // 📝 Percentage Display with magic effects! ✨
            VStack(spacing: 4) {
                Text("\(Int(viewModel.analysisProgress * 100))%")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .contentTransition(.numericText(value: Double(Int(viewModel.analysisProgress * 100))))
                    .modifier(ShimmerModifier(duration: 1.0))
                    .opacity(viewModel.analysisProgress >= 1.0 ? 1.0 : 0.0)

                Text("Complete")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .overlay {
                // 🎉 Success sparkle burst when complete
                if viewModel.analysisProgress >= 1.0 {
                    SparkleEffect(
                        isActive: $successTrigger,
                        colors: [.purple, .pink, .yellow, .cyan],
                        particleCount: 15,
                        maxDistance: 50
                    )
                }
            }

            // ✨ Sparkle Particles
            sparkleOverlay
        }
        .frame(height: 320)
        // .pulseGlow(
        //     isActive: viewModel.analysisProgress > 0 && viewModel.analysisProgress < 1.0,
        //     color: .purple,
        //     radius: 12
        // )
    }

    /// ✨ Animated sparkle particles around the analysis
    private var sparkleOverlay: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                let angle = Double(index) * 30
                let radius: CGFloat = 110

                Image(systemName: "sparkle")
                    .font(.system(size: 16))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(sparkleOffsets[index])
                    .opacity(0.8)
                    .rotationEffect(.degrees(angle))
                    .offset(x: cos(angle * .pi / 180) * radius, y: sin(angle * .pi / 180) * radius)
                    .blur(radius: 1)
            }
        }
    }

    // MARK: - 📊 Progress Details Section

    /// 📜 The animated text showing current analysis phase
    private var progressDetailsSection: some View {
        VStack(spacing: 16) {
            // 🌊 Shimmering Status Text
            Text(analysisPhaseText)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .shimmer(duration: 2.0)

            // 📝 Subtext
            Text(analysisSubtext)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 20)
    }

    /// 📜 Dynamic phase text based on progress
    private var analysisPhaseText: String {
        let progress = viewModel.analysisProgress

        switch progress {
        case 0..<0.2:
            return "🔍 Examining your artwork..."
        case 0.2..<0.4:
            return "🎨 Identifying colors and composition..."
        case 0.4..<0.6:
            return "🧠 Interpreting the visual narrative..."
        case 0.6..<0.8:
            return "✨ Generating story elements..."
        case 0.8..<1.0:
            return "📝 Crafting the perfect title and tags..."
        case 1.0:
            return "✨ Analysis complete!"
        default:
            return "Initializing..."
        }
    }

    /// 📜 Supporting subtext
    private var analysisSubtext: String {
        let progress = viewModel.analysisProgress

        if progress >= 1.0 {
            return "Your story is ready for review"
        } else {
            return "This usually takes a few seconds"
        }
    }

    // MARK: - 🚫 Cancel Button

    /// ⚠️ Allow user to cancel the analysis
    private var cancelButton: some View {
        Button {
            // 🚫 Cancel the analysis and return to upload - because everyone deserves a second chance!
            viewModel.cancelAnalysis()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 16))
                Text("Cancel")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.quaternary.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Cancel analysis")
        .accessibilityHint("Return to upload step")
    }

    // MARK: - 🎉 Celebration Logic

    /// 🎊 Trigger the celebration animation when analysis completes
    private func triggerCelebration() {
        // 🎉 Show confetti celebration
        showCelebration = true

        // 💥 Trigger success burst particle effect
        successTrigger.toggle()

        // 🎭 Hide celebration after a few seconds
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            await MainActor.run {
                showCelebration = false
            }
        }
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Initialize with a view model
    init(viewModel: StoryWizardViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - 🧪 Preview

#Preview("Analyzing - 0%") {
    AnalyzingStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.analysisProgress = 0.0
        return vm
    }())
}

#Preview("Analyzing - 50%") {
    AnalyzingStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.analysisProgress = 0.5
        return vm
    }())
}

#Preview("Analyzing - 100%") {
    AnalyzingStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.analysisProgress = 1.0
        return vm
    }())
}
