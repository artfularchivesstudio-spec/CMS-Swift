/**
 * 🎙️ The TTS Voice - The Digital Bards of Our Age
 *
 * "Where artificial intelligence meets thespian artistry,
 * bringing written word to life through synthesized sound."
 *
 * - The Spellbinding Museum Director of Auditory Arts
 */

import Foundation

// 🎙️ The TTS Voice enum is now defined in AudioGenerationResponse.swift
// This file provides additional extensions and helpers

// MARK: - 🎙️ Voice Extensions

public extension TTSVoice {

    // MARK: - 🎨 Voice Characteristics

    /// 📊 The pitch range of this voice (0.0 to 2.0, where 1.0 is normal)
    var pitchRange: ClosedRange<Double> {
        switch self {
        case .nova, .shimmer:
            return 0.9...1.2 // Female voices tend to be higher
        case .echo, .onyx:
            return 0.7...1.0 // Male voices tend to be lower
        case .alloy, .fable, .noa:
            return 0.8...1.1 // Neutral voices
        }
    }

    /// 🔊 Recommended speed range for this voice
    var recommendedSpeedRange: ClosedRange<Double> {
        switch self {
        case .nova, .shimmer:
            return 0.8...1.1 // Female voices sound good slightly slower
        case .echo, .onyx:
            return 0.9...1.2 // Male voices can handle faster speech
        case .alloy, .fable, .noa:
            return 0.85...1.15 // Balanced range
        }
    }

    /// 🎨 Voice quality/timbre description
    var timbre: VoiceTimbre {
        switch self {
        case .nova:
            return .bright
        case .alloy:
            return .balanced
        case .echo:
            return .deep
        case .fable:
            return .warm
        case .onyx:
            return .rich
        case .shimmer:
            return .gentle
        case .noa:
            return .mellow
        }
    }

    /// 🎭 Best use cases for this voice
    var bestUseCases: [VoiceUseCase] {
        switch self {
        case .nova:
            return [.storytelling, .narration, .general]
        case .alloy:
            return [.informational, .educational, .general]
        case .echo:
            return [.dramatic, .news, .documentary]
        case .fable:
            return [.storytelling, .britishContent, .cultural]
        case .onyx:
            return [.dramatic, .authoritative, .documentary]
        case .shimmer:
            return [.gentle, .children, .meditation]
        case .noa:
            return [.general, .informal, .conversational]
        }
    }

    /// ⚡ Energy level of this voice (0.0 to 1.0)
    var energyLevel: Double {
        switch self {
        case .nova:
            return 0.8 // Energetic and engaging
        case .shimmer:
            return 0.6 // Soft and gentle
        case .alloy:
            return 0.7 // Balanced
        case .fable:
            return 0.75 // Warm and inviting
        case .echo:
            return 0.65 // Steady and measured
        case .onyx:
            return 0.6 // Deep and resonant
        case .noa:
            return 0.7 // Neutral
        }
    }

    /// 🎨 Emotional range of this voice
    var emotionalRange: EmotionalRange {
        switch self {
        case .nova:
            return EmotionalRange(min: 0.6, max: 0.95)
        case .shimmer:
            return EmotionalRange(min: 0.3, max: 0.7)
        case .alloy:
            return EmotionalRange(min: 0.4, max: 0.8)
        case .fable:
            return EmotionalRange(min: 0.5, max: 0.85)
        case .echo:
            return EmotionalRange(min: 0.4, max: 0.75)
        case .onyx:
            return EmotionalRange(min: 0.3, max: 0.7)
        case .noa:
            return EmotionalRange(min: 0.4, max: 0.8)
        }
    }
}

// MARK: - 🎨 Voice Timbre

/// 🎨 The quality or color of the voice
public enum VoiceTimbre: String, CaseIterable, Sendable {
    case bright
    case balanced
    case deep
    case warm
    case rich
    case gentle
    case mellow

    public var displayName: String {
        switch self {
        case .bright: return "Bright"
        case .balanced: return "Balanced"
        case .deep: return "Deep"
        case .warm: return "Warm"
        case .rich: return "Rich"
        case .gentle: return "Gentle"
        case .mellow: return "Mellow"
        }
    }

