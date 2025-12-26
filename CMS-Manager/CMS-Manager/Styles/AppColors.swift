//
//  AppColors.swift
//  CMS-Manager
//
//  🎨 The Color Palette - Grand Spectrum of Visual Delight
//
//  "Where every hue tells a story, every shade whispers a truth,
//   this mystical palette paints the canvas of our digital dreams.
//   From the vibrant primaries to subtle neutrals, each color
//   chosen with intention, blessed with purpose."
//
//  - The Spellbinding Museum Director of Visual Harmony
//

import SwiftUI

// MARK: - 🎨 App Colors

/// 🎨 The complete color system - semantic colors for light and dark modes
/// This extension provides a cohesive color palette with WCAG AA contrast ratios
extension Color {

    // MARK: - 🌟 Primary Colors

    /// 💜 Primary brand color - vibrant and energetic indigo
    /// Perfect for primary actions, accents, and key UI elements
    static let brandPrimary = Color(hex: "6366F1") // Indigo-500

    /// 🌊 Secondary accent - complementary teal
    /// For secondary actions and complementary highlights
    static let brandSecondary = Color(hex: "14B8A6") // Teal-500

    /// ✨ Tertiary accent - warm amber for special moments
    /// Use sparingly for premium features or celebrations
    static let brandTertiary = Color(hex: "F59E0B") // Amber-500

    // MARK: - 🎭 Semantic Colors

    /// 🎉 Success - fresh, natural green
    /// For success states, confirmations, and positive feedback
    static let success = Color(hex: "10B981") // Emerald-500

    /// 🌩️ Error - gentle, non-aggressive red
    /// For errors and destructive actions (with care)
    static let error = Color(hex: "EF4444") // Red-500

    /// 🌅 Warning - warm orange
    /// For warnings and cautions
    static let warning = Color(hex: "F97316") // Orange-500

    /// 💡 Info - calm blue
    /// For informational messages
    static let info = Color(hex: "3B82F6") // Blue-500

    // MARK: - 🌙 Background Colors

    /// 🌌 Primary background - adapts to light/dark mode
    static let backgroundPrimary = Color.adaptive(light: .white, dark: Color(hex: "111827"))

    /// 🌑 Secondary background - subtle elevation
    static let backgroundSecondary = Color.adaptive(light: Color(hex: "F9FAFB"), dark: Color(hex: "1F2937"))

    /// 🌫️ Tertiary background - cards and elevated surfaces
    static let backgroundTertiary = Color.adaptive(light: .white, dark: Color(hex: "374151"))

    /// 🎭 Surface - for cards, modals, and floating elements
    static let surface = Color.adaptive(light: .white, dark: Color(hex: "1F2937"))

    // MARK: - 📝 Text Colors

    /// 📖 Primary text - high contrast, main content
    static let textPrimary = Color.adaptive(light: Color(hex: "111827"), dark: Color(hex: "F9FAFB"))

    /// 📜 Secondary text - medium contrast, supporting text
    static let textSecondary = Color.adaptive(light: Color(hex: "6B7280"), dark: Color(hex: "9CA3AF"))

    /// 🌫️ Tertiary text - low contrast, hints and placeholders
    static let textTertiary = Color.adaptive(light: Color(hex: "9CA3AF"), dark: Color(hex: "6B7280"))

    /// 🔘 Disabled text - for inactive elements
    static let textDisabled = Color.adaptive(light: Color(hex: "D1D5DB"), dark: Color(hex: "4B5563"))

    // MARK: - 🎨 Border & Divider Colors

    /// 🎯 Border - for input fields and cards
    static let border = Color.adaptive(light: Color(hex: "E5E7EB"), dark: Color(hex: "374151"))

    /// 📏 Divider - for separating content
    static let divider = Color.adaptive(light: Color(hex: "F3F4F6"), dark: Color(hex: "374151"))

    /// 🌟 Border focused - for focused input states
    static let borderFocused = Color.brandPrimary

    // MARK: - 🎭 Overlay Colors

    /// 🌑 Overlay - for modals and sheets backdrop
    static let overlay = Color.black.opacity(0.5)

    /// ✨ Scrim - lighter overlay for subtle dimming
    static let scrim = Color.black.opacity(0.2)

    // MARK: - 🌈 Gradient Colors

    /// 🌅 Primary gradient - brand gradient for special elements
    static let gradientPrimary = LinearGradient(
        colors: [Color.brandPrimary, Color.brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// ✨ Success gradient - for success celebrations
    static let gradientSuccess = LinearGradient(
        colors: [Color.success, Color(hex: "34D399")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// 🎨 Warm gradient - for premium/featured content
    static let gradientWarm = LinearGradient(
        colors: [Color(hex: "F59E0B"), Color(hex: "EF4444")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - 🎨 Light/Dark Mode Helper

extension Color {
    /// 🌓 Create a color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    /// - Returns: Adaptive Color
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - 🎨 Hex Color Extension

extension Color {
    /// 🎨 Create a color from a hex string
    /// Supports 6-character (RGB) and 8-character (RGBA) hex codes
    /// - Parameter hex: Hex color string (with or without #)
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        case 8: // RGBA
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - 🧪 Preview

#Preview("Color Palette") {
    ScrollView {
        VStack(spacing: 32) {
            // 🌟 Primary Colors
            colorSection("Primary Colors") {
                colorSwatch("Brand Primary", .brandPrimary)
                colorSwatch("Brand Secondary", .brandSecondary)
                colorSwatch("Brand Tertiary", .brandTertiary)
            }

            // 🎭 Semantic Colors
            colorSection("Semantic Colors") {
                colorSwatch("Success", .success)
                colorSwatch("Error", .error)
                colorSwatch("Warning", .warning)
                colorSwatch("Info", .info)
            }

            // 🌙 Backgrounds
            colorSection("Backgrounds") {
                colorSwatch("Primary", .backgroundPrimary)
                colorSwatch("Secondary", .backgroundSecondary)
                colorSwatch("Tertiary", .backgroundTertiary)
                colorSwatch("Surface", .surface)
            }

            // 📝 Text Colors
            colorSection("Text Colors") {
                colorSwatch("Primary", .textPrimary)
                colorSwatch("Secondary", .textSecondary)
                colorSwatch("Tertiary", .textTertiary)
                colorSwatch("Disabled", .textDisabled)
            }
        }
        .padding()
    }
    .background(Color.backgroundPrimary)
}

// MARK: - 🎨 Preview Helpers

private func colorSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(Color.textPrimary)

        VStack(spacing: 8) {
            content()
        }
    }
}

private func colorSwatch(_ name: String, _ color: Color) -> some View {
    HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(width: 60, height: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.border, lineWidth: 1)
            )

        Text(name)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color.textPrimary)

        Spacer()
    }
    .padding(12)
    .background(Color.surface)
    .cornerRadius(12)
}
