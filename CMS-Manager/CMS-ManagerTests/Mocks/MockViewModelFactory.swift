//
//  MockViewModelFactory.swift
//  CMS-ManagerTests
//
//  🎭 The ViewModel Factory - Where Test View Models Take the Stage
//
//  "Like a theater company assembling its cast before opening night,
//   this factory creates view models pre-configured for specific scenarios.
//   Empty states, loading states, error states—all ready to perform
//   their roles in our testing drama!"
//
//  - The Spellbinding Museum Director of Test Orchestration
//

import Foundation
import SwiftUI
@testable import CMS_Manager
import ArtfulArchivesCore

// MARK: - 🎭 Mock ViewModel Factory

/// 🌟 A factory for creating pre-configured test view models
///
/// This magical workshop produces view models in various states—empty,
/// populated with data, showing errors, or mid-loading. Perfect for
/// testing UI components in different scenarios! ✨
@MainActor
struct MockViewModelFactory {

    // MARK: - 🧙‍♂️ StoryWizardViewModel Builders

    /// 🎨 Create a fresh StoryWizardViewModel at the upload step
    /// - Parameters:
    ///   - apiClient: The API client to use (defaults to MockAPIClient)
    ///   - toastManager: The toast manager (defaults to new instance)
    ///   - audioPlayer: The audio player (defaults to new AudioPlayer instance)
    ///   - hapticManager: The haptic manager (defaults to new HapticManager instance)
    /// - Returns: A pristine wizard ready to begin the journey
    static func createWizardViewModel(
        apiClient: APIClientProtocol? = nil,
        toastManager: ToastManager? = nil,
        audioPlayer: AudioPlayerProtocol? = nil,
        hapticManager: HapticManager? = nil
    ) -> StoryWizardViewModel {
        let mockClient = (apiClient as? MockAPIClient) ?? MockAPIClient()
        let mockToast = toastManager ?? ToastManager()
        let mockAudioPlayer = audioPlayer ?? AudioPlayer()
        let mockHapticManager = hapticManager ?? HapticManager()

        return StoryWizardViewModel(
            apiClient: mockClient,
            toastManager: mockToast,
            audioPlayer: mockAudioPlayer,
            hapticManager: mockHapticManager
        )
    }

    /// 📸 Create a wizard at the Upload step (Step 1)
    static func createWizardAtUpload() -> StoryWizardViewModel {
        let vm = createWizardViewModel()
        // Already at upload step by default
        return vm
    }

    /// 🔍 Create a wizard at the Analyzing step (Step 2)
    /// Pre-configured with uploaded media ✨
    static func createWizardAtAnalyzing() -> StoryWizardViewModel {
        let vm = createWizardViewModel()
        vm.uploadedMediaId = 42
        vm.uploadedMediaUrl = "https://example.com/test-image.jpg"
        vm.goToStep(.analyzing)
        return vm
    }

    /// ✏️ Create a wizard at the Review step (Step 3)
    /// Pre-populated with AI analysis results 📝
    static func createWizardAtReview() -> StoryWizardViewModel {
        let vm = createWizardViewModel()
        vm.uploadedMediaId = 42
        vm.uploadedMediaUrl = "https://example.com/test-image.jpg"
        vm.analysisResult = CMS_Manager.ImageAnalysisResponse.AnalysisData(
            title: "The Mystical Sunset",
            content: "A breathtaking sunset over mountains with vibrant colors.",
            tags: ["nature", "sunset", "landscape"],
            category: "landscape",
            mood: "peaceful"
        )
        vm.storyTitle = "The Mystical Sunset"
        vm.storyContent = "A breathtaking sunset over mountains with vibrant colors."
        vm.storyTags = ["nature", "sunset", "landscape"]
        vm.storySlug = "mystical-sunset"
        vm.goToStep(.review)
        return vm
    }

    /// 🌐 Create a wizard at the Translation step (Step 4)
    /// Ready to generate translations 🗣️
    static func createWizardAtTranslation() -> StoryWizardViewModel {
        let vm = createWizardAtReview()
        vm.goToStep(.translation)
        return vm
    }

