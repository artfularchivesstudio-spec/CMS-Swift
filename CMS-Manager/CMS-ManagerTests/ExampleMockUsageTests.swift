//
//  ExampleMockUsageTests.swift
//  CMS-ManagerTests
//
//  🎓 Example Test Suite - Learning the Art of Mock Testing
//
//  "This suite serves as a living tutorial, demonstrating the elegant
//   dance between mocks and tests. Study these patterns, adapt them
//   to your needs, and watch your test coverage soar like a phoenix!"
//
//  - The Spellbinding Museum Director of Test Education
//

import XCTest
@testable import CMS_Manager
import ArtfulArchivesCore

// MARK: - 🎓 Example Mock Usage Tests

/// 🌟 Example tests demonstrating how to use the mock infrastructure
///
/// This test suite showcases various testing patterns using our mock factories.
/// Use these as templates for your own tests! ✨
@MainActor
final class ExampleMockUsageTests: XCTestCase {

    // MARK: - 🎬 Test Lifecycle

    /// 🧹 Clean up before each test to ensure isolation
    override func setUp() async throws {
        try await super.setUp()
        print("🎬 ✨ TEST SCENE BEGINS!")
    }

    /// 🌙 Clean up after each test
    override func tearDown() async throws {
        print("🌙 Test scene concludes...")
        try await super.tearDown()
    }

    // MARK: - 📸 Example 1: Testing API Client Calls

    /// 🧪 Test that upload media calls the API client correctly
    func testUploadMediaCallsAPIClient() async throws {
        print("🧪 Testing upload media API call...")

        // 🎭 ARRANGE: Set up the test doubles
        let mockAPI = MockAPIClient()
        let mockToast = ToastManager()

        // Configure the mock to return a successful response
        mockAPI.uploadMediaResult = .success(
            MockResponseFactory.createUploadResponse(id: 42)
        )

        // Create the view model with our mocks
        let viewModel = StoryWizardViewModel(
            apiClient: mockAPI,
            toastManager: mockToast
        )

        // 🎬 ACT: Execute the action we're testing
        let testFileURL = MockImageFactory.createTemporaryImageFile()
        defer { MockImageFactory.deleteTemporaryFile(at: testFileURL) }

        await viewModel.uploadImage(fileURL: testFileURL)

        // ✅ ASSERT: Verify the expected behavior
        XCTAssertEqual(mockAPI.uploadMediaCallCount, 1, "Upload should be called exactly once")
        XCTAssertEqual(mockAPI.lastUploadedFileURL, testFileURL, "Should upload the correct file")
        XCTAssertEqual(viewModel.uploadedMediaId, 42, "Should store the returned media ID")
        XCTAssertNotNil(viewModel.uploadedMediaUrl, "Should store the uploaded URL")

        print("✅ Test passed! Upload flow works correctly.")
    }

    // MARK: - 🔍 Example 2: Testing Analysis Flow

    /// 🧪 Test that image analysis populates story fields
    func testImageAnalysisPopulatesStoryFields() async throws {
        print("🧪 Testing image analysis flow...")

        // 🎭 ARRANGE
        let mockAPI = MockAPIClient()
        let mockToast = ToastManager()

        // Configure analysis to return specific data
        let expectedTitle = "The Mystical Sunset"
        let expectedContent = "A breathtaking view of colors in the sky."
        let expectedTags = ["nature", "sunset", "beautiful"]

        mockAPI.analyzeImageResult = .success(
            ImageAnalysisResponse(
                success: true,
                data: ImageAnalysisResponse.AnalysisData(
                    title: expectedTitle,
                    content: expectedContent,
                    tags: expectedTags
                ),
                error: nil
            )
        )

        let viewModel = StoryWizardViewModel(
            apiClient: mockAPI,
            toastManager: mockToast
        )

        // Set up as if we've already uploaded an image
        viewModel.uploadedMediaUrl = "https://example.com/test.jpg"

        // 🎬 ACT
        await viewModel.analyzeImage()

        // ✅ ASSERT
        XCTAssertEqual(mockAPI.analyzeImageCallCount, 1, "Analysis should be called once")
        XCTAssertEqual(viewModel.storyTitle, expectedTitle, "Should populate title from analysis")
        XCTAssertEqual(viewModel.storyContent, expectedContent, "Should populate content from analysis")
        XCTAssertEqual(viewModel.storyTags, expectedTags, "Should populate tags from analysis")
        XCTAssertFalse(viewModel.storySlug.isEmpty, "Should generate a slug from the title")

        print("✅ Test passed! Analysis correctly populates fields.")
    }

