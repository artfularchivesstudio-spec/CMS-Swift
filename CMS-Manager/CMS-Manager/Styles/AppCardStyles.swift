//
//  AppCardStyles.swift
//  CMS-Manager
//
//  🃏 The Card Styles - Containers of Wonder & Delight
//
//  "Where content finds its home in elegant frames,
//   each card a stage for stories yet untold.
//   From subtle whispers to bold declarations,
//   these vessels carry meaning with grace."
//
//  - The Spellbinding Museum Director of Container Arts
//

import SwiftUI

// MARK: - 🃏 Standard Card Style

/// 🃏 Standard card - the everyday hero
/// Clean, simple, perfect for most content
struct StandardCardStyle: ViewModifier {
    let padding: CGFloat

    init(padding: CGFloat = AppSpacing.cardPadding) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.surface)
            .cornerRadiusMD()
            .shadowLevel1()
    }
}

// MARK: - 🎨 Elevated Card Style

/// 🎨 Elevated card - stands out from the crowd
/// Higher elevation for interactive or important content
struct ElevatedCardStyle: ViewModifier {
    let padding: CGFloat

    init(padding: CGFloat = AppSpacing.cardPadding) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.surface)
            .cornerRadiusLG()
            .shadowLevel2()
    }
}

// MARK: - 🌟 Featured Card Style

/// 🌟 Featured card - the star of the show
/// With gradient border and enhanced elevation
struct FeaturedCardStyle: ViewModifier {
    let padding: CGFloat

    init(padding: CGFloat = AppSpacing.cardPadding) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.surface)
            .cornerRadiusLG()
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusLG, style: .continuous)
                    .stroke(Color.gradientPrimary, lineWidth: 2)
            )
            .shadowLevel3()
    }
}

// MARK: - 📋 Compact Card Style

/// 📋 Compact card - space-efficient and clean
/// For list items and tight layouts
struct CompactCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(Color.surface)
            .cornerRadiusSM()
            .shadowLevel1()
    }
}

// MARK: - 🎭 Interactive Card Style

/// 🎭 Interactive card - responds to touch
/// With hover and press states for delightful interaction
struct InteractiveCardStyle: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.cardPadding)
            .background(Color.surface)
            .cornerRadiusMD()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadowLevel2()
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

// MARK: - 🌈 Colored Card Style

/// 🌈 Colored card - with semantic background tint
/// Perfect for status, alerts, and contextual information
struct ColoredCardStyle: ViewModifier {
    let color: Color
    let padding: CGFloat

    init(color: Color, padding: CGFloat = AppSpacing.cardPadding) {
        self.color = color
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(color.opacity(0.1))
            .cornerRadiusMD()
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMD, style: .continuous)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - 🎪 Hero Card Style

/// 🎪 Hero card - large, beautiful, attention-grabbing
/// For featured content, showcases, hero sections
struct HeroCardStyle: ViewModifier {
    let gradient: LinearGradient

    init(gradient: LinearGradient = Color.gradientPrimary) {
        self.gradient = gradient
    }

    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.lg)
            .background(
                ZStack {
                    gradient
                    Color.white.opacity(0.95)
                        .blendMode(.overlay)
                }
            )
            .cornerRadiusXL()
            .deepLayeredShadow()
    }
}

// MARK: - 🏷️ Bordered Card Style

/// 🏷️ Bordered card - clean outline without shadow
/// Perfect for forms, inputs, and light emphasis
struct BorderedCardStyle: ViewModifier {
    let borderColor: Color
    let padding: CGFloat

    init(borderColor: Color = .border, padding: CGFloat = AppSpacing.cardPadding) {
        self.borderColor = borderColor
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.surface)
            .cornerRadiusMD()
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMD, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

// MARK: - 🌫️ Glassmorphic Card Style

/// 🌫️ Glassmorphic card - frosted glass effect
/// Modern, beautiful, perfect for overlays and modals
struct GlassmorphicCardStyle: ViewModifier {
    let padding: CGFloat
    let cornerRadius: CGFloat

