/**
 * 🔍 The Image Analysis Response - The Oracle's Vision
 *
 * "When the digital mystics gaze upon your artwork,
 * they reveal its soul in title, tale, and tags."
 *
 * - The Spellbinding Museum Director of Computer Vision
 */

import Foundation

// 🔍 The Image Analysis Response - What OpenAI sees
public struct ImageAnalysisResponse: Codable, Equatable, Sendable {

    // MARK: - 🌟 Response Structure

    /// ✨ Whether the analysis was successful
    public let success: Bool

    /// 📊 The analyzed data (if successful)
    public let data: AnalysisData?

    /// 🌩️ Error message (if failed)
    public let error: String?

    // MARK: - 🎨 Computed Properties

    /// 🎭 Whether this response contains valid data
    public var hasValidData: Bool {
        success && data != nil
    }

    // MARK: - 🌙 Initialization

    public init(success: Bool, data: AnalysisData? = nil, error: String? = nil) {
        self.success = success
        self.data = data
        self.error = error
    }
}

// MARK: - 📊 Analysis Data

/// 📊 The insights extracted from an image
public struct AnalysisData: Codable, Equatable, Sendable {

    // MARK: - 📝 Content Fields

    /// ✨ The suggested title for the artwork
    public let title: String

    /// 📖 The generated story/description
    public let content: String

    /// 🏷️ Suggested tags for categorization
    public let tags: [String]

    /// 🎨 Additional metadata (optional)
    public let style: String?
    public let mood: String?
    public let medium: String?
    public let colors: [String]?

    // MARK: - 🎨 Computed Properties

    /// 📋 Tags as a comma-separated string
    public var tagsString: String {
        tags.joined(separator: ", ")
    }

    /// 🎨 Primary tag (first one)
    public var primaryTag: String? {
        tags.first
    }

    /// 📊 Word count of the content
    public var wordCount: Int {
        content.split(separator: " ").count
    }

    /// 🎭 Whether the analysis is complete
    public var isComplete: Bool {
        !title.isEmpty && !content.isEmpty && !tags.isEmpty
    }

    // MARK: - 🌙 Initialization

    public init(
        title: String,
        content: String,
        tags: [String],
        style: String? = nil,
        mood: String? = nil,
        medium: String? = nil,
        colors: [String]? = nil
    ) {
        self.title = title
        self.content = content
        self.tags = tags
        self.style = style
        self.mood = mood
        self.medium = medium
        self.colors = colors
    }

    // MARK: - 🎭 Codable Support

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case tags
        case style
        case mood
        case medium
        case colors
    }
}

// MARK: - 📤 Image Analysis Request

/// 📤 Request for analyzing an image
public struct ImageAnalysisRequest: Codable, Sendable {

    /// 🖼️ The URL of the image to analyze
    public let imageUrl: String

    /// 📝 Optional custom prompt for analysis
    public let prompt: String?

    /// 🎯 Optional focus area (e.g., "style", "subject", "colors")
    public let focusArea: String?

    /// 📊 Whether to include detailed metadata
    public let includeMetadata: Bool

    public init(
        imageUrl: String,
        prompt: String? = nil,
        focusArea: String? = nil,
        includeMetadata: Bool = true
    ) {
        self.imageUrl = imageUrl
        self.prompt = prompt
        self.focusArea = focusArea
        self.includeMetadata = includeMetadata
    }

    /// 🎨 Default prompts for different analysis types
    public static func promptForAnalysisType(_ type: AnalysisType) -> String {
        switch type {
        case .general:
            return "Analyze this artwork and provide a title, a detailed description (2-3 paragraphs), and 5-7 relevant tags."

        case .artistic:
            return "Focus on the artistic style, techniques used, medium, and visual elements. Provide a creative title and artistic description."

        case .storytelling:
            return "Create an engaging story inspired by this artwork. Provide a title, narrative content, and thematic tags."

        case .accessibility:
            return "Describe this artwork in detail for accessibility purposes. Include visual elements, colors, composition, and mood."
        }
    }
}

// MARK: - 🎯 Analysis Type

/// 🎯 Different ways to analyze an image
public enum AnalysisType: String, CaseIterable, Sendable {
    case general
    case artistic
    case storytelling
    case accessibility

    public var displayName: String {
        switch self {
        case .general: return "General Analysis"
        case .artistic: return "Artistic Focus"
        case .storytelling: return "Storytelling Mode"
        case .accessibility: return "Accessibility Description"
        }
    }

    public var icon: String {
        switch self {
        case .general: return "photo"
        case .artistic: return "paintbrush"
        case .storytelling: return "book"
        case .accessibility: return "eye"
        }
    }
}

// MARK: - 🎨 Analysis Confidence

/// 🎨 Confidence scores for analysis results
public struct AnalysisConfidence: Codable, Equatable, Sendable {
    public let titleScore: Double
    public let contentScore: Double
    public let tagScore: Double

    public var averageScore: Double {
        (titleScore + contentScore + tagScore) / 3.0
    }

    public var isHighConfidence: Bool {
        averageScore >= 0.7
    }

    public init(titleScore: Double, contentScore: Double, tagScore: Double) {
        self.titleScore = titleScore
        self.contentScore = contentScore
        self.tagScore = tagScore
    }
}

// MARK: - 📊 Batch Analysis Response

/// 📊 Response for analyzing multiple images
public struct BatchImageAnalysisResponse: Codable, Equatable, Sendable {
    public let analyses: [ImageAnalysisResponse]
    public let successCount: Int
    public let failureCount: Int

    public init(analyses: [ImageAnalysisResponse]) {
        self.analyses = analyses
        self.successCount = analyses.filter { $0.success }.count
        self.failureCount = analyses.filter { !$0.success }.count
    }

    /// 🎭 Whether all analyses succeeded
    public var isCompleteSuccess: Bool {
        failureCount == 0
    }

    /// 📊 Get successful analyses only
    public var successfulAnalyses: [AnalysisData] {
        analyses.compactMap { $0.data }
    }
}
