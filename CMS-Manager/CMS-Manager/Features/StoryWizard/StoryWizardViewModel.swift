//
//  StoryWizardViewModel.swift
//  CMS-Manager
//
//  🎭 The Story Wizard View Model - Grand Orchestrator of the 7-Step Dance
//
//  "Like a mystical conductor leading a cosmic orchestra,
//   this view model guides creators through the sacred journey
//   from image to story, weaving translations, audio, and magic
//   into a symphony of digital storytelling wonder."
//
//  - The Spellbinding Museum Director of Wizard Flows
//

import SwiftUI
import ArtfulArchivesCore

// MARK: - 🎭 Story Wizard View Model

/// 🌟 The conductor of our 7-step symphony - where stories are born
@MainActor
@Observable
final class StoryWizardViewModel {

    // MARK: - 🎯 Step Navigation

    /// 📊 Our current position in the mystical journey
    var currentStep: Step = .upload

    /// 🎭 The Seven Sacred Steps of Story Creation
    enum Step: Int, CaseIterable {
        case upload = 0
        case analyzing = 1
        case review = 2
        case translation = 3
        case translationReview = 4
        case audio = 5
        case finalize = 6

        /// 🎨 Display title for each step
        var title: String {
            switch self {
            case .upload: "Upload"
            case .analyzing: "Analyzing"
            case .review: "Review"
            case .translation: "Translate"
            case .translationReview: "Review Translations"
            case .audio: "Audio"
            case .finalize: "Finalize"
            }
        }

        /// 📜 Subtitle for additional guidance
        var subtitle: String {
            switch self {
            case .upload: "Choose your artwork"
            case .analyzing: "AI discovers the story within"
            case .review: "Perfect your tale"
            case .translation: "Select languages"
            case .translationReview: "Refine translations"
            case .audio: "Add voice to your story"
            case .finalize: "Publish your masterpiece"
            }
        }

        /// 🎯 SF Symbol icon for each step
        var iconName: String {
            switch self {
            case .upload: "photo.badge.plus"
            case .analyzing: "brain.head.profile"
            case .review: "pencil.and.outline"
            case .translation: "globe"
            case .translationReview: "doc.text"
            case .audio: "speaker.wave.3"
            case .finalize: "checkmark.seal.fill"
            }
        }
    }

    // MARK: - 📊 Global State

    /// ✨ Is the wizard currently weaving its magic?
    var isLoading = false

    /// 🌩️ Any storm clouds on the horizon?
    var error: APIError?

    /// 🚨 Flag to trigger error alerts (works around APIError not being Equatable)
    var hasError: Bool = false

    // MARK: - 📸 Step 1: Upload

    /// 📊 Upload progress (0.0 to 1.0)
    var uploadProgress: Double = 0

    /// 🖼️ The chosen artwork from the gallery
    var selectedImage: PlatformImage?

    /// 🆔 Media ID blessed by Strapi
    var uploadedMediaId: Int?

    /// 🌐 URL where our image now resides
    var uploadedMediaUrl: String?

    // MARK: - 🔍 Step 2: Analyze

    /// 📊 Progress of our AI visionary (0.0 to 1.0)
    var analysisProgress: Double = 0

    /// 📝 The wisdom revealed by OpenAI Vision
    var analysisResult: ImageAnalysisResponse.AnalysisData?

    // MARK: - ✏️ Step 3: Review

    /// 📜 The tale's title (editable by our creator)
    var storyTitle: String = ""

    /// 📖 The story's content (editable)
    var storyContent: String = ""

    /// 🏷️ Mystical tags for categorization
    var storyTags: [String] = []

    /// 🔖 URL-friendly identifier for the story
    var storySlug: String = ""

    /// 📝 Pending tag being typed
    var pendingTag: String = ""

    /// 📏 Character count for title
    var titleCharacterCount: Int {
        storyTitle.count
    }

    /// ⚠️ Is the title too long?
    var isTitleTooLong: Bool {
        titleCharacterCount > 100
    }

    /// ✅ Can we proceed to the next step?
    var canProceedToReview: Bool {
        !storyTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        !storyContent.trimmingCharacters(in: .whitespaces).isEmpty &&
        !isTitleTooLong
    }

    // MARK: - 🌐 Step 4: Translation

    /// ✅ Languages chosen for translation
    var selectedLanguages: Set<ArtfulArchivesCore.LanguageCode> = []

