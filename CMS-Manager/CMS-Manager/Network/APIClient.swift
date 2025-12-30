//
//  APIClient.swift
//  CMS-Manager
//
//  🌐 The API Client - The Cosmic Messenger Between Realms
//
//  "Bridging the gap between iOS dreams and Python realities,
//   this faithful servant carries requests through the digital ether
//   and returns with treasures from the API kingdom."
//
//  - The Spellbinding Museum Director of Network Communications
//

import Foundation
import ArtfulArchivesCore

// MARK: - 🧙‍♂ Custom Date Decoding

/// 🧙‍♂️ Custom ISO8601 date decoding strategy with fallback formats
func customISO8601Decoding() -> JSONDecoder.DateDecodingStrategy {
    .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: dateString) {
            return date
        }

        // Try alternative format
        let altFormatter = ISO8601DateFormatter()
        altFormatter.formatOptions = [.withInternetDateTime]

        if let date = altFormatter.date(from: dateString) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date from: \(dateString)"
        )
    }
}

// NOTE: AppEnvironment is now imported from ArtfulArchivesCore
// The correct base URL configuration (port 8999) is defined there

// MARK: - 📚 Response Types

/// 📦 Paginated stories response
struct StoriesResponse: Codable, Sendable {
    let stories: [Story]
    let pagination: PaginationInfo

    struct PaginationInfo: Codable, Sendable {
        let page: Int
        let limit: Int
        let total: Int
        let totalPages: Int
    }
}

/// 📦 Story detail response
struct StoryDetailResponse: Codable, Sendable {
    let story: Story
}

// MARK: - 🌐 API Client Actor

