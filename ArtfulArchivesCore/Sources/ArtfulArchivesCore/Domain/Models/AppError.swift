/**
 * 🌩️ The App Error - When Our Magical Realm Encounters Turbulence
 *
 * "Not all who wander are lost, but some encounter errors along the way.
 * Fear not, for every error has a remedy, and every storm passes."
 *
 * - The Spellbinding Museum Director of Error Management
 */

import Foundation

// 🌩️ The App Error - The taxonomy of all that can go awry
public enum AppError: LocalizedError, Identifiable, Equatable, Sendable {

    // MARK: - 🌐 Network Errors

    /// 📡 When the digital realm is unreachable
    case network(NetworkError)

    // MARK: - 🎭 API Errors

    /// 🎪 When the backend API encounters issues
    case api(APIError)

    // MARK: - ✏️ Validation Errors

    /// 🎨 When the input doesn't meet our artistic standards
    case validation(ValidationError)

    // MARK: - 💾 Storage Errors

    /// 🗄️ When persistence fails
    case storage(StorageError)

    // MARK: - 🎬 Audio Errors

    /// 🔊 When sound generation encounters issues
    case audio(AudioError)

    // MARK: - 🌐 Translation Errors

    /// 🗣️ When language barriers prove too thick
    case translation(TranslationError)

    // MARK: - 🖼️ Media Errors

    /// 📸 When images misbehave
    case media(MediaError)

    // MARK: - 🔐 Authentication Errors

    /// 🔑 When access is denied
    case authentication(AuthError)

    // MARK: - 🌙 Unknown Errors

    /// ❓ When mystery strikes
    case unknown(Error)

    // MARK: - 🎨 Computed Properties

    /// 🎭 Unique identifier for this error
    public var id: String {
        localizedDescription
    }

    /// 📜 Human-readable description
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .api(let error):
            return error.localizedDescription
        case .validation(let error):
            return error.localizedDescription
        case .storage(let error):
            return error.localizedDescription
        case .audio(let error):
            return error.localizedDescription
        case .translation(let error):
            return error.localizedDescription
        case .media(let error):
            return error.localizedDescription
        case .authentication(let error):
            return error.localizedDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    /// 💡 Suggested recovery action
    public var recoverySuggestion: String? {
        switch self {
        case .network(.noConnection):
            return "Check your internet connection and try again"
        case .network(.timeout):
            return "The request timed out. Please try again"
        case .api(.unauthorized):
            return "Please sign in again"
        case .api(.rateLimited):
            return "Too many requests. Please wait a moment"
        case .api(.serverError(let code)):
            return "Server error (\(code)). Please try again later"
        case .validation(.emptyInput):
            return "Please provide the required information"
        case .validation(.invalidURL):
            return "The URL format is incorrect"
        case .storage(.diskFull):
            return "Free up some space and try again"
        case .authentication(.tokenExpired):
            return "Your session has expired. Please sign in again"
        case .translation(.unsupportedLanguage):
            return "This language is not supported yet"
        case .media(.invalidFileType):
            return "Please select a valid image file"
        default:
            return "Please try again"
        }
    }

    /// 🎨 SF Symbol icon for this error
    public var icon: String {
        switch self {
        case .network:
            return "wifi.slash"
        case .api(.unauthorized):
            return "lock.shield"
        case .api(.serverError):
            return "server.rack"
        case .api(.notFound):
            return "magnifyingglass"
        case .validation:
            return "exclamationmark.bubble"
        case .storage:
            return "externaldrive.badge.xmark"
        case .audio:
            return "speaker.slash"
        case .translation:
            return "globe.americas"
        case .media:
            return "photo.badge.exclamationmark"
        case .authentication:
            return "lock.badge.exclamationmark"
        default:
            return "exclamationmark.triangle"
        }
    }

    /// 🎨 Color theme for this error
    public var color: ErrorColor {
        switch self {
        case .network:
            return .orange
        case .api:
            return .red
        case .validation:
            return .yellow
        case .storage:
            return .purple
        case .audio:
            return .pink
        case .translation:
            return .blue
        case .media:
            return .indigo
        case .authentication:
            return .red
        default:
            return .gray
        }
    }

    /// 🎭 Whether this error is recoverable
    public var isRecoverable: Bool {
        switch self {
        case .network, .api, .translation, .media:
            return true
        case .validation, .authentication:
            return false
        case .storage, .audio, .unknown:
            return true
        }
    }

    /// 📊 Severity level
    public var severity: ErrorSeverity {
        switch self {
        case .validation, .network(.timeout):
            return .low
        case .network, .api(.rateLimited), .audio, .translation, .media:
            return .medium
        case .api, .authentication, .storage, .unknown:
            return .high
        }
    }

    // MARK: - 🌙 Equatable Conformance

    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

// MARK: - 📡 Network Error

/// 📡 When the digital realm is unreachable
public enum NetworkError: LocalizedError, Equatable, Sendable {
    case noConnection
    case timeout
    case cancelled
    case dnsFailure
    case cellularRestricted

