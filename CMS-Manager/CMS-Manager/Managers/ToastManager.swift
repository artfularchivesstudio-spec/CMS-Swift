//
//  ToastManager.swift
//  CMS-Manager
//
//  🍞 The Toast Manager - Herald of Divine Notifications
//
//  "Like a mystical messenger appearing from the mists,
//   this manager summons fleeting messages that dance
//   across the screen before vanishing into the ether."
//
//  - The Spellbinding Museum Director of UI Notifications
//

import SwiftUI

// MARK: - 🎭 Toast Manager

/// 🍞 The keeper of fleeting notifications - shows and dismisses toast messages
@MainActor
@Observable
final class ToastManager {

    // MARK: - 🌟 Current Toast

    /// 🎭 The currently displayed toast (if any)
    private(set) var currentToast: Toast?

    /// 🧙‍♂️ The task that will dismiss the toast after its duration
    private var dismissTask: Task<Void, Never>?

    // MARK: - 🎭 Toast Methods

    /// 📢 Show a toast notification
    /// - Parameters:
    ///   - toast: The toast to display
    ///   - duration: How long to show the toast (default: 3 seconds)
    func show(_ toast: Toast, duration: TimeInterval = 3.0) {
        print("🍞 ✨ TOAST AWAKENS! [\(toast.type.icon)] \(toast.title)")

        // 🛑 Cancel any existing dismissal
        dismissTask?.cancel()

        // 🎭 Animate in the new toast with a spring
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentToast = toast
        }

        // ⏰ Schedule automatic dismissal
        dismissTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(duration))

                // 🌙 Animate out gracefully
                withAnimation(.easeOut(duration: 0.2)) {
                    currentToast = nil
                }

                print("🌙 Toast fades into the mists...")
            } catch {
                // Task was cancelled - toast dismissed manually
                print("🌙 Toast dismissed by user intervention")
            }
        }
    }

    /// 🚪 Manually dismiss the current toast
    func dismiss() {
        print("🚪 Dismissing toast with a wave of the hand")

        dismissTask?.cancel()
        dismissTask = nil

        withAnimation(.easeOut(duration: 0.2)) {
            currentToast = nil
        }
    }

    // MARK: - 🎯 Convenience Methods

    /// 🎉 Show a success toast
    func success(_ title: String, message: String = "") {
        show(Toast(type: .success, title: title, message: message))
    }

    /// 💥 Show an error toast
    func error(_ title: String, message: String = "") {
        show(Toast(type: .error, title: title, message: message), duration: 5.0)
    }

    /// ⚠️ Show a warning toast
    func warning(_ title: String, message: String = "") {
        show(Toast(type: .warning, title: title, message: message), duration: 4.0)
    }

    /// ℹ️ Show an info toast
    func info(_ title: String, message: String = "") {
        show(Toast(type: .info, title: title, message: message))
    }
}

// MARK: - 🍞 Toast Model

/// 🍞 A single toast notification - brief and beautiful
struct Toast: Identifiable, Equatable {
    /// 🌟 Unique identifier
    let id = UUID()

    /// 🎨 The type/severity of the toast
    let type: ToastType

    /// 📝 The headline message
    let title: String

    /// 📜 Additional detail text
    let message: String

    /// 🎭 Create a new toast
    init(type: ToastType, title: String, message: String = "") {
        self.type = type
        self.title = title
        self.message = message
    }

    /// 📜 Equatable conformance
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - 🎨 Toast Type

/// 🎨 The four spirits of toast notification
enum ToastType {
    case success  // 🎉 All went well
    case error    // 💥 Something broke
    case warning  // ⚠️ Proceed with caution
    case info     // ℹ️ For your information

    /// 🎨 SF Symbol icon for each type
    var icon: String {
        switch self {
        case .success: "checkmark.circle.fill"
        case .error: "xmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .info: "info.circle.fill"
        }
    }

    /// 🌈 Semantic color for each type
    var color: Color {
        switch self {
        case .success: .green
        case .error: .red
        case .warning: .orange
        case .info: .blue
        }
    }

    /// 🎭 A slightly lighter version for backgrounds
    var lightColor: Color {
        switch self {
        case .success: .green.opacity(0.15)
        case .error: .red.opacity(0.15)
        case .warning: .orange.opacity(0.15)
        case .info: .blue.opacity(0.15)
        }
    }
}

// MARK: - 🎨 Toast View Modifier

/// 🎨 A view modifier that displays toast notifications
struct ToastViewModifier: ViewModifier {

    // MARK: - 🏺 Properties

    /// 🍞 The toast manager that provides the current toast
    let manager: ToastManager

    // MARK: - 🎭 Body

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = manager.currentToast {
                    ToastItemView(toast: toast)
                        .padding(.top, 60) // 📱 Below dynamic island / notch
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: manager.currentToast?.id)
    }
}

// MARK: - 🍞 Toast Item View

/// 🍞 The visual representation of a single toast
private struct ToastItemView: View {

    // MARK: - 🏺 Properties

    /// 🍞 The toast to display
    let toast: Toast

    // MARK: - 🎭 Body

    var body: some View {
        HStack(spacing: 12) {
            // 🎨 Icon
            Image(systemName: toast.type.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(toast.type.color)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 4) {
                // 📝 Title
                Text(toast.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                // 📜 Message
                if !toast.message.isEmpty {
                    Text(toast.message)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            // 🚪 Dismiss button
            Button {
                // Can't dismiss here - need reference to manager
                // Users can tap to dismiss, or wait for timeout
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
        )
        .padding(.horizontal, 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(toast.title + (toast.message.isEmpty ? "" : ", \(toast.message)"))
    }
}

// MARK: - 🎨 View Extension

/// 🎨 Convenience extension for adding toast to any view
extension View {

    /// 🍞 Add toast notification support to this view
    /// - Parameter manager: The toast manager
    /// - Returns: A view that can display toasts
    func toast(_ manager: ToastManager) -> some View {
        modifier(ToastViewModifier(manager: manager))
    }
}
