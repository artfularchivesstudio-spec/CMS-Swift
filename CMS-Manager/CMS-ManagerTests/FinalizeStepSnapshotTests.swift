/**
 * 🎭 The Finalize Step Snapshot Tests - Grand Finale Verification
 *
 * "At journey's end, where all the threads converge into a magnificent tapestry,
 * we capture the moment of triumph—the summary of creation, the celebration
 * of publication, the confetti of success. Every pixel must radiate the joy
 * of a story ready to meet its audience across devices and lighting conditions."
 *
 * - The Spellbinding Museum Director of Culmination Validation
 */

import XCTest
import SwiftUI
import SnapshotTesting
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 🎉 Finalize Step Snapshot Tests

/// 🌟 Comprehensive snapshot tests for FinalizeStepView
///
/// Tests the final review and publication UI including summary cards,
/// publishing states, success animations, and celebration confetti.
@MainActor
final class FinalizeStepSnapshotTests: XCTestCase {

    // MARK: - 🎨 Test Configuration

    /// 📸 Set to true to record new reference snapshots
    private let recordMode = false

    /// 📱 Standard device configurations
    private let testDevices: [DeviceConfiguration] = DeviceConfiguration.iPhoneEssentials

    // MARK: - 🧹 Setup & Teardown

    override func setUp() {
        super.setUp()
        // 🌟 Ensure clean test environment
    }

    // MARK: - 📋 Summary View Tests

