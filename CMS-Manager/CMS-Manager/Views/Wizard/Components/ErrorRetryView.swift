//
//  ErrorRetryView.swift
//  CMS-Manager
//
//  🌩️ The Error Retry View - When Digital Spells Require a Second Cast
//
//  "Even the most carefully woven enchantments can encounter turbulence.
//   This mystical view presents errors with grace and offers the gift
//   of redemption through the sacred art of retrying!"
//
//  - The Spellbinding Museum Director of Resilience
//

import SwiftUI

/// 🌩️ Error Retry View - A compassionate error display with retry capabilities
///
/// Features:
/// - Beautiful error presentation with icons
/// - Retry button with loading state
/// - Dismissible error messages
/// - Accessibility support
/// - Animated transitions
public struct ErrorRetryView: View {

    // MARK: - 🎯 Properties

    /// 🌩️ Error to display
    let error: APIError

    /// 🔄 Is retry in progress?
    let isRetrying: Bool

    /// 🎯 Action to perform when retry is tapped
    let onRetry: () async -> Void

    /// ❌ Action to dismiss the error (optional)
    let onDismiss: (() -> Void)?

    // MARK: - 🎨 State

    /// ✨ Animation state for retry button
    @State private var isPressed = false

    // MARK: - 🎨 Body

    public var body: some View {
        VStack(spacing: 20) {
            // 🌩️ Error Icon and Title
            errorHeader

            // 📝 Error Description
            errorDescription

            // 💡 Recovery Suggestion
            if let suggestion = error.recoverySuggestion {
                recoverySuggestion(suggestion)
            }

            // 🔄 Action Buttons
            actionButtons
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(color: .red.opacity(0.15), radius: 20, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [.red.opacity(0.3), .orange.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - 🌩️ Error Header

    /// 🎭 The dramatic error icon and title
    private var errorHeader: some View {
        VStack(spacing: 12) {
            // 🎨 Error Icon with pulsing animation
            Image(systemName: error.icon)
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.pulse, options: .repeating, value: !isRetrying)

            // 📝 Error Title
            Text("Oops! Something Went Wrong")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - 📝 Error Description

    /// 📖 The error's tale of woe
    private var errorDescription: some View {
        Text(error.errorDescription ?? "An unexpected error occurred.")
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - 💡 Recovery Suggestion

    /// 🌟 Helpful guidance for the weary traveler
    private func recoverySuggestion(_ suggestion: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 14))
                .foregroundStyle(.yellow)

            Text(suggestion)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.yellow.opacity(0.1))
        )
    }

    // MARK: - 🔄 Action Buttons

    /// 🎯 Retry and dismiss buttons
    private var actionButtons: some View {
        HStack(spacing: 12) {
            // 🔄 Retry Button
            Button {
                Task {
                    await performRetry()
                }
            } label: {
                HStack(spacing: 8) {
                    if isRetrying {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                    }

                    Text(isRetrying ? "Retrying..." : "Try Again")
                        .font(.system(size: 15, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: isRetrying ? [.gray, .gray] : [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .disabled(isRetrying)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .accessibilityLabel(isRetrying ? "Retrying upload" : "Retry upload")
            .accessibilityHint("Double tap to attempt the upload again")

            // ❌ Dismiss Button (if provided)
            if let onDismiss {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss error")
                .accessibilityHint("Double tap to dismiss this error message")
            }
        }
    }

    // MARK: - 🎯 Actions

    /// 🔄 Perform retry with haptic feedback
    private func performRetry() async {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif

        isPressed = true
        await onRetry()
        isPressed = false
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new error retry view
    /// - Parameters:
    ///   - error: The error to display
    ///   - isRetrying: Whether retry is in progress
    ///   - onRetry: Action to perform when retry is tapped
    ///   - onDismiss: Optional action to dismiss the error
    init(
        error: APIError,
        isRetrying: Bool = false,
        onRetry: @escaping () async -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.error = error
        self.isRetrying = isRetrying
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }
}

// MARK: - 🧪 Previews

#Preview("Network Error") {
    ErrorRetryView(
        error: .validation(.fileTooLarge),
        isRetrying: false,
        onRetry: {
            print("🔄 Retry tapped")
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        },
        onDismiss: {
            print("❌ Dismiss tapped")
        }
    )
    .padding()
}

#Preview("Retrying State") {
    ErrorRetryView(
        error: .uploadFailed("Connection timeout"),
        isRetrying: true,
        onRetry: {
            print("🔄 Retry tapped")
        }
    )
    .padding()
}

#Preview("Server Error") {
    ErrorRetryView(
        error: .serverError(500),
        isRetrying: false,
        onRetry: {
            print("🔄 Retry tapped")
        }
    )
    .padding()
}
