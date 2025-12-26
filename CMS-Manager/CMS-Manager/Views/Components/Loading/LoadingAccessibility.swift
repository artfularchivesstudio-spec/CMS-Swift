//
//  LoadingAccessibility.swift
//  CMS-Manager
//
//  ♿ The Accessibility Guardian - Inclusive Loading Experiences
//
//  "Every user deserves delightful loading states,
//   whether they prefer reduced motion, need screen readers,
//   or simply want a calmer experience. We serve all!"
//
//  - The Spellbinding Museum Director of Universal Design
//

import SwiftUI

// MARK: - ♿ Accessible Loading View

/// ♿ A loading view that respects accessibility preferences
/// Automatically adapts animations based on reduce motion settings! ✨
struct AccessibleLoadingView: View {

    // MARK: - 🎨 Properties

    /// 💬 Loading message
    let message: String

    /// 🎨 Loading style
    let style: LoadingStyle

    /// ♿ Reduce motion preference
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// 🎨 Loading styles
    enum LoadingStyle {
        case spinner       // Circular spinner
        case dots          // Bouncing dots
        case wave          // Wave animation
        case pulse         // Pulsing circle
    }

    /// ♿ Create an accessible loading view
    /// - Parameters:
    ///   - message: Loading message (default: "Loading...")
    ///   - style: Animation style (default: .spinner)
    init(
        message: String = "Loading...",
        style: LoadingStyle = .spinner
    ) {
        self.message = message
        self.style = style
    }

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 16) {
            // 🎨 Loading indicator (respects reduce motion)
            if reduceMotion {
                // ♿ Static indicator for reduced motion
                staticIndicator
            } else {
                // 🎪 Animated indicator
                animatedIndicator
            }

            // 💬 Loading message
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.updatesFrequently)
    }

    // MARK: - ♿ Static Indicator

    /// ♿ Static loading indicator (for reduced motion)
    private var staticIndicator: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 3)
                .frame(width: 40, height: 40)

            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 3)
                .frame(width: 40, height: 40)
        }
    }

    // MARK: - 🎪 Animated Indicator

    /// 🎪 Animated loading indicator
    @ViewBuilder
    private var animatedIndicator: some View {
        switch style {
        case .spinner:
            CircularGradientProgress(size: 40)
        case .dots:
            DotsLoader(dotSize: 10)
        case .wave:
            WaveLoader(barCount: 5)
        case .pulse:
            PulseLoader(size: 60)
        }
    }
}

// MARK: - ♿ Accessible Skeleton

/// ♿ A skeleton view that respects accessibility preferences
/// Reduces animation intensity for reduce motion users! 🎨
struct AccessibleSkeleton: View {

    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    /// ♿ Create an accessible skeleton
    /// - Parameters:
    ///   - width: Width (nil = flexible)
    ///   - height: Height
    ///   - cornerRadius: Corner radius (default: 8)
    init(
        width: CGFloat? = nil,
        height: CGFloat,
        cornerRadius: CGFloat = 8
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(baseColor)
            .frame(width: width, height: height)
            .overlay {
                if !reduceMotion {
                    // Full shimmer for normal motion
                    shimmerOverlay
                } else {
                    // Subtle static overlay for reduced motion
                    Color.white.opacity(colorScheme == .dark ? 0.05 : 0.1)
                }
            }
            .accessibilityLabel("Loading content")
    }

    private var baseColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.15)
    }

    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    .clear,
                    Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4),
                    .clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .rotationEffect(.degrees(-45))
            .frame(
                width: geometry.size.width * 2,
                height: geometry.size.height * 2
            )
            .shimmer(duration: 1.5)
        }
        .clipped()
    }
}

// MARK: - ♿ Accessibility Announcements

/// ♿ Helper for announcing loading state changes to screen readers
struct LoadingStateAnnouncement {

    /// 📢 Announce loading started
    static func announceLoadingStart(_ message: String = "Loading content") {
        UIAccessibility.post(
            notification: .announcement,
            argument: message
        )
    }

    /// 📢 Announce loading completed
    static func announceLoadingComplete(_ message: String = "Content loaded") {
        UIAccessibility.post(
            notification: .announcement,
            argument: message
        )
    }

    /// 📢 Announce loading failed
    static func announceLoadingFailed(_ message: String = "Failed to load content") {
        UIAccessibility.post(
            notification: .announcement,
            argument: message
        )
    }

    /// 📢 Announce progress update
    static func announceProgress(_ current: Int, total: Int) {
        let message = "Loading \(current) of \(total)"
        UIAccessibility.post(
            notification: .announcement,
            argument: message
        )
    }
}

// MARK: - ♿ View Extensions

extension View {
    /// ♿ Announce when a loading state changes
    /// - Parameters:
    ///   - isLoading: Current loading state
    ///   - startMessage: Message for loading start
    ///   - completeMessage: Message for loading complete
    /// - Returns: View with accessibility announcements
    func announceLoadingState(
        _ isLoading: Bool,
        startMessage: String = "Loading content",
        completeMessage: String = "Content loaded"
    ) -> some View {
        self
            .onChange(of: isLoading) { _, newValue in
                if newValue {
                    LoadingStateAnnouncement.announceLoadingStart(startMessage)
                } else {
                    LoadingStateAnnouncement.announceLoadingComplete(completeMessage)
                }
            }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Accessible Loading View") {
    VStack(spacing: 40) {
        AccessibleLoadingView(message: "Loading stories...", style: .spinner)
        AccessibleLoadingView(message: "Syncing data...", style: .dots)
        AccessibleLoadingView(message: "Processing...", style: .wave)
        AccessibleLoadingView(message: "Uploading...", style: .pulse)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Accessible Skeleton") {
    VStack(spacing: 20) {
        AccessibleSkeleton(width: 200, height: 20)
        AccessibleSkeleton(height: 60)
        AccessibleSkeleton(width: 150, height: 40, cornerRadius: 20)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
