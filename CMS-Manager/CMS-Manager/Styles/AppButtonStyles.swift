//
//  AppButtonStyles.swift
//  CMS-Manager
//
//  🎯 The Button Styles - Interactive Delights Collection
//
//  "Where every touch creates magic, every press a moment of joy.
//   From bold primaries to gentle ghosts, each button beckons
//   with purpose and personality, waiting to spring to life
//   beneath the seeker's fingertips."
//
//  - The Spellbinding Museum Director of Interactive Elements
//

import SwiftUI

// MARK: - 🎯 Primary Button Style

/// 🎯 Primary button - bold, filled, the star of the show
/// Use for: Main actions, CTAs, primary navigation
struct PrimaryButtonStyle: ButtonStyle {
    let isLoading: Bool
    let isDisabled: Bool

    init(isLoading: Bool = false, isDisabled: Bool = false) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelLarge)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonMedium)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
                    .fill(isDisabled ? Color.textDisabled : Color.brandPrimary)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(isLoading ? 0.6 : 1.0)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .shadowLevel2()
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed)
    }
}

// MARK: - 🎨 Secondary Button Style

/// 🎨 Secondary button - outlined, elegant sidekick
/// Use for: Secondary actions, cancel buttons
struct SecondaryButtonStyle: ButtonStyle {
    let isLoading: Bool
    let isDisabled: Bool

    init(isLoading: Bool = false, isDisabled: Bool = false) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelLarge)
            .foregroundStyle(isDisabled ? Color.textDisabled : Color.brandPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonMedium)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
                    .stroke(isDisabled ? Color.border : Color.brandPrimary, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
                            .fill(configuration.isPressed ? Color.brandPrimary.opacity(0.05) : Color.clear)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(isLoading ? 0.6 : 1.0)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(Color.brandPrimary)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}

// MARK: - 👻 Ghost Button Style

/// 👻 Ghost button - text only, minimal and elegant
/// Use for: Tertiary actions, subtle navigation
struct GhostButtonStyle: ButtonStyle {
    let isDisabled: Bool

    init(isDisabled: Bool = false) {
        self.isDisabled = isDisabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelLarge)
            .foregroundStyle(isDisabled ? Color.textDisabled : Color.brandPrimary)
            .frame(height: AppSpacing.buttonMedium)
            .padding(.horizontal, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
                    .fill(configuration.isPressed ? Color.brandPrimary.opacity(0.1) : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

// MARK: - 🌩️ Destructive Button Style

/// 🌩️ Destructive button - for delete and dangerous actions
/// Use with care! Always confirm destructive actions
struct DestructiveButtonStyle: ButtonStyle {
    let isLoading: Bool
    let isDisabled: Bool

    init(isLoading: Bool = false, isDisabled: Bool = false) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelLarge)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonMedium)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
                    .fill(isDisabled ? Color.textDisabled : Color.error)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(isLoading ? 0.6 : 1.0)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .shadowLevel2()
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .heavy), trigger: configuration.isPressed)
    }
}

// MARK: - 🏷️ Pill Button Style

