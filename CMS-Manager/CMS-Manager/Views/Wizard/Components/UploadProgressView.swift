//
//  UploadProgressView.swift
//  CMS-Manager
//
//  📊 The Upload Progress View - A Visual Symphony of Upload Status
//
//  "Watch your artwork ascend to the cloud realm! This enchanting progress
//   display transforms the mundane act of uploading into a mesmerizing
//   visual journey, complete with smooth animations and delightful feedback."
//
//  - The Spellbinding Museum Director of Progress Visualization
//

import SwiftUI

/// 📊 Upload Progress View - Beautiful progress visualization for uploads
///
/// Features:
/// - Smooth animated progress bar
/// - Dynamic status messages
/// - Circular progress indicator option
/// - Percentage display
/// - Cancelable uploads
public struct UploadProgressView: View {

    // MARK: - 🎯 Properties

    /// 📊 Current progress (0.0 to 1.0)
    let progress: Double

    /// 📝 Custom status message (optional)
    let statusMessage: String?

    /// 🎨 Progress bar style
    let style: ProgressStyle

    /// ❌ Cancellation callback (optional)
    let onCancel: (() -> Void)?

    // MARK: - 🎨 State

    /// ✨ Animation state for shimmer effect
    @State private var shimmerOffset: CGFloat = -1.0

    /// 🌊 Wave animation phase
    @State private var wavePhase: CGFloat = 0

    // MARK: - 🎭 Style Options

    public enum ProgressStyle {
        case linear
        case circular
        case linearWithCircular
    }

    // MARK: - 🎨 Body

    public var body: some View {
        VStack(spacing: 16) {
            // 📊 Progress Visualization
            switch style {
            case .linear:
                linearProgress
            case .circular:
                circularProgress
            case .linearWithCircular:
                VStack(spacing: 12) {
                    circularProgress
                    linearProgress
                }
            }

            // 📝 Status Message
            if let message = statusMessage ?? Optional(currentStatusMessage) {
                statusText(message)
            }

            // ❌ Cancel Button
            if let onCancel {
                cancelButton(action: onCancel)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - 📊 Linear Progress

    /// 🎯 Linear progress bar with gradient and shimmer
    private var linearProgress: some View {
        VStack(spacing: 8) {
            // 📊 Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 🌑 Background Track
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quaternary)

                    // 🌕 Progress Fill with Gradient
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                        .overlay(
                            // ✨ Shimmer Effect
                            LinearGradient(
                                colors: [
                                    .white.opacity(0),
                                    .white.opacity(0.3),
                                    .white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .offset(x: shimmerOffset * geometry.size.width)
                            .mask(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: geometry.size.width * progress)
                            )
                        )
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 14)

            // 📊 Percentage Display
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())

                Spacer()

                // 🎯 Upload Speed Indicator (simulated based on progress)
                if progress > 0 && progress < 1.0 {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 10))
                        Text(uploadSpeedText)
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.tertiary)
                }
            }
        }
    }

    // MARK: - 🔵 Circular Progress

    /// ⭕ Circular progress indicator
    private var circularProgress: some View {
        ZStack {
            // 🌑 Background Circle
            Circle()
                .stroke(.quaternary, lineWidth: 8)
                .frame(width: 80, height: 80)

            // 🌕 Progress Arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)

            // 📊 Percentage Text
            VStack(spacing: 2) {
                Text("\(Int(progress * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())

                Text("%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - 📝 Status Text

    /// 📜 Dynamic status message with icon
    private func statusText(_ message: String) -> some View {
        HStack(spacing: 8) {
            // ✨ Animated Upload Icon
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(.blue)
                .symbolEffect(.pulse, options: .repeating, value: progress < 1.0)

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)

            Spacer()
        }
    }

    // MARK: - ❌ Cancel Button

    /// 🛑 Cancel upload button
    private func cancelButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 14))

                Text("Cancel Upload")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(.red)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(.red.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Cancel upload")
        .accessibilityHint("Double tap to cancel the current upload")
    }

    // MARK: - 📊 Computed Properties

    /// 📝 Current status message based on progress
    private var currentStatusMessage: String {
        if let statusMessage {
            return statusMessage
        }

        // 🎭 Dynamic messages based on progress stages
        switch progress {
        case 0..<0.1:
            return "Preparing your artwork..."
        case 0.1..<0.3:
            return "Beginning upload to cloud..."
        case 0.3..<0.6:
            return "Uploading to server..."
        case 0.6..<0.8:
            return "Almost there..."
        case 0.8..<0.95:
            return "Finalizing upload..."
        case 0.95..<1.0:
            return "Processing complete..."
        case 1.0:
            return "Upload complete!"
        default:
            return "Uploading..."
        }
    }

    /// 🚀 Simulated upload speed text
    private var uploadSpeedText: String {
        // Simple simulation based on progress rate
        switch progress {
        case 0..<0.3:
            return "Fast"
        case 0.3..<0.7:
            return "Good"
        default:
            return "Excellent"
        }
    }

    // MARK: - ✨ Animations

    /// 🎭 Start continuous animations for shimmer and wave effects
    private func startAnimations() {
        // ✨ Shimmer animation
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            shimmerOffset = 2.0
        }

        // 🌊 Wave animation
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            wavePhase = 2 * .pi
        }
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new upload progress view
    /// - Parameters:
    ///   - progress: Current progress (0.0 to 1.0)
    ///   - statusMessage: Optional custom status message
    ///   - style: Progress bar style (default: linear)
    ///   - onCancel: Optional cancellation callback
    public init(
        progress: Double,
        statusMessage: String? = nil,
        style: ProgressStyle = .linear,
        onCancel: (() -> Void)? = nil
    ) {
        self.progress = min(max(progress, 0), 1)  // Clamp to 0...1
        self.statusMessage = statusMessage
        self.style = style
        self.onCancel = onCancel
    }
}

// MARK: - 🧪 Previews

#Preview("Linear Progress - 45%") {
    UploadProgressView(
        progress: 0.45,
        style: .linear,
        onCancel: {
            print("❌ Upload cancelled")
        }
    )
    .padding()
}

#Preview("Circular Progress - 75%") {
    UploadProgressView(
        progress: 0.75,
        style: .circular
    )
    .padding()
}

#Preview("Combined Progress - 60%") {
    UploadProgressView(
        progress: 0.60,
        statusMessage: "Uploading masterpiece...",
        style: .linearWithCircular,
        onCancel: {
            print("❌ Upload cancelled")
        }
    )
    .padding()
}

#Preview("Complete - 100%") {
    UploadProgressView(
        progress: 1.0,
        style: .linear
    )
    .padding()
}
