//
//  AppTypography.swift
//  CMS-Manager
//
//  📝 The Typography System - Grand Library of Textual Beauty
//
//  "Where words dance in perfect proportion, each glyph
//   carefully weighted, each line harmoniously spaced.
//   From bold headlines to whispered captions, every letter
//   tells its story with grace and clarity."
//
//  - The Spellbinding Museum Director of Typographic Arts
//

import SwiftUI

// MARK: - 📝 Typography System

/// 📝 Complete typography system using SF Pro with proper weights and sizes
/// Supports Dynamic Type for accessibility ✨
extension Font {

    // MARK: - 🎭 Display Styles

    /// 🌟 Display Large - For hero sections and splash screens
    /// Size: 40pt, Weight: Bold, Line Height: 1.2
    static let displayLarge = Font.system(size: 40, weight: .bold, design: .default)

    /// 🎨 Display Medium - For major headings
    /// Size: 32pt, Weight: Bold, Line Height: 1.25
    static let displayMedium = Font.system(size: 32, weight: .bold, design: .default)

    /// ✨ Display Small - For section headers
    /// Size: 24pt, Weight: Bold, Line Height: 1.3
    static let displaySmall = Font.system(size: 24, weight: .bold, design: .default)

    // MARK: - 📰 Headline Styles

    /// 📰 Headline Large - Primary page titles
    /// Size: 28pt, Weight: Semibold, Line Height: 1.3
    static let headlineLarge = Font.system(size: 28, weight: .semibold, design: .default)

    /// 📝 Headline Medium - Card titles, section headers
    /// Size: 20pt, Weight: Semibold, Line Height: 1.4
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .default)

    /// 🎯 Headline Small - Subsection headers
    /// Size: 17pt, Weight: Semibold, Line Height: 1.4
    static let headlineSmall = Font.system(size: 17, weight: .semibold, design: .default)

    // MARK: - 📖 Body Styles

    /// 📖 Body Large - Featured body text
    /// Size: 17pt, Weight: Regular, Line Height: 1.5
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)

    /// 📝 Body Medium - Standard body text
    /// Size: 15pt, Weight: Regular, Line Height: 1.5
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)

    /// 📜 Body Small - Compact body text
    /// Size: 13pt, Weight: Regular, Line Height: 1.5
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - 🏷️ Label Styles

    /// 🏷️ Label Large - Form labels, list items
    /// Size: 15pt, Weight: Medium, Line Height: 1.4
    static let labelLarge = Font.system(size: 15, weight: .medium, design: .default)

    /// 🎯 Label Medium - Button labels, tabs
    /// Size: 13pt, Weight: Medium, Line Height: 1.4
    static let labelMedium = Font.system(size: 13, weight: .medium, design: .default)

    /// 🔖 Label Small - Secondary labels
    /// Size: 11pt, Weight: Medium, Line Height: 1.4
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)

    // MARK: - 📑 Caption Styles

    /// 📑 Caption Large - Metadata, timestamps
    /// Size: 13pt, Weight: Regular, Line Height: 1.4
    static let captionLarge = Font.system(size: 13, weight: .regular, design: .default)

    /// 🏷️ Caption Medium - Helper text
    /// Size: 11pt, Weight: Regular, Line Height: 1.4
    static let captionMedium = Font.system(size: 11, weight: .regular, design: .default)

    /// 🔖 Caption Small - Fine print
    /// Size: 9pt, Weight: Regular, Line Height: 1.4
    static let captionSmall = Font.system(size: 9, weight: .regular, design: .default)

    // MARK: - 🔢 Numeric Styles

    /// 🔢 Numeric Display - For large numbers, stats
    /// Uses tabular/monospaced numbers for alignment
    static let numericDisplay = Font.system(size: 32, weight: .bold, design: .rounded)
        .monospacedDigit()

    /// 📊 Numeric Large - For counters, badges
    static let numericLarge = Font.system(size: 20, weight: .semibold, design: .rounded)
        .monospacedDigit()

    /// 🎯 Numeric Medium - For inline numbers
    static let numericMedium = Font.system(size: 15, weight: .medium, design: .rounded)
        .monospacedDigit()
}

// MARK: - 📐 Text Styles

/// 📐 Text style modifiers for consistent formatting
extension View {

    // MARK: - 🎭 Display Modifiers

    /// 🌟 Apply display large style with proper color and spacing
    func displayLarge(_ color: Color = .textPrimary) -> some View {
        self
            .font(.displayLarge)
            .foregroundStyle(color)
            .tracking(-0.5) // Tighter letter spacing for headlines
            .lineSpacing(4)
    }

    /// 🎨 Apply display medium style
    func displayMedium(_ color: Color = .textPrimary) -> some View {
        self
            .font(.displayMedium)
            .foregroundStyle(color)
            .tracking(-0.5)
            .lineSpacing(3)
    }