/// 🏷️ Pill button - compact, rounded, perfect for filters and chips
/// Use for: Tags, filters, compact options
struct PillButtonStyle: ButtonStyle {
    let isSelected: Bool

    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelMedium)
            .foregroundStyle(isSelected ? .white : Color.textPrimary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
            .background(
                Capsule()
                    .fill(isSelected ? Color.brandPrimary : Color.backgroundTertiary)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color.border, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

// MARK: - 🔘 Icon Button Style

/// 🔘 Icon button - circular, perfect for toolbar actions
/// Use for: Toolbar icons, small actions, close buttons
struct IconButtonStyle: ButtonStyle {
    let size: CGFloat

    init(size: CGFloat = AppSpacing.buttonMedium) {
        self.size = size
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(Color.textPrimary)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(configuration.isPressed ? Color.backgroundTertiary : Color.backgroundSecondary)
            )
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

// MARK: - 🌟 Floating Action Button Style

/// 🌟 Floating Action Button (FAB) - prominent, floating, always accessible
/// Use for: Primary floating actions, create buttons
struct FABStyle: ButtonStyle {
    let isExpanded: Bool

    init(isExpanded: Bool = false) {
        self.isExpanded = isExpanded
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            .padding(isExpanded ? AppSpacing.md : 0)
            .frame(width: isExpanded ? nil : 56, height: 56)
            .background(
                RoundedRectangle(
                    cornerRadius: isExpanded ? AppSpacing.radiusLG : AppSpacing.radiusFull,
                    style: .continuous
                )
                .fill(Color.brandPrimary)
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .deepLayeredShadow()
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed)
    }
}

// MARK: - 🎨 View Extensions

extension View {
    /// 🎯 Apply primary button style
    func primaryButton(isLoading: Bool = false, isDisabled: Bool = false) -> some View {
        buttonStyle(PrimaryButtonStyle(isLoading: isLoading, isDisabled: isDisabled))
            .disabled(isDisabled || isLoading)
    }

    /// 🎨 Apply secondary button style
    func secondaryButton(isLoading: Bool = false, isDisabled: Bool = false) -> some View {
        buttonStyle(SecondaryButtonStyle(isLoading: isLoading, isDisabled: isDisabled))
            .disabled(isDisabled || isLoading)
    }

    /// 👻 Apply ghost button style
    func ghostButton(isDisabled: Bool = false) -> some View {
        buttonStyle(GhostButtonStyle(isDisabled: isDisabled))
            .disabled(isDisabled)
    }

    /// 🌩️ Apply destructive button style
    func destructiveButton(isLoading: Bool = false, isDisabled: Bool = false) -> some View {
        buttonStyle(DestructiveButtonStyle(isLoading: isLoading, isDisabled: isDisabled))
            .disabled(isDisabled || isLoading)
    }

    /// 🏷️ Apply pill button style
    func pillButton(isSelected: Bool = false) -> some View {
        buttonStyle(PillButtonStyle(isSelected: isSelected))
    }

    /// 🔘 Apply icon button style
    func iconButton(size: CGFloat = AppSpacing.buttonMedium) -> some View {
        buttonStyle(IconButtonStyle(size: size))
    }

    /// 🌟 Apply FAB style
    func fab(isExpanded: Bool = false) -> some View {
        buttonStyle(FABStyle(isExpanded: isExpanded))
    }
}

// MARK: - 🧪 Preview

#Preview("Button Styles Showcase") {
    ScrollView {
        VStack(spacing: 32) {
            // 🎯 Primary Buttons
            buttonSection("Primary Buttons") {
                Button("Primary Button") {}
                    .primaryButton()

                Button("Loading") {}
                    .primaryButton(isLoading: true)

                Button("Disabled") {}
                    .primaryButton(isDisabled: true)
            }

            Divider()

            // 🎨 Secondary Buttons
            buttonSection("Secondary Buttons") {
                Button("Secondary Button") {}
                    .secondaryButton()

                Button("Loading") {}
                    .secondaryButton(isLoading: true)

                Button("Disabled") {}
                    .secondaryButton(isDisabled: true)
            }

            Divider()

            // 👻 Ghost Buttons
            buttonSection("Ghost Buttons") {
                Button("Ghost Button") {}
                    .ghostButton()

                Button("Disabled") {}
                    .ghostButton(isDisabled: true)
            }

            Divider()

            // 🌩️ Destructive Buttons
            buttonSection("Destructive Buttons") {
                Button("Delete") {}
                    .destructiveButton()

                Button("Deleting...") {}
                    .destructiveButton(isLoading: true)
            }

            Divider()

            // 🏷️ Pill Buttons
            buttonSection("Pill Buttons") {
                HStack {
                    Button("Unselected") {}
                        .pillButton(isSelected: false)

                    Button("Selected") {}
                        .pillButton(isSelected: true)
                }
            }

            Divider()

            // 🔘 Icon Buttons
            buttonSection("Icon Buttons") {
                HStack(spacing: 16) {
                    Button {
                    } label: {
                        Image(systemName: "heart")
                    }
                    .iconButton()

                    Button {
                    } label: {
                        Image(systemName: "star")
                    }
                    .iconButton()

                    Button {
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    .iconButton()
                }
            }

            Divider()

            // 🌟 FAB
            buttonSection("Floating Action Button") {
                HStack(spacing: 16) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                    .fab()

                    Button {
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create")
                        }
                    }
                    .fab(isExpanded: true)
                }
            }
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}

// MARK: - 🎨 Preview Helper

private func buttonSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 16) {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .textCase(.uppercase)
            .tracking(1)

        VStack(spacing: 12) {
            content()
        }
    }
}
