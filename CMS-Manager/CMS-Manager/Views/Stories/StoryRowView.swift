//
//  StoryRowView.swift
//  CMS-Manager
//
//  📜 The Story Row - A Glimpse Into Each Tale
//
//  "Like museum placards beneath each masterpiece,
//   these compact cards reveal the essence of stories
//   waiting to be discovered by wandering souls."
//
//  - The Spellbinding Museum Director of Exhibition Design
//

import SwiftUI
import ArtfulArchivesCore

// MARK: - 📜 Story Row View

/// 📜 A compact card representing a single story in the list
struct StoryRowView: View {

    // MARK: - 🏺 Properties

    /// 📖 The story to display (using ArtfulArchivesCore Story model)
    let story: ArtfulArchivesCore.Story

    /// 🎨 The visual layout style
    var layoutStyle: LayoutStyle = .list

    // MARK: - 🌟 Animation State

    /// 💫 Is the card being pressed? (for that buttery tap animation)
    @State private var isPressed = false

    /// 🖼️ Has the image loaded? (for fade-in animation)
    @State private var imageLoaded = false

    /// 🏷️ Badge animation phases for sequential entrance
    @State private var showBadges = false

    // MARK: - 🎨 Layout Style

    /// 🎨 Different ways to arrange the story card
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
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onAppear {
            // 🎬 Stagger badge animations for that delightful cascade effect
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1)) {
                showBadges = true
            }
        }
        .simultaneousGesture(
            // 🎯 Detect press for scale animation (without blocking NavigationLink)
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        // 🌊 Haptic feedback for that tactile feel
                        #if os(iOS)
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        #endif
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }

    // MARK: - 📋 List Layout

    /// 📋 Horizontal layout with image on left
    private var listLayout: some View {
        HStack(spacing: 16) {
            // 🖼️ Thumbnail
            thumbnail
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            // 📝 Content
            VStack(alignment: .leading, spacing: 6) {
                // 📜 Title
                Text(story.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                // ✂️ Excerpt
                Text(story.excerpt)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                // 🏷️ Footer
                HStack(spacing: 8) {
                    // 🎭 Status badge
                    statusBadge
                        .opacity(showBadges ? 1 : 0)
                        .scaleEffect(showBadges ? 1 : 0.8)

                    // 🌐 Language flags (if multilingual)
                    if hasLocalizations {
                        languageFlags
                            .opacity(showBadges ? 1 : 0)
                            .scaleEffect(showBadges ? 1 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.15), value: showBadges)
                    }

                    // 🎵 Audio count indicator
                    if hasAudio {
                        audioIndicator
                            .opacity(showBadges ? 1 : 0)
                            .scaleEffect(showBadges ? 1 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.2), value: showBadges)
                    }

                    Spacer()

                    // 📅 Date
                    Text(story.updatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: isPressed ? 4 : 2)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Story: \(story.title). Status: \(story.workflowStage.displayName).")
    }

    // MARK: - 🎨 Grid Layout

    /// 🎨 Vertical layout with image on top
    private var gridLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🖼️ Thumbnail
            thumbnail
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            // 📝 Content
            VStack(alignment: .leading, spacing: 6) {
                // 📜 Title
                Text(story.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                // ✂️ Excerpt
                Text(story.excerpt)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                // 🏷️ Footer
                HStack(spacing: 6) {
                    statusBadge
                        .opacity(showBadges ? 1 : 0)
                        .scaleEffect(showBadges ? 1 : 0.8)

                    if hasLocalizations {
                        languageFlags
                            .opacity(showBadges ? 1 : 0)
                            .scaleEffect(showBadges ? 1 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.15), value: showBadges)
                    }

                    if hasAudio {
                        audioIndicator
                            .opacity(showBadges ? 1 : 0)
                            .scaleEffect(showBadges ? 1 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.2), value: showBadges)
                    }

                    Spacer()

                    Text(story.updatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: isPressed ? 4 : 2)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Story: \(story.title). Status: \(story.workflowStage.displayName).")
    }

    // MARK: - 🖼️ Thumbnail

    /// 🖼️ The story cover image with smooth fade-in animation
    private var thumbnail: some View {
        Group {
            if let imageURL = story.previewImageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        // 💀 Shimmer placeholder while loading
                        shimmerPlaceholder
                    case .success(let image):
                        // 🎨 Beautiful fade-in when image loads
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .opacity(imageLoaded ? 1 : 0)
                            .scaleEffect(imageLoaded ? 1 : 0.95)
                            .onAppear {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    imageLoaded = true
                                }
                            }
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }

    /// 🎨 A placeholder when no image is available
    private var placeholder: some View {
        ZStack {
            // 🌙 Gradient background
            LinearGradient(
                colors: [stageColor(for: story.workflowStage).opacity(0.3), .purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // 📜 Icon
            Image(systemName: "doc.text.fill")
                .font(.system(size: 30))
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    /// 💀 Shimmer placeholder for loading images
    private var shimmerPlaceholder: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Shimmer overlay - that sweet, sweet loading animation
                LinearGradient(
                    stops: [
                        .init(color: Color.white.opacity(0), location: 0),
                        .init(color: Color.white.opacity(0.3), location: 0.5),
                        .init(color: Color.white.opacity(0), location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: imageLoaded ? geometry.size.width : -geometry.size.width)
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: imageLoaded)
            }
        }
        .onAppear {
            // Trigger shimmer animation
            imageLoaded = false
        }
    }

    // MARK: - 🎭 Status Badge

    /// 🎭 A colored badge showing workflow status
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: story.workflowStage.icon)
                .font(.system(size: 9, weight: .semibold))

            Text(shortDisplayName)
                .font(.system(size: 10, weight: .medium))
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(stageColor(for: story.workflowStage).opacity(0.15))
        )
        .foregroundStyle(stageColor(for: story.workflowStage))
        .accessibilityLabel("Status: \(story.workflowStage.displayName)")
    }

    /// 📜 Shortened display name for compact badge
    private var shortDisplayName: String {
        switch story.workflowStage {
        case .created: "New"
        case .englishTextApproved: "EN Text"
        case .englishAudioApproved: "EN Audio"
        case .englishVersionApproved: "EN Ready"
        case .multilingualTextApproved: "ML Text"
        case .multilingualAudioApproved: "ML Audio"
        case .pendingFinalReview: "Review"
        case .approved: "Done"
        }
    }

    // MARK: - 🌐 Language Flags

    /// 🌐 Flags showing available translations
    private var languageFlags: some View {
        HStack(spacing: 2) {
            // 🇬🇧 Always have English
            Text("🇬🇧")
                .font(.system(size: 10))

            // 🌐 Show other localizations
            if let localizations = story.localizations {
                ForEach(localizations, id: \.id) { loc in
                    Text(flagForLocale(loc.locale))
                        .font(.system(size: 10))
                }
            }
        }
        .accessibilityLabel("Available in multiple languages")
    }

    /// 🏳️ Get flag emoji for locale
    private func flagForLocale(_ locale: String) -> String {
        switch locale.lowercased().prefix(2) {
        case "en": return "🇬🇧"
        case "es": return "🇪🇸"
        case "hi": return "🇮🇳"
        default: return "🌐"
        }
    }

    // MARK: - 🎵 Audio Indicator

    /// 🎵 Shows number of available audio tracks
    private var audioIndicator: some View {
        HStack(spacing: 2) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: 8, weight: .semibold))

            Text("\(audioCount)")
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(.secondary)
        .accessibilityLabel("\(audioCount) audio tracks available")
    }

    /// 🎵 Count of available audio tracks
    private var audioCount: Int {
        guard let audio = story.audio else { return 0 }
        var count = 0
        if audio.english != nil { count += 1 }
        if audio.spanish != nil { count += 1 }
        if audio.hindi != nil { count += 1 }
        return count
    }

    // MARK: - 🧮 Computed Properties

    /// 🌐 Does this story have translations?
    private var hasLocalizations: Bool {
        (story.localizations?.isEmpty == false)
    }

    /// 🎵 Does this story have audio?
    private var hasAudio: Bool {
        story.audio != nil
    }

    // MARK: - 🎨 Helpers

    /// 🎨 Get the color for a workflow stage
    private func stageColor(for stage: WorkflowStage) -> Color {
        switch stage {
        case .created: .blue
        case .englishTextApproved: .teal
        case .englishAudioApproved: .purple
        case .englishVersionApproved: .indigo
        case .multilingualTextApproved: .orange
        case .multilingualAudioApproved: .pink
        case .pendingFinalReview: .yellow
        case .approved: .green
        }
    }
}