    /// ✨ Apply display small style
    func displaySmall(_ color: Color = .textPrimary) -> some View {
        self
            .font(.displaySmall)
            .foregroundStyle(color)
            .tracking(-0.3)
            .lineSpacing(2)
    }

    // MARK: - 📰 Headline Modifiers

    /// 📰 Apply headline large style
    func headlineLarge(_ color: Color = .textPrimary) -> some View {
        self
            .font(.headlineLarge)
            .foregroundStyle(color)
            .tracking(-0.3)
    }

    /// 📝 Apply headline medium style
    func headlineMedium(_ color: Color = .textPrimary) -> some View {
        self
            .font(.headlineMedium)
            .foregroundStyle(color)
    }

    /// 🎯 Apply headline small style
    func headlineSmall(_ color: Color = .textPrimary) -> some View {
        self
            .font(.headlineSmall)
            .foregroundStyle(color)
    }

    // MARK: - 📖 Body Modifiers

    /// 📖 Apply body large style
    func bodyLarge(_ color: Color = .textPrimary) -> some View {
        self
            .font(.bodyLarge)
            .foregroundStyle(color)
            .lineSpacing(4)
    }

    /// 📝 Apply body medium style
    func bodyMedium(_ color: Color = .textPrimary) -> some View {
        self
            .font(.bodyMedium)
            .foregroundStyle(color)
            .lineSpacing(3)
    }

    /// 📜 Apply body small style
    func bodySmall(_ color: Color = .textSecondary) -> some View {
        self
            .font(.bodySmall)
            .foregroundStyle(color)
            .lineSpacing(2)
    }

    // MARK: - 🏷️ Label Modifiers

    /// 🏷️ Apply label large style
    func labelLarge(_ color: Color = .textPrimary) -> some View {
        self
            .font(.labelLarge)
            .foregroundStyle(color)
    }

    /// 🎯 Apply label medium style
    func labelMedium(_ color: Color = .textSecondary) -> some View {
        self
            .font(.labelMedium)
            .foregroundStyle(color)
    }

    /// 🔖 Apply label small style
    func labelSmall(_ color: Color = .textTertiary) -> some View {
        self
            .font(.labelSmall)
            .foregroundStyle(color)
    }

    // MARK: - 📑 Caption Modifiers

    /// 📑 Apply caption large style
    func captionLarge(_ color: Color = .textSecondary) -> some View {
        self
            .font(.captionLarge)
            .foregroundStyle(color)
    }

    /// 🏷️ Apply caption medium style
    func captionMedium(_ color: Color = .textTertiary) -> some View {
        self
            .font(.captionMedium)
            .foregroundStyle(color)
    }

    /// 🔖 Apply caption small style
    func captionSmall(_ color: Color = .textTertiary) -> some View {
        self
            .font(.captionSmall)
            .foregroundStyle(color)
    }
}

// MARK: - 🧪 Preview

#Preview("Typography Showcase") {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            // 🎭 Display Styles
            typographySection("Display Styles") {
                Text("Display Large")
                    .displayLarge()
                Text("Display Medium")
                    .displayMedium()
                Text("Display Small")
                    .displaySmall()
            }

            Divider()

            // 📰 Headlines
            typographySection("Headlines") {
                Text("Headline Large")
                    .headlineLarge()
                Text("Headline Medium")
                    .headlineMedium()
                Text("Headline Small")
                    .headlineSmall()
            }

            Divider()

            // 📖 Body Text
            typographySection("Body Text") {
                Text("Body Large - The quick brown fox jumps over the lazy dog")
                    .bodyLarge()
                Text("Body Medium - The quick brown fox jumps over the lazy dog")
                    .bodyMedium()
                Text("Body Small - The quick brown fox jumps over the lazy dog")
                    .bodySmall()
            }

            Divider()

            // 🏷️ Labels
            typographySection("Labels") {
                Text("Label Large")
                    .labelLarge()
                Text("Label Medium")
                    .labelMedium()
                Text("Label Small")
                    .labelSmall()
            }

            Divider()

            // 📑 Captions
            typographySection("Captions") {
                Text("Caption Large - Updated 2 minutes ago")
                    .captionLarge()
                Text("Caption Medium - Last modified today")
                    .captionMedium()
                Text("Caption Small - Version 1.0.0")
                    .captionSmall()
            }

            Divider()

            // 🔢 Numeric Styles
            typographySection("Numeric Styles") {
                Text("1,234,567")
                    .font(.numericDisplay)
                    .foregroundStyle(Color.textPrimary)
                Text("9,876")
                    .font(.numericLarge)
                    .foregroundStyle(Color.textPrimary)
                Text("42")
                    .font(.numericMedium)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}

// MARK: - 🎨 Preview Helper

private func typographySection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .textCase(.uppercase)
            .tracking(1)

        VStack(alignment: .leading, spacing: 16) {
            content()
        }
    }
}
