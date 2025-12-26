//
//  SkeletonCard.swift
//  CMS-Manager
//
//  💀 The Skeleton Card - Mystical Loading Placeholders
//
//  "While the cosmic data flows through digital veins,
//   these shimmering ghosts dance across the screen,
//   promising stories yet to materialize from the ether."
//
//  - The Spellbinding Museum Director of Loading States
//

import SwiftUI

// MARK: - 💀 Skeleton Card View

/// 💀 A beautiful shimmer loading placeholder for story cards
/// Performs an elegant gradient sweep that catches the eye without being distracting
struct SkeletonCard: View {

    // MARK: - 🌟 State

    /// ✨ Controls the shimmer animation position (0.0 to 1.0)
    @State private var shimmerPhase: CGFloat = 0

    // MARK: - 🏺 Properties

    /// 🎨 The visual layout style
    let layoutStyle: LayoutStyle

    // MARK: - 🎨 Layout Style

    /// 🎨 Different ways to arrange the skeleton card
    enum LayoutStyle {
        case list   // Horizontal: image on left, text on right
        case grid   // Vertical: image on top, text below
    }

    // MARK: - 🎭 Body

    var body: some View {
        Group {
            if layoutStyle == .list {
                listLayout
            } else {
                gridLayout
            }
        }
        .onAppear {
            // 🌊 Start the mesmerizing shimmer dance
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerPhase = 1.0
            }
        }
    }

    // MARK: - 📋 List Layout

    /// 📋 Horizontal skeleton with image on left
    private var listLayout: some View {
        HStack(spacing: 16) {
            // 🖼️ Thumbnail skeleton
            skeletonBox(width: 80, height: 80, cornerRadius: 8)

            // 📝 Content skeleton
            VStack(alignment: .leading, spacing: 8) {
                // 📜 Title skeleton (2 lines)
                skeletonBox(height: 16, cornerRadius: 4)
                    .frame(maxWidth: .infinity)

                skeletonBox(height: 16, cornerRadius: 4)
                    .frame(maxWidth: 200)

                // ✂️ Excerpt skeleton (2 lines)
                skeletonBox(height: 12, cornerRadius: 4)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                skeletonBox(height: 12, cornerRadius: 4)
                    .frame(maxWidth: 180)

                Spacer()

                // 🏷️ Footer skeleton
                HStack(spacing: 8) {
                    skeletonBox(width: 60, height: 20, cornerRadius: 10)
                    skeletonBox(width: 40, height: 20, cornerRadius: 10)

                    Spacer()

                    skeletonBox(width: 60, height: 12, cornerRadius: 4)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    // MARK: - 🎨 Grid Layout

    /// 🎨 Vertical skeleton with image on top
    private var gridLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🖼️ Thumbnail skeleton
            skeletonBox(height: 140, cornerRadius: 12)

            // 📝 Content skeleton
            VStack(alignment: .leading, spacing: 6) {
                // 📜 Title skeleton (2 lines)
                skeletonBox(height: 14, cornerRadius: 4)
                    .frame(maxWidth: .infinity)

                skeletonBox(height: 14, cornerRadius: 4)
                    .frame(maxWidth: 100)

                // ✂️ Excerpt skeleton (2 lines)
                skeletonBox(height: 11, cornerRadius: 4)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 2)

                skeletonBox(height: 11, cornerRadius: 4)
                    .frame(maxWidth: 80)

                // 🏷️ Footer skeleton
                HStack(spacing: 6) {
                    skeletonBox(width: 50, height: 18, cornerRadius: 9)
                    skeletonBox(width: 30, height: 18, cornerRadius: 9)

                    Spacer()

                    skeletonBox(width: 50, height: 10, cornerRadius: 4)
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    // MARK: - 💀 Skeleton Box

    /// 💀 A single shimmering skeleton element
    /// The shimmer effect uses a gradient that sweeps across like moonlight on water
    private func skeletonBox(width: CGFloat? = nil, height: CGFloat, cornerRadius: CGFloat) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: Color.gray.opacity(0.15), location: 0),
                        .init(color: Color.gray.opacity(0.25), location: shimmerPhase - 0.3),
                        .init(color: Color.gray.opacity(0.35), location: shimmerPhase),
                        .init(color: Color.gray.opacity(0.25), location: shimmerPhase + 0.3),
                        .init(color: Color.gray.opacity(0.15), location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

// MARK: - 🧙‍♂️ Previews

#Preview("List Style") {
    VStack(spacing: 12) {
        SkeletonCard(layoutStyle: .list)
        SkeletonCard(layoutStyle: .list)
        SkeletonCard(layoutStyle: .list)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Grid Style") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            SkeletonCard(layoutStyle: .grid)
            SkeletonCard(layoutStyle: .grid)
            SkeletonCard(layoutStyle: .grid)
            SkeletonCard(layoutStyle: .grid)
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Mixed Loading") {
    ScrollView {
        VStack(spacing: 12) {
            ForEach(0..<3) { _ in
                SkeletonCard(layoutStyle: .list)
            }
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}
