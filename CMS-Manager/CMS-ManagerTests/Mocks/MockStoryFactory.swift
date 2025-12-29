//
//  MockStoryFactory.swift
//  CMS-ManagerTests
//
//  🏭 The Story Factory - Where Test Tales Are Born
//
//  "In the mystical foundry of testing dreams, this factory
//   crafts stories from thin air—each one perfectly formed,
//   ready to populate our test scenarios with realistic data.
//   No database required, just pure creative engineering!"
//
//  - The Spellbinding Museum Director of Test Data Manufacturing
//

import Foundation
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 🏭 Mock Story Factory

/// 🌟 A factory for creating realistic test Story instances
///
/// This magical workshop produces stories in all stages of the workflow,
/// complete with images, audio, translations, and metadata. Perfect for
/// populating test scenarios without needing a live database! ✨
struct MockStoryFactory {

    // MARK: - 🎨 Story Builders - The Assembly Line

    /// 📖 Create a basic story with sensible defaults
    /// - Parameters:
    ///   - id: Story ID (default: 1)
    ///   - title: Story title (default: "The Enchanted Gallery")
    ///   - stage: Workflow stage (default: .created)
    /// - Returns: A freshly minted Story instance
    static func createStory(
        id: Int = 1,
        title: String = "The Enchanted Gallery",
        stage: WorkflowStage = .created
    ) -> Story {
        Story(
            id: id,
            documentId: "doc-\(id)",
            title: title,
            slug: generateSlug(from: title),
            bodyMessage: """
            In the heart of the city stands a museum unlike any other. Its walls whisper \
            secrets of centuries past, each artwork a window into another world. Visitors \
            often speak of feeling transported, as if the paintings themselves are alive \
            with stories waiting to be told.

            The curator, a mysterious figure known only as the Keeper, ensures that each \
            piece receives the reverence it deserves. Legend has it that on certain nights, \
            when the moon is full, the artworks reveal their true magic to those pure of heart.
            """,
            excerpt: "Discover the mystical museum where art comes alive and stories transcend time.",
            image: createStoryMedia(id: 100, name: "gallery-entrance.jpg"),
            images: [
                createStoryMedia(id: 101, name: "artwork-1.jpg"),
                createStoryMedia(id: 102, name: "artwork-2.jpg")
            ],
            audio: createStoryAudio(),
            workflowStage: stage,
            visible: stage == .approved,
            locale: "en",
            localizations: stage.rawValue.contains("multilingual") ? createLocalizations() : nil,
            createdAt: Date().addingTimeInterval(-86400 * 7), // 7 days ago
            updatedAt: Date().addingTimeInterval(-3600), // 1 hour ago
            publishedAt: stage == .approved ? Date() : nil,
            createdBy: createStoryAuthor(id: 1, name: "The Curator"),
            strapiAttributes: nil
        )
    }

    /// 🎭 Create a story at the "Created" stage - just born!
    static func createNewStory(id: Int = 10) -> Story {
        createStory(
            id: id,
            title: "The Birth of Digital Art",
            stage: .created
        )
    }

    /// ✅ Create a story at the "English Text Approved" stage
    static func createEnglishApprovedStory(id: Int = 20) -> Story {
        createStory(
            id: id,
            title: "Renaissance Reimagined",
            stage: .englishTextApproved
        )
    }

    /// 🔊 Create a story at the "English Audio Approved" stage
    static func createEnglishAudioApprovedStory(id: Int = 30) -> Story {
        createStory(
            id: id,
            title: "The Sound of Sculpture",
            stage: .englishAudioApproved
        )
    }

    /// 🌐 Create a story at the "Multilingual Text Approved" stage
    static func createMultilingualStory(id: Int = 40) -> Story {
        Story(
            id: id,
            documentId: "doc-\(id)",
            title: "A Global Canvas",
            slug: "global-canvas",
            bodyMessage: "Art speaks every language, transcending borders and cultures.",
            excerpt: "Experience art from around the world in your native tongue.",
            image: createStoryMedia(id: 200, name: "world-art.jpg"),
            images: nil,
            audio: StoryAudio(
                english: "https://example.com/audio/en/global-canvas.mp3",
                spanish: "https://example.com/audio/es/global-canvas.mp3",
                hindi: "https://example.com/audio/hi/global-canvas.mp3"
            ),
            workflowStage: .multilingualTextApproved,
            visible: false,
            locale: "en",
            localizations: [
                StoryLocalization(id: 1, locale: "es", title: "Un Lienzo Global"),
                StoryLocalization(id: 2, locale: "hi", title: "एक वैश्विक कैनवास"),
                StoryLocalization(id: 3, locale: "fr", title: "Une Toile Mondiale")
            ],
            createdAt: Date().addingTimeInterval(-86400 * 3),
            updatedAt: Date().addingTimeInterval(-7200),
            publishedAt: nil,
            createdBy: createStoryAuthor(id: 2, name: "The Polyglot"),
            strapiAttributes: nil
        )
    }

