//
//  SearchResultsSkeleton.swift
//  CMS-Manager
//
//  🔍 The Search Ghost - Loading While You Seek
//
//  "As queries dance through the digital void,
//   these placeholders maintain the rhythm of discovery,
//   promising treasures soon to be unveiled."
//
//  - The Spellbinding Museum Director of Search Experiences
//

import SwiftUI

// MARK: - 🔍 Search Results Skeleton

/// 🔍 Skeleton for search results
/// Compact cards optimized for quick scanning! 👀
struct SearchResultsSkeleton: View {

    // MARK: - 🎨 Properties

    /// 📊 Number of skeleton results to show
    let count: Int

    /// 🔍 Show search bar in active state
    let showSearchBar: Bool

    /// 🔍 Create a search results skeleton
    /// - Parameters:
    ///   - count: Number of skeleton results (default: 5)
    ///   - showSearchBar: Show search bar skeleton (default: true)
    init(count: Int = 5, showSearchBar: Bool = true) {
        self.count = count
        self.showSearchBar = showSearchBar
    }

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 0) {
            // 🔍 Search bar skeleton
            if showSearchBar {
                searchBarSkeleton
            }

            // 🏷️ Filter chips skeleton
            filterChipsSkeleton

            // 📋 Search results
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<count, id: \.self) { index in
                        searchResultCardSkeleton
                            .transition(.opacity)
                            .animation(
                                .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                                value: index
                            )
                    }
                }
                .padding()
            }
        }
        .accessibilityLabel("Loading search results")
    }

    // MARK: - 🔍 Search Bar Skeleton

    /// 🔍 Search bar in loading state
    private var searchBarSkeleton: some View {
        HStack(spacing: 12) {
            // 🔍 Search icon
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.tertiary)

            // 📝 Search text placeholder
            SkeletonLine(width: 160, height: 14)

            Spacer()

            // ✖️ Clear button placeholder
            SkeletonView(shape: .circle, height: 20, width: 20)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemGray6))
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - 🏷️ Filter Chips Skeleton

    /// 🏷️ Filter chips row
    private var filterChipsSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { _ in
                    SkeletonBadge(width: CGFloat.random(in: 60...100))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }

    // MARK: - 📇 Search Result Card Skeleton

    /// 📇 A compact search result card
    private var searchResultCardSkeleton: some View {
        HStack(spacing: 12) {
            // 🖼️ Small thumbnail
            SkeletonImage(width: 60, height: 60, cornerRadius: 8)

            // 📝 Content
            VStack(alignment: .leading, spacing: 6) {
                // Title (1-2 lines)
                SkeletonLine(height: 14)
                SkeletonLine(width: 140, height: 14)

                // Excerpt (1 line)
                SkeletonLine(width: 180, height: 12)

                // Footer
                HStack(spacing: 8) {
                    SkeletonBadge(width: 50)
                    SkeletonLine(width: 60, height: 10)
                }
            }

            Spacer()

            // 🎯 Relevance indicator
            SkeletonView(shape: .circle, height: 8, width: 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
    }
}

// MARK: - 🔍 Empty Search State

/// 🔍 Skeleton shown while search initializes
/// Before the user has typed anything - the blank canvas! 🎨
struct EmptySearchSkeleton: View {

    var body: some View {
        VStack(spacing: 20) {
            // 🔍 Magnifying glass with shimmer
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.tertiary)
                .shimmer(duration: 1.5)

            // 💬 Suggestion text skeletons
            VStack(spacing: 8) {
                SkeletonLine(width: 200, height: 16)
                SkeletonLine(width: 160, height: 14)
            }

            // 🏷️ Popular searches
            VStack(alignment: .leading, spacing: 12) {
                SkeletonLine(width: 120, height: 14)

                HStack(spacing: 8) {
                    SkeletonBadge(width: 90)
                    SkeletonBadge(width: 70)
                    SkeletonBadge(width: 100)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityLabel("Initializing search")
    }
}

// MARK: - 🎯 Searching State

/// 🎯 Active searching animation
/// Shows while query is being executed - the suspenseful moment! ⏳
struct SearchingStateSkeleton: View {

    var body: some View {
        VStack(spacing: 24) {
            // 🔍 Animated search icon
            DotsLoader(dotSize: 10, color: .blue)

            VStack(spacing: 8) {
                Text("Searching...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)

                SkeletonLine(width: 180, height: 14)
            }

            // 🌊 Wave animation for visual interest
            WaveLoader(barCount: 7, barHeight: 40, color: .blue.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .accessibilityLabel("Searching for results")
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Search Results Skeleton") {
    SearchResultsSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Empty Search Skeleton") {
    EmptySearchSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Searching State Skeleton") {
    SearchingStateSkeleton()
        .background(Color(uiColor: .systemGroupedBackground))
}
