/**
 * 🔊 The Audio Generation Response - The Voice of the Muse
 *
 * "When text transcends the silent page and becomes sound,
 * the TTS oracle weaves spoken word from pure imagination."
 *
 * - The Spellbinding Museum Director of Auditory Arts
 */

import Foundation

// 🔊 The Audio Generation Response - What we get after generating audio
public struct AudioGenerationResponse: Codable, Equatable, Sendable {

    // MARK: - 🌟 Response Structure

    /// ✨ Whether the generation was successful
    public let success: Bool

    /// 🔗 The URL to the generated audio file
    public let audioUrl: String?

    /// 🌩️ Error message (if failed)
    public let error: String?

    /// 🎯 The language of the generated audio
    public let language: LanguageCode?

    /// 🎙️ The voice used
    public let voice: TTSVoice?

    /// ⏱️ Duration in seconds (optional, may not be available immediately)
    public let duration: Double?

    // MARK: - 🎨 Computed Properties

    /// 🎭 Whether this response contains valid audio
    public var hasValidAudio: Bool {
        success && audioUrl != nil && !audioUrl!.isEmpty
    }

    /// 🌐 Convert string URL to URL type
    public var audioURL: URL? {
        guard let urlString = audioUrl else { return nil }

        // Handle data URLs
        if urlString.hasPrefix("data:") {
            return URL(string: urlString)
        }

        // Handle regular URLs
        return URL(string: urlString)
    }

