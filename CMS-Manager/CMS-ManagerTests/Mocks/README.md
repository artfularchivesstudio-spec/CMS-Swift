# 🎭 Test Mocks Infrastructure

Welcome to the mystical realm of test doubles! This directory contains the mock infrastructure for testing the CMS-Manager app.

## 📚 What's Inside

### 🌐 MockAPIClient.swift
A complete mock implementation of `APIClientProtocol` with:
- ✅ Configurable success/failure responses for all API methods
- 📊 Call count tracking for verification
- 🎬 Parameter capture for assertion testing
- 🧹 Reset functionality for clean test setup

**Usage Example:**
```swift
let mockClient = MockAPIClient()
mockClient.uploadMediaResult = .success(mockUploadResponse)
let response = try await mockClient.uploadMedia(file: testURL)
XCTAssertEqual(mockClient.uploadMediaCallCount, 1)
```

### 🏭 MockStoryFactory.swift
Factory methods for creating realistic Story instances:
- 📖 Basic stories with sensible defaults
- 🎭 Stories at different workflow stages
- 📚 Collections for list view testing
- 🌈 Edge cases and special scenarios

**Usage Example:**
```swift
let newStory = MockStoryFactory.createNewStory()
let approvedStory = MockStoryFactory.createApprovedStory()
let collection = MockStoryFactory.createStoryCollection()
```

### 🎬 MockViewModelFactory.swift
Pre-configured view models for testing UI in different states:
- 📸 Wizard at each step (upload, analyze, review, etc.)
- ⏳ Loading states with progress
- 💥 Error states for failure testing
- ✅ Success states with completed data

**Usage Example:**
```swift
let wizardAtReview = MockViewModelFactory.createWizardAtReview()
let wizardLoading = MockViewModelFactory.createWizardLoading()
let wizardWithError = MockViewModelFactory.createWizardWithUploadError()
```

### 🎨 MockDataFactories.swift
Utilities for creating test fixtures:
- 🖼️ **MockImageFactory**: Generate test UIImages/NSImages
- 🔍 **MockAnalysisFactory**: AI analysis responses
- 🌐 **MockTranslationFactory**: Translation responses
- 🔊 **MockAudioFactory**: Audio generation responses
- 📦 **MockResponseFactory**: General API responses

**Usage Example:**
```swift
let testImage = MockImageFactory.createImage(color: .blue)
let analysis = MockAnalysisFactory.createArtworkAnalysis()
let translation = MockTranslationFactory.createSpanishTranslation(for: "Hello")
let audioResponse = MockAudioFactory.createAudioResponse(for: .spanish)
```

## 🎯 Quick Start Guide

### Testing a ViewModel
```swift
@MainActor
class MyViewModelTests: XCTestCase {
    func testUploadFlow() async {
        // 1. Create mock API client
        let mockAPI = MockAPIClient()
        let mockToast = ToastManager()

        // 2. Configure expected responses
        mockAPI.uploadMediaResult = .success(
            MockResponseFactory.createUploadResponse()
        )

        // 3. Create view model with mock dependencies
        let viewModel = StoryWizardViewModel(
            apiClient: mockAPI,
            toastManager: mockToast
        )

        // 4. Execute the action
        let testURL = MockImageFactory.createTemporaryImageFile()
        await viewModel.uploadImage(fileURL: testURL)

        // 5. Verify the results
        XCTAssertEqual(mockAPI.uploadMediaCallCount, 1)
        XCTAssertNotNil(viewModel.uploadedMediaId)
    }
}
```

### Testing UI Components
```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Empty state
            MyView(viewModel: MockViewModelFactory.createWizardAtUpload())

            // Loading state
            MyView(viewModel: MockViewModelFactory.createWizardLoading())

            // Success state
            MyView(viewModel: MockViewModelFactory.createWizardWithPublishedStory())

            // Error state
            MyView(viewModel: MockViewModelFactory.createWizardWithUploadError())
        }
    }
}
```

## 🎨 Design Patterns

### Configurable Results
Mocks use `Result<Success, Error>` for flexible testing:
```swift
// Test success path
mockAPI.analyzeImageResult = .success(analysisResponse)

// Test failure path
mockAPI.analyzeImageResult = .failure(APIError.serverError(500))
```

### Call Tracking
All mocks track how many times methods are called:
```swift
await mockAPI.uploadMedia(file: url)
await mockAPI.uploadMedia(file: url)
XCTAssertEqual(mockAPI.uploadMediaCallCount, 2)
```

### Parameter Capture
Verify what arguments were passed:
```swift
await mockAPI.translate(content: "Hello", targetLanguage: "es")
XCTAssertEqual(mockAPI.lastTranslationContent, "Hello")
XCTAssertEqual(mockAPI.lastTranslationLanguage, "es")
```

## 🧹 Best Practices

1. **Reset Between Tests**: Use `mockAPI.reset()` in `setUp()` or `tearDown()`
2. **Explicit Configuration**: Always set expected results before running tests
3. **Realistic Data**: Use factories to create realistic test data
4. **Test Edge Cases**: Use specialized factory methods for edge cases
5. **Clean Up Resources**: Delete temporary files after tests

## 🌟 Adding New Mocks

When adding new API methods or view models:

1. Add the method to `MockAPIClient` with:
   - Call count tracking
   - Configurable result property
   - Parameter capture (if needed)
   - Implementation that returns/throws based on result

2. Add factory methods to create common scenarios

3. Update this README with usage examples

## 🎭 Philosophy

> "Good mocks are like good actors—they know their lines perfectly,
> hit their marks every time, and make testing a joy rather than a chore.
> These mocks are your co-stars in the theater of testing!" ✨
>
> — The Spellbinding Museum Director of Test Infrastructure

---

Happy Testing! 🧪✨
