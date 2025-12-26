//
//  EmptyStateView.swift
//  CMS-Manager
//
//  🌙 The Empty State View - Beautiful Voids of Possibility
//
//  "Where nothing exists, everything is possible.
//   These gentle invitations transform emptiness into opportunity,
//   guiding seekers toward their next creative act
//   with warmth, clarity, and a touch of magic."
//
//  - The Spellbinding Museum Director of Empty Canvases
//

import SwiftUI

// MARK: - 🌙 Empty State View

/// 🌙 A beautiful empty state component
/// Shows when there's no content, with helpful messaging and actions
struct EmptyStateView: View {

    // MARK: - 🏺 Properties

    /// 🎨 The SF Symbol icon to display
    let icon: String

    /// 📝 The main title
    let title: String

    /// 📜 The descriptive message
    let message: String

    /// 🎯 Optional primary action
    let primaryAction: (() -> Void)?

    /// 🔖 Primary action label
    let primaryActionLabel: String?

    /// 🎨 Optional secondary action
    let secondaryAction: (() -> Void)?

    /// 🔖 Secondary action label
    let secondaryActionLabel: String?

    /// 🌈 Icon color theme
    let iconColor: Color

    /// 🎭 Custom illustration (optional)
    let illustration: AnyView?

    // MARK: - 🎭 Initialization

    /// 🌟 Create an empty state view
    /// - Parameters:
    ///   - icon: SF Symbol name
    ///   - title: Main headline
    ///   - message: Descriptive text
    ///   - iconColor: Color for the icon (default: tertiary)
    ///   - primaryAction: Optional primary button action
    ///   - primaryActionLabel: Label for primary button
    ///   - secondaryAction: Optional secondary button action
    ///   - secondaryActionLabel: Label for secondary button
    ///   - illustration: Optional custom illustration view
    init(
        icon: String,
        title: String,
        message: String,
        iconColor: Color = .textTertiary,
        primaryAction: (() -> Void)? = nil,
        primaryActionLabel: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        secondaryActionLabel: String? = nil,
        illustration: AnyView? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.iconColor = iconColor
        self.primaryAction = primaryAction
        self.primaryActionLabel = primaryActionLabel
        self.secondaryAction = secondaryAction
        self.secondaryActionLabel = secondaryActionLabel
        self.illustration = illustration
    }

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            // 🎨 Illustration or Icon
            if let illustration = illustration {
                illustration
                    .frame(height: 180)
            } else {
                iconView
            }

            // 📝 Content
            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .headlineLarge()
                    .multilineTextAlignment(.center)

                Text(message)
                    .bodyMedium(.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, AppSpacing.xl)

            // 🎯 Actions
            if primaryAction != nil || secondaryAction != nil {
                VStack(spacing: AppSpacing.sm) {
                    if let action = primaryAction, let label = primaryActionLabel {
                        Button(action: action) {
                            Text(label)
                        }
                        .primaryButton()
                        .padding(.horizontal, AppSpacing.xl)
                    }

                    if let action = secondaryAction, let label = secondaryActionLabel {
                        Button(action: action) {
                            Text(label)
                        }
                        .ghostButton()
                    }
                }
                .padding(.top, AppSpacing.sm)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }

    // MARK: - 🎨 Icon View

    /// 🎨 The icon display with beautiful styling
    private var iconView: some View {
        ZStack {
            // 🌙 Background circle
            Circle()
                .fill(iconColor.opacity(0.1))
                .frame(width: 120, height: 120)

            // ✨ Icon
            Image(systemName: icon)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(iconColor)
        }
        .accessibilityHidden(true)
    }
}

// MARK: - 🎨 Convenience Initializers

extension EmptyStateView {

    /// 📚 Empty stories state
    static func noStories(onRefresh: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "book.closed",
            title: "No Stories Yet",
            message: "Your collection is waiting to be filled with wonderful stories. Create your first story or pull down to refresh.",
            iconColor: .brandPrimary,
            primaryAction: nil,
            primaryActionLabel: nil,
            secondaryAction: onRefresh,
            secondaryActionLabel: "Refresh"
        )
    }

    /// 🔍 Search results empty
    static func noSearchResults(query: String, onClear: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results Found",
            message: "We couldn't find any stories matching '\(query)'. Try a different search term or clear your filters.",
            iconColor: .textSecondary,
            primaryAction: onClear,
            primaryActionLabel: "Clear Search"
        )
    }

    /// 🏷️ Filter results empty
    static func noFilterResults(onClear: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "line.3.horizontal.decrease.circle",
            title: "No Matching Stories",
            message: "Try adjusting your filters to see more results.",
            iconColor: .brandSecondary,
            primaryAction: onClear,
            primaryActionLabel: "Clear Filters"
        )
    }

    /// 🌐 Network error state
    static func networkError(onRetry: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "wifi.exclamationmark",
            title: "Connection Lost",
            message: "We're having trouble connecting to the server. Please check your internet connection and try again.",
            iconColor: .error,
            primaryAction: onRetry,
            primaryActionLabel: "Try Again"
        )
    }

    /// 💥 Generic error state
    static func error(message: String, onRetry: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "exclamationmark.triangle",
            title: "Something Went Wrong",
            message: message,
            iconColor: .error,
            primaryAction: onRetry,
            primaryActionLabel: "Try Again"
        )
    }
}

// MARK: - 🧪 Preview

#Preview("Empty States Showcase") {
    TabView {
        EmptyStateView.noStories(onRefresh: {})
            .background(Color.backgroundPrimary)
            .tabItem { Label("No Stories", systemImage: "book.closed") }

        EmptyStateView.noSearchResults(query: "unicorns", onClear: {})
            .background(Color.backgroundPrimary)
            .tabItem { Label("No Results", systemImage: "magnifyingglass") }

        EmptyStateView.noFilterResults(onClear: {})
            .background(Color.backgroundPrimary)
            .tabItem { Label("No Filters", systemImage: "line.3.horizontal.decrease") }

        EmptyStateView.networkError(onRetry: {})
            .background(Color.backgroundPrimary)
            .tabItem { Label("Network Error", systemImage: "wifi.exclamationmark") }

        EmptyStateView(
            icon: "star.fill",
            title: "No Favorites Yet",
            message: "Start favoriting stories to see them here.",
            iconColor: .warning,
            primaryAction: {},
            primaryActionLabel: "Browse Stories"
        )
        .background(Color.backgroundPrimary)
        .tabItem { Label("Custom", systemImage: "star") }
    }
}