    /// 📊 Format duration as time string
    public var durationFormatted: String {
        guard let duration = duration else { return "--:--" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - 🌙 Initialization

    public init(
        success: Bool,
        audioUrl: String? = nil,
        error: String? = nil,
        language: LanguageCode? = nil,
        voice: TTSVoice? = nil,
        duration: Double? = nil
    ) {
        self.success = success
        self.audioUrl = audioUrl
        self.error = error
        self.language = language
        self.voice = voice
        self.duration = duration
    }

    // MARK: - 🎭 Codable Support

    enum CodingKeys: String, CodingKey {
        case success
        case audioUrl = "audio_url"
        case error
        case language
        case voice
        case duration
    }
}

// MARK: - 📤 Audio Generation Request

/// 📤 Request for generating audio from text
public struct AudioGenerationRequest: Codable, Sendable {

    /// 📝 The text to convert to speech
    public let text: String

    /// 🎯 The language of the text
    public let language: LanguageCode

    /// 🎙️ The voice to use
    public let voice: TTSVoice?

    /// ⚡ The speed of speech (0.25 to 4.0, default 1.0)
    public let speed: Double

    /// 🎨 Optional audio format
    public let format: AudioFormat

    public init(
        text: String,
        language: LanguageCode,
        voice: TTSVoice? = nil,
        speed: Double = 0.9,
        format: AudioFormat = .mp3
    ) {
        self.text = text
        self.language = language
        self.voice = voice ?? TTSVoice.defaultVoice(for: language)
        self.speed = speed
        self.format = format
    }

    /// 🎨 Validate request parameters
    public var isValid: Bool {
        !text.isEmpty && speed >= 0.25 && speed <= 4.0
    }

    /// 📊 Estimated duration based on word count
    public var estimatedDuration: Double {
        let wordCount = Double(text.split(separator: " ").count)
        let wordsPerSecond = 2.5 * speed // Average speaking rate
        return wordCount / wordsPerSecond
    }
}

// MARK: - 🎙️ TTS Voice

/// 🎙️ Available text-to-speech voices
public enum TTSVoice: String, CaseIterable, Codable, Equatable, Sendable, Identifiable {
    // English voices
    case nova
    case alloy
    case echo
    case fable
    case onyx
    case shimmer

    // Spanish voices
    case noa // Actually "nova" but different pronunciation

    // Hindi voices

    public var displayName: String {
        switch self {
        case .nova: return "Nova (Female, English)"
        case .alloy: return "Alloy (Neutral, English)"
        case .echo: return "Echo (Male, English)"
        case .fable: return "Fable (British, English)"
        case .onyx: return "Onyx (Deep Male, English)"
        case .shimmer: return "Shimmer (Soft Female, English)"
        case .noa: return "Noa (Spanish)"
        }
    }

    public var gender: VoiceGender {
        switch self {
        case .nova, .shimmer: return .female
        case .echo, .onyx: return .male
        case .alloy, .fable, .noa: return .neutral
        }
    }

    public var language: LanguageCode {
        switch self {
        case .nova, .alloy, .echo, .fable, .onyx, .shimmer: return .english
        case .noa: return .spanish
        }
    }

    /// 🎨 Default voice for a language
    public static func defaultVoice(for language: LanguageCode) -> TTSVoice {
        switch language {
        case .english: return .nova
        case .spanish: return .noa
        case .hindi: return .alloy // Fallback
        }
    }

    /// 🎙️ All voices for a language
    public static func voicesForLanguage(_ language: LanguageCode) -> [TTSVoice] {
        switch language {
        case .english:
            return [.nova, .alloy, .echo, .fable, .onyx, .shimmer]
        case .spanish:
            return [.noa]
        case .hindi:
            return [.alloy] // Fallback
        }
    }
}

// MARK: - 👥 Voice Gender

/// 👥 The gender presentation of a voice
public enum VoiceGender: String, CaseIterable, Sendable {
    case male
    case female
    case neutral

    public var icon: String {
        switch self {
        case .male: return "person.fill"
        case .female: return "person.fill"
        case .neutral: return "person.2.fill"
        }
    }
}

// MARK: - 🎵 Audio Format

/// 🎵 Supported audio formats
public enum AudioFormat: String, CaseIterable, Codable, Sendable {
    case mp3
    case opus
    case aac
    case flac

    public var fileExtension: String {
        rawValue
    }

    public var mimeType: String {
        switch self {
        case .mp3: return "audio/mpeg"
        case .opus: return "audio/opus"
        case .aac: return "audio/aac"
        case .flac: return "audio/flac"
        }
    }

    public var displayName: String {
        rawValue.uppercased()
    }
}

// MARK: - 📊 Batch Audio Generation Response

/// 📊 Response for generating audio in multiple languages
public struct BatchAudioGenerationResponse: Codable, Equatable, Sendable {
    public let audioFiles: [AudioGenerationResponse]
    public let successCount: Int
    public let failureCount: Int
    public let totalDuration: Double

    public init(audioFiles: [AudioGenerationResponse]) {
        self.audioFiles = audioFiles
        self.successCount = audioFiles.filter { $0.success }.count
        self.failureCount = audioFiles.filter { !$0.success }.count
        self.totalDuration = audioFiles.compactMap { $0.duration }.reduce(0, +)
    }

    /// 🎭 Whether all generations succeeded
    public var isCompleteSuccess: Bool {
        failureCount == 0
    }

    /// 📊 Get successful audio URLs as dictionary
    public var successfulAudioURLs: [LanguageCode: String] {
        var result: [LanguageCode: String] = [:]
        for response in audioFiles {
            if let url = response.audioUrl, let lang = response.language {
                result[lang] = url
            }
        }
        return result
    }

    /// 🌩️ Get errors for failed generations
    public var errors: [LanguageCode: String] {
        var result: [LanguageCode: String] = [:]
        for response in audioFiles {
            if let error = response.error, let lang = response.language {
                result[lang] = error
            }
        }
        return result
    }
}

// MARK: - 📊 Audio Generation Progress

/// 📊 Progress tracking for audio generation
public struct AudioGenerationProgress: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let language: LanguageCode
    public var progress: Double // 0.0 to 1.0
    public var status: AudioGenerationStatus
    public var currentDuration: Double?

    public init(
        language: LanguageCode,
        progress: Double = 0.0,
        status: AudioGenerationStatus = .pending,
        currentDuration: Double? = nil
    ) {
        self.language = language
        self.progress = progress
        self.status = status
        self.currentDuration = currentDuration
    }

    /// 🎭 Whether this generation is complete
    public var isComplete: Bool {
        status == .completed
    }

    /// 🌙 Whether this generation is in progress
    public var isInProgress: Bool {
        status == .inProgress
    }

    /// 🌩️ Whether this generation failed
    public var hasFailed: Bool {
        status == .failed
    }
}

// MARK: - 📊 Audio Generation Status

/// 📊 The current state of audio generation
public enum AudioGenerationStatus: String, Codable, Equatable, Sendable {
    case pending
    case inProgress = "in_progress"
    case processing
    case completed
    case failed
    case cancelled

    public var displayName: String {
        switch self {
        case .pending: return "Waiting"
        case .inProgress: return "Generating..."
        case .processing: return "Processing..."
        case .completed: return "Complete"
        case .failed: return "Failed"
        case .cancelled: return "Cancelled"
        }
    }

    public var icon: String {
        switch self {
        case .pending: return "clock"
        case .inProgress, .processing: return "waveform"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .cancelled: return "minus.circle"
        }
    }
}

// MARK: - 🎵 Audio Metadata

/// 🎵 Additional metadata about generated audio
public struct AudioMetadata: Codable, Equatable, Sendable {
    public let duration: Double
    public let sampleRate: Int
    public let channels: Int
    public let bitrate: Int?
    public let fileSize: Int?

    public init(
        duration: Double,
        sampleRate: Int = 24000,
        channels: Int = 1,
        bitrate: Int? = nil,
        fileSize: Int? = nil
    ) {
        self.duration = duration
        self.sampleRate = sampleRate
        self.channels = channels
        self.bitrate = bitrate
        self.fileSize = fileSize
    }

    /// 📊 Format duration as time string
    public var durationFormatted: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// 📊 File size in human-readable format
    public var fileSizeFormatted: String {
        guard let size = fileSize else { return "Unknown" }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
}

// MARK: - TTSVoice + Identifiable
extension TTSVoice {
    public var id: String { rawValue }
}
