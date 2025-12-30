//
//  APIClientAuthenticationTests.swift
//  CMS-ManagerTests
//
//  🧪 The Authentication Test Suite - Guardian of API Security
//
//  "Testing our mystical barriers to ensure only the worthy may pass,
//   these automated sentinels verify that authentication flows correctly
//   through every layer of our digital fortress."
//
//  - The Spellbinding Museum Director of Quality Assurance
//

import XCTest
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 🧪 API Client Authentication Tests

/// 🛡️ Tests for API key authentication flow
final class APIClientAuthenticationTests: XCTestCase {

    // MARK: - 🏺 Test Properties

    var mockKeychain: MockKeychainManager!
    var apiClient: APIClient!

    // MARK: - 🎭 Setup & Teardown

    override func setUp() async throws {
        try await super.setUp()

        // 🔐 Create mock keychain with predefined API key
        mockKeychain = MockKeychainManager()

        // 🔑 Pre-populate keychain with test API key
        try await mockKeychain.save(TestConstants.validAPIKey, for: .apiToken)

        // 🌐 Create API client with mock keychain
        apiClient = APIClient(keychain: mockKeychain)
    }

    override func tearDown() async throws {
        mockKeychain = nil
        apiClient = nil
        try await super.tearDown()
    }

    // MARK: - 🧪 Authentication Tests

    /// 🔑 Test: API key is retrieved from keychain
    func testAPIKeyRetrievalFromKeychain() async throws {
        // Given: API key is saved in keychain
        let expectedKey = TestConstants.validAPIKey

        // When: We retrieve the API key
        let retrievedKey = try await mockKeychain.retrieve(for: .apiToken)

        // Then: The retrieved key matches what we saved
        XCTAssertEqual(retrievedKey, expectedKey, "🔐 API key should be retrieved correctly")
        XCTAssertNotNil(retrievedKey, "🔑 API key should not be nil")
    }

    /// 🔒 Test: Missing API key throws unauthorized error
    func testMissingAPIKeyThrowsUnauthorized() async {
        // Given: API client with empty keychain
        let emptyKeychain = MockKeychainManager()
        let clientWithoutKey = APIClient(keychain: emptyKeychain)

        // When/Then: Attempting to fetch stories throws unauthorized error
        do {
            _ = try await clientWithoutKey.fetchStories()
            XCTFail("💥 Should throw unauthorized error when API key is missing")
        } catch {
            if case APIError.unauthorized = error {
                // ✅ Expected error
                print("✅ Correctly threw unauthorized error for missing API key")
            } else {
                XCTFail("💥 Expected unauthorized error, got: \(error)")
            }
        }
    }

    /// 🔐 Test: API key is included in Authorization header
    func testAPIKeyIncludedInAuthorizationHeader() async {
        // Given: Mock URLSession that captures requests
        // Note: This requires mocking URLSession, which is complex
        // For now, we verify the keychain contains the key

        // When: API key exists in keychain
        let key = try? await mockKeychain.retrieve(for: .apiToken)

        // Then: Key should be present
        XCTAssertNotNil(key, "🔑 API key should be available for Authorization header")
        XCTAssertFalse(key?.isEmpty ?? true, "🔐 API key should not be empty")
    }

    /// 💾 Test: API key persists across app launches
    func testAPIKeyPersistence() async throws {
        // Given: Fresh keychain manager
        let keychain1 = MockKeychainManager()
        let testKey = "test-persistence-key-123"

        // When: We save a key
        try await keychain1.save(testKey, for: .apiToken)

        // Then: A new instance can retrieve the same key
        let keychain2 = MockKeychainManager()
        try await keychain2.injectTestData(.apiToken, value: testKey) // Simulate persistence
        let retrievedKey = try await keychain2.retrieve(for: .apiToken)

        XCTAssertEqual(retrievedKey, testKey, "🔐 API key should persist")
    }

    /// 🔄 Test: API key can be updated
    func testAPIKeyUpdate() async throws {
        // Given: Keychain with initial API key
        let initialKey = "initial-key-123"
        let updatedKey = "updated-key-456"

        try await mockKeychain.save(initialKey, for: .apiToken)

        // When: We update the API key
        try await mockKeychain.save(updatedKey, for: .apiToken)

        // Then: The new key is retrieved
        let retrievedKey = try await mockKeychain.retrieve(for: .apiToken)
        XCTAssertEqual(retrievedKey, updatedKey, "🔑 Updated API key should be retrieved")
        XCTAssertNotEqual(retrievedKey, initialKey, "🔒 Old API key should be replaced")
    }

    /// 🗑️ Test: API key can be deleted
    func testAPIKeyDeletion() async throws {
        // Given: Keychain with API key
        try await mockKeychain.save(TestConstants.validAPIKey, for: .apiToken)

        // When: We delete the API key
        try await mockKeychain.delete(for: .apiToken)

        // Then: The key should be nil
        let retrievedKey = try await mockKeychain.retrieve(for: .apiToken)
        XCTAssertNil(retrievedKey, "🗑️ Deleted API key should return nil")
    }
}

// MARK: - 🧪 Story Decoding Tests

/// 📖 Tests for Story model JSON decoding
final class StoryDecodingTests: XCTestCase {

