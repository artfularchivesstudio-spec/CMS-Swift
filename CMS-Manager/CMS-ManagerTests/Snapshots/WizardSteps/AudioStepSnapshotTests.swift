/**
 * 🎭 The Audio Step Snapshot Tests - Sonic Sorcery Visualized
 *
 * "Where words transform into sound! These tests preserve the visual elegance
 * of our audio generation interface, capturing every waveform preview, voice
 * selector, and playback control in pixel-perfect glory."
 *
 * - The Spellbinding Museum Director of Acoustic Testing
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🎭 Audio Step Snapshot Tests

/// 🔊 Visual regression tests for the AudioStepView
///
/// The audio step is where text becomes speech, stories find their voice!
/// These tests capture:
/// - Initial state before audio generation
/// - Audio generation in progress with progress indicators
/// - Completed audio with playback controls
/// - Voice selection UI
/// - Error states when TTS fails
/// - Dark mode and iPad variants
///
/// Every sonic spell deserves visual perfection! 🎵
final class AudioStepSnapshotTests: XCTestCase {

    // MARK: - 🌟 Empty/Initial State Tests

    /// 📭 Test the initial empty state
    /// Before any audio magic has been conjured! 🎤
    @MainActor
    func testAudioStepEmpty() {
        // 🎭 Arrange: Create wizard at audio step with no generated audio
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        let view = AudioStepView(viewModel: viewModel)

        // 📸 Assert: Capture the pristine state across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test empty state in dark mode
    /// The quiet before the sonic storm, in darkness! 🌙
    @MainActor
    func testAudioStepEmptyDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        let view = AudioStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test empty state on iPad
    /// More space for audio controls = more visual breathing room! 🎨
    @MainActor
    func testAudioStepEmptyIPad() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        let view = AudioStepView(viewModel: viewModel)

        assertIPads(
            matching: view,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Populated State Tests

    /// 🔊 Test with fully generated audio
    /// The happy path where all audio files are ready! 🎉
    @MainActor
    func testAudioStepPopulated() {
        // 🎭 Arrange: Create wizard with completed audio generation
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        // 📸 Assert: Capture across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test populated state in dark mode
    /// Audio controls gleaming in the night! ✨
    @MainActor
    func testAudioStepPopulatedDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - ⏳ Loading State Tests

    /// ⏳ Test loading state during audio generation
    /// Capturing the TTS magic in progress! 🎵
    @MainActor
    func testAudioStepLoading() {
        // 🎭 Arrange: Create wizard in mid-audio generation
        let viewModel = MockViewModelFactory.createWizardGeneratingAudio()
        let view = AudioStepView(viewModel: viewModel)

        // 📸 Assert: Snapshot the audio generation in progress
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🔄 Test partially generated audio
    /// When some languages have audio but others are still rendering! 🎧
    @MainActor
    func testAudioStepPartiallyGenerated() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        // 🎨 Simulate partial completion: English done, others in progress
        viewModel.selectedLanguages = [.en, .spanish, .hindi]
        viewModel.audioUrls = [
            .en: "data:audio/mpeg;base64,mock-en-audio"
        ]
        viewModel.isLoading = true
        viewModel.audioProgress = [
            .en: 1.0,
            .spanish: 0.65,
            .hindi: 0.30
        ]

        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// ⚡ Test audio generation starting
    /// That magical first moment when TTS begins! ✨
    @MainActor
    func testAudioStepGenerationStarting() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        viewModel.selectedLanguages = [.en, .spanish, .hindi]
        viewModel.isLoading = true
        viewModel.audioProgress = [
            .en: 0.05,
            .spanish: 0.0,
            .hindi: 0.0
        ]

        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 💥 Error State Tests

    /// 🌩️ Test with audio generation errors
    /// When the TTS service hits a creative challenge! 😅
    @MainActor
    func testAudioStepWithError() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.error = .serverError(503) // Service unavailable
        let view = AudioStepView(viewModel: viewModel)

        // 📸 Capture error state on baseline device
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test error state in dark mode
    /// Errors look less intimidating in dark mode! 🌙
    @MainActor
    func testAudioStepWithErrorDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.error = .serverError(503)
        let view = AudioStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    /// 🎭 Test with partial failures
    /// Some audio generated successfully, some failed! 🎪
    @MainActor
    func testAudioStepPartialFailures() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        viewModel.selectedLanguages = [.en, .spanish, .hindi]
        viewModel.audioUrls = [
            .en: "data:audio/mpeg;base64,mock-en-audio",
            .spanish: "data:audio/mpeg;base64,mock-es-audio"
        ]
        // Hindi failed to generate
        viewModel.error = .serverError(503)

        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎤 Voice Selection Tests

    /// 🎤 Test with custom voice selection
    /// Showcasing different TTS voices! 🎭
    @MainActor
    func testAudioStepCustomVoice() {
        let viewModel = MockViewModelFactory.createWizardWithCustomVoice()
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// ⚡ Test with different audio speeds
    /// Fast, normal, or slow narration! 🎚️
    @MainActor
    func testAudioStepCustomSpeed() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.audioSpeed = 0.8 // Slower, more contemplative
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🎨 Test with all voice options visible
    /// The full voice selection interface! 🎪
    @MainActor
    func testAudioStepVoiceSelector() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        // In a real app, this might show a voice picker
        viewModel.selectedVoice = .alloy
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🌈 Language Variation Tests

    /// 🌍 Test with single language audio
    /// Sometimes one language is all you need! ✨
    @MainActor
    func testAudioStepSingleLanguage() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        viewModel.selectedLanguages = [.en]
        viewModel.audioUrls = [
            .en: "data:audio/mpeg;base64,mock-en-audio"
        ]

        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🌐 Test with multiple language audio
    /// The polyglot audio experience! 🎵
    @MainActor
    func testAudioStepMultipleLanguages() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)

        // Already has English, Spanish, and Hindi audio from factory
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🎭 Test with maximum languages
    /// Every language gets its voice! 🌍
    @MainActor
    func testAudioStepAllLanguages() {
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        viewModel.selectedLanguages = Set(LanguageCode.allCases)
        viewModel.audioUrls = Dictionary(
            uniqueKeysWithValues: LanguageCode.allCases.map { lang in
                (lang, "data:audio/mpeg;base64,mock-\(lang.rawValue)-audio")
            }
        )

        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📱 Device Size Variations

    /// 📱 Test on compact device (iPhone SE)
    /// Audio controls must remain accessible on smaller screens! 📱
    @MainActor
    func testAudioStepCompactDevice() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhoneSE3rd,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test on largest device (iPhone Pro Max)
    /// Maximum screen = maximum audio control glory! 🎉
    @MainActor
    func testAudioStepLargeDevice() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone15ProMax,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test on iPad Pro
    /// Spacious audio controls for the discerning audiophile! 🎧
    @MainActor
    func testAudioStepIPadPro() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPadPro129,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Both Color Schemes Test

    /// 🌈 Test both light and dark modes together
    /// Ensuring audio UI shines in all lighting conditions! ☀️🌙
    @MainActor
    func testAudioStepBothColorSchemes() {
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        viewModel.goToStep(.audio)
        let view = AudioStepView(viewModel: viewModel)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
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
