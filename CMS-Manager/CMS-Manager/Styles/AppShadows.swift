//
//  AppShadows.swift
//  CMS-Manager
//
//  🌑 The Shadow System - Mystical Depth & Elevation
//
//  "Where light and shadow dance in perfect balance,
//   each surface floating at its destined height.
//   From subtle whispers to bold declarations,
//   shadows grant our UI the gift of dimension."
//
//  - The Spellbinding Museum Director of Depth Perception
//

import SwiftUI

// MARK: - 🌑 Shadow System

/// 🌑 Elevation-based shadow system for depth hierarchy
/// Each level represents a different "height" above the base layer
enum AppShadow {

    // MARK: - 🎭 Elevation Levels

    /// 📄 Level 0 - No elevation (flat on surface)
    /// Use for: Base layer elements, disabled states
    case none

    /// ✨ Level 1 - Subtle elevation (2-4pt)
    /// Use for: Cards, list items, subtle containers
    case level1

    /// 🎨 Level 2 - Medium elevation (4-8pt)
    /// Use for: Floating buttons, hover states, dropdowns
    case level2

    /// 🌟 Level 3 - High elevation (8-16pt)
    /// Use for: Modals, sheets, popovers, alerts
    case level3

    /// 💫 Level 4 - Maximum elevation (16-24pt)
    /// Use for: Toasts, tooltips, top-most elements
    case level4

    // MARK: - 🎨 Shadow Properties

    /// 🎯 Shadow configuration for each level
    var properties: ShadowProperties {
        switch self {
        case .none:
            return ShadowProperties(color: .clear, radius: 0, x: 0, y: 0)
        case .level1:
            return ShadowProperties(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        case .level2:
            return ShadowProperties(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        case .level3:
            return ShadowProperties(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        case .level4:
            return ShadowProperties(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        }
    }
}

// MARK: - 🎨 Shadow Properties

/// 🎨 Shadow configuration structure
struct ShadowProperties {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - 🌑 View Extensions

extension View {

    // MARK: - 🎭 Elevation Modifiers

    /// 📄 Apply no shadow (flat)
    func shadowNone() -> some View {
        shadow(color: .clear, radius: 0, x: 0, y: 0)
    }

    /// ✨ Apply level 1 shadow (subtle elevation)
    func shadowLevel1() -> some View {
        let props = AppShadow.level1.properties
        return shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
    }

    /// 🎨 Apply level 2 shadow (medium elevation)
    func shadowLevel2() -> some View {
        let props = AppShadow.level2.properties
        return shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
    }

    /// 🌟 Apply level 3 shadow (high elevation)
    func shadowLevel3() -> some View {
        let props = AppShadow.level3.properties
        return shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
    }

    /// 💫 Apply level 4 shadow (maximum elevation)
    func shadowLevel4() -> some View {
        let props = AppShadow.level4.properties
        return shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
    }

    // MARK: - 🎨 Colored Shadows

    /// 🌈 Apply a colored shadow (for emphasis)
    /// - Parameters:
    ///   - color: The shadow color
    ///   - radius: Shadow blur radius
    ///   - y: Vertical offset
    func coloredShadow(color: Color, radius: CGFloat = 8, y: CGFloat = 4) -> some View {
        shadow(color: color.opacity(0.3), radius: radius, x: 0, y: y)
    }

    /// ✨ Apply brand-colored shadow
    func brandShadow() -> some View {
        coloredShadow(color: .brandPrimary, radius: 8, y: 4)
    }

    /// 🎉 Apply success-colored shadow
    func successShadow() -> some View {
        coloredShadow(color: .success, radius: 8, y: 4)
    }

    /// 🌩️ Apply error-colored shadow
    func errorShadow() -> some View {
        coloredShadow(color: .error, radius: 8, y: 4)
    }

    // MARK: - 🎭 Layered Shadows

    /// 🌟 Apply layered shadow for enhanced depth
    /// Combines two shadows for a more realistic effect
    func layeredShadow() -> some View {
        self
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    /// 💫 Apply deep layered shadow for maximum depth
    func deepLayeredShadow() -> some View {
        self
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 8)
    }

    // MARK: - 🎨 Inner Shadow Effect

    /// 🌑 Apply inner shadow effect (for pressed/inset elements)
    func innerShadow(color: Color = .black.opacity(0.1), radius: CGFloat = 2) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: AppSpacing.radiusMD, style: .continuous)
                .stroke(color, lineWidth: 1)
                .blur(radius: radius)
                .offset(y: 1)
                .mask(
                    RoundedRectangle(cornerRadius: AppSpacing.radiusMD, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.black, .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
        )
    }
}

// MARK: - 🎨 Card Style with Shadow

/// 🃏 Card container with proper elevation and styling
struct CardContainer<Content: View>: View {
    let content: Content
    let elevation: AppShadow

    init(elevation: AppShadow = .level1, @ViewBuilder content: () -> Content) {
        self.elevation = elevation
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.surface)
            .cornerRadiusMD()
            .modifier(ShadowModifier(shadow: elevation))
    }
}

// MARK: - 🌑 Shadow Modifier

/// 🎨 Reusable shadow modifier
struct ShadowModifier: ViewModifier {
    let shadow: AppShadow

    func body(content: Content) -> some View {
        let props = shadow.properties
        return content
            .shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
    }
}

// MARK: - 🧪 Preview

#Preview("Shadow Showcase") {
    ScrollView {
        VStack(spacing: 32) {
            // 🌑 Shadow Levels
            shadowSection("Shadow Levels") {
                shadowCard("No Shadow", elevation: .none)
                shadowCard("Level 1 - Subtle", elevation: .level1)
                shadowCard("Level 2 - Medium", elevation: .level2)
                shadowCard("Level 3 - High", elevation: .level3)
                shadowCard("Level 4 - Maximum", elevation: .level4)
            }

            Divider()

            // 🌈 Colored Shadows
            shadowSection("Colored Shadows") {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        coloredShadowCard("Brand", color: .brandPrimary)
                        coloredShadowCard("Success", color: .success)
                    }
                    HStack(spacing: 16) {
                        coloredShadowCard("Warning", color: .warning)
                        coloredShadowCard("Error", color: .error)
                    }
                }
            }

            Divider()

            // 🌟 Layered Shadows
            shadowSection("Layered Shadows") {
                VStack {
                    Text("Layered Shadow")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.surface)
                        .cornerRadiusMD()
                        .layeredShadow()

                    Text("Deep Layered Shadow")
                        .font(.bodyMedium)
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.surface)
                        .cornerRadiusMD()
                        .deepLayeredShadow()
                }
            }
        }
        .padding()
    }
    .background(Color.backgroundSecondary)
}

// MARK: - 🎨 Preview Helpers

private func shadowSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 16) {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .textCase(.uppercase)
            .tracking(1)

        content()
    }
}

@MainActor
private func shadowCard(_ title: String, elevation: AppShadow) -> some View {
    Text(title)
        .font(.bodyMedium)
        .foregroundStyle(Color.textPrimary)
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.surface)
        .cornerRadiusMD()
        .modifier(ShadowModifier(shadow: elevation))
}

@MainActor
private func coloredShadowCard(_ title: String, color: Color) -> some View {
    Text(title)
        .font(.bodyMedium)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(color)
        .cornerRadiusMD()
        .coloredShadow(color: color)
}
