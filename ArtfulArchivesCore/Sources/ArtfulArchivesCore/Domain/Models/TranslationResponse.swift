/**
 * 🌐 The Translation Response - The Universal Polyglot
 *
 * "Breaking down the towers of Babel, one translation at a time,
 * bringing stories to every corner of the digital realm."
 *
 * - The Spellbinding Museum Director of Linguistic Arts
 */

import Foundation

// 🌐 The Translation Response - What we get after translating
public struct TranslationResponse: Codable, Equatable, Sendable {

    // MARK: - 🌟 Response Structure

    /// ✨ Whether the translation was successful
    public let success: Bool

    /// 📝 The translated content
    public let translatedContent: String?

    /// 🌩️ Error message (if failed)
    public let error: String?

    /// 🎯 The target language code
    public let targetLanguage: LanguageCode?

    // MARK: - 🎨 Computed Properties

    /// 🎭 Whether this response contains valid translation
    public var hasValidTranslation: Bool {
        success && translatedContent != nil && !translatedContent!.isEmpty
    }

    /// 📊 Word count of translated content
    public var wordCount: Int {
        guard let content = translatedContent else { return 0 }
        return content.split(separator: " ").count
    }

    // MARK: - 🌙 Initialization

    public init(
        success: Bool,
        translatedContent: String? = nil,
        error: String? = nil,
        targetLanguage: LanguageCode? = nil
    ) {
        self.success = success
        self.translatedContent = translatedContent
        self.error = error
        self.targetLanguage = targetLanguage
    }

    // MARK: - 🎭 Codable Support

    enum CodingKeys: String, CodingKey {
        case success
        case translatedContent = "translated_content"
        case error
        case targetLanguage = "target_language"
    }
}

// MARK: - 📤 Translation Request

/// 📤 Request for translating content
public struct TranslationRequest: Codable, Sendable {

    /// 📝 The content to translate
    public let content: String

    /// 🎯 The target language
    public let targetLanguage: LanguageCode

    /// 🌐 The source language (optional, will auto-detect)
    public let sourceLanguage: LanguageCode?

    /// 🎨 Optional context for better translation
    public let context: String?

    /// 📊 Whether to preserve formatting
    public let preserveFormatting: Bool

    public init(
        content: String,
        targetLanguage: LanguageCode,
        sourceLanguage: LanguageCode? = nil,
        context: String? = nil,
        preserveFormatting: Bool = true
    ) {
        self.content = content
        self.targetLanguage = targetLanguage
        self.sourceLanguage = sourceLanguage
        self.context = context
        self.preserveFormatting = preserveFormatting
    }

    /// 🎨 Default contexts for different content types
    public static func contextForContentType(_ type: ContentType) -> String {
        switch type {
        case .story:
            return "This is an artistic story about an artwork. Maintain poetic and descriptive language."

        case .title:
            return "This is a title for an artwork. Keep it concise and evocative."

        case .description:
            return "This is a detailed description of visual art. Use descriptive and sensory language."

        case .caption:
            return "This is a brief caption. Keep it short and engaging."

        case .tag:
            return "These are keywords/tags. Translate them individually, maintaining their meaning."
        }
    }
}

// MARK: - 📝 Content Type

/// 📝 Different types of content to translate
public enum ContentType: String, CaseIterable, Sendable {
    case story
    case title
    case description
    case caption
    case tag

    public var displayName: String {
        switch self {
        case .story: return "Story Content"
        case .title: return "Title"
        case .description: return "Description"
        case .caption: return "Caption"
        case .tag: return "Tags"
        }
    }
}

// MARK: - 🌐 Batch Translation Response

/// 🌐 Response for translating to multiple languages
public struct BatchTranslationResponse: Codable, Equatable, Sendable {
    public let translations: [TranslationResponse]
    public let sourceLanguage: LanguageCode
    public let targetLanguages: [LanguageCode]
    public let successCount: Int
    public let failureCount: Int

    public init(
        translations: [TranslationResponse],
        sourceLanguage: LanguageCode,
        targetLanguages: [LanguageCode]
    ) {
        self.translations = translations
        self.sourceLanguage = sourceLanguage
        self.targetLanguages = targetLanguages
        self.successCount = translations.filter { $0.success }.count
        self.failureCount = translations.filter { !$0.success }.count
    }

    /// 🎭 Whether all translations succeeded
    public var isCompleteSuccess: Bool {
        failureCount == 0
    }

    /// 📊 Get successful translations as dictionary
    public var successfulTranslations: [LanguageCode: String] {
        var result: [LanguageCode: String] = [:]
        for response in translations {
            if let success = response.translatedContent, let lang = response.targetLanguage {
                result[lang] = success
            }
        }
        return result
    }

    /// 🌩️ Get errors for failed translations
    public var errors: [LanguageCode: String] {
        var result: [LanguageCode: String] = [:]
        for response in translations {
            if let error = response.error, let lang = response.targetLanguage {
                result[lang] = error
            }
        }
        return result
    }
}

// MARK: - 📊 Translation Progress

/// 📊 Progress tracking for translation operations
public struct TranslationProgress: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let language: LanguageCode
    public var progress: Double // 0.0 to 1.0
    public var status: TranslationStatus

    public init(language: LanguageCode, progress: Double = 0.0, status: TranslationStatus = .pending) {
        self.language = language
        self.progress = progress
        self.status = status
    }

    /// 🎭 Whether this translation is complete
    public var isComplete: Bool {
        status == .completed
    }

    /// 🌙 Whether this translation is in progress
    public var isInProgress: Bool {
        status == .inProgress
    }

    /// 🌩️ Whether this translation failed
    public var hasFailed: Bool {
        status == .failed
    }
}

// MARK: - 📊 Translation Status

/// 📊 The current state of a translation
public enum TranslationStatus: String, Codable, Equatable, Sendable {
    case pending
    case inProgress = "in_progress"
    case completed
    case failed
    case cancelled

    public var displayName: String {
        switch self {
        case .pending: return "Waiting"
        case .inProgress: return "Translating..."
        case .completed: return "Complete"
        case .failed: return "Failed"
        case .cancelled: return "Cancelled"
        }
    }

    public var icon: String {
        switch self {
        case .pending: return "clock"
        case .inProgress: return "arrow.triangle.2.circlepath"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .cancelled: return "minus.circle"
        }
    }
}

// MARK: - 🌐 Language Context

/// 🌐 Additional context for better translations
public struct LanguageContext: Codable, Sendable {
    public let locale: String
    public let formalityLevel: FormalityLevel
    public let regionalVariant: String?

    public init(
        locale: String,
        formalityLevel: FormalityLevel = .neutral,
        regionalVariant: String? = nil
    ) {
        self.locale = locale
        self.formalityLevel = formalityLevel
        self.regionalVariant = regionalVariant
    }
}

// MARK: - 🎭 Formality Level

/// 🎭 How formal the translation should be
public enum FormalityLevel: String, CaseIterable, Codable, Sendable {
    case casual
    case neutral
    case formal

    public var displayName: String {
        switch self {
        case .casual: return "Casual"
        case .neutral: return "Neutral"
        case .formal: return "Formal"
        }
    }
}