// MARK: - 🧙‍♂️ Previews

#Preview("List Style") {
    VStack(spacing: 12) {
        StoryRowView(story: .mock, layoutStyle: .list)
        StoryRowView(story: .mockWithTranslations, layoutStyle: .list)
        StoryRowView(story: .mockPendingReview, layoutStyle: .list)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Grid Style") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StoryRowView(story: .mock, layoutStyle: .grid)
            StoryRowView(story: .mockWithTranslations, layoutStyle: .grid)
            StoryRowView(story: .mockPendingReview, layoutStyle: .grid)
            StoryRowView(story: .mock, layoutStyle: .grid)
            StoryRowView(story: .mockWithTranslations, layoutStyle: .grid)
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}

// MARK: - 🧪 Mock Extensions

extension ArtfulArchivesCore.Story {
    /// 🎭 A mock story for previews
    static var mock: ArtfulArchivesCore.Story {
        ArtfulArchivesCore.Story(
            id: 1,
            documentId: "doc-1",
            title: "The Mona Lisa's Secret Smile",
            slug: "mona-lisa-secret-smile",
            bodyMessage: "For centuries, art historians have debated the meaning behind the Mona Lisa's enigmatic expression...",
            excerpt: "A groundbreaking discovery about Da Vinci's most famous masterpiece.",
            image: ArtfulArchivesCore.StoryMedia(
                id: 1,
                name: "mona-lisa.jpg",
                alternativeText: "Mona Lisa painting",
                caption: "The Mona Lisa by Leonardo da Vinci",
                width: 800,
                height: 1200,
                url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/800px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg")!
            ),
            images: nil,
            audio: ArtfulArchivesCore.StoryAudio(english: "https://example.com/audio-en.mp3"),
            workflowStage: .approved,
            visible: true,
            locale: "en",
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date().addingTimeInterval(-86400),
            publishedAt: Date(),
            createdBy: ArtfulArchivesCore.StoryAuthor(id: 1, name: "Art Curator"),
            strapiAttributes: nil
        )
    }

