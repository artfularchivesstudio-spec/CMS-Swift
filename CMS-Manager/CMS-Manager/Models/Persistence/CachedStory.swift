//
//  CachedStory.swift
//  CMS-Manager
//
//  💎 The Cached Story - Crystallized Wisdom for Offline Reading
//
//  "In the vault of local storage, stories rest like treasured artifacts,
//   waiting to enchant even when the network sleeps. Each cached tale
//   preserves the essence of its cloud-bound twin, a faithful mirror
//   ready to spring to life at a moment's notice."
//
//  - The Spellbinding Museum Director of Offline Persistence
//

import Foundation
import SwiftData
import ArtfulArchivesCore

// MARK: - 💎 Cached Story Model

/// 💎 A local copy of a Story for offline access
/// SwiftData model that mirrors the core Story structure with JSON-encoded complex fields
@Model
final class CachedStory {

    // MARK: - 🏺 Core Properties

    /// 🆔 Unique story identifier - ensures no duplicates in cache
    @Attribute(.unique) var id: Int

    /// 📄 Document ID from Strapi
    var documentId: String

    /// 📝 The story's title - what draws readers in
    var title: String

    /// 🔗 URL-friendly slug
    var slug: String

    /// 📜 The main content (markdown) - the heart of the tale
    var bodyMessage: String

    /// ✂️ Brief excerpt - the tantalizing preview
    var excerpt: String

    /// 👁️ Is this story visible to the public?
    var visible: Bool

    /// 🌐 Locale code (e.g., "en", "es")
    var locale: String?

    // MARK: - 🎨 Complex Properties (JSON-encoded)

    /// 🖼️ Main image data (JSON-encoded StoryMedia)
    var imageJSON: Data?

    /// 🖼️ Additional images (JSON-encoded [StoryMedia])
    var imagesJSON: Data?

    /// 🎵 Audio narrations (JSON-encoded StoryAudio)
    var audioJSON: Data?

    /// 🌐 Localizations (JSON-encoded [StoryLocalization])
    var localizationsJSON: Data?

    /// 👤 Author info (JSON-encoded StoryAuthor)
    var createdByJSON: Data?

    // MARK: - 🎭 Workflow Properties

    /// 🎭 Current workflow stage (raw string value)
    var workflowStageRaw: String

    // MARK: - 📅 Timestamps

    /// 📅 When the original story was created
    var createdAt: Date

    /// 🔄 When the original story was last updated
    var updatedAt: Date

    /// 🌟 When the original story was published
    var publishedAt: Date?

    /// 💾 When this story was cached locally
    var cachedAt: Date

    // MARK: - 🎭 Initialization

    /// 🌟 Create a cached story from a network Story
    init(from story: ArtfulArchivesCore.Story) {
        print("🔮 ✨ STORY CACHING RITUAL COMMENCES!")

        // Core properties - direct mapping
        self.id = story.id
        self.documentId = story.documentId
        self.title = story.title
        self.slug = story.slug
        self.bodyMessage = story.bodyMessage
        self.excerpt = story.excerpt
        self.visible = story.visible
        self.locale = story.locale
        self.workflowStageRaw = story.workflowStage.rawValue
        self.createdAt = story.createdAt
        self.updatedAt = story.updatedAt
        self.publishedAt = story.publishedAt
        self.cachedAt = Date()

        // 🎨 Complex properties - encode to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        // 🖼️ Encode main image
        if let image = story.image {
            self.imageJSON = try? encoder.encode(image)
            print("🖼️ Main image crystallized")
        }

        // 🖼️ Encode additional images
        if let images = story.images {
            self.imagesJSON = try? encoder.encode(images)
            print("🖼️ \(images.count) gallery images preserved")
        }

        // 🎵 Encode audio
        if let audio = story.audio {
            self.audioJSON = try? encoder.encode(audio)
            print("🎵 Audio narrations secured")
        }

        // 🌐 Encode localizations
        if let localizations = story.localizations {
            self.localizationsJSON = try? encoder.encode(localizations)
            print("🌐 \(localizations.count) translations archived")
        }

        // 👤 Encode author
        if let author = story.createdBy {
            self.createdByJSON = try? encoder.encode(author)
            print("👤 Author signature preserved")
        }

        print("💎 ✨ STORY CACHING MASTERPIECE COMPLETE! Story '\(title)' now immortalized")
    }

    // MARK: - 🔄 Conversion Back to Story

    /// 🔄 Convert cached story back to the network Story model
    /// Because sometimes you need to resurrect the full form from the crystallized essence
    func toStory() -> ArtfulArchivesCore.Story? {
        print("🔮 ✨ STORY RESURRECTION RITUAL AWAKENS!")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // 🖼️ Decode image
        let image: StoryMedia? = imageJSON.flatMap { try? decoder.decode(StoryMedia.self, from: $0) }

        // 🖼️ Decode images array
        let images: [StoryMedia]? = imagesJSON.flatMap { try? decoder.decode([StoryMedia].self, from: $0) }

        // 🎵 Decode audio
        let audio: StoryAudio? = audioJSON.flatMap { try? decoder.decode(StoryAudio.self, from: $0) }

        // 🌐 Decode localizations
        let localizations: [StoryLocalization]? = localizationsJSON.flatMap { try? decoder.decode([StoryLocalization].self, from: $0) }

        // 👤 Decode author
        let author: StoryAuthor? = createdByJSON.flatMap { try? decoder.decode(StoryAuthor.self, from: $0) }

        // 🎭 Parse workflow stage
        guard let workflowStage = WorkflowStage(rawValue: workflowStageRaw) else {
            print("🌩️ Failed to parse workflow stage: \(workflowStageRaw)")
            return nil
        }

        let resurrectedStory = ArtfulArchivesCore.Story(
            id: id,
            documentId: documentId,
            title: title,
            slug: slug,
            bodyMessage: bodyMessage,
            excerpt: excerpt,
            image: image,
            images: images,
            audio: audio,
            workflowStage: workflowStage,
            visible: visible,
            locale: locale,
            localizations: localizations,
            createdAt: createdAt,
            updatedAt: updatedAt,
            publishedAt: publishedAt,
            createdBy: author,
            strapiAttributes: nil // Not cached - rarely needed offline
        )

        print("🎉 ✨ STORY RESURRECTION MASTERPIECE COMPLETE! '\(title)' lives again")
        return resurrectedStory
    }

    // MARK: - 🌟 Computed Properties

    /// 🎭 Get the workflow stage enum
    var workflowStage: WorkflowStage? {
        WorkflowStage(rawValue: workflowStageRaw)
    }

    /// ⏰ How long ago was this cached? (for cache freshness checks)
    var cacheAge: TimeInterval {
        Date().timeIntervalSince(cachedAt)
    }

    /// 📊 Is this cache fresh? (less than 24 hours old)
    var isCacheFresh: Bool {
        cacheAge < 86400 // 24 hours in seconds
    }
}

// MARK: - 🧙‍♂️ Extensions

extension CachedStory {
    /// 🎨 Quick description for debugging - because even mystical objects need toString()
    var debugDescription: String {
        """
        💎 CachedStory {
            id: \(id)
            title: "\(title)"
            cached: \(cachedAt.formatted())
            age: \(Int(cacheAge / 3600))h
            fresh: \(isCacheFresh ? "✨" : "🌙")
        }
        """
    }
}
