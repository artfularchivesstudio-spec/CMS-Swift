//
//  StoryCardSkeleton.swift
//  CMS-Manager
//
//  📇 The Story Card Ghost - Preview of Things to Come
//
//  "Before stories materialize from the digital ether,
//   these ghostly cards hold their place in the gallery,
//   maintaining rhythm, preserving flow, promising content."
//
//  - The Spellbinding Museum Director of Placeholder Choreography
//

import SwiftUI

// MARK: - 📇 Story Card Skeleton

/// 📇 A skeleton placeholder that matches StoryRowView's layout
/// Available in both list and grid styles - the chameleon of loading states! 🦎
struct StoryCardSkeleton: View {

    // MARK: - 🎨 Properties

    /// 🎨 The visual layout style (matches StoryRowView)
    let layoutStyle: LayoutStyle

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
        .accessibilityLabel("Loading story")
    }

    // MARK: - 📋 List Layout

    /// 📋 Horizontal skeleton matching list layout
    private var listLayout: some View {
        HStack(spacing: 16) {
            // 🖼️ Thumbnail skeleton
            SkeletonImage(width: 80, height: 80, cornerRadius: 8)

            // 📝 Content skeleton
            VStack(alignment: .leading, spacing: 6) {
                // 📜 Title lines (2 lines)
                SkeletonLine(height: 16)
                SkeletonLine(width: 180, height: 16)

                // ✂️ Excerpt lines (2 lines)
                SkeletonLine(width: 220, height: 13)
                SkeletonLine(width: 160, height: 13)

                Spacer()

                // 🏷️ Footer skeleton (badges and metadata)
                HStack(spacing: 8) {
                    SkeletonBadge(width: 70) // Status badge
                    SkeletonBadge(width: 50) // Language flags

                    Spacer()

                    SkeletonLine(width: 60, height: 11) // Date
                }
            }

            Spacer()
        }
        .frame(height: 120)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    // MARK: - 🎨 Grid Layout

    /// 🎨 Vertical skeleton matching grid layout
    private var gridLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🖼️ Thumbnail skeleton (full width)
            SkeletonImage(height: 140, cornerRadius: 12)

            // 📝 Content skeleton
            VStack(alignment: .leading, spacing: 6) {
                // 📜 Title lines (2 lines)
                SkeletonLine(height: 15)
                SkeletonLine(width: 140, height: 15)

                // ✂️ Excerpt lines (2 lines)
                SkeletonLine(width: 160, height: 12)
                SkeletonLine(width: 120, height: 12)

                // 🏷️ Footer skeleton
                HStack(spacing: 6) {
                    SkeletonBadge(width: 60)
                    SkeletonBadge(width: 40)

                    Spacer()

                    SkeletonLine(width: 50, height: 10)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
        )
    }
}

// MARK: - 📚 Stories List Skeleton

/// 📚 Multiple skeleton cards for the stories list
/// Shows 5-8 cards to fill the initial screen - the welcoming committee! 🎭
struct StoriesListSkeleton: View {

    let viewMode: ViewMode
    let count: Int

    /// 🎨 View mode (matches StoriesListView)
    enum ViewMode {
        case list
        case grid
    }

    /// 📚 Create a stories list skeleton
    /// - Parameters:
    ///   - viewMode: List or grid layout
    ///   - count: Number of skeleton cards to show (default: 6)
    init(viewMode: ViewMode = .list, count: Int = 6) {
        self.viewMode = viewMode
        self.count = count
    }

    var body: some View {
        ScrollView {
            if viewMode == .list {
                listView
            } else {
                gridView
            }
        }
        .accessibilityLabel("Loading stories list")
    }

    // MARK: - 📋 List View

    private var listView: some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<count, id: \.self) { index in
                StoryCardSkeleton(layoutStyle: .list)
                    .transition(.opacity)
                    // 🎭 Staggered fade-in for each card
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                        value: index
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    // MARK: - 🎨 Grid View

    private var gridView: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(0..<count, id: \.self) { index in
                StoryCardSkeleton(layoutStyle: .grid)
                    .transition(.scale.combined(with: .opacity))
                    // 🎭 Staggered scale-in for grid items
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05),
                        value: index
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    /// 📐 Responsive grid columns
    private var gridColumns: [GridItem] {
        #if os(iOS)
        // 📱 iPhone: 2 columns, iPad: 3-4 columns
        Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        #else
        // 💻 Mac: 4 columns
        Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        #endif
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Story Card Skeleton - List") {
    VStack(spacing: 12) {
        StoryCardSkeleton(layoutStyle: .list)
        StoryCardSkeleton(layoutStyle: .list)
        StoryCardSkeleton(layoutStyle: .list)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Story Card Skeleton - Grid") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StoryCardSkeleton(layoutStyle: .grid)
            StoryCardSkeleton(layoutStyle: .grid)
            StoryCardSkeleton(layoutStyle: .grid)
            StoryCardSkeleton(layoutStyle: .grid)
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Stories List Skeleton - List Mode") {
    StoriesListSkeleton(viewMode: .list, count: 5)
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Stories List Skeleton - Grid Mode") {
    StoriesListSkeleton(viewMode: .grid, count: 6)
        .background(Color(uiColor: .systemGroupedBackground))
}
