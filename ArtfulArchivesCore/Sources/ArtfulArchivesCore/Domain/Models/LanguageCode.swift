/**
 * 🌐 The Language Code - The Universal Translator's Compass
 *
 * "Pointing the way to understanding across the digital realm,
 * where every story finds its voice in every tongue."
 *
 * - The Spellbinding Museum Director of Linguistic Arts
 */

import Foundation

// 🌐 The Language Code - Supporting our multilingual cosmos
public enum LanguageCode: String, Codable, CaseIterable, Equatable, Identifiable, Sendable {

    // MARK: - 🌟 Supported Languages

    /// 🇬🇧 English - The lingua franca of our digital museum
    case english = "en"

    /// 🇪🇸 Spanish - The romance of the Iberian Peninsula
    case spanish = "es"

    /// 🇮🇳 Hindi - The soul of the subcontinent
    case hindi = "hi"

    // MARK: - 🎨 Computed Properties

    /// 🎭 Unique identifier (the code itself)
    public var id: String {
        rawValue
    }

    /// 📜 Full language name in English
    public var name: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .hindi:
            return "Hindi"
        }
    }

    /// 🌍 Native language name
    public var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Español"
        case .hindi:
            return "हिन्दी"
        }
    }

    /// 🏳️ ISO country code for flag display
    public var countryCode: String {
        switch self {
        case .english:
            return "GB"
        case .spanish:
            return "ES"
        case .hindi:
            return "IN"
        }
    }

    /// 🎨 Emoji flag for this language
    public var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .spanish:
            return "🇪🇸"
        case .hindi:
            return "🇮🇳"
        }
    }

    /// 🎨 Direction of text (left-to-right or right-to-left)
    public var textDirection: TextDirection {
        switch self {
        case .english, .spanish, .hindi:
            return .leftToRight
        }
    }

    /// 🎙️ Default voice for TTS in this language
    public var defaultVoice: TTSVoice {
        TTSVoice.defaultVoice(for: self)
    }

    /// 🎭 All available voices for this language
    public var availableVoices: [TTSVoice] {
        TTSVoice.voicesForLanguage(self)
    }

    /// 🌐 Locale identifier for formatting
    public var localeIdentifier: String {
        switch self {
        case .english:
            return "en_US"
        case .spanish:
            return "es_ES"
        case .hindi:
            return "hi_IN"
        }
    }

    /// 📊 Whether this language is currently supported
    public var isSupported: Bool {
        true // All cases in this enum are supported
    }

    /// 🎯 Language family/group
    public var family: LanguageFamily {
        switch self {
        case .english:
            return .germanic
        case .spanish:
            return .romance
        case .hindi:
            return .indoAryan
        }
    }

    // MARK: - 🌙 Initialization from Raw Value

    /// 🎨 Create from string code
    public init?(code: String) {
        guard let language = LanguageCode(rawValue: code.lowercased()) else {
            return nil
        }
        self = language
    }

    /// 🌐 Create from locale identifier
    public init?(locale: String) {
        let code = locale.prefix(2).lowercased()
        self.init(rawValue: String(code))
    }
}

// MARK: - 📐 Text Direction

/// 📐 Direction in which text flows
public enum TextDirection: String, CaseIterable, Sendable {
    case leftToRight = "LTR"
    case rightToLeft = "RTL"

    public var isLeftToRight: Bool {
        self == .leftToRight
    }

    public var isRightToLeft: Bool {
        self == .rightToLeft
    }

    public var iconName: String {
        switch self {
        case .leftToRight: return "text.alignleft"
        case .rightToLeft: return "text.alignright"
        }
    }
}

// MARK: - 👨‍👩‍👧‍👦 Language Family

/// 👨‍👩‍👧‍👦 Linguistic groupings
public enum LanguageFamily: String, CaseIterable, Sendable {
    case germanic
    case romance
    case indoAryan

    public var displayName: String {
        switch self {
        case .germanic: return "Germanic"
        case .romance: return "Romance"
        case .indoAryan: return "Indo-Aryan"
        }
    }
}

// MARK: - 🌍 Language Metadata

/// 🌍 Extended information about a language
public struct LanguageMetadata: Equatable, Sendable {
    public let code: LanguageCode
    public let isRTL: Bool
    public let requiresIME: Bool
    public let characterSet: CharacterSet

    public init(
        code: LanguageCode,
        isRTL: Bool = false,
        requiresIME: Bool = false,
        characterSet: CharacterSet? = nil
    ) {
        self.code = code
        self.isRTL = isRTL
        self.requiresIME = requiresIME
        self.characterSet = characterSet ?? .decimalDigits
    }

    /// 🎨 Metadata for each language
    public static func metadata(for code: LanguageCode) -> LanguageMetadata {
        switch code {
        case .english:
            return LanguageMetadata(
                code: code,
                isRTL: false,
                requiresIME: false,
                characterSet: .letters
            )

        case .spanish:
            return LanguageMetadata(
                code: code,
                isRTL: false,
                requiresIME: false,
                characterSet: .letters
            )

        case .hindi:
            return LanguageMetadata(
                code: code,
                isRTL: false,
                requiresIME: true,
                characterSet: CharacterSet(charactersIn: "ऀ-ॿ")
            )
        }
    }
}

// MARK: - 🌐 Locale Extensions

/// 🌐 Locale-aware helpers
public extension LanguageCode {

    /// 📅 Date formatter for this language
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateStyle = .medium
        return formatter
    }

    /// ⏰ Time formatter for this language
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.timeStyle = .short
        return formatter
    }

    /// 💰 Number formatter for this language
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter
    }

    /// 📊 Format a date in this language
    func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    /// 💰 Format a number in this language
    func formatNumber(_ number: Double) -> String {
        numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// MARK: - 🌐 Language Preferences

/// 🌐 User language preferences
public struct LanguagePreferences: Codable, Equatable, Sendable {
    public let primary: LanguageCode
    public let secondary: [LanguageCode]
    public let autoTranslate: Bool
    public let autoDetect: Bool

    public init(
        primary: LanguageCode,
        secondary: [LanguageCode] = [],
        autoTranslate: Bool = false,
        autoDetect: Bool = true
    ) {
        self.primary = primary
        self.secondary = secondary
        self.autoTranslate = autoTranslate
        self.autoDetect = autoDetect
    }

    /// 🎭 All preferred languages
    public var allLanguages: [LanguageCode] {
        [primary] + secondary
    }

    /// 🌐 Check if a language is preferred
    func isPreferred(_ language: LanguageCode) -> Bool {
        language == primary || secondary.contains(language)
    }

    /// 📊 Default preferences
    public static let `default` = LanguagePreferences(
        primary: .english,
        secondary: [.spanish, .hindi],
        autoTranslate: false,
        autoDetect: true
    )
}

// MARK: - 🌐 Translation Pair

/// 🌐 A pair of languages for translation
public struct TranslationPair: Codable, Equatable, Sendable {
    public let source: LanguageCode
    public let target: LanguageCode

    public init(source: LanguageCode, target: LanguageCode) {
        self.source = source
        self.target = target
    }

    /// 🎭 Whether this is a valid translation pair
    public var isValid: Bool {
        source != target
    }

    /// 📜 Display string
    public var displayString: String {
        "\(source.nativeName) → \(target.nativeName)"
    }

    /// 🎯 Create bidirectional pairs
    public var reversed: TranslationPair {
        TranslationPair(source: target, target: source)
    }
}
