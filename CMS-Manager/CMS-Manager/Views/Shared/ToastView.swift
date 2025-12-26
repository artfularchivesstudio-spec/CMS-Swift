//
//  ToastView.swift
//  CMS-Manager
//
//  🎨 The Toast View - Stage for Fleeting Announcements
//
//  "Like actors stepping briefly into the spotlight,
//   these messages dance upon the stage, deliver
//   their lines with grace, then vanish into the wings."
//
//  - The Spellbinding Museum Director of Theater UI
//

import SwiftUI

// MARK: - 🎭 Toast View

/// 🎨 The standalone toast view - displays a single toast notification
struct ToastView: View {

    // MARK: - 🏺 Properties

    /// 🍞 The toast notification to display
    let toast: Toast

    /// 🎯 Whether to show the dismiss button
    var showDismissButton: Bool = true

    // MARK: - 🎭 Body

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            // 🎨 Icon - the herald's standard
            Image(systemName: toast.type.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(toast.type.color)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(toast.type.lightColor)
                )

            // 📜 Message content - the spoken lines
            VStack(alignment: .leading, spacing: 4) {
                // 📝 Title - the headline
                Text(toast.title)
                    .font(.labelLarge)
                    .foregroundStyle(Color.textPrimary)

                // 📜 Message - the supporting details
                if !toast.message.isEmpty {
                    Text(toast.message)
                        .font(.captionLarge)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: AppSpacing.xs)

            // 🚪 Dismiss button - the exit cue
            if showDismissButton {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.textSecondary.opacity(0.6))
                    .accessibilityLabel("Dismiss")
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            // 🎭 The stage - frosted glass effect with new design system
            RoundedRectangle(cornerRadius: AppSpacing.radiusLG, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.radiusLG, style: .continuous)
                        .stroke(toast.type.color.opacity(0.2), lineWidth: 1.5)
                )
        )
        .shadowLevel3()
        .padding(.horizontal, AppSpacing.md)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(toast.type.localizedDescription): \(toast.title)\(toast.message.isEmpty ? "" : ", \(toast.message)")")
        .accessibilityHint("Double tap to dismiss")
    }
}

// MARK: - 🎨 Toast Container View

/// 🎨 A container that manages toast display with animations
struct ToastContainerView: View {

    // MARK: - 🏺 Properties

    /// 🍞 The toast manager that orchestrates notifications
    let manager: ToastManager

    /// 📍 Where the toast should appear on screen
    var position: ToastPosition = .top

    // MARK: - 🎭 Body

    var body: some View {
        if let toast = manager.currentToast {
            ToastView(toast: toast)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: position.insertionEdge).combined(with: .opacity),
                        removal: .opacity
                    )
                )
                .onTapGesture {
                    // 👆 Tap to dismiss - the audience can end the performance early
                    withAnimation(.easeOut(duration: 0.2)) {
                        manager.dismiss()
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: position.yOffset)
        }
    }
}

// MARK: - 📍 Toast Position

/// 📍 Where on stage the toast shall appear
enum ToastPosition {
    case top        // 🎭 Above the stage (top of screen)
    case center     // 🎯 Center stage
    case bottom     // 🎭 Below the stage (bottom of screen)

    /// 🎬 The edge from which the toast enters
    var insertionEdge: Edge {
        switch self {
        case .top: .top
        case .center: .top
        case .bottom: .bottom
        }
    }

    /// 📏 The vertical position on screen
    var yOffset: CGFloat {
        switch self {
        case .top: 80 // Below Dynamic Island / notch
        case .center: UIScreen.main.bounds.height / 2
        case .bottom: UIScreen.main.bounds.height - 100
        }
    }
}

// MARK: - 🎭 Toast View Modifier (Enhanced)

/// 🎨 View modifier for adding toast support to any view
struct ToastContainerModifier: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🍞 The toast manager
    let manager: ToastManager

    /// 📍 Where to position the toast
    var position: ToastPosition = .top

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .overlay {
                ToastContainerView(manager: manager, position: position)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: manager.currentToast?.id)
    }
}

// MARK: - 🎨 View Extension

/// 🎨 Convenience extensions for adding toast to any view
extension View {

    /// 🍞 Add toast notification support to this view
    /// - Parameters:
    ///   - manager: The toast manager
    ///   - position: Where to show the toast (default: top)
    /// - Returns: A view that can display toasts
    func toast(
        _ manager: ToastManager,
        position: ToastPosition = .top
    ) -> some View {
        modifier(ToastContainerModifier(manager: manager, position: position))
    }

    /// 🍞 Add toast at the top of the screen
    func toastTop(_ manager: ToastManager) -> some View {
        toast(manager, position: .top)
    }

    /// 🍞 Add toast at the center of the screen
    func toastCenter(_ manager: ToastManager) -> some View {
        toast(manager, position: .center)
    }

    /// 🍞 Add toast at the bottom of the screen
    func toastBottom(_ manager: ToastManager) -> some View {
        toast(manager, position: .bottom)
    }
}

// MARK: - 🎯 Accessibility Support

/// 🎯 Accessibility descriptions for toast types
extension ToastType {

    /// 📜 A human-readable description for VoiceOver
    var localizedDescription: String {
        switch self {
        case .success: "Success"
        case .error: "Error"
        case .warning: "Warning"
        case .info: "Information"
        }
    }
}

// MARK: - 🧪 Preview

#Preview {
    VStack(spacing: 40) {
        ToastView(
            toast: Toast(
                type: .success,
                title: "Upload Complete",
                message: "Your masterpiece has been saved to the gallery"
            )
        )

        ToastView(
            toast: Toast(
                type: .error,
                title: "Upload Failed",
                message: "The digital muses are taking a break"
            )
        )

        ToastView(
            toast: Toast(
                type: .warning,
                title: "Connection Unstable",
                message: "Your internet signal is weak"
            )
        )

        ToastView(
            toast: Toast(
                type: .info,
                title: "New Feature",
                message: "We've added magical new capabilities"
            )
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