    /// 📝 Create a wizard at the Translation Review step (Step 5)
    /// With completed translations in Spanish and Hindi ✨
    static func createWizardAtTranslationReview() -> StoryWizardViewModel {
        let vm = createWizardAtTranslation()
        vm.selectedLanguages = [.spanish, .hindi]
        vm.translations = [
            .spanish: "Una puesta de sol impresionante sobre las montañas con colores vibrantes.",
            .hindi: "जीवंत रंगों के साथ पहाड़ों पर एक लुभावनी सूर्यास्त।"
        ]
        vm.translatedTitles = [
            .spanish: "El Atardecer Místico",
            .hindi: "रहस्यमय सूर्यास्त"
        ]
        vm.goToStep(.translationReview)
        return vm
    }

    /// 🔊 Create a wizard at the Audio step (Step 6)
    /// Ready to generate audio narrations 🎤
    static func createWizardAtAudio() -> StoryWizardViewModel {
        let vm = createWizardAtTranslationReview()
        vm.goToStep(.audio)
        return vm
    }

    /// 🎉 Create a wizard at the Finalize step (Step 7)
    /// With completed audio for all languages 🎵
    static func createWizardAtFinalize() -> StoryWizardViewModel {
        let vm = createWizardAtAudio()
        vm.audioUrls = [
            .english: "data:audio/mpeg;base64,mock-en-audio",
            .spanish: "data:audio/mpeg;base64,mock-es-audio",
            .hindi: "data:audio/mpeg;base64,mock-hi-audio"
        ]
        vm.goToStep(.finalize)
        return vm
    }

    /// ✅ Create a wizard with a published story
    /// Shows the success state with confetti! 🎊
    static func createWizardWithPublishedStory() -> StoryWizardViewModel {
        let vm = createWizardAtFinalize()
        vm.createdStoryId = 123
        vm.isPublished = true
        vm.showConfetti = true
        return vm
    }

    // MARK: - 🌩️ Error State Builders

    /// 💥 Create a wizard showing an upload error
    static func createWizardWithUploadError() -> StoryWizardViewModel {
        let vm = createWizardViewModel()
        vm.error = .uploadFailed("Failed to upload image: Network timeout")
        return vm
    }

    /// 💥 Create a wizard showing an analysis error
    static func createWizardWithAnalysisError() -> StoryWizardViewModel {
        let vm = createWizardAtAnalyzing()
        vm.error = .serverError(500)
        return vm
    }

    /// 💥 Create a wizard showing a creation error
    static func createWizardWithCreationError() -> StoryWizardViewModel {
        let vm = createWizardAtFinalize()
        vm.error = .serverError(500)
        return vm
    }

    // MARK: - 📊 Loading State Builders

    /// ⏳ Create a wizard in loading state during upload
    static func createWizardLoading() -> StoryWizardViewModel {
        let vm = createWizardViewModel()
        vm.isLoading = true
        vm.uploadProgress = 0.45
        return vm
    }

    /// ⏳ Create a wizard in loading state during analysis
    static func createWizardAnalyzing() -> StoryWizardViewModel {
        let vm = createWizardAtAnalyzing()
        vm.isLoading = true
        vm.analysisProgress = 0.65
        return vm
    }

    /// ⏳ Create a wizard in loading state during translation
    static func createWizardTranslating() -> StoryWizardViewModel {
        let vm = createWizardAtTranslation()
        vm.isLoading = true
        vm.selectedLanguages = [.spanish, .hindi]
        vm.translationProgress = [
            .spanish: 0.8,
            .hindi: 0.3
        ]
        return vm
    }

    /// ⏳ Create a wizard in loading state during audio generation
    static func createWizardGeneratingAudio() -> StoryWizardViewModel {
        let vm = createWizardAtAudio()
        vm.isLoading = true
        vm.selectedLanguages = [.english, .spanish, .hindi]
        vm.audioProgress = [
            .english: 1.0,
            .spanish: 0.6,
            .hindi: 0.2
        ]
        return vm
    }