    // MARK: - 💥 Example 3: Testing Error Handling

    /// 🧪 Test that upload errors are handled gracefully
    func testUploadErrorIsHandledGracefully() async throws {
        print("🧪 Testing error handling...")

        // 🎭 ARRANGE
        let mockAPI = MockAPIClient()
        let mockToast = ToastManager()

        // Configure the mock to return an error
        mockAPI.uploadMediaResult = .failure(APIError.serverError(500))

        let viewModel = StoryWizardViewModel(
            apiClient: mockAPI,
            toastManager: mockToast
        )

        // 🎬 ACT
        let testFileURL = MockImageFactory.createTemporaryImageFile()
        defer { MockImageFactory.deleteTemporaryFile(at: testFileURL) }

        await viewModel.uploadImage(fileURL: testFileURL)

        // ✅ ASSERT
        XCTAssertNotNil(viewModel.error, "Should set error property when upload fails")
        XCTAssertNil(viewModel.uploadedMediaId, "Should not have a media ID on failure")
        XCTAssertFalse(viewModel.isLoading, "Should stop loading after error")

        print("✅ Test passed! Errors are handled correctly.")
    }

    // MARK: - 🌐 Example 4: Testing Translation Flow

    /// 🧪 Test that translations are generated for selected languages
    func testTranslationsAreGeneratedForSelectedLanguages() async throws {
        print("🧪 Testing translation generation...")

        // 🎭 ARRANGE
        let mockAPI = MockAPIClient()
        let mockToast = ToastManager()

        // Configure translation to succeed
        mockAPI.translateResult = .success(
            TranslationResponse(success: true, translatedContent: "Translated text", error: nil)
        )

        let viewModel = StoryWizardViewModel(
            apiClient: mockAPI,
            toastManager: mockToast
        )

        // Set up story content
        viewModel.storyContent = "Original content"
        viewModel.selectedLanguages = [.spanish, .hindi]

        // 🎬 ACT
        await viewModel.generateTranslations()

        // ✅ ASSERT
        XCTAssertEqual(mockAPI.translateCallCount, 2, "Should translate for each selected language")
        XCTAssertEqual(viewModel.translations.count, 2, "Should have translations for both languages")
        XCTAssertNotNil(viewModel.translations[.spanish], "Should have Spanish translation")
        XCTAssertNotNil(viewModel.translations[.hindi], "Should have Hindi translation")

        print("✅ Test passed! Translations generated correctly.")
    }

    // MARK: - 🏭 Example 5: Using Story Factory

    /// 🧪 Test story factory creates stories with correct workflow stages
    func testStoryFactoryCreatesCorrectStages() {
        print("🧪 Testing story factory...")

        // 🎬 ACT: Create stories at different stages
        let newStory = MockStoryFactory.createNewStory()
        let approvedStory = MockStoryFactory.createApprovedStory()
        let multilingualStory = MockStoryFactory.createMultilingualStory()

        // ✅ ASSERT: Verify each story has the correct stage
        XCTAssertEqual(newStory.workflowStage, .created, "New story should be at 'created' stage")
        XCTAssertEqual(approvedStory.workflowStage, .approved, "Approved story should be at 'approved' stage")
        XCTAssertEqual(multilingualStory.workflowStage, .multilingualTextApproved, "Multilingual story should be at correct stage")

        // Verify visibility matches stage
        XCTAssertFalse(newStory.visible, "New stories shouldn't be visible")
        XCTAssertTrue(approvedStory.visible, "Approved stories should be visible")

        // Verify multilingual story has localizations
        XCTAssertNotNil(multilingualStory.localizations, "Multilingual story should have localizations")
        XCTAssertTrue(multilingualStory.localizations!.count > 0, "Should have at least one localization")

        print("✅ Test passed! Factory creates correct story configurations.")
    }

    // MARK: - 🎨 Example 6: Testing View Model States

