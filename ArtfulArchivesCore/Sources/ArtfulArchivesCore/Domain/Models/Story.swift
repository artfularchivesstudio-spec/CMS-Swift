/**
 * 🎭 The Story - The Chronicles of Our Digital Museum
 *
 * "Behold, the Story - where image and text dance together in mystical harmony,
 * capturing the essence of artistic vision across languages and media."
 *
 * - The Spellbinding Museum Director of Domain Models
 */

import Foundation

// 🎭 The Story - A complete tale of image, text, and audio
public struct Story: Codable, Identifiable, Equatable, Sendable {

    // MARK: - 🌟 Core Identity

    /// 🎭 The unique identifier from Strapi
    public let id: Int

    /// 📜 The document ID for i18n tracking
    public let documentId: String

    // MARK: - 📝 Content Fields

    /// ✨ The title that captures attention
    public let title: String

    /// 🌿 The SEO-friendly URL path
    public let slug: String

    /// 📖 The main story body (rich text)
    public let bodyMessage: String

    /// 💎 A brief preview of the tale
    public let excerpt: String

    // MARK: - 🎨 Media Fields

    /// 🖼️ The featured image from Strapi Media Library
    public let image: StoryMedia?

    /// 🖼️ All images in the story's gallery
    public let images: [StoryMedia]?

    /// 🎵 Audio versions in multiple languages
    public let audio: StoryAudio?

    // MARK: - 🎭 Workflow State

    /// 🎪 The current stage in the content lifecycle
    public let workflowStage: WorkflowStage

    /// 👁️ Whether this story is visible to the public
    public let visible: Bool

    // MARK: - 🌐 Localization

    /// 🗺️ The locale code (en, es, hi, etc.)
    public let locale: String?

    /// 📚 The localizations of this story (other language versions)
    public let localizations: [StoryLocalization]?

    // MARK: - 📅 Timestamps

    /// 🎨 When the story was first created
    public let createdAt: Date

    /// ✏️ When the story was last modified
    public let updatedAt: Date

    /// 📅 When the story was published (optional)
    public let publishedAt: Date?

    // MARK: - 🔗 Relations

    /// 👤 The author who created this masterpiece
    public let createdBy: StoryAuthor?

    /// 📝 The Strapi metadata
    public let strapiAttributes: StrapiAttributes?

    // MARK: - 🎨 Computed Properties

    /// 🎭 Display name with title and status
    public var displayName: String {
        "\(title) (\(workflowStage.displayName))"
    }

    /// 🌿 Full URL path for sharing
    public var webURL: String {
        "/stories/\(slug)"
    }

    /// 🎨 Image URL for preview
    public var previewImageURL: URL? {
        image?.url
    }

    /// 📊 Progress through workflow stages
    public var workflowProgress: Double {
        WorkflowStage.allCases.firstIndex(of: workflowStage).map {
            Double($0) / Double(WorkflowStage.allCases.count - 1)
        } ?? 0.0
    }

    /// 🎭 Whether this story is ready for publishing
    public var isReadyToPublish: Bool {
        workflowStage == .approved && visible
    }

    // MARK: - 🌙 Initialization

    public init(
        id: Int,
        documentId: String,
        title: String,
        slug: String,
        bodyMessage: String,
        excerpt: String,
        image: StoryMedia?,
        images: [StoryMedia]?,
        audio: StoryAudio?,
        workflowStage: WorkflowStage,
        visible: Bool,
        locale: String? = nil,
        localizations: [StoryLocalization]?,
        createdAt: Date,
        updatedAt: Date,
        publishedAt: Date?,
        createdBy: StoryAuthor?,
        strapiAttributes: StrapiAttributes?
    ) {
        self.id = id
        self.documentId = documentId
        self.title = title
        self.slug = slug
        self.bodyMessage = bodyMessage
        self.excerpt = excerpt
        self.image = image
        self.images = images
        self.audio = audio
        self.workflowStage = workflowStage
        self.visible = visible
        self.locale = locale
        self.localizations = localizations
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
        self.createdBy = createdBy
        self.strapiAttributes = strapiAttributes
    }

    // MARK: - 🎭 Codable Support

