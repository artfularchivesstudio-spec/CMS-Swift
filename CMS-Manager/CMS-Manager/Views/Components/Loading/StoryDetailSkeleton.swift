//
//  StoryDetailSkeleton.swift
//  CMS-Manager
//
//  📖 The Detail Page Phantom - Full Story Placeholder
//
//  "Like a theatrical stage awaiting its performance,
//   this skeleton sets the scene with perfect proportions,
//   promising a tale of wonder to unfold momentarily."
//
//  - The Spellbinding Museum Director of Story Previews
//

import SwiftUI

// MARK: - 📖 Story Detail Skeleton

/// 📖 A full skeleton placeholder for StoryDetailView
/// Matches the exact layout - image, title, content, audio, metadata! ✨
struct StoryDetailSkeleton: View {

    // MARK: - 🎭 Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 🖼️ Cover image skeleton
                coverImageSkeleton

                VStack(alignment: .leading, spacing: 20) {
                    // 🏷️ Header section skeleton
                    headerSkeleton

                    // 📝 Content section skeleton
                    contentSkeleton

                    // 🎵 Audio section skeleton
                    audioSkeleton

                    // 🎭 Workflow section skeleton
                    workflowSkeleton

                    // 📅 Metadata section skeleton
                    metadataSkeleton
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .accessibilityLabel("Loading story details")
    }

    // MARK: - 🖼️ Cover Image Skeleton

    /// 🖼️ Large banner image placeholder
    private var coverImageSkeleton: some View {
        SkeletonImage(height: 250, cornerRadius: 0)
    }

    // MARK: - 🏷️ Header Skeleton

    /// 🏷️ Title, status badge, and excerpt
    private var headerSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🎭 Status badge skeleton
            SkeletonBadge(width: 120)

            // 📜 Title skeleton (2 lines, bold weight)
            SkeletonLine(height: 24)
            SkeletonLine(width: 240, height: 24)

            // ✂️ Excerpt skeleton (1 line)
            SkeletonLine(width: 280, height: 15)
        }
    }

    // MARK: - 📝 Content Skeleton

    /// 📝 Main story content (markdown rendering placeholder)
    private var contentSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📑 Section title
            SkeletonLine(width: 60, height: 14)

            // 📜 Content paragraphs (varied widths for realism)
            VStack(alignment: .leading, spacing: 10) {
                // Paragraph 1
                SkeletonLine(height: 14)
                SkeletonLine(width: 300, height: 14)
                SkeletonLine(width: 280, height: 14)
                SkeletonLine(width: 200, height: 14)

                Spacer().frame(height: 8)

                // Paragraph 2
                SkeletonLine(height: 14)
                SkeletonLine(width: 320, height: 14)
                SkeletonLine(width: 260, height: 14)

                Spacer().frame(height: 8)

                // Paragraph 3
                SkeletonLine(height: 14)
                SkeletonLine(width: 290, height: 14)
                SkeletonLine(width: 310, height: 14)
                SkeletonLine(width: 180, height: 14)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    // MARK: - 🎵 Audio Skeleton

    /// 🎵 Audio player placeholder
    private var audioSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📑 Section title
            SkeletonLine(width: 50, height: 14)

            VStack(spacing: 16) {
                // 🗣️ Language picker skeleton
                SkeletonView(
                    shape: .roundedRectangle,
                    height: 32,
                    cornerRadius: 8
                )

                // 🎵 Player controls skeleton
                VStack(spacing: 12) {
                    // Progress bar
                    SkeletonView(
                        shape: .capsule,
                        height: 4
                    )

                    // Time labels
                    HStack {
                        SkeletonLine(width: 40, height: 10)
                        Spacer()
                        SkeletonLine(width: 40, height: 10)
                    }

                    // Control buttons
                    HStack(spacing: 20) {
                        SkeletonView(shape: .circle, height: 40, width: 40)
                        Spacer()
                        SkeletonView(shape: .circle, height: 60, width: 60)
                        Spacer()
                        SkeletonView(shape: .circle, height: 40, width: 40)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
    }

    // MARK: - 🎭 Workflow Skeleton

    /// 🎭 Workflow status section
    private var workflowSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📑 Section title
            SkeletonLine(width: 110, height: 14)

            // 📊 Progress bar skeleton
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    SkeletonLine(width: 60, height: 13)
                    Spacer()
                    SkeletonLine(width: 30, height: 13)
                }

                SkeletonView(
                    shape: .capsule,
                    height: 6
                )
            }

            // 🎭 Current stage
            HStack {
                SkeletonLine(width: 180, height: 13)
            }

            // 💡 Suggested action
            HStack(spacing: 8) {
                SkeletonLine(width: 240, height: 12)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    // MARK: - 📅 Metadata Skeleton

    /// 📅 Creation and modification dates
    private var metadataSkeleton: some View {
        VStack(alignment: .leading, spacing: 8) {
            metadataRowSkeleton
            metadataRowSkeleton
            metadataRowSkeleton
            metadataRowSkeleton
        }
    }

    /// 📅 A single metadata row skeleton
    private var metadataRowSkeleton: some View {
        HStack {
            SkeletonLine(width: 70, height: 13)
            Spacer()
            SkeletonLine(width: 100, height: 13)
        }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Story Detail Skeleton") {
    NavigationStack {
        StoryDetailSkeleton()
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Story Detail Skeleton - Dark Mode") {
    NavigationStack {
        StoryDetailSkeleton()
            .navigationBarTitleDisplayMode(.inline)
    }
    .preferredColorScheme(.dark)
}