    // MARK: - 🎨 Edge Case Builders - Testing the Unusual

    /// 📝 Create a wizard with an empty title (should disable proceed button)
    static func createWizardWithEmptyTitle() -> StoryWizardViewModel {
        let vm = createWizardAtReview()
        vm.storyTitle = ""
        return vm
    }

    /// ⚠️ Create a wizard with a too-long title (should show validation error)
    static func createWizardWithLongTitle() -> StoryWizardViewModel {
        let vm = createWizardAtReview()
        vm.storyTitle = String(repeating: "A", count: 150) // Over the 100 char limit
        return vm
    }

    /// 🌐 Create a wizard with no languages selected for translation
    static func createWizardWithNoLanguages() -> StoryWizardViewModel {
        let vm = createWizardAtTranslation()
        vm.selectedLanguages = []
        return vm
    }

    /// 🌐 Create a wizard with all available languages selected
    static func createWizardWithAllLanguages() -> StoryWizardViewModel {
        let vm = createWizardAtTranslation()
        vm.selectedLanguages = Set(LanguageCode.allCases)
        return vm
    }

    /// 🌩️ Create a wizard with some failed translations
    static func createWizardWithFailedTranslations() -> StoryWizardViewModel {
        let vm = createWizardAtTranslationReview()
        vm.selectedLanguages = [.spanish, .hindi]
        vm.translations = [
            .spanish: "Una puesta de sol impresionante"
        ]
        vm.translationErrors = [
            .hindi: "Translation service unavailable"
        ]
        return vm
    }

    /// 🎤 Create a wizard with custom voice selection
    static func createWizardWithCustomVoice() -> StoryWizardViewModel {
        let vm = createWizardAtAudio()
        vm.selectedVoice = .fable
        vm.audioSpeed = 1.2
        return vm
    }

    // MARK: - 🎯 Special Scenarios

    /// 🔄 Create a wizard mid-journey for testing "back" navigation
    static func createWizardMidJourney() -> StoryWizardViewModel {
        createWizardAtTranslation()
    }

    /// 🎬 Create a complete wizard journey for integration testing
    /// Returns a wizard that's been through all the steps 🌟
    static func createCompleteJourney() -> StoryWizardViewModel {
        let vm = createWizardViewModel()

        // Step 1: Upload complete
        vm.uploadedMediaId = 42
        vm.uploadedMediaUrl = "https://example.com/test-image.jpg"

        // Step 2: Analysis complete
        vm.analysisResult = CMS_Manager.ImageAnalysisResponse.AnalysisData(
            title: "The Digital Renaissance",
            content: "A journey through art reimagined for the digital age.",
            tags: ["digital", "art", "modern"],
            category: "art",
            mood: "inspiring"
        )

        // Step 3: Review complete
        vm.storyTitle = "The Digital Renaissance"
        vm.storyContent = "A journey through art reimagined for the digital age."
        vm.storyTags = ["digital", "art", "modern"]
        vm.storySlug = "digital-renaissance"

        // Step 4: Translations selected
        vm.selectedLanguages = [.spanish, .hindi]

        // Step 5: Translations complete
        vm.translations = [
            .spanish: "Un viaje a través del arte reimaginado para la era digital.",
            .hindi: "डिजिटल युग के लिए पुनर्कल्पित कला के माध्यम से एक यात्रा।"
        ]
        vm.translatedTitles = [
            .spanish: "El Renacimiento Digital",
            .hindi: "डिजिटल पुनर्जागरण"
        ]

        // Step 6: Audio generation complete
        vm.audioUrls = [
            .english: "data:audio/mpeg;base64,mock-en",
            .spanish: "data:audio/mpeg;base64,mock-es",
            .hindi: "data:audio/mpeg;base64,mock-hi"
        ]

        // Step 7: At finalize step, ready to publish
        vm.goToStep(.finalize)

        return vm
    }
}