    /// 🎉 Create a fully approved story - ready for the world!
    static func createApprovedStory(id: Int = 50) -> Story {
        Story(
            id: id,
            documentId: "doc-\(id)",
            title: "The Masterpiece Unveiled",
            slug: "masterpiece-unveiled",
            bodyMessage: """
            After months of restoration, the painting finally reveals its true colors. \
            Conservators discovered hidden layers beneath the surface, each telling a \
            story of its own. The artist's technique, revolutionary for its time, still \
            captivates modern audiences with its luminous quality and emotional depth.
            """,
            excerpt: "A masterpiece restored to its former glory, revealing secrets centuries old.",
            image: createStoryMedia(id: 300, name: "masterpiece.jpg"),
            images: [
                createStoryMedia(id: 301, name: "restoration-before.jpg"),
                createStoryMedia(id: 302, name: "restoration-after.jpg"),
                createStoryMedia(id: 303, name: "hidden-layers.jpg")
            ],
            audio: StoryAudio(
                english: "https://example.com/audio/en/masterpiece.mp3",
                spanish: "https://example.com/audio/es/masterpiece.mp3",
                hindi: "https://example.com/audio/hi/masterpiece.mp3"
            ),
            workflowStage: .approved,
            visible: true,
            locale: "en",
            localizations: [
                StoryLocalization(id: 10, locale: "es", title: "La Obra Maestra Revelada"),
                StoryLocalization(id: 11, locale: "hi", title: "उत्कृष्ट कृति का अनावरण")
            ],
            createdAt: Date().addingTimeInterval(-86400 * 30), // 30 days ago
            updatedAt: Date().addingTimeInterval(-86400), // Yesterday
            publishedAt: Date().addingTimeInterval(-3600), // 1 hour ago
            createdBy: createStoryAuthor(id: 1, name: "The Curator"),
            strapiAttributes: nil
        )
    }

    /// 📚 Create a collection of stories in different workflow stages
    /// Perfect for testing list views and filtering! 🎨
    static func createStoryCollection() -> [Story] {
        [
            createNewStory(id: 1),
            createEnglishApprovedStory(id: 2),
            createApprovedStory(id: 3)
        ]
    }

    /// 🌈 Create a diverse collection with all workflow stages represented
    static func createFullStageCollection() -> [Story] {
        [
            createStory(id: 1, title: "Just Created", stage: .created),
            createStory(id: 2, title: "English Text Ready", stage: .englishTextApproved),
            createStory(id: 3, title: "English Audio Ready", stage: .englishAudioApproved),
            createStory(id: 4, title: "English Complete", stage: .englishVersionApproved),
            createStory(id: 5, title: "Multilingual Text", stage: .multilingualTextApproved),
            createStory(id: 6, title: "Multilingual Audio", stage: .multilingualAudioApproved),
            createStory(id: 7, title: "Pending Review", stage: .pendingFinalReview),
            createStory(id: 8, title: "Approved Masterpiece", stage: .approved)
        ]
    }

    // MARK: - 🎨 Component Builders - Individual Parts

    /// 🖼️ Create a StoryMedia instance
    static func createStoryMedia(
        id: Int,
        name: String,
        alternativeText: String? = nil,
        width: Int = 1920,
        height: Int = 1080
    ) -> StoryMedia {
        StoryMedia(
            id: id,
            name: name,
            alternativeText: alternativeText ?? "A beautiful piece of art",
            caption: "Part of our enchanted collection",
            width: width,
            height: height,
            url: URL(string: "https://example.com/media/\(name)")!
        )
    }

    /// 🎵 Create a StoryAudio instance with English audio
    static func createStoryAudio(
        includeSpanish: Bool = false,
        includeHindi: Bool = false
    ) -> StoryAudio {
        StoryAudio(
            english: "https://example.com/audio/en/story.mp3",
            spanish: includeSpanish ? "https://example.com/audio/es/story.mp3" : nil,
            hindi: includeHindi ? "https://example.com/audio/hi/story.mp3" : nil
        )
    }

    /// 🌐 Create story localizations
    static func createLocalizations() -> [StoryLocalization] {
        [
            StoryLocalization(id: 1, locale: "es", title: "La Galería Encantada"),
            StoryLocalization(id: 2, locale: "hi", title: "जादुई गैलरी")
        ]
    }

    /// 👤 Create a story author
    static func createStoryAuthor(id: Int, name: String) -> StoryAuthor {
        StoryAuthor(id: id, name: name)
    }

    // MARK: - 🔧 Utilities

    /// 🔖 Generate a URL-friendly slug from a title
    private static func generateSlug(from title: String) -> String {
        title
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
            .replacingOccurrences(of: "[^a-z0-9\\s]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
    }
}

// MARK: - 🎭 Story Extensions for Testing

extension Story {
    /// 🎨 Create a modified copy with a different workflow stage
    /// Handy for testing state transitions! ✨
    func withStage(_ stage: WorkflowStage) -> Story {
        Story(
            id: self.id,
            documentId: self.documentId,
            title: self.title,
            slug: self.slug,
            bodyMessage: self.bodyMessage,
            excerpt: self.excerpt,
            image: self.image,
            images: self.images,
            audio: self.audio,
            workflowStage: stage,
            visible: self.visible,
            locale: self.locale,
            localizations: self.localizations,
            createdAt: self.createdAt,
            updatedAt: Date(), // Update timestamp
            publishedAt: stage == .approved ? Date() : nil,
            createdBy: self.createdBy,
            strapiAttributes: self.strapiAttributes
        )
    }

    /// 👁️ Create a modified copy with different visibility
    func withVisibility(_ visible: Bool) -> Story {
        Story(
            id: self.id,
            documentId: self.documentId,
            title: self.title,
            slug: self.slug,
            bodyMessage: self.bodyMessage,
            excerpt: self.excerpt,
            image: self.image,
            images: self.images,
            audio: self.audio,
            workflowStage: self.workflowStage,
            visible: visible,
            locale: self.locale,
            localizations: self.localizations,
            createdAt: self.createdAt,
            updatedAt: Date(),
            publishedAt: self.publishedAt,
            createdBy: self.createdBy,
            strapiAttributes: self.strapiAttributes
        )
    }
}