    public var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request was cancelled"
        case .dnsFailure:
            return "Unable to reach the server"
        case .cellularRestricted:
            return "Cellular data is restricted"
        }
    }
}

// MARK: - 🎭 API Error

/// 🎪 When the backend API encounters issues
public enum APIError: LocalizedError, Sendable {
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case rateLimited
    case invalidResponse
    case decodingError(String)
    case encodingError(String)
    case missingRequiredField(String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Authentication required"
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error (\(code))"
        case .rateLimited:
            return "Rate limit exceeded"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let message):
            return "Data parsing error: \(message)"
        case .encodingError(let message):
            return "Data encoding error: \(message)"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        }
    }
}

// 📐 Equatable conformance for APIError
extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.rateLimited, .rateLimited),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.serverError(lCode), .serverError(rCode)):
            return lCode == rCode
        case let (.decodingError(lMsg), .decodingError(rMsg)),
             let (.encodingError(lMsg), .encodingError(rMsg)):
            return lMsg == rMsg
        case let (.missingRequiredField(lField), .missingRequiredField(rField)):
            return lField == rField
        default:
            return false
        }
    }
}

// MARK: - ✏️ Validation Error

/// ✏️ When the input doesn't meet our artistic standards
public enum ValidationError: LocalizedError, Equatable, Sendable {
    case emptyInput
    case tooShort(minLength: Int)
    case tooLong(maxLength: Int)
    case invalidURL
    case invalidEmail
    case invalidFormat(String)
    case outOfRange(min: Double, max: Double)
    case missingRequiredField(String)

    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "This field cannot be empty"
        case .tooShort(let length):
            return "Must be at least \(length) characters"
        case .tooLong(let length):
            return "Must be no more than \(length) characters"
        case .invalidURL:
            return "Invalid URL format"
        case .invalidEmail:
            return "Invalid email address"
        case .invalidFormat(let format):
            return "Invalid format: \(format)"
        case .outOfRange(let min, let max):
            return "Must be between \(min) and \(max)"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        }
    }
}

// MARK: - 💾 Storage Error

/// 💾 When persistence fails
public enum StorageError: LocalizedError, Equatable, Sendable {
    case diskFull
    case permissionDenied
    case notFound
    case corrupted
    case writeFailed
    case readFailed
    case quotaExceeded

    public var errorDescription: String? {
        switch self {
        case .diskFull:
            return "Storage is full"
        case .permissionDenied:
            return "Permission denied"
        case .notFound:
            return "Item not found"
        case .corrupted:
            return "Data is corrupted"
        case .writeFailed:
            return "Failed to save data"
        case .readFailed:
            return "Failed to read data"
        case .quotaExceeded:
            return "Storage quota exceeded"
        }
    }
}

// MARK: - 🎬 Audio Error

/// 🔊 When sound generation encounters issues
public enum AudioError: LocalizedError, Equatable, Sendable {
    case generationFailed
    case playbackFailed
    case invalidFormat
    case fileNotFound
    case durationTooLong(maxSeconds: Int)
    case textTooEmpty
    case unsupportedVoice
    case downloadFailed

    public var errorDescription: String? {
        switch self {
        case .generationFailed:
            return "Failed to generate audio"
        case .playbackFailed:
            return "Failed to play audio"
        case .invalidFormat:
            return "Invalid audio format"
        case .fileNotFound:
            return "Audio file not found"
        case .durationTooLong(let max):
            return "Audio duration exceeds maximum of \(max) seconds"
        case .textTooEmpty:
            return "Not enough text to generate audio"
        case .unsupportedVoice:
            return "Voice is not supported"
        case .downloadFailed:
            return "Failed to download audio"
        }
    }
}

// MARK: - 🌐 Translation Error

/// 🗣️ When language barriers prove too thick
public enum TranslationError: LocalizedError, Equatable, Sendable {
    case serviceUnavailable
    case unsupportedLanguage
    case quotaExceeded
    case textTooEmpty
    case textTooLong(maxCharacters: Int)
    case translationFailed(String)
    case invalidLanguagePair

    public var errorDescription: String? {
        switch self {
        case .serviceUnavailable:
            return "Translation service is unavailable"
        case .unsupportedLanguage:
            return "Language is not supported"
        case .quotaExceeded:
            return "Translation quota exceeded"
        case .textTooEmpty:
            return "Not enough text to translate"
        case .textTooLong(let max):
            return "Text exceeds maximum of \(max) characters"
        case .translationFailed(let lang):
            return "Failed to translate to \(lang)"
        case .invalidLanguagePair:
            return "Invalid language pair"
        }
    }
}

// MARK: - 🖼️ Media Error

/// 📸 When images misbehave
public enum MediaError: LocalizedError, Equatable, Sendable {
    case uploadFailed
    case invalidFileType
    case fileTooLarge(maxSizeMB: Int)
    case corrupted
    case analysisFailed
    case downloadFailed
    case unsupportedFormat(String)