    enum CodingKeys: String, CodingKey {
        case id
        case documentId = "document_id"
        case title
        case slug
        case bodyMessage = "body_message"
        case excerpt
        case image
        case images
        case audio
        case workflowStage = "workflow_stage"
        case visible
        case locale
        case localizations
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case createdBy = "created_by"
        case strapiAttributes
    }
}

// MARK: - 🖼️ Story Media

/// 🖼️ The media attached to a story
public struct StoryMedia: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let alternativeText: String?
    public let caption: String?
    public let width: Int?
    public let height: Int?
    public let url: URL
    public let mime: String?
    public let size: Double? // File size in bytes

    public var displayName: String {
        alternativeText ?? name
    }

    public init(
        id: Int,
        name: String,
        alternativeText: String? = nil,
        caption: String? = nil,
        width: Int? = nil,
        height: Int? = nil,
        url: URL,
        mime: String? = nil,
        size: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.alternativeText = alternativeText
        self.caption = caption
        self.width = width
        self.height = height
        self.url = url
        self.mime = mime
        self.size = size
    }
}

// MARK: - 🎵 Story Audio

/// 🎵 The audio tracks for multilingual storytelling
public struct StoryAudio: Codable, Equatable, Sendable {
    public let english: String? // URL to English audio
    public let spanish: String? // URL to Spanish audio
    public let hindi: String? // URL to Hindi audio

    /// 🎵 Get audio URL for a specific language
    public func audioURL(for language: LanguageCode) -> String? {
        switch language {
        case .english: return english
        case .spanish: return spanish
        case .hindi: return hindi
        }
    }

    public init(english: String? = nil, spanish: String? = nil, hindi: String? = nil) {
        self.english = english
        self.spanish = spanish
        self.hindi = hindi
    }
}

// MARK: - 🌐 Story Localization

/// 🌐 Links to other language versions of this story
public struct StoryLocalization: Codable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let locale: String
    public let title: String

    public init(id: Int, locale: String, title: String) {
        self.id = id
        self.locale = locale
        self.title = title
    }
}

// MARK: - 👤 Story Author

/// 👤 The creator of a story
public struct StoryAuthor: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let email: String?

    public init(id: Int, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: - 🎨 Strapi Attributes

/// 🎨 Additional Strapi metadata
public struct StrapiAttributes: Codable, Equatable, Sendable {
    public let publishedAt: Date?
    public let createdBy: StoryAuthor?
    public let updatedBy: StoryAuthor?

    public init(publishedAt: Date? = nil, createdBy: StoryAuthor? = nil, updatedBy: StoryAuthor? = nil) {
        self.publishedAt = publishedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
    }
}

// MARK: - 🎭 Story Response (API Wrapper)

/// 🎭 The API response wrapper for stories
public struct StoryResponse: Codable, Equatable, Sendable {
    public let story: Story
    public let savedPostId: Int?

    public init(story: Story, savedPostId: Int? = nil) {
        self.story = story
        self.savedPostId = savedPostId
    }
}

// MARK: - 📝 Story Create Request

/// 📝 Request body for creating a new story
public struct StoryCreateRequest: Codable, Sendable {
    public let title: String
    public let content: String
    public let imageId: Int?
    public let imageUrl: String?
    public let audioDuration: Int?
    public let workflowStage: WorkflowStage?
    public let visible: Bool?

    public init(
        title: String,
        content: String,
        imageId: Int? = nil,
        imageUrl: String? = nil,
        audioDuration: Int? = nil,
        workflowStage: WorkflowStage = .created,
        visible: Bool = false
    ) {
        self.title = title
        self.content = content
        self.imageId = imageId
        self.imageUrl = imageUrl
        self.audioDuration = audioDuration
        self.workflowStage = workflowStage
        self.visible = visible
    }
}

// MARK: - ✏️ Story Update Request

/// ✏️ Request body for updating a story
public struct StoryUpdateRequest: Codable, Sendable {
    public let title: String?
    public let content: String?
    public let imageId: Int?
    public let workflowStage: WorkflowStage?
    public let visible: Bool?

    public init(
        title: String? = nil,
        content: String? = nil,
        imageId: Int? = nil,
        workflowStage: WorkflowStage? = nil,
        visible: Bool? = nil
    ) {
        self.title = title
        self.content = content
        self.imageId = imageId
        self.workflowStage = workflowStage
        self.visible = visible
    }
}
