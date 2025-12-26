//
//  MockAPIClient.swift
//  CMS-ManagerTests
//
//  🎭 The Mock API Client - A Digital Doppelgänger for Testing Tales
//
//  "Like a theatrical understudy who knows every line and cue,
//   this mock client performs the same dance as the real API,
//   but with scripts we control, data we design, and perfect timing
//   for the testing stage. No network required—pure imagination!"
//
//  - The Spellbinding Museum Director of Test Infrastructure
//

import Foundation
@testable import CMS_Manager
import ArtfulArchivesCore

// MARK: - 🎭 Mock API Client

/// 🧪 A test double that implements APIClientProtocol with configurable responses
///
/// This mystical actor mirrors the real API client but returns pre-configured
/// mock data instead of making actual network requests. Perfect for testing
/// without the chaos of network dependencies! ✨
///
/// Usage:
/// ```swift
/// let mockClient = MockAPIClient()
/// mockClient.uploadMediaResult = .success(mockUploadResponse)
/// let response = try await mockClient.uploadMedia(file: testURL)
/// XCTAssertEqual(mockClient.uploadMediaCallCount, 1)
/// ```
actor MockAPIClient: APIClientProtocol {

    // MARK: - 📊 Call Tracking - Spying on the Action

    /// 📸 How many times uploadMedia was summoned
    var uploadMediaCallCount = 0

    /// 🧠 How many times analyzeImage was invoked
    var analyzeImageCallCount = 0

    /// 🌐 How many times translate was called
    var translateCallCount = 0

    /// 🔊 How many times generateAudio was requested
    var generateAudioCallCount = 0

    /// 🚀 How many times createStoryComplete was invoked
    var createStoryCompleteCallCount = 0

    /// 📖 How many times fetchStories was called
    var fetchStoriesCallCount = 0

    /// 📄 How many times fetchStory was called
    var fetchStoryCallCount = 0

    /// ✏️ How many times updateStory was called
    var updateStoryCallCount = 0

    /// 🗑️ How many times deleteStory was called
    var deleteStoryCallCount = 0

    /// 🌐 How many times createTranslation was called
    var createTranslationCallCount = 0

    // MARK: - 🎯 Configurable Results - Controlling the Narrative

    /// 📤 The result to return when uploadMedia is called
    var uploadMediaResult: Result<MediaUploadResponse, Error> = .success(
        MediaUploadResponse(
            id: 42,
            url: "https://example.com/test-image.jpg",
            name: "test-image.jpg",
            mime: "image/jpeg",
            size: 1024
        )
    )

    /// 🧠 The result to return when analyzeImage is called
    var analyzeImageResult: Result<ImageAnalysisResponse, Error> = .success(
        ImageAnalysisResponse(
            success: true,
            data: ImageAnalysisResponse.AnalysisData(
                title: "The Mystical Sunset Over Mountains",
                content: "A breathtaking view of the sun setting behind majestic peaks, painting the sky in hues of orange and purple.",
                tags: ["nature", "sunset", "mountains", "landscape"]
            ),
            error: nil
        )
    )

    /// 🌐 The result to return when translate is called
    var translateResult: Result<TranslationResponse, Error> = .success(
        TranslationResponse(
            success: true,
            translatedContent: "Contenido traducido",
            error: nil
        )
    )

    /// 🔊 The result to return when generateAudio is called
    var generateAudioResult: Result<AudioGenerationResponse, Error> = .success(
        AudioGenerationResponse(
            success: true,
            audioUrl: "data:audio/mpeg;base64,mock-audio-data",
            error: nil
        )
    )

    /// 🚀 The result to return when createStoryComplete is called
    var createStoryCompleteResult: Result<StoryCreateResponse, Error> = .success(
        StoryCreateResponse(
            success: true,
            storyId: 123,
            storyData: MockStoryFactory.createStory(),
            message: "Story created successfully"
        )
    )

    /// 📖 The result to return when fetchStories is called
    var fetchStoriesResult: Result<StoriesResponse, Error> = .success(
        StoriesResponse(
            stories: MockStoryFactory.createStoryCollection(),
            pagination: StoriesResponse.PaginationInfo(
                page: 1,
                limit: 20,
                total: 3,
                totalPages: 1
            )
        )
    )

    /// 📄 The result to return when fetchStory is called
    var fetchStoryResult: Result<Story, Error> = .success(MockStoryFactory.createStory())

    /// ✏️ The result to return when updateStory is called
    var updateStoryResult: Result<Story, Error> = .success(MockStoryFactory.createStory())

    /// 🗑️ Whether deleteStory should succeed (throws if false)
    var deleteStorySucceeds = true

    /// 🌐 Whether createTranslation should succeed (throws if false)
    var createTranslationSucceeds = true

    // MARK: - 📝 Captured Parameters - Recording the Script

    /// 🎬 The last file URL uploaded
    var lastUploadedFileURL: URL?

    /// 🎬 The last image URL analyzed
    var lastAnalyzedImageURL: String?

    /// 🎬 The last translation content
    var lastTranslationContent: String?

    /// 🎬 The last translation target language
    var lastTranslationLanguage: String?

    /// 🎬 The last audio generation text
    var lastAudioText: String?

    /// 🎬 The last audio generation language
    var lastAudioLanguage: String?

    /// 🎬 The last story creation request
    var lastStoryRequest: StoryCreateRequest?

    /// 🎬 The last story update ID
    var lastUpdateStoryId: Int?

    /// 🎬 The last story update data
    var lastStoryUpdate: StoryUpdate?

    // MARK: - 🎭 APIClientProtocol Implementation

    /// 📤 Upload media file (mock version)
    func uploadMedia(file: URL) async throws -> MediaUploadResponse {
        print("🧪 ✨ MOCK UPLOAD AWAKENS! \(file.lastPathComponent)")
        uploadMediaCallCount += 1
        lastUploadedFileURL = file

        switch uploadMediaResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 🧠 Analyze image (mock version)
    func analyzeImage(url: String, prompt: String?) async throws -> ImageAnalysisResponse {
        print("🧪 ✨ MOCK ANALYSIS AWAKENS! URL: \(url)")
        analyzeImageCallCount += 1
        lastAnalyzedImageURL = url

        switch analyzeImageResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 🌐 Translate content (mock version)
    func translate(content: String, targetLanguage: String) async throws -> TranslationResponse {
        print("🧪 ✨ MOCK TRANSLATION AWAKENS! Target: \(targetLanguage)")
        translateCallCount += 1
        lastTranslationContent = content
        lastTranslationLanguage = targetLanguage

        switch translateResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 🔊 Generate audio (mock version)
    func generateAudio(text: String, language: String, voice: TTSVoice?) async throws -> AudioGenerationResponse {
        print("🧪 ✨ MOCK AUDIO GENERATION AWAKENS! Voice: \(voice?.rawValue ?? "default")")
        generateAudioCallCount += 1
        lastAudioText = text
        lastAudioLanguage = language

        switch generateAudioResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 🚀 Create complete story (mock version)
    func createStoryComplete(request: StoryCreateRequest) async throws -> StoryCreateResponse {
        print("🧪 ✨ MOCK STORY CREATION AWAKENS! Title: \(request.title)")
        createStoryCompleteCallCount += 1
        lastStoryRequest = request

        switch createStoryCompleteResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 📖 Fetch stories (mock version)
    func fetchStories(
        page: Int,
        pageSize: Int,
        stage: WorkflowStage?,
        search: String?,
        sort: String?
    ) async throws -> StoriesResponse {
        print("🧪 ✨ MOCK FETCH STORIES AWAKENS! Page: \(page)")
        fetchStoriesCallCount += 1

        switch fetchStoriesResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// 📄 Fetch single story (mock version)
    func fetchStory(id: Int) async throws -> Story {
        print("🧪 ✨ MOCK FETCH STORY AWAKENS! ID: \(id)")
        fetchStoryCallCount += 1

        switch fetchStoryResult {
        case .success(let story):
            return story
        case .failure(let error):
            throw error
        }
    }

    /// ✏️ Update story (mock version)
    func updateStory(id: Int, updates: StoryUpdate) async throws -> Story {
        print("🧪 ✨ MOCK UPDATE STORY AWAKENS! ID: \(id)")
        updateStoryCallCount += 1
        lastUpdateStoryId = id
        lastStoryUpdate = updates

        switch updateStoryResult {
        case .success(let story):
            return story
        case .failure(let error):
            throw error
        }
    }

    /// 🗑️ Delete story (mock version)
    func deleteStory(id: Int) async throws {
        print("🧪 ✨ MOCK DELETE STORY AWAKENS! ID: \(id)")
        deleteStoryCallCount += 1

        if !deleteStorySucceeds {
            throw APIError.serverError(500)
        }
    }

    /// 🌐 Create translation (mock version)
    func createTranslation(id: Int, locale: String, title: String, content: String) async throws {
        print("🧪 ✨ MOCK CREATE TRANSLATION AWAKENS! Story ID: \(id), Locale: \(locale)")
        createTranslationCallCount += 1

        if !createTranslationSucceeds {
            throw APIError.serverError(500)
        }
    }

    // MARK: - 🧹 Test Helpers

    /// 🧹 Reset all call counts and captured parameters
    /// Perfect for cleaning up between test cases! 🎭
    func reset() {
        uploadMediaCallCount = 0
        analyzeImageCallCount = 0
        translateCallCount = 0
        generateAudioCallCount = 0
        createStoryCompleteCallCount = 0
        fetchStoriesCallCount = 0
        fetchStoryCallCount = 0
        updateStoryCallCount = 0
        deleteStoryCallCount = 0
        createTranslationCallCount = 0

        lastUploadedFileURL = nil
        lastAnalyzedImageURL = nil
        lastTranslationContent = nil
        lastTranslationLanguage = nil
        lastAudioText = nil
        lastAudioLanguage = nil
        lastStoryRequest = nil
        lastUpdateStoryId = nil
        lastStoryUpdate = nil

        print("🧹 ✨ MOCK API CLIENT RESET COMPLETE! All counters zeroed.")
    }
}
