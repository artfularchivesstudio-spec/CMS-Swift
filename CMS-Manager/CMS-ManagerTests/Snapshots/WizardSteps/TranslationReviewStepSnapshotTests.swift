/**
 * 🎭 The Translation Review Step Snapshot Tests - Multilingual Magic Captured
 *
 * "Where languages dance in harmony! These tests immortalize the visual splendor
 * of our translation review interface, ensuring every translated phrase, language
 * toggle, and editing control renders beautifully across our device ensemble."
 *
 * - The Spellbinding Museum Director of Polyglot Testing
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager
import ArtfulArchivesCore

// MARK: - 🎭 Translation Review Step Snapshot Tests

/// 🌐 Visual regression tests for the TranslationReviewStepView
///
/// The translation review step showcases multilingual content in all its glory!
/// These tests capture:
/// - Populated translations in multiple languages
/// - Empty/initial state before translations
/// - Loading states during translation generation
/// - Error states when translations fail
/// - Dark mode and iPad variants
///
/// Each state proves our UI is ready for the world stage! ✨
final class TranslationReviewStepSnapshotTests: XCTestCase {

    // MARK: - 🌟 Empty/Initial State Tests

    /// 📭 Test the initial empty state
    /// Before any translations exist - the blank canvas awaits! 🎨
    @MainActor
    func testTranslationReviewStepEmpty() {
        // 🎭 Arrange: Create wizard at translation review with no translations yet
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi]
        viewModel.goToStep(.translationReview)
        let view = TranslationReviewStepView(viewModel: viewModel)

        // 📸 Assert: Capture the pristine state across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test empty state in dark mode
    /// Because empty states deserve dark mode love too! 💜
    @MainActor
    func testTranslationReviewStepEmptyDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtTranslation()
        viewModel.selectedLanguages = [.spanish, .hindi]
        viewModel.goToStep(.translationReview)
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Populated State Tests

    /// 🌐 Test with fully populated translations
    /// The happy path where all translations are complete! 🎉
    @MainActor
    func testTranslationReviewStepPopulated() {
        // 🎭 Arrange: Create wizard with completed translations
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        let view = TranslationReviewStepView(viewModel: viewModel)

        // 📸 Assert: Capture across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test populated state in dark mode
    /// Multilingual content shines in the darkness! ✨
    @MainActor
    func testTranslationReviewStepPopulatedDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test populated state on iPad
    /// More languages visible at once on that spacious screen! 🎨
    @MainActor
    func testTranslationReviewStepPopulatedIPad() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertIPads(
            matching: view,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - ⏳ Loading State Tests

    /// ⏳ Test loading state during translation generation
    /// Capturing the magic of AI translation in progress! ✨
    @MainActor
    func testTranslationReviewStepLoading() {
        // 🎭 Arrange: Create wizard in mid-translation
        let viewModel = MockViewModelFactory.createWizardTranslating()
        viewModel.goToStep(.translationReview)
        let view = TranslationReviewStepView(viewModel: viewModel)

        // 📸 Assert: Snapshot the loading state
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🔄 Test partially loaded state
    /// When some translations are done but others are still cooking! 🍳
    @MainActor
    func testTranslationReviewStepPartiallyLoaded() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        // 🎨 Simulate partial completion: Spanish done, Hindi still loading
        viewModel.selectedLanguages = [.spanish, .hindi, .english]
        viewModel.translations = [
            .spanish: "Una puesta de sol impresionante sobre las montañas."
        ]
        viewModel.translatedTitles = [
            .spanish: "El Atardecer Místico"
        ]
        viewModel.isLoading = true
        viewModel.translationProgress = [
            .spanish: 1.0,
            .hindi: 0.6,
            .english: 0.2
        ]

        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 💥 Error State Tests

    /// 🌩️ Test with translation errors
    /// When the translation service hits a creative challenge! 😅
    @MainActor
    func testTranslationReviewStepWithErrors() {
        let viewModel = MockViewModelFactory.createWizardWithFailedTranslations()
        let view = TranslationReviewStepView(viewModel: viewModel)

        // 📸 Capture error state on baseline device
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test error state in dark mode
    /// Errors look less scary in dark mode, right? 🌙
    @MainActor
    func testTranslationReviewStepWithErrorsDarkMode() {
        let viewModel = MockViewModelFactory.createWizardWithFailedTranslations()
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🌈 Language Variation Tests

    /// 🌍 Test with all available languages
    /// The grand polyglot showcase! 🎭
    @MainActor
    func testTranslationReviewStepAllLanguages() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        // 🎨 Add all supported languages
        let supportedLanguages = [LanguageCode.english, .spanish, .hindi]
        viewModel.selectedLanguages = Set(supportedLanguages)
        viewModel.translations = Dictionary(
            uniqueKeysWithValues: supportedLanguages.map { lang in
                (lang, "[\(lang.rawValue.uppercased())] Translated content for \(lang.rawValue)")
            }
        )
        viewModel.translatedTitles = Dictionary(
            uniqueKeysWithValues: supportedLanguages.map { lang in
                (lang, "[\(lang.rawValue.uppercased())] Translated Title")
            }
        )

        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🌐 Test with single language translation
    /// Sometimes simplicity is best! ✨
    @MainActor
    func testTranslationReviewStepSingleLanguage() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        viewModel.selectedLanguages = [.spanish]
        viewModel.translations = [
            .spanish: "Una puesta de sol impresionante sobre las montañas con colores vibrantes."
        ]
        viewModel.translatedTitles = [
            .spanish: "El Atardecer Místico"
        ]

        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📱 Device Size Variations

    /// 📱 Test on compact device (iPhone SE)
    /// Ensuring translations remain readable on smaller screens! 📱
    @MainActor
    func testTranslationReviewStepCompactDevice() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhoneSE3rd,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test on largest device (iPhone Pro Max)
    /// More translations visible = more linguistic glory! 🎉
    @MainActor
    func testTranslationReviewStepLargeDevice() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()
        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone15ProMax,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Content Variation Tests

    /// 📝 Test with very long translated content
    /// Testing scrolling and layout with verbose translations! 📜
    @MainActor
    func testTranslationReviewStepLongContent() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        // 🎨 Create verbose translations that test scrolling
        viewModel.translations = [
            .spanish: """
            En la hora dorada de una tarde de verano, cuando el sol pintaba el cielo en tonos de ámbar \
            y rosa, una figura solitaria se encontraba sobre el antiguo puente. El río debajo susurraba \
            secretos de siglos pasados, sus suaves corrientes llevando memorias río abajo como hojas \
            caídas en otoño. Esta escena capturada habla del diálogo eterno entre la humanidad y la \
            naturaleza, entre el mundo construido de piedra y acero y los ritmos orgánicos del agua y \
            el viento. La arquitectura se convierte en poesía, y el momento ordinario se transforma en \
            algo profundo y trascendental.
            """,
            .hindi: """
            गर्मी की शाम के स्वर्णिम घंटे में, जब सूरज ने आकाश को अंबर और गुलाब के रंगों में रंग दिया, \
            एक अकेली आकृति प्राचीन पुल पर खड़ी थी। नीचे की नदी सदियों के रहस्यों को फुसफुसा रही थी, \
            इसकी कोमल धाराएं यादों को पतझड़ में गिरे पत्तों की तरह नीचे की ओर ले जा रही थीं। यह \
            तस्वीर मानवता और प्रकृति के बीच शाश्वत संवाद की बात करती है, पत्थर और स्टील की \
            निर्मित दुनिया और पानी और हवा की जैविक लय के बीच।
            """
        ]

        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 📏 Test with very long translated titles
    /// Some languages use more words than others! 🌍
    @MainActor
    func testTranslationReviewStepLongTitles() {
        let viewModel = MockViewModelFactory.createWizardAtTranslationReview()

        viewModel.translatedTitles = [
            .spanish: "El Atardecer Místico Sobre Las Montañas Majestuosas del Horizonte Dorado",
            .hindi: "रहस्यमय सूर्यास्त जो पहाड़ों के ऊपर स्वर्णिम क्षितिज में चमकता है"
        ]

        let view = TranslationReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🔧 Test Configuration

    /// 🎬 Override to enable snapshot recording mode
    /// Set SNAPSHOT_RECORDING=true in environment to record new snapshots
    override var isRecordingSnapshots: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORDING"] == "true"
    }
}