    public var errorDescription: String? {
        switch self {
        case .uploadFailed:
            return "Failed to upload image"
        case .invalidFileType:
            return "Invalid file type"
        case .fileTooLarge(let size):
            return "File size exceeds \(size)MB limit"
        case .corrupted:
            return "Image file is corrupted"
        case .analysisFailed:
            return "Failed to analyze image"
        case .downloadFailed:
            return "Failed to download image"
        case .unsupportedFormat(let format):
            return "Unsupported format: \(format)"
        }
    }
}

// MARK: - 🔐 Authentication Error

/// 🔑 When access is denied
public enum AuthError: LocalizedError, Equatable, Sendable {
    case notAuthenticated
    case tokenExpired
    case invalidCredentials
    case accountLocked
    case sessionInvalid
    case refreshFailed

    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Not authenticated"
        case .tokenExpired:
            return "Session has expired"
        case .invalidCredentials:
            return "Invalid credentials"
        case .accountLocked:
            return "Account is locked"
        case .sessionInvalid:
            return "Session is invalid"
        case .refreshFailed:
            return "Failed to refresh session"
        }
    }
}

// MARK: - 🎨 Error Color

/// 🎨 Visual themes for errors
public enum ErrorColor: String, CaseIterable, Sendable {
    case red
    case orange
    case yellow
    case blue
    case purple
    case pink
    case indigo
    case gray

    public var hexValue: String {
        switch self {
        case .red: return "#FF3B30"
        case .orange: return "#FF9500"
        case .yellow: return "#FFCC00"
        case .blue: return "#007AFF"
        case .purple: return "#AF52DE"
        case .pink: return "#FF2D55"
        case .indigo: return "#5856D6"
        case .gray: return "#8E8E93"
        }
    }
}

// MARK: - 📊 Error Severity

/// 📊 How severe an error is
public enum ErrorSeverity: Int, CaseIterable, Comparable, Sendable {
    case low = 0
    case medium = 1
    case high = 2

    public var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }

    public var iconName: String {
        switch self {
        case .low: return "info.circle"
        case .medium: return "exclamationmark.triangle"
        case .high: return "xmark.octagon.fill"
        }
    }

    public static func < (lhs: ErrorSeverity, rhs: ErrorSeverity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - 📋 Error Context

/// 📋 Additional context about when/how an error occurred
public struct ErrorContext: Equatable, Sendable {
    public let operation: String
    public let timestamp: Date
    public let additionalInfo: [String: String]?

    public init(
        operation: String,
        timestamp: Date = Date(),
        additionalInfo: [String: String]? = nil
    ) {
        self.operation = operation
        self.timestamp = timestamp
        self.additionalInfo = additionalInfo
    }
}

// MARK: - 📊 Error Report

/// 📊 Full error report for analytics/debugging
public struct ErrorReport: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let error: AppError
    public let context: ErrorContext
    public let stackTrace: String?
    public let userId: String?

    public init(
        error: AppError,
        context: ErrorContext,
        stackTrace: String? = nil,
        userId: String? = nil
    ) {
        self.error = error
        self.context = context
        self.stackTrace = stackTrace
        self.userId = userId
    }

    /// 📊 Serializable dictionary for reporting
    public var dictionary: [String: Any] {
        [
            "error_type": String(describing: error),
            "error_description": error.localizedDescription,
            "operation": context.operation,
            "timestamp": context.timestamp,
            "severity": error.severity.rawValue
        ]
    }
}

// MARK: - 🎭 Error Conversion Helpers

/// 🎭 Convert system errors to AppError
public extension Error {

    /// 🌩️ Convert any Error to AppError
    func asAppError(context: String = "Unknown") -> AppError {
        if let appError = self as? AppError {
            return appError
        }

        if let urlError = self as? URLError {
            return .network(urlError.asNetworkError)
        }

        return .unknown(self)
    }
}

public extension URLError {

    /// 📡 Convert URLError to NetworkError
    var asNetworkError: NetworkError {
        switch code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noConnection
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .cannotFindHost, .dnsLookupFailed:
            return .dnsFailure
        case .internationalRoamingOff:
            return .cellularRestricted
        default:
            return .noConnection
        }
    }
}

// MARK: - 🧪 Test Helpers

/// 🧪 Helpers for testing with errors
public extension AppError {

    /// 🎭 Create a mock error for testing
    static func mock(
        type: ErrorType = .network,
        description: String = "Mock error"
    ) -> AppError {
        switch type {
        case .network:
            return .network(.noConnection)
        case .api:
            return .api(.serverError(500))
        case .validation:
            return .validation(.emptyInput)
        case .storage:
            return .storage(.diskFull)
        case .audio:
            return .audio(.generationFailed)
        case .translation:
            return .translation(.serviceUnavailable)
        case .media:
            return .media(.uploadFailed)
        case .authentication:
            return .authentication(.notAuthenticated)
        }
    }

    /// 📊 Types of errors for testing
    enum ErrorType {
        case network
        case api
        case validation
        case storage
        case audio
        case translation
        case media
        case authentication
    }
}