    /// 📋 Test summary view - complete story overview
    ///
    /// When: User arrives at finalize step with complete story
    /// Expect: Summary cards showing title, content, images, languages, audio
    /// Tests: Light + dark mode on all devices
    func testSummaryView() {
        // 🏭 Create wizard at finalize with complete data
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 📋 Test summary with English only - minimal multilingual
    ///
    /// When: Story has English content but no translations
    /// Expect: Summary shows English-only status
    /// Tests: Light + dark mode on standard device
    func testSummaryEnglishOnly() {
        // 🏭 Create wizard with English only
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.selectedLanguages = [.en]
        viewModel.translations = [:]
        viewModel.audioUrls = [.en: "data:audio/mpeg;base64,mock-en"]

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 📋 Test summary with full multilingual - the complete package
    ///
    /// When: Story has translations and audio in multiple languages
    /// Expect: Summary shows all languages, all audio tracks
    /// Tests: Light + dark mode on all devices
    func testSummaryFullMultilingual() {
        // 🏭 Create wizard with complete multilingual content
        let viewModel = MockViewModelFactory.createCompleteJourney()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 📋 Test story preview card - before publishing
    ///
    /// When: Story preview shows final content
    /// Expect: Title, excerpt, image preview, metadata
    /// Tests: Light + dark mode on standard device
    func testStoryPreviewCard() {
        // 🏭 Create wizard at finalize
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🔄 Publishing State Tests

    /// ⏳ Test publishing state - in progress
    ///
    /// When: User clicks publish and request is processing
    /// Expect: Loading spinner, publish button disabled, progress message
    /// Tests: Light + dark mode on all devices
    func testPublishingState() {
        // 🏭 Create wizard in publishing state
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.isLoading = true

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// ⏳ Test initial state - ready to publish
    ///
    /// When: User first sees finalize step, hasn't published yet
    /// Expect: Publish button enabled, summary visible, no confetti
    /// Tests: Light + dark mode on standard device
    func testInitialStateReadyToPublish() {
        // 🏭 Create wizard ready to publish
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.isPublished = false
        viewModel.showConfetti = false

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - ✅ Success State Tests

    /// ✅ Test success state - story published!
    ///
    /// When: Story successfully published to backend
    /// Expect: Success checkmark, confetti animation, celebration message
    /// Tests: Light + dark mode on all devices
    func testSuccessState() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 🎊 Test success with confetti - celebration time!
    ///
    /// When: Success animation plays with confetti
    /// Expect: Animated confetti particles, success checkmark scaling
    /// Tests: Light mode on standard device (confetti is colorful!)
    func testSuccessWithConfetti() {
        // 🏭 Create wizard showing confetti
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()
        viewModel.showConfetti = true

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// ✅ Test success message and actions
    ///
    /// When: Story is published successfully
    /// Expect: "View Story" button, "Create Another" button, share button
    /// Tests: Light + dark mode on standard device
    func testSuccessActionsButtons() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🌩️ Error State Tests

    /// 💥 Test publication error - network failure
    ///
    /// When: Publishing fails due to network/server error
    /// Expect: Error message, retry button, error alert
    /// Tests: Light + dark mode on standard device
    func testPublicationError() {
        // 🏭 Create wizard with creation error
        let viewModel = MockViewModelFactory.createWizardWithCreationError()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 💥 Test validation error - missing required data
    ///
    /// When: User tries to publish with missing required fields
    /// Expect: Publish button disabled, validation message
    /// Tests: Light mode on standard device
    func testValidationError() {
        // 🏭 Create wizard with missing data
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.storyTitle = "" // Missing title!

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 💥 Test retry after error
    ///
    /// When: User retries publishing after initial failure
    /// Expect: Loading state reappears, error clears
    /// Tests: Light mode on standard device
    func testRetryAfterError() {
        // 🏭 Create wizard retrying publication
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.isLoading = true
        viewModel.error = nil // Error cleared for retry

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 📊 Summary Components Tests

    /// 📊 Test translations summary section
    ///
    /// When: Summary shows translation details
    /// Expect: List of languages, checkmarks for completed translations
    /// Tests: Light + dark mode on standard device
    func testTranslationsSummary() {
        // 🏭 Create wizard with translations
        let viewModel = MockViewModelFactory.createCompleteJourney()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🔊 Test audio summary section
    ///
    /// When: Summary shows audio generation details
    /// Expect: List of languages with audio, voice used, speed setting
    /// Tests: Light + dark mode on standard device
    func testAudioSummary() {
        // 🏭 Create wizard with audio
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 📸 Test image summary
    ///
    /// When: Summary shows uploaded image
    /// Expect: Image thumbnail, dimensions, file info
    /// Tests: Light + dark mode
    func testImageSummary() {
        // 🏭 Create wizard with image
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 📝 Test content summary
    ///
    /// When: Summary shows story content
    /// Expect: Title, excerpt, word count, character count
    /// Tests: Light mode on standard device
    func testContentSummary() {
        // 🏭 Create wizard with content
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 📱 Device-Specific Tests

    /// 📱 Test on iPad - spacious summary layout
    ///
    /// When: Finalize step viewed on iPad
    /// Expect: Multi-column summary cards, larger preview
    /// Tests: Light + dark mode on iPad Pro 11"
    func testIPadLayout() {
        // 🏭 Create wizard with complete data
        let viewModel = MockViewModelFactory.createCompleteJourney()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPadPro11],
            record: recordMode
        )
    }

    /// 📱 Test on iPhone SE - compact summary
    ///
    /// When: Finalize step on smallest screen
    /// Expect: Stacked summary cards, compact text
    /// Tests: Light + dark mode on iPhone SE
    func testCompactLayout() {
        // 🏭 Create wizard at finalize
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhoneSE3rd],
            record: recordMode
        )
    }

    /// 📱 Test large screen success - confetti everywhere!
    ///
    /// When: Success state on large screen
    /// Expect: Full-screen confetti, dramatic celebration
    /// Tests: Light mode on iPhone 15 Pro Max
    func testLargeScreenSuccess() {
        // 🏭 Create wizard with success
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone15ProMax,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 🎨 Visual Polish Tests

    /// 🎨 Test summary card styles
    ///
    /// When: Summary cards are displayed
    /// Expect: Beautiful cards with icons, labels, values
    /// Tests: Light + dark mode on standard device
    func testSummaryCardStyles() {
        // 🏭 Create wizard with complete data
        let viewModel = MockViewModelFactory.createCompleteJourney()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎨 Test checkmark animation styling
    ///
    /// When: Success checkmark is displayed
    /// Expect: Large, green checkmark with scale animation
    /// Tests: Light + dark mode
    func testCheckmarkAnimation() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎨 Test button states - enabled/disabled/loading
    ///
    /// When: Buttons are in various states
    /// Expect: Visual distinction between states
    /// Tests: Light mode on standard device
    func testButtonStates() {
        // 🏭 Create wizard showing various button states
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 🔄 Interaction State Tests

    /// 📤 Test share sheet trigger
    ///
    /// When: User taps share button after publishing
    /// Expect: Share button visible and accessible
    /// Tests: Light mode on standard device
    func testShareButton() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 🔄 Test create another story button
    ///
    /// When: After publishing, user can start new story
    /// Expect: "Create Another Story" button visible
    /// Tests: Light + dark mode
    func testCreateAnotherButton() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 👁️ Test view story button
    ///
    /// When: After publishing, user can view the story
    /// Expect: "View Story" button prominent
    /// Tests: Light + dark mode
    func testViewStoryButton() {
        // 🏭 Create wizard with published story
        let viewModel = MockViewModelFactory.createWizardWithPublishedStory()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🎯 Navigation Tests

    /// 🎯 Test action buttons - back and publish
    ///
    /// When: Finalize step is active
    /// Expect: Back button, publish/done button
    /// Tests: Light + dark mode
    func testActionButtons() {
        // 🏭 Create wizard at finalize
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = FinalizeStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }
}

// MARK: - 📝 Testing Instructions

/*
 🎓 HOW TO USE THESE TESTS:

 1. 📸 Recording Snapshots:
    - Set `recordMode = true`
    - Run tests to capture reference images
    - Set `recordMode = false` before committing

 2. 🔍 Test Coverage:
    - Summary states (English-only, multilingual, complete)
    - Publishing states (initial, loading, success, error)
    - Success animations (confetti, checkmark, celebration)
    - Error states (network failures, validation errors)
    - Device variations (iPad, iPhone SE, standard, Pro Max)

 3. 🎉 Success Testing:
    - Confetti animation renders correctly
    - Success checkmark scales beautifully
    - Celebration message is prominent
    - Action buttons are accessible

 4. 🎨 Visual Validation:
    - Light + dark mode tested comprehensively
    - Multiple device sizes for layout validation
    - Summary cards are consistent and clear
    - Buttons have proper visual states

 5. 🔄 Updating Tests:
    - When adding new summary components, update tests
    - When changing success animations, re-record
    - When modifying button layouts, validate

 These tests ensure the grand finale of story creation is
 celebratory, informative, and pixel-perfect! 🎉✨
 */
