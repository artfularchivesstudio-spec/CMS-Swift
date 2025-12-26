//
//  AppSpacing.swift
//  CMS-Manager
//
//  📏 The Spacing System - Sacred Geometry of Visual Rhythm
//
//  "Where whitespace breathes life into design, each gap
//   a measured pause in the visual symphony. From intimate
//   moments to grand gestures, spacing creates the rhythm
//   that guides the eye through our digital landscape."
//
//  - The Spellbinding Museum Director of Spatial Harmony
//

import SwiftUI

// MARK: - 📏 Spacing System

/// 📏 Consistent spacing scale based on 4pt grid
/// All spacing values are multiples of 4 for perfect alignment
enum AppSpacing {

    // MARK: - 🎯 Core Spacing Scale

    /// ✨ Tiny - 4pt
    /// For very tight spacing, borders, small gaps
    static let tiny: CGFloat = 4

    /// 🔸 Extra Small - 8pt
    /// For compact lists, tight padding
    static let xs: CGFloat = 8

    /// 🔹 Small - 12pt
    /// For comfortable padding in compact UI
    static let sm: CGFloat = 12

    /// 📐 Medium - 16pt
    /// Default spacing for most UI elements
    static let md: CGFloat = 16

    /// 📏 Large - 24pt
    /// For section spacing, card padding
    static let lg: CGFloat = 24

    /// 🎭 Extra Large - 32pt
    /// For major sections, generous padding
    static let xl: CGFloat = 32

    /// 🌟 2X Large - 48pt
    /// For hero sections, large gaps
    static let xxl: CGFloat = 48

    /// 💫 3X Large - 64pt
    /// For maximum spacing, empty states
    static let xxxl: CGFloat = 64

    // MARK: - 📦 Component Spacing

    /// 🎯 Button padding (horizontal)
    static let buttonPaddingH: CGFloat = 24

    /// 🎯 Button padding (vertical)
    static let buttonPaddingV: CGFloat = 12

    /// 🃏 Card padding
    static let cardPadding: CGFloat = 16

    /// 📋 List item padding (vertical)
    static let listItemPaddingV: CGFloat = 12

    /// 📋 List item padding (horizontal)
    static let listItemPaddingH: CGFloat = 16

    /// 📱 Screen edge padding
    static let screenEdge: CGFloat = 16

    /// 📄 Section spacing
    static let sectionSpacing: CGFloat = 32

    /// 🎨 Icon spacing (from text)
    static let iconSpacing: CGFloat = 8

    // MARK: - 🎭 Interactive Element Sizes

    /// 👆 Minimum tap target (44pt - Apple HIG)
    static let minTapTarget: CGFloat = 44

    /// 🎯 Recommended tap target (48pt - Material Design)
    static let recommendedTapTarget: CGFloat = 48

    /// 🔘 Small button height
    static let buttonSmall: CGFloat = 36

    /// 🎯 Medium button height
    static let buttonMedium: CGFloat = 44

    /// 🌟 Large button height
    static let buttonLarge: CGFloat = 52

    // MARK: - 🎨 Corner Radius

    /// 🔸 Extra Small radius - 4pt
    /// For small chips, tags
    static let radiusXS: CGFloat = 4

    /// 🔹 Small radius - 8pt
    /// For buttons, inputs
    static let radiusSM: CGFloat = 8

    /// 📐 Medium radius - 12pt
    /// Default for cards, modals
    static let radiusMD: CGFloat = 12

    /// 📏 Large radius - 16pt
    /// For large cards, sheets
    static let radiusLG: CGFloat = 16

    /// 🎭 Extra Large radius - 24pt
    /// For hero cards, featured content
    static let radiusXL: CGFloat = 24

    /// 🌕 Full radius - 9999pt
    /// For circular elements, pills
    static let radiusFull: CGFloat = 9999
}

// MARK: - 📏 Spacing View Extensions

extension View {

    // MARK: - 🎯 Padding Modifiers

    /// ✨ Apply tiny padding (4pt)
    func paddingTiny() -> some View {
        padding(AppSpacing.tiny)
    }

    /// 🔸 Apply extra small padding (8pt)
    func paddingXS() -> some View {
        padding(AppSpacing.xs)
    }

    /// 🔹 Apply small padding (12pt)
    func paddingSM() -> some View {
        padding(AppSpacing.sm)
    }

    /// 📐 Apply medium padding (16pt) - Default
    func paddingMD() -> some View {
        padding(AppSpacing.md)
    }

    /// 📏 Apply large padding (24pt)
    func paddingLG() -> some View {
        padding(AppSpacing.lg)
    }

    /// 🎭 Apply extra large padding (32pt)
    func paddingXL() -> some View {
        padding(AppSpacing.xl)
    }

    /// 🌟 Apply 2X large padding (48pt)
    func paddingXXL() -> some View {
        padding(AppSpacing.xxl)
    }

    /// 💫 Apply 3X large padding (64pt)
    func paddingXXXL() -> some View {
        padding(AppSpacing.xxxl)
    }

    // MARK: - 📏 Edge-Specific Padding

    /// 📱 Apply screen edge padding (horizontal)
    func paddingScreenEdge() -> some View {
        padding(.horizontal, AppSpacing.screenEdge)
    }

