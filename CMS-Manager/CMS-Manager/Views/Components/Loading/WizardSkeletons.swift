//
//  WizardSkeletons.swift
//  CMS-Manager
//
//  🧙‍♂️ The Wizard Step Phantoms - Multi-Step Loading Magic
//
//  "Each wizard step deserves its own loading choreography,
//   from upload areas pulsing with anticipation,
//   to analysis spinners weaving their magic,
//   to translation cards shimmering into existence."
//
//  - The Spellbinding Museum Director of Wizard UX
//

import SwiftUI

// MARK: - 📤 Upload Step Skeleton

/// 📤 Skeleton for the upload step
/// A pulsing upload area waiting for content to arrive! 📦
struct UploadStepSkeleton: View {

    /// 💫 Pulse animation state
    @State private var pulse: CGFloat = 0.8

    var body: some View {
        VStack(spacing: 24) {
            // 📤 Upload area placeholder
            VStack(spacing: 16) {
                // 📦 Upload icon with pulse
                Image(systemName: "arrow.up.doc")
                    .font(.system(size: 60))
                    .foregroundStyle(.tertiary)
                    .scaleEffect(pulse)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                        ) {
                            pulse = 1.1
                        }
                    }

                // Text placeholders
                SkeletonLine(width: 200, height: 18)
                SkeletonLine(width: 160, height: 14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                    )
                    .foregroundStyle(.quaternary)
            }

            // 🏷️ Instructions skeleton
            VStack(alignment: .leading, spacing: 12) {
                SkeletonLine(width: 180, height: 16)
                SkeletonLine(height: 14)
                SkeletonLine(width: 240, height: 14)
            }
        }
        .padding()
        .accessibilityLabel("Loading upload interface")
    }
}

// MARK: - 🔍 Analyzing Step Skeleton

/// 🔍 Skeleton for the analyzing step
/// Shows image with shimmer overlay and progress indicator! 🎨
struct AnalyzingStepSkeleton: View {

    var body: some View {
        VStack(spacing: 24) {
            // 🖼️ Image being analyzed
            ZStack {
                SkeletonImage(height: 250, cornerRadius: 16)

                // 🌊 Analysis in progress overlay
                VStack(spacing: 12) {
                    CircularGradientProgress(size: 50)

                    Text("Analyzing...")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                }
            }

            // 📊 Progress information
            VStack(spacing: 16) {
                HStack {
                    SkeletonLine(width: 120, height: 14)
                    Spacer()
                    SkeletonLine(width: 40, height: 14)
                }

                GradientLinearProgress(progress: 0.6, height: 8)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
            )
        }
        .padding()
        .accessibilityLabel("Analyzing image")
    }
}

// MARK: - 📝 Review Step Skeleton

/// 📝 Skeleton for the review step
/// Form fields waiting to be filled with AI magic! ✨
struct ReviewStepSkeleton: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🖼️ Preview image
                SkeletonImage(height: 200, cornerRadius: 12)

                // 📝 Form fields
                VStack(spacing: 16) {
                    formFieldSkeleton(label: "Title", lines: 2)
                    formFieldSkeleton(label: "Excerpt", lines: 3)
                    formFieldSkeleton(label: "Content", lines: 8)
                }

                // 🏷️ Tags section
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLine(width: 60, height: 14)

                    HStack(spacing: 8) {
                        SkeletonBadge(width: 70)
                        SkeletonBadge(width: 90)
                        SkeletonBadge(width: 60)
                    }
                }
            }
            .padding()
        }
        .accessibilityLabel("Loading review form")
    }

    /// 📝 A form field skeleton
    private func formFieldSkeleton(label: String, lines: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonLine(width: 80, height: 12)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(0..<lines, id: \.self) { index in
                    if index == lines - 1 {
                        SkeletonLine(width: 180, height: 14)
                    } else {
                        SkeletonLine(height: 14)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .systemGray6))
            )
        }
    }
}

// MARK: - 🌐 Translation Step Skeleton

/// 🌐 Skeleton for the translation step
/// Language cards shimmering into existence! 🌍
struct TranslationStepSkeleton: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🌐 Language cards
                ForEach(["Spanish", "Hindi"], id: \.self) { _ in
                    languageCardSkeleton
                }

                // 🔘 Action buttons skeleton
                HStack(spacing: 12) {
                    SkeletonView(
                        shape: .capsule,
                        height: 44
                    )

                    SkeletonView(
                        shape: .capsule,
                        height: 44
                    )
                }
            }
            .padding()
        }
        .accessibilityLabel("Loading translations")
    }

    /// 🌐 A single language card skeleton
    private var languageCardSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🏷️ Language header
            HStack {
                SkeletonView(shape: .circle, height: 24, width: 24)
                SkeletonLine(width: 100, height: 16)
                Spacer()
                SkeletonBadge(width: 80)
            }

            Divider()

            // 📝 Content preview
            VStack(alignment: .leading, spacing: 8) {
                SkeletonLine(width: 120, height: 14)
                SkeletonLine(height: 14)
                SkeletonLine(width: 200, height: 14)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
    }
}

// MARK: - 🎵 Audio Step Skeleton

/// 🎵 Skeleton for the audio generation step
/// Voice cards with waveform previews! 🎙️
struct AudioStepSkeleton: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🗣️ Language selection skeleton
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBadge(width: 80)
                    }
                }

                // 🎙️ Voice cards
                ForEach(0..<3, id: \.self) { _ in
                    voiceCardSkeleton
                }
            }
            .padding()
        }
        .accessibilityLabel("Loading audio options")
    }

    /// 🎙️ A single voice card skeleton
    private var voiceCardSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🏷️ Voice info
            HStack {
                SkeletonView(shape: .circle, height: 40, width: 40)

                VStack(alignment: .leading, spacing: 6) {
                    SkeletonLine(width: 120, height: 16)
                    SkeletonLine(width: 80, height: 12)
                }

                Spacer()

                SkeletonView(shape: .circle, height: 32, width: 32)
            }

            // 🌊 Waveform visualization skeleton
            HStack(spacing: 2) {
                ForEach(0..<40, id: \.self) { _ in
                    SkeletonView(
                        shape: .capsule,
                        height: CGFloat.random(in: 10...40),
                        width: 2
                    )
                }
            }
            .frame(height: 40)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Upload Step Skeleton") {
    UploadStepSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Analyzing Step Skeleton") {
    AnalyzingStepSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Review Step Skeleton") {
    ReviewStepSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Translation Step Skeleton") {
    TranslationStepSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Audio Step Skeleton") {
    AudioStepSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}