    public var iconName: String {
        switch self {
        case .bright: return "sun.max.fill"
        case .balanced: return "scale.3d"
        case .deep: return "arrow.down.circle"
        case .warm: return "flame.fill"
        case .rich: return "sparkles"
        case .gentle: return "heart"
        case .mellow: return "moon.fill"
        }
    }
}

// MARK: - 🎯 Voice Use Case

/// 🎯 Best scenarios for using a voice
public enum VoiceUseCase: String, CaseIterable, Sendable {
    case storytelling
    case narration
    case informational
    case educational
    case dramatic
    case news
    case documentary
    case britishContent = "british_content"
    case cultural
    case gentle
    case children
    case meditation
    case authoritative
    case general
    case informal
    case conversational

    public var displayName: String {
        switch self {
        case .storytelling: return "Storytelling"
        case .narration: return "Narration"
        case .informational: return "Informational"
        case .educational: return "Educational"
        case .dramatic: return "Dramatic"
        case .news: return "News"
        case .documentary: return "Documentary"
        case .britishContent: return "British Content"
        case .cultural: return "Cultural"
        case .gentle: return "Gentle Content"
        case .children: return "Children's Content"
        case .meditation: return "Meditation"
        case .authoritative: return "Authoritative"
        case .general: return "General Purpose"
        case .informal: return "Informal"
        case .conversational: return "Conversational"
        }
    }

    public var iconName: String {
        switch self {
        case .storytelling: return "book.fill"
        case .narration: return "mic.fill"
        case .informational: return "info.circle.fill"
        case .educational: return "graduationcap.fill"
        case .dramatic: return "theatermasks.fill"
        case .news: return "newspaper.fill"
        case .documentary: return "film.fill"
        case .britishContent: return "crown.fill"
        case .cultural: return "globe"
        case .gentle: return "heart.fill"
        case .children: return "teddybear.fill"
        case .meditation: return "zzz"
        case .authoritative: return "person.crop.circle.fill"
        case .general: return "star.fill"
        case .informal: return "hand.wave.fill"
        case .conversational: return "message.fill"
        }
    }
}

// MARK: - 📊 Emotional Range

/// 📊 The emotional expressiveness of a voice
public struct EmotionalRange: Equatable, Sendable {
    public let min: Double
    public let max: Double

    public init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }

    /// 📊 The midpoint of this range
    public var midpoint: Double {
        (min + max) / 2.0
    }

    /// 📊 The span of this range
    public var span: Double {
        max - min
    }
}

// MARK: - 🎙️ Voice Selection Helper

/// 🎙️ Helper for selecting the right voice
public struct VoiceSelector {

    /// 🎯 Recommend a voice based on content and context
    public static func recommendVoice(
        for contentType: ContentType,
        language: LanguageCode,
        mood: ContentMood = .neutral
    ) -> TTSVoice {
        let availableVoices = TTSVoice.voicesForLanguage(language)

        // Default to first available if nothing else matches
        guard let baseVoice = availableVoices.first else {
            return TTSVoice.defaultVoice(for: language)
        }

        switch (contentType, mood) {
        case (.story, .dramatic):
            return availableVoices.first { $0.gender == .male && $0.timbre == .deep }
                ?? baseVoice

        case (.story, .gentle):
            return availableVoices.first { $0.gender == .female && $0.timbre == .gentle }
                ?? baseVoice

        case (.story, .energetic):
            return availableVoices.first { $0.energyLevel > 0.7 }
                ?? baseVoice

        case (.title, _):
            return availableVoices.first { $0.timbre == .bright || $0.timbre == .balanced }
                ?? baseVoice

        case (.description, _):
            return availableVoices.first { $0.timbre == .warm || $0.timbre == .balanced }
                ?? baseVoice

        default:
            return baseVoice
        }
    }

    /// 🎨 Find voices matching specific criteria
    public static func findVoices(
        language: LanguageCode,
        gender: VoiceGender? = nil,
        timbre: VoiceTimbre? = nil,
        minEnergy: Double? = nil
    ) -> [TTSVoice] {
        let voices = TTSVoice.voicesForLanguage(language)

        return voices.filter { voice in
            if let gender = gender, voice.gender != gender {
                return false
            }
            if let timbre = timbre, voice.timbre != timbre {
                return false
            }
            if let minEnergy = minEnergy, voice.energyLevel < minEnergy {
                return false
            }
            return true
        }
    }