    init(padding: CGFloat = AppSpacing.cardPadding, cornerRadius: CGFloat = AppSpacing.radiusMD) {
        self.padding = padding
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadowLevel2()
    }
}

// MARK: - 📊 Stats Card Style

/// 📊 Stats card - perfect for displaying metrics
/// Clean design with emphasis on numbers
struct StatsCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.lg)
            .background(
                LinearGradient(
                    colors: [Color.surface, Color.backgroundTertiary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadiusLG()
            .shadowLevel1()
    }
}

// MARK: - 🎨 View Extensions

extension View {
    /// 🃏 Apply standard card style
    func standardCard(padding: CGFloat = AppSpacing.cardPadding) -> some View {
        modifier(StandardCardStyle(padding: padding))
    }

    /// 🎨 Apply elevated card style
    func elevatedCard(padding: CGFloat = AppSpacing.cardPadding) -> some View {
        modifier(ElevatedCardStyle(padding: padding))
    }

    /// 🌟 Apply featured card style
    func featuredCard(padding: CGFloat = AppSpacing.cardPadding) -> some View {
        modifier(FeaturedCardStyle(padding: padding))
    }

    /// 📋 Apply compact card style
    func compactCard() -> some View {
        modifier(CompactCardStyle())
    }

    /// 🎭 Apply interactive card style
    func interactiveCard() -> some View {
        modifier(InteractiveCardStyle())
    }

    /// 🌈 Apply colored card style
    func coloredCard(color: Color, padding: CGFloat = AppSpacing.cardPadding) -> some View {
        modifier(ColoredCardStyle(color: color, padding: padding))
    }

    /// 🎪 Apply hero card style
    func heroCard(gradient: LinearGradient = Color.gradientPrimary) -> some View {
        modifier(HeroCardStyle(gradient: gradient))
    }

    /// 🏷️ Apply bordered card style
    func borderedCard(borderColor: Color = .border, padding: CGFloat = AppSpacing.cardPadding) -> some View {
        modifier(BorderedCardStyle(borderColor: borderColor, padding: padding))
    }

    /// 🌫️ Apply glassmorphic card style
    func glassmorphicCard(padding: CGFloat = AppSpacing.cardPadding, cornerRadius: CGFloat = AppSpacing.radiusMD) -> some View {
        modifier(GlassmorphicCardStyle(padding: padding, cornerRadius: cornerRadius))
    }

    /// 📊 Apply stats card style
    func statsCard() -> some View {
        modifier(StatsCardStyle())
    }
}

// MARK: - 🧪 Preview

#Preview("Card Styles Showcase") {
    ScrollView {
        VStack(spacing: 24) {
            // 🃏 Standard Card
            cardSection("Standard Card") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard Card")
                        .headlineSmall()
                    Text("Clean and simple, perfect for everyday content.")
                        .bodySmall()
                }
                .standardCard()
            }

            // 🎨 Elevated Card
            cardSection("Elevated Card") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Elevated Card")
                        .headlineSmall()
                    Text("Stands out with higher elevation.")
                        .bodySmall()
                }
                .elevatedCard()
            }

            // 🌟 Featured Card
            cardSection("Featured Card") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Featured Card")
                        .headlineSmall()
                    Text("The star of the show with gradient border.")
                        .bodySmall()
                }
                .featuredCard()
            }

            // 📋 Compact Card
            cardSection("Compact Card") {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.warning)
                    Text("Compact and space-efficient")
                        .bodySmall()
                }
                .compactCard()
            }

            // 🌈 Colored Cards
            cardSection("Colored Cards") {
                VStack(spacing: 12) {
                    Text("Success Message")
                        .bodyMedium()
                        .coloredCard(color: .success)

                    Text("Warning Message")
                        .bodyMedium()
                        .coloredCard(color: .warning)

                    Text("Error Message")
                        .bodyMedium()
                        .coloredCard(color: .error)
                }
            }

            // 🌫️ Glassmorphic Card
            ZStack {
                Color.gradientPrimary
                    .frame(height: 200)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Glassmorphic Card")
                        .headlineSmall()
                    Text("Beautiful frosted glass effect.")
                        .bodySmall()
                }
                .glassmorphicCard()
                .padding()
            }
            .cornerRadiusMD()

            // 📊 Stats Card
            cardSection("Stats Card") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("1,234")
                                .font(.numericLarge)
                                .foregroundStyle(Color.textPrimary)
                            Text("Total Stories")
                                .captionLarge()
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.success)
                    }
                }
                .statsCard()
            }

            // 🏷️ Bordered Card
            cardSection("Bordered Card") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bordered Card")
                        .headlineSmall()
                    Text("Clean outline without shadow.")
                        .bodySmall()
                }
                .borderedCard()
            }
        }
        .padding()
    }
    .background(Color.backgroundSecondary)
}

// MARK: - 🎨 Preview Helper

private func cardSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .textCase(.uppercase)
            .tracking(1)

        content()
    }
}
