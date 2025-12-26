//
//  PullToRefreshCustom.swift
//  CMS-Manager
//
//  🔄 The Refresh Choreographer - Delightful Pull Interactions
//
//  "Why settle for boring spinners when you can have
//   elastic animations, particle effects, and satisfying haptics?
//   Make every refresh feel like a gift unwrapped!"
//
//  - The Spellbinding Museum Director of Interactive Feedback
//

import SwiftUI

// MARK: - 🔄 Custom Pull to Refresh

/// 🔄 A custom pull-to-refresh indicator with spring physics
/// Replaces the default spinner with something MAGICAL! ✨
struct CustomPullToRefresh: View {

    // MARK: - 🎨 Properties

    /// 📊 Pull progress (0.0 to 1.0)
    let progress: Double

    /// 🎨 Color of the refresh indicator
    let color: Color

    /// 🔄 Is refresh currently active?
    let isRefreshing: Bool

    /// 💫 Rotation angle for the refresh icon
    @State private var rotation: Double = 0

    /// 🔄 Create a custom pull-to-refresh indicator
    /// - Parameters:
    ///   - progress: Pull progress (0.0 = not pulled, 1.0 = fully pulled)
    ///   - color: Color of the indicator (default: blue)
    ///   - isRefreshing: Whether refresh is active
    init(
        progress: Double,
        color: Color = .blue,
        isRefreshing: Bool = false
    ) {
        self.progress = progress
        self.color = color
        self.isRefreshing = isRefreshing
    }

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // 🌀 Background circle that grows with pull
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .scaleEffect(max(0.5, progress))

                // 🎯 Progress ring
                Circle()
                    .trim(from: 0, to: isRefreshing ? 0.7 : progress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(isRefreshing ? rotation : -90))
                    .scaleEffect(max(0.5, progress))

                // 🔄 Refresh icon
                Image(systemName: isRefreshing ? "arrow.clockwise" : "arrow.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
                    .rotationEffect(.degrees(isRefreshing ? rotation : 0))
                    .scaleEffect(max(0.5, progress))
            }
            .animation(.spring(response: 0.3), value: progress)
            .onChange(of: isRefreshing) { _, newValue in
                if newValue {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                } else {
                    rotation = 0
                }
            }

            // 💬 Status text
            if progress > 0.1 {
                Text(statusText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(color)
                    .opacity(min(1.0, progress * 2))
            }
        }
        .frame(height: 60)
        .accessibilityLabel(isRefreshing ? "Refreshing" : "Pull to refresh")
    }

    // MARK: - 💬 Status Text

    /// 💬 Dynamic status message based on state
    private var statusText: String {
        if isRefreshing {
            return "Refreshing..."
        } else if progress >= 1.0 {
            return "Release to refresh"
        } else if progress > 0.5 {
            return "Almost there..."
        } else {
            return "Pull down"
        }
    }
}

// MARK: - 🎊 Success Animation

/// 🎊 Success animation shown after refresh completes
/// A burst of joy to celebrate fresh data! 🎉
struct RefreshSuccessAnimation: View {

    /// 🎨 Color of the success indicator
    let color: Color

    /// ✨ Animation scale
    @State private var scale: CGFloat = 0.5

    /// ✨ Animation opacity
    @State private var opacity: Double = 1

    /// 🎊 Create a success animation
    /// - Parameter color: Color of the checkmark (default: green)
    init(color: Color = .green) {
        self.color = color
    }

    var body: some View {
        ZStack {
            // 🎯 Expanding circle
            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: 50, height: 50)
                .scaleEffect(scale)
                .opacity(opacity)

            // ✅ Checkmark
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(color)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                opacity = 0
            }
        }
        .accessibilityLabel("Refresh complete")
    }
}

// MARK: - 🎪 Loading State Transitions

/// 🎪 Coordinated loading state with smooth transitions
/// Manages the full lifecycle: idle → pulling → refreshing → success! 🎭
struct LoadingStateView: View {

    // MARK: - 🌟 Loading States

    enum State {
        case idle
        case loading
        case success
        case error
    }

    // MARK: - 🎨 Properties

    let state: State
    let message: String?
    let color: Color

    /// 🎪 Create a loading state view
    /// - Parameters:
    ///   - state: Current loading state
    ///   - message: Optional custom message
    ///   - color: Color theme (default: blue)
    init(
        state: State,
        message: String? = nil,
        color: Color = .blue
    ) {
        self.state = state
        self.message = message
        self.color = color
    }

    var body: some View {
        VStack(spacing: 16) {
            // 🎭 State indicator
            Group {
                switch state {
                case .idle:
                    // No visual - placeholder
                    Color.clear.frame(height: 1)

                case .loading:
                    CircularGradientProgress(
                        size: 50,
                        colors: [color, color.opacity(0.5)]
                    )

                case .success:
                    RefreshSuccessAnimation(color: .green)

                case .error:
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 50, height: 50)

                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 24))
                            .foregroundStyle(.red)
                    }
                }
            }
            .transition(.scale.combined(with: .opacity))

            // 💬 Status message
            if let message = message {
                Text(message)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4), value: state)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - ♿ Accessibility

    private var accessibilityLabel: String {
        switch state {
        case .idle:
            return "Ready"
        case .loading:
            return message ?? "Loading"
        case .success:
            return "Success"
        case .error:
            return message ?? "Error occurred"
        }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Custom Pull to Refresh") {
    VStack(spacing: 40) {
        Text("Pull to Refresh States")
            .font(.headline)

        // 🔄 Different pull states
        VStack(spacing: 20) {
            CustomPullToRefresh(progress: 0.3, isRefreshing: false)
            CustomPullToRefresh(progress: 0.7, isRefreshing: false)
            CustomPullToRefresh(progress: 1.0, isRefreshing: false)
            CustomPullToRefresh(progress: 1.0, isRefreshing: true)
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

#Preview("Loading State Transitions") {
    VStack(spacing: 40) {
        LoadingStateView(state: .idle)
        LoadingStateView(state: .loading, message: "Loading stories...")
        LoadingStateView(state: .success, message: "Loaded successfully!")
        LoadingStateView(state: .error, message: "Failed to load")
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Success Animation") {
    RefreshSuccessAnimation()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
}