    /// 🎯 Compare two voices
    public static func compare(_ voice1: TTSVoice, to voice2: TTSVoice) -> VoiceComparison {
        VoiceComparison(
            voice1: voice1,
            voice2: voice2,
            energyDifference: voice1.energyLevel - voice2.energyLevel,
            genderMatch: voice1.gender == voice2.gender,
            timbreSimilarity: voice1.timbre == voice2.timbre
        )
    }
}

// MARK: - 📊 Voice Comparison

/// 📊 Comparison between two voices
public struct VoiceComparison: Equatable, Sendable {
    public let voice1: TTSVoice
    public let voice2: TTSVoice
    public let energyDifference: Double
    public let genderMatch: Bool
    public let timbreSimilarity: Bool

    /// 🎭 Whether these voices are similar
    public var areSimilar: Bool {
        genderMatch && timbreSimilarity && abs(energyDifference) < 0.1
    }
}

// MARK: - 🎭 Content Mood

/// 🎭 The emotional tone of content
public enum ContentMood: String, CaseIterable, Sendable {
    case neutral
    case dramatic
    case gentle
    case energetic
    case melancholic
    case joyful
    case mysterious
    case urgent

    public var displayName: String {
        switch self {
        case .neutral: return "Neutral"
        case .dramatic: return "Dramatic"
        case .gentle: return "Gentle"
        case .energetic: return "Energetic"
        case .melancholic: return "Melancholic"
        case .joyful: return "Joyful"
        case .mysterious: return "Mysterious"
        case .urgent: return "Urgent"
        }
    }

    public var iconName: String {
        switch self {
        case .neutral: return "circle"
        case .dramatic: return "theatermasks"
        case .gentle: return "heart"
        case .energetic: return "bolt.fill"
        case .melancholic: return "cloud.rain.fill"
        case .joyful: return "sun.max.fill"
        case .mysterious: return "eye"
        case .urgent: return "exclamationmark.octagon.fill"
        }
    }
}

// MARK: - 🎙️ Voice Settings

/// 🎙️ Combined voice and audio settings
public struct VoiceSettings: Codable, Equatable, Sendable {
    public let voice: TTSVoice
    public let speed: Double
    public let pitch: Double?
    public let format: AudioFormat

    public init(
        voice: TTSVoice,
        speed: Double = 0.9,
        pitch: Double? = nil,
        format: AudioFormat = .mp3
    ) {
        self.voice = voice
        self.speed = speed
        self.pitch = pitch
        self.format = format
    }

    /// 🎨 Validate settings
    public var isValid: Bool {
        speed >= 0.25 && speed <= 4.0
    }

    /// 📊 Default settings for a language
    public static func `default`(for language: LanguageCode) -> VoiceSettings {
        VoiceSettings(
            voice: TTSVoice.defaultVoice(for: language),
            speed: 0.9,
            pitch: nil,
            format: .mp3
        )
    }

    /// 🎯 Optimized settings for a content type
    public static func optimized(
        for contentType: ContentType,
        language: LanguageCode
    ) -> VoiceSettings {
        let voice = VoiceSelector.recommendVoice(
            for: contentType,
            language: language
        )

        let speed: Double
        switch contentType {
        case .story, .description:
            speed = 0.9 // Slightly slower for narrative
        case .title:
            speed = 0.95 // Almost normal for titles
        case .caption, .tag:
            speed = 1.0 // Normal for brief content
        }

        return VoiceSettings(
            voice: voice,
            speed: speed,
            pitch: nil,
            format: .mp3
        )
    }
}

// MARK: - 📊 Voice Analytics

/// 📊 Analytics about voice usage
public struct VoiceAnalytics: Equatable, Sendable {
    public let voice: TTSVoice
    public let usageCount: Int
    public let averageDuration: TimeInterval
    public let successRate: Double
    public let lastUsed: Date?

    public init(
        voice: TTSVoice,
        usageCount: Int,
        averageDuration: TimeInterval,
        successRate: Double,
        lastUsed: Date? = nil
    ) {
        self.voice = voice
        self.usageCount = usageCount
        self.averageDuration = averageDuration
        self.successRate = successRate
        self.lastUsed = lastUsed
    }

    /// 🎭 Whether this voice is reliable
    public var isReliable: Bool {
        successRate > 0.9 && usageCount > 5
    }
}