    /// 🌐 A mock story with translations
    static var mockWithTranslations: ArtfulArchivesCore.Story {
        ArtfulArchivesCore.Story(
            id: 2,
            documentId: "doc-2",
            title: "Starry Night: A Journey Through Swirls",
            slug: "starry-night-journey",
            bodyMessage: "Van Gogh's masterpiece swirls with emotion, each brushstroke a cry of passion and pain...",
            excerpt: "Exploring the turbulent mind behind one of history's most beloved paintings.",
            image: nil,
            images: nil,
            audio: ArtfulArchivesCore.StoryAudio(
                english: "https://example.com/audio-en.mp3",
                spanish: "https://example.com/audio-es.mp3",
                hindi: "https://example.com/audio-hi.mp3"
            ),
            workflowStage: .multilingualAudioApproved,
            visible: true,
            locale: "en",
            localizations: [
                ArtfulArchivesCore.StoryLocalization(id: 1, locale: "es", title: "Noche Estrellada"),
                ArtfulArchivesCore.StoryLocalization(id: 2, locale: "hi", title: "तारों भरी रात")
            ],
            createdAt: Date(),
            updatedAt: Date().addingTimeInterval(-172800),
            publishedAt: nil,
            createdBy: ArtfulArchivesCore.StoryAuthor(id: 1, name: "Art Curator"),
            strapiAttributes: nil
        )
    }

    /// 👁️ A mock story pending review
    static var mockPendingReview: ArtfulArchivesCore.Story {
        ArtfulArchivesCore.Story(
            id: 3,
            documentId: "doc-3",
            title: "The Birth of Venus: Renaissance Reborn",
            slug: "birth-of-venus-renaissance",
            bodyMessage: "Botticelli's masterpiece captures the divine emergence of the goddess of love...",
            excerpt: "Discover the mythological tale behind this iconic Renaissance painting.",
            image: nil,
            images: nil,
            audio: nil,
            workflowStage: .pendingFinalReview,
            visible: false,
            locale: "en",
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date().addingTimeInterval(-43200),
            publishedAt: nil,
            createdBy: ArtfulArchivesCore.StoryAuthor(id: 2, name: "Junior Curator"),
            strapiAttributes: nil
        )
    }

    /// ✨ A newly created story
    static var mockNew: ArtfulArchivesCore.Story {
        ArtfulArchivesCore.Story(
            id: 4,
            documentId: "doc-4",
            title: "The Scream: Expressionist Nightmare",
            slug: "scream-expressionist",
            bodyMessage: "Munch's iconic painting captures existential angst in swirling colors...",
            excerpt: "A haunting exploration of human anxiety.",
            image: nil,
            images: nil,
            audio: nil,
            workflowStage: .created,
            visible: false,
            locale: "en",
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date(),
            publishedAt: nil,
            createdBy: ArtfulArchivesCore.StoryAuthor(id: 1, name: "Art Curator"),
            strapiAttributes: nil
        )
    }
}
