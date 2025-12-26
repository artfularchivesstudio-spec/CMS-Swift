//
//  SkeletonView.swift
//  CMS-Manager
//
//  💀 The Skeleton Architect - Placeholder Perfection
//
//  "Before content arrives, these elegant ghosts dance across the screen,
//   maintaining layout, preserving space, whispering 'patience, dear user,
//   your data approaches at light speed.'"
//
//  - The Spellbinding Museum Director of Anticipation Design
//

import SwiftUI

// MARK: - 💀 Skeleton View

/// 💀 A base skeleton view with shimmer effect
/// The foundation for all our beautiful loading placeholders! ✨
struct SkeletonView: View {

    // MARK: - 🎨 Properties

    /// 📐 Shape style (rectangle, circle, capsule)
    let shape: SkeletonShape

    /// 📏 Height of the skeleton
    let height: CGFloat?

    /// 📏 Width of the skeleton (nil = expand to available space)
    let width: CGFloat?

    /// 🎨 Corner radius (only applies to rounded rectangles)
    let cornerRadius: CGFloat

    /// 🎨 Color scheme for adaptive colors
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - 💀 Skeleton Shapes

    enum SkeletonShape {
        case rectangle
        case circle
        case capsule
        case roundedRectangle
    }

    // MARK: - 🎭 Initializer

    /// 💀 Create a skeleton view
    /// - Parameters:
    ///   - shape: The shape of the skeleton (default: .roundedRectangle)
    ///   - height: Fixed height (nil = flexible)
    ///   - width: Fixed width (nil = flexible)
    ///   - cornerRadius: Corner radius for rounded rectangles (default: 8)
    init(
        shape: SkeletonShape = .roundedRectangle,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        cornerRadius: CGFloat = 8
    ) {
        self.shape = shape
        self.height = height
        self.width = width
        self.cornerRadius = cornerRadius
    }

    // MARK: - 🎭 Body

    @ViewBuilder
    var body: some View {
        switch shape {
        case .rectangle:
            Rectangle()
                .fill(baseColor)
                .frame(width: width, height: height)
                .shimmer()
                .accessibilityLabel("Loading content")
                .accessibilityAddTraits(.updatesFrequently)
        case .circle:
            Circle()
                .fill(baseColor)
                .frame(width: width, height: height)
                .shimmer()
                .accessibilityLabel("Loading content")
                .accessibilityAddTraits(.updatesFrequently)
        case .capsule:
            Capsule()
                .fill(baseColor)
                .frame(width: width, height: height)
                .shimmer()
                .accessibilityLabel("Loading content")
                .accessibilityAddTraits(.updatesFrequently)
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(baseColor)
                .frame(width: width, height: height)
                .shimmer()
                .accessibilityLabel("Loading content")
                .accessibilityAddTraits(.updatesFrequently)
        }
    }

    // MARK: - 🎨 Colors

    /// 🎨 Base color for the skeleton (adapts to dark/light mode)
    private var baseColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.15)
    }
}

// MARK: - 📏 Skeleton Line

/// 📏 A skeleton line (rounded rectangle) - perfect for text placeholders
/// Like a ghost of text that hasn't been written yet! 👻
struct SkeletonLine: View {

    let width: CGFloat?
    let height: CGFloat

    /// 📏 Create a skeleton line for text
    /// - Parameters:
    ///   - width: Width of the line (nil = full width)
    ///   - height: Height of the line (default: 14 - like body text)
    init(width: CGFloat? = nil, height: CGFloat = 14) {
        self.width = width
        self.height = height
    }

    var body: some View {
        SkeletonView(
            shape: .roundedRectangle,
            height: height,
            width: width,
            cornerRadius: 4
        )
    }
}

// MARK: - 🖼️ Skeleton Image

/// 🖼️ A skeleton image placeholder - for those precious pixels yet to load
/// A rectangle or square that dreams of being a masterpiece! 🎨
struct SkeletonImage: View {

    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    /// 🖼️ Create a skeleton image placeholder
    /// - Parameters:
    ///   - width: Width (nil = flexible)
    ///   - height: Height
    ///   - cornerRadius: Corner radius (default: 8)
    init(width: CGFloat? = nil, height: CGFloat = 100, cornerRadius: CGFloat = 8) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        ZStack {
            SkeletonView(
                shape: .roundedRectangle,
                height: height,
                width: width,
                cornerRadius: cornerRadius
            )

            // 📷 Camera icon overlay - subtle hint of what's coming
            Image(systemName: "photo")
                .font(.system(size: height * 0.3))
                .foregroundStyle(.tertiary)
                .opacity(0.3)
        }
    }
}

// MARK: - 🎨 Skeleton Badge

/// 🎨 A skeleton badge - capsule shaped placeholder
/// For those status badges and tags that are fashionably late! 💅
struct SkeletonBadge: View {

    let width: CGFloat

    /// 🎨 Create a skeleton badge
    /// - Parameter width: Width of the badge (default: 80)
    init(width: CGFloat = 80) {
        self.width = width
    }

    var body: some View {
        SkeletonView(
            shape: .capsule,
            height: 24,
            width: width
        )
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Skeleton Components") {
    ScrollView {
        VStack(spacing: 24) {
            // 📏 Skeleton Lines
            VStack(alignment: .leading, spacing: 8) {
                Text("Skeleton Lines")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                SkeletonLine(height: 20) // Title
                SkeletonLine(width: 200) // Subtitle
                SkeletonLine(width: 150) // Short text
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // 🖼️ Skeleton Images
            VStack(spacing: 12) {
                Text("Skeleton Images")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    SkeletonImage(width: 80, height: 80) // Square
                    SkeletonImage(height: 80) // Flexible width
                }

                SkeletonImage(height: 200, cornerRadius: 12) // Wide banner
            }

            Divider()

            // 🎨 Skeleton Badges
            VStack(spacing: 12) {
                Text("Skeleton Badges")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    SkeletonBadge(width: 60)
                    SkeletonBadge(width: 90)
                    SkeletonBadge(width: 70)
                }
            }

            Divider()

            // 🎭 Various Shapes
            VStack(spacing: 12) {
                Text("Various Shapes")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    SkeletonView(shape: .circle, height: 60, width: 60)
                    SkeletonView(shape: .capsule, height: 40, width: 120)
                    SkeletonView(shape: .rectangle, height: 60)
                }
            }
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}