    /// 🧪 Test that view model factory creates correct states
    func testViewModelFactoryCreatesCorrectStates() {
        print("🧪 Testing view model factory...")

        // 🎬 ACT: Create view models in different states
        let uploadVM = MockViewModelFactory.createWizardAtUpload()
        let reviewVM = MockViewModelFactory.createWizardAtReview()
        let finalizeVM = MockViewModelFactory.createWizardAtFinalize()
        let errorVM = MockViewModelFactory.createWizardWithUploadError()

        // ✅ ASSERT: Verify each is at the correct step
        XCTAssertEqual(uploadVM.currentStep, .upload, "Should be at upload step")
        XCTAssertEqual(reviewVM.currentStep, .review, "Should be at review step")
        XCTAssertEqual(finalizeVM.currentStep, .finalize, "Should be at finalize step")

        // Verify review VM has populated fields
        XCTAssertFalse(reviewVM.storyTitle.isEmpty, "Review VM should have a title")
        XCTAssertFalse(reviewVM.storyContent.isEmpty, "Review VM should have content")

        // Verify error VM has an error
        XCTAssertNotNil(errorVM.error, "Error VM should have an error set")

        print("✅ Test passed! Factory creates correct view model states.")
    }

    // MARK: - 🎯 Example 7: Testing Navigation

    /// 🧪 Test that wizard navigation works correctly
    func testWizardNavigationFlow() {
        print("🧪 Testing wizard navigation...")

        // 🎭 ARRANGE
        let viewModel = MockViewModelFactory.createWizardAtUpload()

        // ✅ ASSERT: Start at upload
        XCTAssertEqual(viewModel.currentStep, .upload, "Should start at upload")

        // 🎬 ACT: Navigate forward
        viewModel.nextStep()

        // ✅ ASSERT: Should be at analyzing
        XCTAssertEqual(viewModel.currentStep, .analyzing, "Should advance to analyzing")

        // 🎬 ACT: Navigate backward
        viewModel.previousStep()

        // ✅ ASSERT: Should be back at upload
        XCTAssertEqual(viewModel.currentStep, .upload, "Should return to upload")

        print("✅ Test passed! Navigation works correctly.")
    }

    // MARK: - 🔧 Example 8: Testing Validation

    /// 🧪 Test that validation prevents proceeding with invalid data
    func testValidationPreventsInvalidData() {
        print("🧪 Testing validation...")

        // 🎭 ARRANGE
        let viewModel = MockViewModelFactory.createWizardAtReview()

        // 🎬 ACT: Set invalid title (empty)
        viewModel.storyTitle = ""

        // ✅ ASSERT: Should not be able to proceed
        XCTAssertFalse(viewModel.canProceedToReview, "Should not proceed with empty title")

        // 🎬 ACT: Set valid title but too long
        viewModel.storyTitle = String(repeating: "A", count: 150)

        // ✅ ASSERT: Should detect title too long
        XCTAssertTrue(viewModel.isTitleTooLong, "Should detect title exceeding limit")
        XCTAssertFalse(viewModel.canProceedToReview, "Should not proceed with too-long title")

        // 🎬 ACT: Set valid title
        viewModel.storyTitle = "Perfect Title"
        viewModel.storyContent = "Perfect content"

        // ✅ ASSERT: Should allow proceeding
        XCTAssertFalse(viewModel.isTitleTooLong, "Valid title should not be too long")
        XCTAssertTrue(viewModel.canProceedToReview, "Should allow proceeding with valid data")

        print("✅ Test passed! Validation works correctly.")
    }
}

// MARK: - 🎭 Notes for Test Writers

/*
 🌟 Key Testing Patterns Demonstrated:

 1. **AAA Pattern** (Arrange-Act-Assert)
    - Arrange: Set up mocks and test data
    - Act: Execute the code being tested
    - Assert: Verify the expected outcome

 2. **Dependency Injection**
    - Pass mock dependencies to view models
    - Configure mocks before running tests
    - Verify interactions after execution

 3. **Realistic Test Data**
    - Use factories to create consistent, realistic data
    - Keep test data simple but representative
    - Use edge cases to test boundaries

 4. **Isolation**
    - Each test is independent
    - Clean up between tests
    - Don't rely on test execution order

 5. **Clarity**
    - Use descriptive test names
    - Add print statements for debugging
    - Keep assertions focused and clear

 Happy testing! May your code coverage be ever in your favor! ✨
 */