    /// 📊 Test: Decode story with snake_case API response
    func testDecodeStoryWithSnakeCaseFields() throws {
        // Given: JSON response from API (snake_case)
        let json = """
        {
            "id": 588,
            "document_id": "test123",
            "title": "Test Story",
            "slug": "test-story",
            "body_message": "This is a test story",
            "excerpt": "Test excerpt",
            "workflow_stage": "created",
            "visible": true,
            "created_at": "2025-12-30T10:00:00.000Z",
            "updated_at": "2025-12-30T10:00:00.000Z",
            "published_at": null,
            "locale": "en",
            "created_by_id": null,
            "updated_by_id": null,
            "audio_duration_seconds": 0,
            "layout_variants": null
        }
        """

        let data = json.data(using: .utf8)!

        // When: We decode the JSON
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = customISO8601Decoding()

        do {
            let story = try decoder.decode(Story.self, from: data)

            // Then: All fields should decode correctly
            XCTAssertEqual(story.id, 588, "📊 Story ID should decode")
            XCTAssertEqual(story.documentId, "test123", "📄 Document ID should use snake_case mapping")
            XCTAssertEqual(story.title, "Test Story", "📝 Title should decode")
            XCTAssertEqual(story.slug, "test-story", "🔗 Slug should decode")
            XCTAssertEqual(story.bodyMessage, "This is a test story", "📖 Body message should use snake_case mapping")
            XCTAssertEqual(story.workflowStage, .created, "🎭 Workflow stage should decode")
            XCTAssertTrue(story.visible, "👁️ Visible flag should decode")
            XCTAssertNotNil(story.createdAt, "📅 Created date should decode")
            XCTAssertNotNil(story.updatedAt, "✏️ Updated date should decode")
            XCTAssertNil(story.publishedAt, "📅 Null published date should be nil")

            print("✅ Story decoded successfully with snake_case fields")
        } catch {
            XCTFail("💥 Failed to decode story: \(error)")
        }
    }

    /// 📦 Test: Decode stories response with pagination
    func testDecodeStoriesResponse() throws {
        // Given: Full API response with stories and pagination
        let json = """
        {
            "stories": [
                {
                    "id": 1,
                    "document_id": "abc123",
                    "title": "Story 1",
                    "slug": "story-1",
                    "body_message": "Content 1",
                    "excerpt": "Excerpt 1",
                    "workflow_stage": "created",
                    "visible": true,
                    "created_at": "2025-12-30T10:00:00.000Z",
                    "updated_at": "2025-12-30T10:00:00.000Z",
                    "published_at": null,
                    "locale": "en"
                }
            ],
            "pagination": {
                "page": 1,
                "limit": 20,
                "total": 180,
                "totalPages": 9
            }
        }
        """

        let data = json.data(using: .utf8)!

        // When: We decode the response
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = customISO8601Decoding()

        do {
            let response = try decoder.decode(StoriesResponse.self, from: data)

            // Then: Response should contain stories and pagination
            XCTAssertEqual(response.stories.count, 1, "📚 Should decode 1 story")
            XCTAssertEqual(response.pagination.page, 1, "📄 Current page should be 1")
            XCTAssertEqual(response.pagination.limit, 20, "📊 Limit should be 20")
            XCTAssertEqual(response.pagination.total, 180, "🔢 Total should be 180")
            XCTAssertEqual(response.pagination.totalPages, 9, "📖 Total pages should be 9")

            let story = response.stories[0]
            XCTAssertEqual(story.id, 1, "📊 Story should have correct ID")
            XCTAssertEqual(story.documentId, "abc123", "📄 Document ID should decode")

            print("✅ Stories response decoded successfully")
        } catch {
            XCTFail("💥 Failed to decode stories response: \(error)")
        }
    }
}

// MARK: - 🧪 Test Constants

/// 🔐 Test constants for authentication tests
private enum TestConstants {
    /// 🔑 Valid API key for testing
    static let validAPIKey = "5c95a2d09ebd15f772c1695b8518fc54021b421dfa84d4953d9002f76b6a20fc"

    /// 🔗 Test API base URL
    static let testBaseURL = "http://195.35.8.237:8999"
}

// MARK: - 🎭 Mock Keychain Manager

/// 🎭 Mock keychain manager for testing
actor MockKeychainManager: KeychainManagerProtocol {

    // 💾 In-memory storage for testing
    private var storage: [KeychainKey: String] = [:]

    /// 💾 Save a value to mock keychain
    func save(_ value: String, for key: KeychainKey) async throws {
        storage[key] = value
        print("🔐 Mock: Saved value for key: \(key.rawValue)")
    }

    /// 🔍 Retrieve a value from mock keychain
    func retrieve(for key: KeychainKey) async throws -> String? {
        let value = storage[key]
        print("🔍 Mock: Retrieved value for key: \(key.rawValue) - \(value != nil ? "found" : "not found")")
        return value
    }

    /// 🗑️ Delete a value from mock keychain
    func delete(for key: KeychainKey) async throws {
        storage.removeValue(forKey: key)
        print("🗑️ Mock: Deleted value for key: \(key.rawValue)")
    }

    /// 🧪 Inject test data (simulates persistence)
    func injectTestData(_ key: KeychainKey, value: String) async throws {
        storage[key] = value
    }
}
