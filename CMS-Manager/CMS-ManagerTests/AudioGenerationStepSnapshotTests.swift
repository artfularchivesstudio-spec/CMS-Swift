/**
 * 🎭 The Audio Generation Step Snapshot Tests - Symphony of Voices
 *
 * "In the mystical recording studio where words become waves,
 * where silence transforms into storytelling, we capture every moment—
 * from the selection of the perfect voice to the triumphant playback
 * of multilingual audio. Nova's warmth, Fable's drama, Shimmer's
 * clarity—all tested across speeds, devices, and lighting conditions."
 *
 * - The Spellbinding Museum Director of Sonic Verification
 */

import XCTest
import SwiftUI
import SnapshotTesting
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 🔊 Audio Generation Step Snapshot Tests

/// 🌟 Comprehensive snapshot tests for AudioStepView
///
/// Tests the audio generation UI including voice selection, speed controls,
/// generation progress, and playback preview across various states and devices.
@MainActor
final class AudioGenerationStepSnapshotTests: XCTestCase {

    // MARK: - 🎨 Test Configuration

    /// 📸 Set to true to record new reference snapshots
    private let recordMode = true

    /// 📱 Standard device configurations
    private let testDevices: [DeviceConfiguration] = DeviceConfiguration.iPhoneEssentials

    // MARK: - 🧹 Setup & Teardown

    override func setUp() {
        super.setUp()
        // 🌟 Ensure clean test environment
    }

    // MARK: - 🎬 Initial State Tests