/// 🎭 The main API client - handles all HTTP requests to Python backend
actor APIClient: APIClientProtocol {

    // MARK: - 🏺 Private Properties

    /// 🔐 The keychain manager for secure token storage
    /// nonisolated(unsafe) is safe here since KeychainManager is already an actor (thread-safe)
    nonisolated(unsafe) private let keychain: KeychainManagerProtocol

    /// 🌐 The base URL for API requests
    private let baseURL: URL

    /// 🧙‍♂️ The shared URLSession for network requests
    private let session: URLSession

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new API client
    /// - Parameter keychain: The keychain manager for auth tokens
    init(keychain: KeychainManagerProtocol = KeychainManager()) {
        self.keychain = keychain
        // 🌐 Set base URL - Using production API via domain
        // TODO: Set up SSL certificate for https://api-router.cloud
        self.baseURL = URL(string: "http://api-router.cloud:8999")!

        // 🧙‍♂️ Configure URLSession with custom settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - 📚 Stories Endpoints

    /// 📖 Fetch all stories with optional filtering
    /// - Parameters:
    ///   - page: Page number (default: 1)
    ///   - pageSize: Items per page (default: 20)
    ///   - stage: Filter by workflow stage
    ///   - search: Search query string
    ///   - sort: Sort field (e.g., "createdAt:desc")
    /// - Returns: Stories response with pagination info
    func fetchStories(
        page: Int = 1,
        pageSize: Int = 20,
        stage: WorkflowStage? = nil,
        search: String? = nil,
        sort: String? = nil
    ) async throws -> StoriesResponse {
        print("🌐 ✨ STORIES FETCH AWAKENS! Page \(page), \(pageSize) items")

        var components = URLComponents(url: baseURL.appendingPathComponent("/api/v1/stories"), resolvingAgainstBaseURL: true)!

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]

        if let stage {
            queryItems.append(URLQueryItem(name: "workflowStage", value: stage.rawValue))
        }

        if let search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }

        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        try await addAuthHeader(to: &request)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            print("📊 Response status: \(httpResponse.statusCode)")

            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = customISO8601Decoding()
                let result = try decoder.decode(StoriesResponse.self, from: data)
                print("🎉 ✨ STORIES MASTERPIECE COMPLETE! \(result.stories.count) stories loaded")
                return result
            case 401:
                throw APIError.unauthorized
            case 404:
                throw APIError.notFound
            case 500...599:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.unknownError
            }
        } catch let error as APIError {
            print("🌩️ API Error: \(error.localizedDescription)")
            throw error
        } catch {
            print("💥 😭 NETWORK QUEST TEMPORARILY HALTED! \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }

    /// 📖 Fetch a single story by ID
    /// - Parameter id: The story ID
    /// - Returns: The story details
    func fetchStory(id: Int) async throws -> Story {
        print("🌐 ✨ SINGLE STORY QUEST AWAKENS! ID: \(id)")

        let url = baseURL.appendingPathComponent("/api/v1/stories/\(id)")
        var request = URLRequest(url: url)
        try await addAuthHeader(to: &request)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = customISO8601Decoding()
        let storyResponse = try decoder.decode(StoryDetailResponse.self, from: data)

        print("🎉 ✨ STORY MASTERPIECE COMPLETE! '\(storyResponse.story.title)' loaded")
        return storyResponse.story
    }

    /// ✏️ Update an existing story
    /// - Parameters:
    ///   - id: The story ID
    ///   - updates: Fields to update
    /// - Returns: Updated story
    func updateStory(id: Int, updates: StoryUpdate) async throws -> Story {
        print("🌐 ✨ STORY UPDATE AWAKENS! ID: \(id)")

        let url = baseURL.appendingPathComponent("/api/v1/stories/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &request)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(updates)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = customISO8601Decoding()
        let storyResponse = try decoder.decode(StoryDetailResponse.self, from: data)

        print("🎉 ✨ STORY UPDATE MASTERPIECE COMPLETE!")
        return storyResponse.story
    }

    /// 🗑️ Delete a story
    /// - Parameter id: The story ID
    func deleteStory(id: Int) async throws {
        print("🌐 ✨ STORY DELETION AWAKENS! ID: \(id)")

        let url = baseURL.appendingPathComponent("/api/v1/stories/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        try await addAuthHeader(to: &request)

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        print("🎉 ✨ STORY DELETION MASTERPIECE COMPLETE! Farewell, sweet story.")
    }

    /// 🌐 Create a new translation for a story
    /// - Parameters:
    ///   - id: The story ID
    ///   - locale: Target language locale
    ///   - title: Translated title
    ///   - content: Translated content
    func createTranslation(
        id: Int,
        locale: String,
        title: String,
        content: String
    ) async throws {
        print("🌐 ✨ TRANSLATION CREATION AWAKENS! Story ID: \(id), Locale: \(locale)")

        let url = baseURL.appendingPathComponent("/api/v1/stories/\(id)/translations")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &request)

        let body: [String: Any] = [
            "locale": locale,
            "title": title,
            "content": content
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        print("🎉 ✨ TRANSLATION MASTERPIECE COMPLETE!")
    }

    // MARK: - 📤 Media Upload Endpoint

    /// 📤 Upload a media file to the server
    /// - Parameter file: The local file URL to upload
    /// - Returns: Media upload response with ID and URL
    func uploadMedia(file: URL) async throws -> MediaUploadResponse {
        print("📤 ✨ MEDIA UPLOAD AWAKENS! \(file.lastPathComponent)")

        let url = baseURL.appendingPathComponent("/api/v1/upload-media")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        try await addAuthHeader(to: &request)

        // 🧙‍♂️ Create multipart form data boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 📦 Read file data
        let fileData = try Data(contentsOf: file)
        let mimeType = mimeTypeForFile(at: file)

        // 🧙‍♂️ Build multipart body
        var body = Data()

        // Add file data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(file.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)

        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("🌩️ Upload failed with status: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(MediaUploadResponse.self, from: data)

        print("🎉 ✨ UPLOAD MASTERPIECE COMPLETE! Media ID: \(result.id)")
        return result
    }

    // MARK: - 🧠 Image Analysis Endpoint

    /// 🧠 Analyze an image using AI vision
    /// - Parameters:
    ///   - url: The URL of the image to analyze
    ///   - prompt: Optional custom prompt for analysis
    /// - Returns: Image analysis response with story suggestions
    func analyzeImage(url: String, prompt: String?) async throws -> ImageAnalysisResponse {
        print("🧠 ✨ IMAGE ANALYSIS AWAKENS! URL: \(url)")

        let requestUrl = baseURL.appendingPathComponent("/api/v1/analyze-image")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &request)

        let requestBody: [String: Any?] = [
            "url": url,
            "prompt": prompt
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("🌩️ Analysis failed with status: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(ImageAnalysisResponse.self, from: data)

        print("🎉 ✨ ANALYSIS MASTERPIECE COMPLETE!")
        return result
    }

    // MARK: - 🌐 Translation Endpoint

    /// 🌐 Translate content to a target language
    /// - Parameters:
    ///   - content: The text content to translate
    ///   - targetLanguage: The target language code
    /// - Returns: Translation response with translated content
    func translate(content: String, targetLanguage: String) async throws -> TranslationResponse {
        print("🌐 ✨ TRANSLATION AWAKENS! Target: \(targetLanguage)")

        let url = baseURL.appendingPathComponent("/api/v1/translate")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &request)

        let requestBody: [String: String] = [
            "content": content,
            "target_language": targetLanguage
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("🌩️ Translation failed with status: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(TranslationResponse.self, from: data)

        print("🎉 ✨ TRANSLATION MASTERPIECE COMPLETE!")
        return result
    }

    // MARK: - 🔊 Audio Generation Endpoint

    /// 🔊 Generate audio from text using TTS
    /// - Parameters:
    ///   - text: The text to convert to speech
    ///   - language: The language code
    ///   - voice: The TTS voice to use (optional, uses default for language if nil)
    /// - Returns: Audio generation response with audio URL
    func generateAudio(text: String, language: String, voice: TTSVoice?, speed: Double = 0.9) async throws -> AudioGenerationResponse {
        print("🔊 ✨ AUDIO GENERATION AWAKENS! Voice: \(voice?.rawValue ?? "default"), Speed: \(speed)x")

        let url = baseURL.appendingPathComponent("/api/v1/generate-audio")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &request)

        var requestBody: [String: Any] = [
            "text": text,
            "language": language,
            "speed": speed
        ]

        if let voice = voice {
            requestBody["voice"] = voice.rawValue
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("🌩️ Audio generation failed with status: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(AudioGenerationResponse.self, from: data)

        print("🎉 ✨ AUDIO GENERATION MASTERPIECE COMPLETE!")
        return result
    }

    // MARK: - 🎉 Complete Story Creation Endpoint

    /// 🚀 Create a complete story with all components
    /// - Parameter storyRequest: The story creation request
    /// - Returns: Story creation response
    func createStoryComplete(request: StoryCreateRequest) async throws -> StoryCreateResponse {
        print("🚀 ✨ STORY CREATION AWAKENS! '\(request.title)'")

        let url = baseURL.appendingPathComponent("/api/v1/create-story-complete")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        try await addAuthHeader(to: &urlRequest)

        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("🌩️ Story creation failed with status: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = customISO8601Decoding()
        let result = try decoder.decode(StoryCreateResponse.self, from: data)

        print("🎉 ✨ STORY CREATION MASTERPIECE COMPLETE! Story ID: \(result.storyId ?? 0)")
        return result
    }

    // MARK: - 🔧 Helper Methods

    /// 🧙‍♂️ Determine MIME type for a file
    /// - Parameter file: The file URL
    /// - Returns: The MIME type string
    private func mimeTypeForFile(at file: URL) -> String {
        let pathExtension = file.pathExtension.lowercased()
        switch pathExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "webp":
            return "image/webp"
        case "pdf":
            return "application/pdf"
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "mp4":
            return "video/mp4"
        default:
            return "application/octet-stream"
        }
    }

    // MARK: - 🔐 Authentication Helpers

    /// 🔑 Add authentication header to request
    /// - Parameter request: The URLRequest to modify
    /// - Throws: APIError.unauthorized if no API key is found
    private func addAuthHeader(to request: inout URLRequest) async throws {
        // 🔍 Retrieve API key from keychain
        guard let token = try await keychain.retrieve(for: .apiToken), !token.isEmpty else {
            print("💥 😭 No API key found in keychain!")
            throw APIError.unauthorized
        }

        // 🔑 Add Bearer token to Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 ✨ Authorization header added successfully")
    }
}

// MARK: - 🎭 API Error

/// 🌩️ The pantheon of possible API failures
enum APIError: LocalizedError {
    case unauthorized
    case notFound
    case serverError(Int)
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case unknownError
    case uploadFailed(String)
    case validation(ValidationError)
    case unknown(Error)

    /// 🌩️ Validation errors
    enum ValidationError {
        case invalidImage
        case fileTooLarge
        case unsupportedFormat
    }

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Authentication required. Please sign in."
        case .notFound:
            return "The requested resource was not found."
        case .serverError(let code):
            return "Server error occurred (Code: \(code)). Please try again later."
        case .invalidResponse:
            return "Invalid server response format."
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        case .uploadFailed(let message):
            return "Upload failed: \(message)"
        case .validation(let error):
            switch error {
            case .invalidImage:
                return "Invalid image selected. Please try another."
            case .fileTooLarge:
                return "File is too large. Maximum size is 10MB."
            case .unsupportedFormat:
                return "Unsupported file format. Please use JPG, PNG, or HEIC."
            }
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unauthorized:
            return "Please check your credentials and try again."
        case .networkError:
            return "Check your internet connection and try again."
        case .serverError:
            return "The server is experiencing issues. Please wait a moment."
        case .uploadFailed:
            return "Please check the file and try again."
        case .validation:
            return "Please select a different file."
        default:
            return "Please try again."
        }
    }

    var icon: String {
        switch self {
        case .unauthorized: "lock.shield"
        case .notFound: "magnifyingglass"
        case .serverError: "server.rack"
        case .invalidResponse: "doc.text.magnifyingglass"
        case .decodingError: "doc.badge.ellipsis"
        case .networkError: "wifi.slash"
        case .unknownError: "exclamationmark.triangle"
        case .uploadFailed: "arrow.up.doc"
        case .validation: "exclamationmark.triangle.fill"
        case .unknown: "exclamationmark.triangle"
        }
    }
}

// MARK: - 📦 Response Models

/// ✏️ Story update request body
struct StoryUpdate: Codable {
    let title: String?
    let bodyMessage: String?
    let excerpt: String?
    let workflowStage: String?
    let visible: Bool?
}

// MARK: - 🎤 TTS Voice

/// 🎭 Text-to-speech voice options for audio generation
enum TTSVoice: String, CaseIterable, Codable {
    case nova = "nova"
    case alloy = "alloy"
    case echo = "echo"
    case fable = "fable"
    case onyx = "onyx"
    case shimmer = "shimmer"

    /// 🎭 Display name for UI
    var displayName: String {
        switch self {
        case .nova: return "Nova"
        case .alloy: return "Alloy"
        case .echo: return "Echo"
        case .fable: return "Fable"
        case .onyx: return "Onyx"
        case .shimmer: return "Shimmer"
        }
    }

    /// 📜 Voice description
    var description: String {
        switch self {
        case .nova: return "Warm and engaging female voice"
        case .alloy: return "Clear and neutral female voice"
        case .echo: return "Warm and friendly male voice"
        case .fable: return "Expressive British male voice"
        case .onyx: return "Deep and resonant male voice"
        case .shimmer: return "Clear and bright female voice"
        }
    }
}

// MARK: - 🌐 Language Code

/// 🌐 Supported languages for translation and audio
// MARK: - 📤 Media Upload Response

/// 📦 Response from media upload endpoint
struct MediaUploadResponse: Codable {
    let id: Int
    let url: String
    let name: String
    let mime: String?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case id, url, name, mime, size
    }
}

// MARK: - 🧠 Image Analysis Response

/// 📦 Response from image analysis endpoint
struct ImageAnalysisResponse: Codable {
    let success: Bool
    let data: AnalysisData?
    let message: String?

    /// 📝 Analysis data containing story suggestions
    struct AnalysisData: Codable {
        let title: String
        let content: String
        let tags: [String]
        let category: String?
        let mood: String?
    }
}

// MARK: - 🌐 Translation Response

/// 📦 Response from translation endpoint
struct TranslationResponse: Codable {
    let success: Bool
    let translatedContent: String?
    let originalLanguage: String?
    let targetLanguage: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case success
        case translatedContent = "translated_content"
        case originalLanguage = "original_language"
        case targetLanguage = "target_language"
        case message
    }
}

// MARK: - 🔊 Audio Generation Response

/// 📦 Response from audio generation endpoint
struct AudioGenerationResponse: Codable {
    let success: Bool
    let audioUrl: String?
    let duration: Double?
    let language: String?
    let voice: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case success
        case audioUrl = "audio_url"
        case duration, language, voice, message
    }
}

// MARK: - 🎭 Protocols

/// 🎭 The API client protocol - for dependency injection and testing
protocol APIClientProtocol: Actor {
    func fetchStories(page: Int, pageSize: Int, stage: WorkflowStage?, search: String?, sort: String?) async throws -> StoriesResponse
    func fetchStory(id: Int) async throws -> Story
    func updateStory(id: Int, updates: StoryUpdate) async throws -> Story
    func deleteStory(id: Int) async throws
    func createTranslation(id: Int, locale: String, title: String, content: String) async throws
    func uploadMedia(file: URL) async throws -> MediaUploadResponse
    func analyzeImage(url: String, prompt: String?) async throws -> ImageAnalysisResponse
    func translate(content: String, targetLanguage: String) async throws -> TranslationResponse
    func generateAudio(text: String, language: String, voice: TTSVoice?, speed: Double) async throws -> AudioGenerationResponse
    func createStoryComplete(request: StoryCreateRequest) async throws -> StoryCreateResponse
}

// MARK: - 🧪 Mock API Client

/// 🧪 Mock API client for SwiftUI previews
actor MockAPIClient: APIClientProtocol {

    func fetchStories(page: Int, pageSize: Int, stage: WorkflowStage?, search: String?, sort: String?) async throws -> StoriesResponse {
        StoriesResponse(
            stories: [],
            pagination: .init(page: page, limit: pageSize, total: 0, totalPages: 0)
        )
    }

    func fetchStory(id: Int) async throws -> Story {
        Story(
            id: 1,
            documentId: "mock",
            title: "Mock Story",
            slug: "mock-story",
            bodyMessage: "Mock content",
            excerpt: "Mock excerpt",
            image: nil,
            images: nil,
            audio: nil,
            workflowStage: .created,
            visible: true,
            locale: nil,
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date(),
            publishedAt: nil,
            createdBy: nil,
            strapiAttributes: nil
        )
    }

    func updateStory(id: Int, updates: StoryUpdate) async throws -> Story {
        Story(
            id: id,
            documentId: "mock",
            title: "Updated Story",
            slug: "updated-story",
            bodyMessage: "Updated content",
            excerpt: "Updated excerpt",
            image: nil,
            images: nil,
            audio: nil,
            workflowStage: .created,
            visible: true,
            locale: nil,
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date(),
            publishedAt: nil,
            createdBy: nil,
            strapiAttributes: nil
        )
    }

    func deleteStory(id: Int) async throws {
        // Mock deletion
    }

    func createTranslation(id: Int, locale: String, title: String, content: String) async throws {
        // Mock translation creation
    }

    func uploadMedia(file: URL) async throws -> MediaUploadResponse {
        MediaUploadResponse(
            id: 123,
            url: "https://example.com/mock.jpg",
            name: file.lastPathComponent,
            mime: "image/jpeg",
            size: 1024
        )
    }

    func analyzeImage(url: String, prompt: String?) async throws -> ImageAnalysisResponse {
        ImageAnalysisResponse(
            success: true,
            data: .init(
                title: "Mock Analysis Title",
                content: "Mock analysis content",
                tags: ["mock", "test"],
                category: "art",
                mood: "inspiring"
            ),
            message: nil
        )
    }

    func translate(content: String, targetLanguage: String) async throws -> TranslationResponse {
        TranslationResponse(
            success: true,
            translatedContent: "Translated: \(content)",
            originalLanguage: "en",
            targetLanguage: targetLanguage,
            message: nil
        )
    }

    func generateAudio(text: String, language: String, voice: TTSVoice?, speed: Double = 0.9) async throws -> AudioGenerationResponse {
        AudioGenerationResponse(
            success: true,
            audioUrl: "data:audio/mpeg;base64,mock",
            duration: 10.0,
            language: language,
            voice: voice?.rawValue,
            message: nil
        )
    }

    func createStoryComplete(request: StoryCreateRequest) async throws -> StoryCreateResponse {
        StoryCreateResponse(
            success: true,
            storyId: 123,
            storyData: nil,
            message: "Story created successfully"
        )
    }
}
