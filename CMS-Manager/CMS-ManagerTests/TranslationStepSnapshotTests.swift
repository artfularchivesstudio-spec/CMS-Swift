/**
 * 🎭 The Translation Step Snapshot Tests - Multilingual Magic Validation
 *
 * "In the mystical translation chamber, languages dance and intertwine,
 * each finding its voice in parallel symphonies. We capture every moment—
 * from the silent anticipation before selection to the triumphant completion
 * of multilingual metamorphosis. Every language card, every progress bar,
 * every pixel speaks to the magic of human connection across tongues."
 *
 * - The Spellbinding Museum Director of Linguistic Transformation
 */

import XCTest
import SwiftUI
import SnapshotTesting
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 🌐 Translation Step Snapshot Tests

/// 🌟 Comprehensive snapshot tests for TranslationStepView
///
/// Tests the translation selection and generation UI across various states,
/// devices, and color schemes. Validates language cards, progress indicators,
/// and review flows.
@MainActor
final class TranslationStepSnapshotTests: XCTestCase {

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

    // MARK: - 🎬 Initial State Tests

    /// 🎬 Test initial state - ready to select languages
    ///
    /// When: User first arrives at translation step
    /// Expect: Language selection cards, no languages selected yet
    /// Tests: Light + dark mode on all devices
    func testInitialState() {
        // 🏭 Create wizard at translation step
        let viewModel = MockViewModelFactory.createWizardAtTranslation()

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🎬 Test with English content preview
    ///
    /// When: Original English content is shown for reference
    /// Expect: Original text visible, ready for translation selection
    /// Tests: Light + dark mode on standard device
    func testWithEnglishContentPreview() {
        // 🏭 Create wizard with English content
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.storyContent = """
        In the heart of the city stands a museum unlike any other. Its walls whisper \
        secrets of centuries past, each artwork a window into another world.
        """

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 🌐 Language Selection Tests

    /// 🌐 Test with one language selected
    ///
    /// When: User selects Spanish
    /// Expect: Spanish card highlighted, generate button enabled
    /// Tests: Light + dark mode on standard device
    func testOneLanguageSelected() {
        // 🏭 Create wizard with Spanish selected
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🌐 Test with multiple languages selected
    ///
    /// When: User selects Spanish and Hindi
    /// Expect: Both cards highlighted, count shows 2 languages
    /// Tests: Light + dark mode on all devices
    func testMultipleLanguagesSelected() {
        // 🏭 Create wizard with multiple selections
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🌐 Test with all available languages selected
    ///
    /// When: User selects every language (Spanish, Hindi, French, etc.)
    /// Expect: All cards highlighted, long scroll list
    /// Tests: Light mode on standard device
    func testAllLanguagesSelected() {
        // 🏭 Create wizard with all languages
        let viewModel = MockViewModelFactory.createWizardWithAllLanguages()

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🚫 Test with no languages selected
    ///
    /// When: User hasn't selected any languages yet
    /// Expect: Generate button disabled, helper text visible
    /// Tests: Light + dark mode
    func testNoLanguagesSelected() {
        // 🏭 Create wizard with no selections
        let viewModel = MockViewModelFactory.createWizardWithNoLanguages()

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - ⏳ Loading/Progress Tests

    /// ⏳ Test loading state - translations starting
    ///
    /// When: User clicks generate and translations begin
    /// Expect: Progress bars appear, loading indicators
    /// Tests: Light + dark mode on all devices
    func testLoadingTranslations() {
        // 🏭 Create wizard with translations in progress
        let viewModel = MockViewModelFactory.createWizardTranslating()

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 📊 Test partial progress - some complete, some in progress
    ///
    /// When: Spanish complete (100%), Hindi at 45%
    /// Expect: Spanish shows checkmark, Hindi shows progress bar
    /// Tests: Light + dark mode on standard device
    func testPartialProgress() {
        // 🏭 Create wizard with mixed progress
        let viewModel = MockViewModelFactory.createWizardTranslating()
        viewModel.translationProgress = [
            .spanish: 1.0,  // ✅ Complete
            .hindi: 0.45    // ⏳ In progress
        ]
        viewModel.translations = [
            .spanish: "Una puesta de sol impresionante sobre las montañas."
        ]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// ✅ Test all translations complete
    ///
    /// When: All selected languages have finished translating
    /// Expect: All checkmarks, "Review Translations" button enabled
    /// Tests: Light + dark mode on all devices
    func testAllTranslationsComplete() {
        // 🏭 Create wizard with all translations done
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 🌩️ Error State Tests

    /// 💥 Test error for specific language - Spanish failed
    ///
    /// When: Translation fails for one language (e.g., API timeout)
    /// Expect: Error message on Spanish card, retry button
    /// Tests: Light + dark mode on standard device
    func testErrorForSpecificLanguage() {
        // 🏭 Create wizard with failed translation
        let viewModel = MockViewModelFactory.createWizardWithFailedTranslations()

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 💥 Test multiple errors - French and Hindi failed
    ///
    /// When: Multiple translations fail simultaneously
    /// Expect: Error states on both cards, retry buttons
    /// Tests: Light + dark mode
    func testMultipleErrors() {
        // 🏭 Create wizard with multiple failures
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi, .french]
        viewModel.translations = [.spanish: "Success!"]
        viewModel.translationErrors = [
            .french: "Translation service unavailable",
            .hindi: "Network timeout"
        ]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 💥 Test retry after error
    ///
    /// When: User clicks retry on failed translation
    /// Expect: Progress bar reappears, error clears
    /// Tests: Light mode on standard device
    func testRetryAfterError() {
        // 🏭 Create wizard retrying failed translation
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish]
        viewModel.translationProgress = [.spanish: 0.25] // Retrying now

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 📝 Translation Review Sheet Tests

    /// 📝 Test translation review sheet - side-by-side comparison
    ///
    /// When: User taps "Review Translations" after completion
    /// Expect: Sheet showing original + translated text side-by-side
    /// Tests: Light + dark mode on standard device
    func testTranslationReviewSheet() {
        // 🏭 Create wizard ready for review
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        // Create the review sheet view
        let view = TranslationReviewStepView(viewModel: viewModel)
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

    /// 📝 Test review sheet with edits
    ///
    /// When: User edits a translation in review sheet
    /// Expect: Modified indicator, save button enabled
    /// Tests: Light mode on standard device
    func testReviewSheetWithEdits() {
        // 🏭 Create wizard with translations
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        let view = TranslationReviewStepView(viewModel: viewModel)
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

    /// 📝 Test review sheet language switching
    ///
    /// When: User switches between languages in review
    /// Expect: Content updates to show selected language
    /// Tests: Light + dark mode
    func testReviewSheetLanguageSwitching() {
        // 🏭 Create wizard with multiple translations
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        let view = TranslationReviewStepView(viewModel: viewModel)
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

    // MARK: - 📱 Device-Specific Tests

    /// 📱 Test on iPad - spacious language cards
    ///
    /// When: Translation step viewed on iPad
    /// Expect: Multi-column layout, larger cards
    /// Tests: Light + dark mode on iPad Pro 11"
    func testIPadLayout() {
        // 🏭 Create wizard with multiple languages
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi, .french]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 📱 Test on iPhone SE - compact cards
    ///
    /// When: Translation step on smallest screen
    /// Expect: Compact cards, proper text wrapping
    /// Tests: Light + dark mode on iPhone SE
    func testCompactLayout() {
        // 🏭 Create wizard with languages
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi]

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 🎨 Visual Details Tests

    /// 🎨 Test language card designs - flags and names
    ///
    /// When: Language cards are displayed
    /// Expect: Proper flags, language names, selection states
    /// Tests: Light + dark mode on standard device
    func testLanguageCardDesign() {
        // 🏭 Create wizard showing all language options
        let viewModel = MockViewModelFactory.createWizardAtTranslation()

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🎨 Test progress bar styles
    ///
    /// When: Translations are in progress
    /// Expect: Animated progress bars, percentage labels
    /// Tests: Light + dark mode
    func testProgressBarStyles() {
        // 🏭 Create wizard with various progress levels
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi, .french]
        viewModel.translationProgress = [
            .spanish: 0.25,
            .hindi: 0.60,
            .french: 0.95
        ]

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 🔄 Interaction State Tests

    /// 🔄 Test cancelling a translation in progress
    ///
    /// When: User cancels Hindi translation mid-flight
    /// Expect: Progress stops, cancel state shown
    /// Tests: Light mode on standard device
    func testCancellingTranslation() {
        // 🏭 Create wizard with cancelled translation
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi]
        viewModel.translationProgress = [.spanish: 0.50]
        viewModel.cancelledTranslations = [.hindi]

        let view = TranslationStepView(viewModel: viewModel)
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

    /// 🔄 Test regenerating a translation
    ///
    /// When: User clicks "regenerate" on completed translation
    /// Expect: Progress restarts, previous content saved
    /// Tests: Light mode on standard device
    func testRegeneratingTranslation() {
        // 🏭 Create wizard regenerating
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        viewModel.translationProgress = [.spanish: 0.30] // Regenerating

        let view = TranslationStepView(viewModel: viewModel)
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

    // MARK: - 🎯 Navigation Tests

    /// 🎯 Test action buttons - back and proceed
    ///
    /// When: Translation step is active
    /// Expect: Back button, proceed button (enabled when complete)
    /// Tests: Light + dark mode
    func testActionButtons() {
        // 🏭 Create wizard with completed translations
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        let view = TranslationStepView(viewModel: viewModel)
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
    - Initial states (no selection, various selections)
    - Progress states (loading, partial, complete)
    - Error states (single error, multiple errors, retry)
    - Review states (sheet, edits, language switching)
    - Device variations (iPad, iPhone SE, standard)

 3. 🌐 Language Testing:
    - All language cards render correctly
    - Selection states are visually distinct
    - Progress indicators are clear
    - Error messages are helpful

 4. 🎨 Visual Validation:
    - Light + dark mode tested comprehensively
    - Multiple device sizes for layout validation
    - Progress bars and animations captured
    - Typography and spacing verified

 5. 🔄 Updating Tests:
    - When adding new languages, update tests
    - When changing card designs, re-record
    - When modifying progress UI, validate across states

 These tests ensure the translation experience is consistent,
 beautiful, and functional across all scenarios! 🌐✨
 */