    /// 🃏 Apply card padding (all sides)
    func paddingCard() -> some View {
        padding(AppSpacing.cardPadding)
    }

    /// 📋 Apply list item padding
    func paddingListItem() -> some View {
        padding(.horizontal, AppSpacing.listItemPaddingH)
            .padding(.vertical, AppSpacing.listItemPaddingV)
    }

    // MARK: - 🎨 Corner Radius Modifiers

    /// 🔸 Apply extra small corner radius (4pt)
    func cornerRadiusXS() -> some View {
        clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusXS, style: .continuous))
    }

    /// 🔹 Apply small corner radius (8pt)
    func cornerRadiusSM() -> some View {
        clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous))
    }

    /// 📐 Apply medium corner radius (12pt) - Default
    func cornerRadiusMD() -> some View {
        clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMD, style: .continuous))
    }

    /// 📏 Apply large corner radius (16pt)
    func cornerRadiusLG() -> some View {
        clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLG, style: .continuous))
    }

    /// 🎭 Apply extra large corner radius (24pt)
    func cornerRadiusXL() -> some View {
        clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusXL, style: .continuous))
    }

    /// 🌕 Apply full corner radius (circular/pill)
    func cornerRadiusFull() -> some View {
        clipShape(Capsule())
    }

    // MARK: - 👆 Tap Target Modifiers

    /// 👆 Ensure minimum tap target size (44pt)
    func minTapTarget() -> some View {
        frame(minWidth: AppSpacing.minTapTarget, minHeight: AppSpacing.minTapTarget)
    }

    /// 🎯 Ensure recommended tap target size (48pt)
    func recommendedTapTarget() -> some View {
        frame(minWidth: AppSpacing.recommendedTapTarget, minHeight: AppSpacing.recommendedTapTarget)
    }
}

// MARK: - 📏 Spacer Helpers

extension View {

    /// ✨ Add vertical spacing
    func vSpacing(_ spacing: CGFloat) -> some View {
        self.padding(.vertical, spacing / 2)
    }

    /// 🎨 Add horizontal spacing
    func hSpacing(_ spacing: CGFloat) -> some View {
        self.padding(.horizontal, spacing / 2)
    }
}

// MARK: - 🧪 Preview

#Preview("Spacing Showcase") {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            // 📏 Spacing Scale
            spacingSection("Spacing Scale") {
                spacingItem("Tiny (4pt)", AppSpacing.tiny)
                spacingItem("XS (8pt)", AppSpacing.xs)
                spacingItem("SM (12pt)", AppSpacing.sm)
                spacingItem("MD (16pt)", AppSpacing.md)
                spacingItem("LG (24pt)", AppSpacing.lg)
                spacingItem("XL (32pt)", AppSpacing.xl)
                spacingItem("XXL (48pt)", AppSpacing.xxl)
                spacingItem("XXXL (64pt)", AppSpacing.xxxl)
            }

            Divider()

            // 🎨 Corner Radius
            spacingSection("Corner Radius") {
                radiusItem("XS (4pt)", AppSpacing.radiusXS)
                radiusItem("SM (8pt)", AppSpacing.radiusSM)
                radiusItem("MD (12pt)", AppSpacing.radiusMD)
                radiusItem("LG (16pt)", AppSpacing.radiusLG)
                radiusItem("XL (24pt)", AppSpacing.radiusXL)
            }

            Divider()

            // 👆 Button Sizes
            spacingSection("Button Heights") {
                buttonSizeItem("Small (36pt)", AppSpacing.buttonSmall)
                buttonSizeItem("Medium (44pt)", AppSpacing.buttonMedium)
                buttonSizeItem("Large (52pt)", AppSpacing.buttonLarge)
            }
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}

// MARK: - 🎨 Preview Helpers

private func spacingSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .textCase(.uppercase)
            .tracking(1)

        VStack(spacing: 8) {
            content()
        }
    }
}

private func spacingItem(_ name: String, _ value: CGFloat) -> some View {
    HStack(spacing: 12) {
        Rectangle()
            .fill(Color.brandPrimary)
            .frame(width: value, height: 20)

        Text(name)
            .font(.bodyMedium)
            .foregroundStyle(Color.textPrimary)

        Spacer()

        Text("\(Int(value))pt")
            .font(.captionLarge)
            .foregroundStyle(Color.textSecondary)
    }
}

private func radiusItem(_ name: String, _ value: CGFloat) -> some View {
    HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: value, style: .continuous)
            .fill(Color.brandPrimary)
            .frame(width: 60, height: 40)

        Text(name)
            .font(.bodyMedium)
            .foregroundStyle(Color.textPrimary)

        Spacer()

        Text("\(Int(value))pt")
            .font(.captionLarge)
            .foregroundStyle(Color.textSecondary)
    }
}

private func buttonSizeItem(_ name: String, _ height: CGFloat) -> some View {
    HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: AppSpacing.radiusSM, style: .continuous)
            .fill(Color.brandPrimary)
            .frame(width: 120, height: height)
            .overlay(
                Text("Button")
                    .font(.labelMedium)
                    .foregroundStyle(.white)
            )

        Text(name)
            .font(.bodyMedium)
            .foregroundStyle(Color.textPrimary)

        Spacer()
    }
}