    /// 📊 Translation progress per language
    var translationProgress: [ArtfulArchivesCore.LanguageCode: Double] = [:]

    /// 📝 Completed translations awaiting review
    var translations: [ArtfulArchivesCore.LanguageCode: String] = [:]

    /// 🌩️ Translation errors per language - tracking creative challenges
    var translationErrors: [ArtfulArchivesCore.LanguageCode: String] = [:]

    /// 🎭 Translated titles for each language - the story's name in many tongues
    var translatedTitles: [ArtfulArchivesCore.LanguageCode: String] = [:]

    /// ❌ Languages the user cancelled during translation
    var cancelledTranslations: Set<ArtfulArchivesCore.LanguageCode> = []

    // MARK: - 📝 Step 5: Translation Review

    /// ✏️ User-refined translations (uses String keys to support "-title" suffix)
    var editedTranslations: [String: String] = [:]

    // MARK: - 🔊 Step 6: Audio

    /// 🎤 Voice chosen for narration
    var selectedVoice: TTSVoice = .nova

    /// ⚡ Playback speed (0.25 to 4.0)
    var audioSpeed: Double = 0.9

    /// 📊 Audio generation progress per language
    var audioProgress: [ArtfulArchivesCore.LanguageCode: Double] = [:]

    /// 🎵 Generated audio URLs
    var audioUrls: [ArtfulArchivesCore.LanguageCode: String] = [:]

    /// ❌ Languages that had their audio generation cancelled
    var cancelledAudio: Set<ArtfulArchivesCore.LanguageCode> = []

    /// 🔊 Currently playing preview language (if any)
    var currentlyPlayingAudio: LanguageCode?

    /// ▶️ Whether preview audio is playing
    var isAudioPlaying = false

    // MARK: - 🎉 Step 7: Finalize

    /// 🆔 The story's new home in the database
    var createdStoryId: Int?

    /// ✨ Has the story been published?
    var isPublished = false

    /// 🎊 Whether to show confetti celebration
    var showConfetti = false

    /// 📝 A summary of the created story
    var storySummary: StorySummary {
        StorySummary(
            translationsCount: selectedLanguages.count,
            audioCount: audioUrls.count,
            selectedLanguages: selectedLanguages
        )
    }

    /// 📝 Story summary struct
    struct StorySummary {
        let translationsCount: Int
        let audioCount: Int
        let selectedLanguages: Set<ArtfulArchivesCore.LanguageCode>
    }

    // MARK: - 🔗 Dependencies

    /// 🌐 Our faithful messenger to the backend
    private let apiClient: APIClientProtocol

    /// 🍞 The herald of notifications
    private let toastManager: ToastManager

    /// 🎵 The maestro of audio playback
    private let audioPlayer: AudioPlayerProtocol

    /// 🌟 The maestro of tactile feedback
    private let hapticManager: HapticManager

    /// 🧙‍♂️ Task cancellation for async operations
    /// nonisolated(unsafe) is required for @Observable classes
    /// Safe here since Task cancellation is thread-safe
    nonisolated(unsafe) private var currentTask: Task<Void, Never>?

    // MARK: - 🌟 Initialization

    /// ✨ Awaken the wizard with its mystical companions
    /// - Parameters:
    ///   - apiClient: The API client for backend communication
    ///   - toastManager: The toast notification manager
    ///   - audioPlayer: The audio player for preview playback
    ///   - hapticManager: The haptic feedback manager
    init(
        apiClient: APIClientProtocol,
        toastManager: ToastManager,
        audioPlayer: AudioPlayerProtocol,
        hapticManager: HapticManager
    ) {
        self.apiClient = apiClient
        self.toastManager = toastManager
        self.audioPlayer = audioPlayer
        self.hapticManager = hapticManager
    }

    // MARK: - 🎯 Navigation Actions