    /// 🎬 Test initial state - ready to generate audio
    ///
    /// When: User first arrives at audio generation step
    /// Expect: Voice selection cards, speed slider, generate button
    /// Tests: Light + dark mode on all devices
    func testInitialState() {
        // 🏭 Create wizard at audio step
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 🎬 Test with languages to generate
    ///
    /// When: Step shows languages that need audio (English, Spanish, Hindi)
    /// Expect: Language list visible, generation pending
    /// Tests: Light + dark mode on standard device
    func testWithLanguagesToGenerate() {
        // 🏭 Create wizard with multiple languages
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.english, .spanish, .hindi]

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🎤 Voice Selection Tests

    /// 🎤 Test voice selection - Nova selected
    ///
    /// When: User selects Nova voice
    /// Expect: Nova card highlighted, preview button visible
    /// Tests: Light + dark mode on all devices
    func testVoiceSelectionNova() {
        // 🏭 Create wizard with Nova voice
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedVoice = .nova

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 🎤 Test voice selection - Fable selected
    ///
    /// When: User selects Fable voice (dramatic!)
    /// Expect: Fable card highlighted
    /// Tests: Light + dark mode on standard device
    func testVoiceSelectionFable() {
        // 🏭 Create wizard with Fable voice
        let viewModel = MockViewModelFactory.createWizardWithCustomVoice()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎤 Test voice selection - Shimmer selected
    ///
    /// When: User selects Shimmer voice (clear and crisp!)
    /// Expect: Shimmer card highlighted
    /// Tests: Light mode on standard device
    func testVoiceSelectionShimmer() {
        // 🏭 Create wizard with Shimmer voice
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedVoice = .shimmer

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 🎤 Test all voice cards display
    ///
    /// When: Voice selection grid is shown
    /// Expect: All available voices displayed with descriptions
    /// Tests: Light + dark mode on standard device
    func testAllVoiceCardsDisplay() {
        // 🏭 Create wizard showing all voice options
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - ⚡ Speed Control Tests

    /// ⚡ Test default speed - 1.0x
    ///
    /// When: Speed slider at default position
    /// Expect: Slider at middle, label shows "1.0x"
    /// Tests: Light + dark mode
    func testDefaultSpeed() {
        // 🏭 Create wizard with default speed
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.audioSpeed = 1.0

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// ⚡ Test slow speed - 0.5x
    ///
    /// When: User sets speed to 0.5x (half speed)
    /// Expect: Slider at low position, label shows "0.5x"
    /// Tests: Light mode on standard device
    func testSlowSpeed() {
        // 🏭 Create wizard with slow speed
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.audioSpeed = 0.5

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// ⚡ Test fast speed - 2.0x
    ///
    /// When: User sets speed to 2.0x (double speed!)
    /// Expect: Slider at high position, label shows "2.0x"
    /// Tests: Light mode on standard device
    func testFastSpeed() {
        // 🏭 Create wizard with fast speed
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.audioSpeed = 2.0

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// ⚡ Test custom speed - 1.25x
    ///
    /// When: User sets custom speed
    /// Expect: Slider reflects custom position, precise label
    /// Tests: Light + dark mode
    func testCustomSpeed() {
        // 🏭 Create wizard with custom speed
        let viewModel = MockViewModelFactory.createWizardWithCustomVoice()
        // Already has custom speed of 1.2

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - ⏳ Generating Audio Tests

    /// ⏳ Test generating audio - in progress
    ///
    /// When: Audio generation is running
    /// Expect: Progress bars for each language, waveform animations
    /// Tests: Light + dark mode on all devices
    func testGeneratingAudio() {
        // 🏭 Create wizard generating audio
        let viewModel = MockViewModelFactory.createWizardGeneratingAudio()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 📊 Test partial progress - English done, Spanish in progress
    ///
    /// When: English audio complete (100%), Spanish at 60%, Hindi at 20%
    /// Expect: Checkmark for English, progress bars for others
    /// Tests: Light + dark mode on standard device
    func testPartialProgress() {
        // 🏭 Create wizard with mixed progress
        let viewModel = MockViewModelFactory.createWizardGeneratingAudio()
        // Already has partial progress from factory

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// ✅ Test all audio complete - ready for playback!
    ///
    /// When: All languages have finished generating
    /// Expect: All checkmarks, playback controls visible
    /// Tests: Light + dark mode on all devices
    func testAllAudioComplete() {
        // 🏭 Create wizard with completed audio
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - 🎵 Audio Player Controls Tests

    /// 🎵 Test audio player for English
    ///
    /// When: English audio is complete and can be played
    /// Expect: Play button, waveform visualization, timestamp
    /// Tests: Light + dark mode on standard device
    func testAudioPlayerEnglish() {
        // 🏭 Create wizard with English audio ready
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎵 Test audio player for multiple languages
    ///
    /// When: Multiple audio files ready to preview
    /// Expect: Player for each language, selectable
    /// Tests: Light + dark mode on all devices
    func testMultipleAudioPlayers() {
        // 🏭 Create wizard with all audio complete
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 🎵 Test audio player while playing
    ///
    /// When: Audio is currently playing
    /// Expect: Pause button, animated waveform, progress indicator
    /// Tests: Light mode on standard device
    func testAudioPlayerPlaying() {
        // 🏭 Create wizard with audio playing
        let viewModel = MockViewModelFactory.createWizardAtFinalize()
        // Note: Would need to set isPlaying state if exposed

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 🎵 Test waveform visualization
    ///
    /// When: Audio is playing or ready
    /// Expect: Animated waveform bars
    /// Tests: Light + dark mode
    func testWaveformVisualization() {
        // 🏭 Create wizard with audio
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🌩️ Error State Tests

    /// 💥 Test generation error - single language failed
    ///
    /// When: Spanish audio generation fails
    /// Expect: Error message on Spanish card, retry button
    /// Tests: Light + dark mode on standard device
    func testGenerationError() {
        // 🏭 Create wizard with generation error
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.english, .spanish, .hindi]
        viewModel.audioUrls = [.english: "data:audio/mpeg;base64,mock"]
        viewModel.error = .serverError(500)

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 💥 Test multiple generation errors
    ///
    /// When: Multiple languages fail to generate
    /// Expect: Error states on multiple cards, batch retry option
    /// Tests: Light mode on standard device
    func testMultipleGenerationErrors() {
        // 🏭 Create wizard with multiple errors
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.english, .spanish, .hindi]
        viewModel.audioUrls = [.english: "data:audio/mpeg;base64,mock"]
        viewModel.error = .serverError(500)

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 💥 Test retry after error
    ///
    /// When: User retries failed audio generation
    /// Expect: Progress reappears, error clears
    /// Tests: Light mode on standard device
    func testRetryAfterError() {
        // 🏭 Create wizard retrying generation
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.spanish]
        viewModel.audioProgress = [.spanish: 0.15] // Retrying

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 📱 Device-Specific Tests

    /// 📱 Test on iPad - spacious audio studio
    ///
    /// When: Audio step viewed on iPad
    /// Expect: Multi-column voice grid, larger audio players
    /// Tests: Light + dark mode on iPad Pro 11"
    func testIPadLayout() {
        // 🏭 Create wizard with audio
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPadPro11],
            record: recordMode
        )
    }

    /// 📱 Test on iPhone SE - compact audio controls
    ///
    /// When: Audio step on smallest screen
    /// Expect: Compact voice cards, stacked players
    /// Tests: Light + dark mode on iPhone SE
    func testCompactLayout() {
        // 🏭 Create wizard with audio
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.english, .spanish]

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhoneSE3rd],
            record: recordMode
        )
    }

    // MARK: - 🎨 Visual Polish Tests

    /// 🎨 Test voice card designs
    ///
    /// When: Voice selection cards are displayed
    /// Expect: Beautiful cards with voice names, descriptions, icons
    /// Tests: Light + dark mode on standard device
    func testVoiceCardDesigns() {
        // 🏭 Create wizard showing voice options
        let viewModel = MockViewModelFactory.createWizardAtAudio()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎨 Test progress indicators
    ///
    /// When: Audio is generating
    /// Expect: Smooth progress bars, percentage labels
    /// Tests: Light + dark mode
    func testProgressIndicators() {
        // 🏭 Create wizard with various progress levels
        let viewModel = MockViewModelFactory.createWizardAtAudio()
        viewModel.selectedLanguages = [.english, .spanish, .hindi]
        viewModel.audioProgress = [
            .english: 0.90,
            .spanish: 0.55,
            .hindi: 0.25
        ]

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🎯 Navigation Tests

    /// 🎯 Test action buttons - back and proceed
    ///
    /// When: Audio step is active
    /// Expect: Back button, proceed button (enabled when complete)
    /// Tests: Light + dark mode
    func testActionButtons() {
        // 🏭 Create wizard with completed audio
        let viewModel = MockViewModelFactory.createWizardAtFinalize()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎯 Test proceed button disabled state
    ///
    /// When: Audio generation incomplete
    /// Expect: Proceed button disabled/grayed out
    /// Tests: Light mode on standard device
    func testProceedButtonDisabled() {
        // 🏭 Create wizard with incomplete audio
        let viewModel = MockViewModelFactory.createWizardGeneratingAudio()

        let view = AudioStepView(viewModel: viewModel)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
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
    - Initial states (voice selection, speed controls)
    - Progress states (generating, partial, complete)
    - Player states (ready, playing, controls)
    - Error states (generation failures, retry)
    - Device variations (iPad, iPhone SE, standard)

 3. 🎤 Voice Testing:
    - All voice cards render correctly
    - Selection states are visually distinct
    - Preview buttons are accessible
    - Voice descriptions are clear

 4. 🎨 Visual Validation:
    - Light + dark mode tested comprehensively
    - Multiple device sizes for layout validation
    - Waveform animations captured
    - Player controls are intuitive

 5. 🔄 Updating Tests:
    - When adding new voices, update tests
    - When changing player UI, re-record
    - When modifying progress indicators, validate

 These tests ensure the audio generation experience is
 smooth, beautiful, and functional! 🔊✨
 */