    /// ➡️ Advance to the next step in our journey
    func nextStep() {
        let nextStepValue = currentStep.rawValue + 1
        guard let nextStep = Step(rawValue: nextStepValue) else {
            return
        }

        // 🌟 Light haptic for forward progress
        hapticManager.lightImpact()

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentStep = nextStep
        }
    }

    /// ⬅️ Return to the previous step
    func previousStep() {
        let previousStepValue = currentStep.rawValue - 1
        guard let previousStep = Step(rawValue: previousStepValue) else {
            return
        }

        // 🌟 Medium haptic for backward navigation
        hapticManager.mediumImpact()

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentStep = previousStep
        }
    }

    /// 🎯 Jump directly to a specific step
    /// - Parameter step: The destination step
    func goToStep(_ step: Step) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentStep = step
        }
    }

    /// Convenience wrapper used by SwiftUI views for semantic naming
    func goToNextStep() {
        nextStep()
    }

    /// Convenience wrapper used by SwiftUI views for semantic naming
    func goToPreviousStep() {
        previousStep()
    }

    // MARK: - 📸 Step 1: Upload Actions

    /// 📤 Send our chosen image to the cloud
    /// - Parameter fileURL: The local file URL to upload
    func uploadImage(fileURL: URL) async {
        print("📤 ✨ IMAGE UPLOAD AWAKENS! \(fileURL.lastPathComponent)")

        isLoading = true
        error = nil

        do {
            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled before API call")
                return
            }

            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled before API call")
                return
            }

            let response = try await apiClient.uploadMedia(file: fileURL)

            uploadedMediaId = response.id
            uploadedMediaUrl = response.url

            print("🎉 ✨ UPLOAD MASTERPIECE COMPLETE! Media ID: \(response.id)")

            // 🎉 Success haptic for upload completion
            hapticManager.success()

            toastManager.success("Upload Complete", message: "Your artwork is ready for analysis")

            // Auto-advance to analyzing step
            nextStep()

        } catch {
            print("🌩️ Upload failed: \(error.localizedDescription)")
            self.error = error as? APIError ?? .unknown(error)

            // 💥 Error haptic for upload failure
            hapticManager.error()

            toastManager.error("Upload Failed", message: error.localizedDescription)
        }

        isLoading = false
    }

    // MARK: - 🔍 Step 2: Analyze Actions

    /// 🧠 Summon OpenAI Vision to reveal the story within
    /// - Parameter imageUrl: The URL of the image to analyze
    func analyzeImage(imageUrl: String? = nil) async {
        print("🧠 ✨ IMAGE ANALYSIS AWAKENS!")

        isLoading = true
        error = nil
        analysisProgress = 0

        // Use uploaded URL or provided URL
        guard let urlString = imageUrl ?? uploadedMediaUrl else {
            error = .uploadFailed("No image URL available")
            isLoading = false
            return
        }

        // Animate progress for visual feedback
        animateProgress(from: 0, to: 0.9, duration: 2.0) { progress in
            self.analysisProgress = progress
        }

        do {
            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled before API call")
                return
            }

            let response = try await apiClient.analyzeImage(url: urlString, prompt: nil)

            // 🔍 Check again after async call
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled after API call")
                return
            }

            guard response.success, let data = response.data else {
                throw APIError.invalidResponse
            }

            analysisResult = data
            analysisProgress = 1.0

            // Populate review fields with AI suggestions
            storyTitle = data.title
            storyContent = data.content
            storyTags = data.tags
            storySlug = generateSlug(from: data.title)

            print("🎉 ✨ ANALYSIS MASTERPIECE COMPLETE!")
            print("   Title: \(data.title)")
            print("   Tags: \(data.tags.joined(separator: ", "))")

            // 🎉 Success haptic for analysis completion
            hapticManager.success()

            toastManager.success("Analysis Complete", message: "Your story awaits refinement")

            // Auto-advance to review step
            await MainActor.run {
                nextStep()
            }

        } catch {
            // 🔍 Don't show error if task was cancelled
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled during processing")
                return
            }

            print("🌩️ Analysis failed: \(error.localizedDescription)")
            self.error = error as? APIError ?? .unknown(error)

            // 💥 Error haptic for analysis failure
            hapticManager.error()

            toastManager.error("Analysis Failed", message: error.localizedDescription)
        }

        isLoading = false
    }


    /// 🚫 Cancel the ongoing image analysis
    /// Gracefully halts the AI vision process and returns to upload step
    func cancelAnalysis() {
        print("🚫 ✨ ANALYSIS CANCELLATION INITIATED!")

        // Cancel any running task
        currentTask?.cancel()
        currentTask = nil

        // Reset analysis state
        analysisProgress = 0
        analysisResult = nil
        error = nil
        isLoading = false

        // Return to upload step
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentStep = .upload
        }

        toastManager.info("Analysis Cancelled", message: "Returned to upload step")
        print("🌙 ✨ Analysis cancelled - wizard returned to upload step")
    }

    // MARK: - 🌐 Step 4: Translation Actions

    /// Entry point for the UI to begin the translation process
    func startTranslations() async {
        await generateTranslations()
    }

    /// Allow the user to cancel a translation while tasks are running
    func cancelTranslation(_ language: LanguageCode) {
        cancelledTranslations.insert(language)
        translationProgress[language] = 0
        translations.removeValue(forKey: language)
    }

    /// 🌐 Weave translations in the chosen tongues - parallel processing with error tracking
    /// Because sometimes the cosmic translator needs a coffee break ☕
    func generateTranslations() async {
        print("🌐 ✨ TRANSLATION ORCHESTRA AWAKENS! \(selectedLanguages.count) languages")

        isLoading = true
        error = nil
        cancelledTranslations = []

        // Reset translation state
        translations = [:]
        translationProgress = [:]
        editedTranslations = [:]
        translationErrors = [:]
        translatedTitles = [:]

        // Initialize progress for all selected languages
        for language in selectedLanguages {
            translationProgress[language] = 0
        }

        // 🎭 Translate each language in parallel - the grand symphony of tongues!
        await withTaskGroup(of: (LanguageCode, TranslationResult).self) { group in
            for language in selectedLanguages {
                group.addTask {
                    await self.translateLanguage(language)
                }
            }

            // 🎪 Collect results as they complete - each language a new act in our show
            for await (language, result) in group {
                guard !cancelledTranslations.contains(language) else {
                    translationProgress[language] = 0
                    continue
                }

                switch result {
                case .success(let content, let title):
                    // 🎉 Success! The language learned its lines perfectly
                    translations[language] = content
                    translatedTitles[language] = title
                    translationProgress[language] = 1.0
                    translationErrors.removeValue(forKey: language)

                    // 🌟 Light haptic for each translation completion
                    hapticManager.lightImpact()

                case .failure(let errorMessage):
                    // 🌩️ A temporary storm - we'll track it for retry
                    translationErrors[language] = errorMessage
                    translationProgress[language] = 0
                }
            }
        }

        let successCount = translations.count
        let failureCount = translationErrors.count

        if failureCount > 0 {
            print("⚠️ ✨ TRANSLATION SYMPHONY COMPLETE WITH INTERMISSIONS! \(successCount) translations, \(failureCount) awaiting retry")

            // ⚠️ Warning haptic for partial completion
            hapticManager.warning()

            toastManager.warning("Translations Partially Complete", message: "\(successCount) successful, \(failureCount) failed")
        } else {
            print("🎉 ✨ TRANSLATION MASTERPIECE COMPLETE! \(successCount) translations")

            // 🎉 Success haptic when all translations complete
            hapticManager.success()

            toastManager.success("Translations Complete", message: "\(successCount) languages ready for review")
        }

        isLoading = false
    }

    /// 🎭 Retry translation for a specific language - because everyone deserves a second chance
    /// Sometimes the cosmic internet hiccups, and we just need to try again! 🌠
    func retryTranslation(_ language: LanguageCode) async {
        print("🔄 ✨ RETRYING TRANSLATION for \(language.name)...")

        // 🧹 Clear the error state
        translationErrors.removeValue(forKey: language)
        cancelledTranslations.remove(language)
        translationProgress[language] = 0

        // 🎪 Attempt the translation again
        let result = await translateLanguage(language)

        switch result.1 {
        case .success(let content, let title):
            translations[language] = content
            translatedTitles[language] = title
            translationProgress[language] = 1.0
            toastManager.success("Retry Successful", message: "\(language.name) translation complete")

        case .failure(let errorMessage):
            translationErrors[language] = errorMessage
            translationProgress[language] = 0
            toastManager.error("Retry Failed", message: "Translation for \(language.name) failed again")
        }
    }

    /// 🎤 Translate content AND title for a single language
    /// Because a story deserves to shine in every tongue, name and all! ✨
    /// - Parameter language: The target language
    /// - Returns: The language code and translation result
    private func translateLanguage(_ language: LanguageCode) async -> (LanguageCode, TranslationResult) {
        print("🌐 ✨ Translating content and title to \(language.name)...")

        do {
            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Translation cancelled before API call")
                return (language, .failure(error: "Translation cancelled by user"))
            }

            // 🎭 First act: Translate the story content
            let contentResponse = try await apiClient.translate(
                content: storyContent,
                targetLanguage: language.rawValue
            )

            guard contentResponse.success, let translatedContent = contentResponse.translatedContent else {
                throw APIError.invalidResponse
            }

            // 🎨 Second act: Translate the story title
            let titleResponse = try await apiClient.translate(
                content: storyTitle,
                targetLanguage: language.rawValue
            )

            guard titleResponse.success, let translatedTitle = titleResponse.translatedContent else {
                // 🌙 Content succeeded but title failed - we'll use the content and note the title issue
                print("⚠️ Title translation failed for \(language.name), using content only")
                return (language, .success(content: translatedContent, title: storyTitle))
            }

            print("✨ Translation complete for \(language.name)")
            return (language, .success(content: translatedContent, title: translatedTitle))

        } catch {
            print("🌩️ Translation failed for \(language.name): \(error)")
            let errorMessage: String

            // 🎭 Create a friendly, mystical error message
            if let apiError = error as? APIError {
                switch apiError {
                case .networkError:
                    errorMessage = "🌊 The network waves are turbulent - please try again"
                case .invalidResponse:
                    errorMessage = "🔮 The translation oracle gave an unclear answer"
                case .unauthorized:
                    errorMessage = "🚫 The translation gates require proper credentials"
                default:
                    errorMessage = "🌩️ A temporary creative challenge occurred"
                }
            } else {
                errorMessage = "🌩️ \(error.localizedDescription)"
            }

            return (language, .failure(error: errorMessage))
        }
    }

    /// 🎭 Translation result - success with content and title, or failure with friendly error
    private enum TranslationResult {
        case success(content: String, title: String)
        case failure(error: String)
    }

    // MARK: - 🔊 Step 6: Audio Actions

    /// Entry point used by SwiftUI to kick off audio generation
    func startAudioGeneration() async {
        await generateAudio()
    }

    /// Allow the user to cancel generation for a specific language
    func cancelAudioGeneration(_ language: LanguageCode) {
        cancelledAudio.insert(language)
        audioProgress[language] = 0
        audioUrls.removeValue(forKey: language)
    }

    /// 🎵 Play audio preview for a specific language
    /// - Parameter language: The language audio to play
    func playAudio(for language: LanguageCode) {
        guard let audioUrl = audioUrls[language] else { return }

        print("🎵 ✨ AUDIO PREVIEW AWAKENS! Language: \(language.name)")

        // 🌟 Light haptic for audio playback start
        hapticManager.lightImpact()

        Task {
            do {
                // 🎵 Play the audio through the audio player
                try await audioPlayer.play(url: audioUrl)

                // ⚡ Apply the selected playback speed (cast to concrete type)
                if let concretePlayer = audioPlayer as? AudioPlayer {
                    concretePlayer.setRate(Float(audioSpeed))
                }

                // 📊 Update playback state
                await MainActor.run {
                    currentlyPlayingAudio = language
                    isAudioPlaying = true
                }

                print("🎉 ✨ AUDIO PREVIEW PLAYING! Speed: \(audioSpeed)x")
            } catch {
                print("🌩️ Audio preview failed: \(error.localizedDescription)")
                await MainActor.run {
                    toastManager.error("Playback Failed", message: error.localizedDescription)
                    isAudioPlaying = false
                    currentlyPlayingAudio = nil
                }
            }
        }
    }

    /// ⏹️ Stop any in-progress playback preview
    func stopAudio() {
        print("⏹️ Stopping audio preview")

        // 🌟 Light haptic for audio stop
        hapticManager.lightImpact()

        audioPlayer.stop()
        isAudioPlaying = false
        currentlyPlayingAudio = nil
    }

    /// 🎵 Summon audio narrations for all translations
    func generateAudio() async {
        print("🎵 ✨ AUDIO ORCHESTRA AWAKENS!")

        isLoading = true
        error = nil
        cancelledAudio = []
        currentlyPlayingAudio = nil
        isAudioPlaying = false

        // Reset audio state
        audioUrls = [:]
        audioProgress = [:]

        // 📝 Use English text + all translations (with edited versions if available!)
        let languagesToGenerate: [(ArtfulArchivesCore.LanguageCode, String)] = [(ArtfulArchivesCore.LanguageCode.english, storyContent)] +
            translations.map { language, originalText in
                // ✨ Use edited translation if available, otherwise use original
                let text = getFinalTranslation(for: language)
                return (language, text)
            }

        // Initialize progress
        for (language, _) in languagesToGenerate {
            audioProgress[language] = 0
        }

        // Generate audio in parallel
        await withTaskGroup(of: (LanguageCode, String).self) { group in
            for (language, text) in languagesToGenerate {
                group.addTask {
                    await self.generateAudioFor(language: language, text: text)
                }
            }

            for await (language, url) in group {
                guard !cancelledAudio.contains(language) else {
                    audioProgress[language] = 0
                    continue
                }

                audioUrls[language] = url
                audioProgress[language] = 1.0
            }
        }

        print("🎉 ✨ AUDIO MASTERPIECE COMPLETE! \(audioUrls.count) tracks")

        // 🎉 Success haptic for audio generation completion
        hapticManager.success()

        toastManager.success("Audio Complete", message: "\(audioUrls.count) narration tracks ready")

        isLoading = false
    }

    /// 🎤 Generate audio for a single language
    /// - Parameters:
    ///   - language: The target language
    ///   - text: The text to convert to speech
    /// - Returns: The audio URL
    private func generateAudioFor(language: LanguageCode, text: String) async -> (LanguageCode, String) {
        print("🎤 ✨ Generating audio for \(language.name) at \(audioSpeed)x speed...")

        do {
            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Audio generation cancelled before API call")
                return (language, "")
            }

            let response = try await apiClient.generateAudio(
                text: text,
                language: language.rawValue,
                voice: selectedVoice,
                speed: audioSpeed
            )

            guard response.success, let audioUrl = response.audioUrl else {
                throw APIError.invalidResponse
            }

            print("✨ Audio complete for \(language.name)")
            return (language, audioUrl)

        } catch {
            print("🌩️ Audio generation failed for \(language.name): \(error)")
            return (language, "")
        }
    }

    // MARK: - 🎉 Step 7: Finalize Actions

    /// 💾 Save story as draft
    func saveDraft() async {
        await createStory(asDraft: true)
    }
    
    /// 🚀 Publish the story (not as draft)
    func publishStory() async {
        await createStory(asDraft: false)
    }
    
    /// 🚀 Bring the story into existence (as draft or published)
    /// - Parameter asDraft: If true, saves as draft; if false, publishes immediately
    func createStory(asDraft: Bool = true) async {
        print("🚀 ✨ STORY CREATION AWAKENS! Mode: \(asDraft ? "Draft" : "Published")")

        isLoading = true
        error = nil
        hasError = false  // Reset error flag for new attempt

        do {
            // 🔍 Check if we've been cancelled before making API call
            guard !Task.isCancelled else {
                print("🌙 ✨ Analysis cancelled before API call")
                return
            }

            // Build the complete story request
            let request = StoryCreateRequest(
                title: storyTitle,
                content: storyContent,
                imageId: uploadedMediaId,
                imageUrl: uploadedMediaUrl,
                audioDuration: nil
            )

            let response = try await apiClient.createStoryComplete(request: request, asDraft: asDraft)

            guard response.success,
                  let storyId = response.storyId,
                  let storyData = response.storyData else {
                throw APIError.invalidResponse
            }

            createdStoryId = storyId
            isPublished = !asDraft // Only mark as published if we explicitly published

            print("🎉 ✨ STORY MASTERPIECE COMPLETE! Story ID: \(storyId), Status: \(asDraft ? "Draft" : "Published")")

            // 🎊 CELEBRATION haptic sequence for successful creation!
            hapticManager.celebrate()

            if asDraft {
                toastManager.success("Draft Saved!", message: "Your story has been saved as a draft")
            } else {
                toastManager.success("Story Published!", message: "Your masterpiece is now live")
            }

        } catch {
            print("🌩️ Story creation failed: \(error.localizedDescription)")
            self.error = error as? APIError ?? .unknown(error)
            self.hasError = true  // 🚨 Trigger error alert in UI

            // 💥 Error haptic for creation failure
            hapticManager.error()

            toastManager.error("Creation Failed", message: error.localizedDescription)
        }

        isLoading = false
    }

    // MARK: - 🔧 Helper Methods

    /// ✨ Get the final translation for a language (edited version if available, otherwise original)
    /// This ensures audio generation uses the user's refined translations! 🎨
    /// - Parameter language: The language to retrieve
    /// - Returns: The final translation text (edited or original)
    func getFinalTranslation(for language: LanguageCode) -> String {
        let contentKey = "\(language.rawValue)-content"
        return editedTranslations[contentKey] ?? translations[language] ?? ""
    }

    /// ✨ Get the final translated title for a language (edited version if available, otherwise original)
    /// - Parameter language: The language to retrieve
    /// - Returns: The final translated title (edited or original)
    func getFinalTranslatedTitle(for language: LanguageCode) -> String {
        let titleKey = "\(language.rawValue)-title"
        return editedTranslations[titleKey] ?? translatedTitles[language] ?? storyTitle
    }

    /// 🎯 Populate review fields from analysis result
    func populateFromAnalysis() {
        guard let data = analysisResult else { return }
        storyTitle = data.title
        storyContent = data.content
        storyTags = data.tags
        storySlug = generateSlug(from: data.title)
    }

    /// 🏷️ Add a tag to the story
    func addTag() {
        let tag = pendingTag.trimmingCharacters(in: .whitespaces)
        guard !tag.isEmpty, !storyTags.contains(tag) else { return }
        storyTags.append(tag)
        pendingTag = ""

        // 🌟 Light haptic for adding tag
        hapticManager.lightImpact()
    }

    /// 🗑️ Remove a tag from the story
    /// - Parameter tag: The tag to remove
    func removeTag(_ tag: String) {
        storyTags.removeAll { $0 == tag }

        // 🌟 Light haptic for removing tag
        hapticManager.lightImpact()
    }

    /// 🔖 Generate a URL-friendly slug from a title
    /// - Parameter title: The source title
    /// - Returns: A slugified string
    func generateSlug() {
        storySlug = generateSlug(from: storyTitle)
    }

    /// 🔖 Generate a URL-friendly slug from a title
    /// - Parameter title: The source title
    /// - Returns: A slugified string
    private func generateSlug(from title: String) -> String {
        title
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
            .replacingOccurrences(of: "[^a-z0-9\\s]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
    }

    /// 🎭 Animate a progress value over time
    /// - Parameters:
    ///   - from: Starting value
    ///   - to: Ending value
    ///   - duration: Animation duration in seconds
    ///   - update: Closure called with each progress value
    private func animateProgress(
        from: Double,
        to: Double,
        duration: TimeInterval,
        update: @escaping (Double) -> Void
    ) {
        let steps = 60
        let stepDuration = duration / Double(steps)
        let increment = (to - from) / Double(steps)

        currentTask?.cancel()
        currentTask = Task { @MainActor in
            for i in 0...steps {
                try? await Task.sleep(nanoseconds: UInt64(stepDuration * 1_000_000_000))
                guard !Task.isCancelled else { return }
                update(from + (increment * Double(i)))
            }
        }
    }

    /// 🧹 Reset the wizard to its initial state
    func reset() {
        currentStep = .upload
        isLoading = false
        error = nil
        selectedImage = nil
        uploadedMediaId = nil
        uploadedMediaUrl = nil
        analysisProgress = 0
        analysisResult = nil
        storyTitle = ""
        storyContent = ""
        storyTags = []
        storySlug = ""
        pendingTag = ""
        selectedLanguages = []
        translationProgress = [:]
        translations = [:]
        translationErrors = [:]
        translatedTitles = [:]
        cancelledTranslations = []
        editedTranslations = [:]
        selectedVoice = .nova
        audioSpeed = 0.9
        audioProgress = [:]
        audioUrls = [:]
        cancelledAudio = []
        currentlyPlayingAudio = nil
        isAudioPlaying = false
        createdStoryId = nil
        isPublished = false
        showConfetti = false
        currentTask?.cancel()
        currentTask = nil

        print("🧹 ✨ WIZARD RESET COMPLETE! Ready for a new tale.")
    }


    // MARK: - 💀 Deinitialization

    /// 💀 Clean up when the wizard departs
    deinit {
        currentTask?.cancel()
    }
}

// MARK: - 🖼️ Platform Image Type Alias

/// 🖼️ Platform-specific image type
#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif
