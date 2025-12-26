/**
 * 🎭 The Analyzing Step Snapshot Tests - Capturing AI Magic in Motion
 *
 * "Where artificial intelligence meets visual delight! These tests preserve
 * the mystical appearance of our AI analysis interface—the loading states,
 * progress indicators, and that moment of anticipation as the AI discovers
 * the story within each image."
 *
 * - The Spellbinding Museum Director of AI Visualization
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🎭 Analyzing Step Snapshot Tests

/// 🧠 Visual regression tests for the AnalyzingStepView
///
/// The analyzing step is pure theater—AI working its magic!
/// These tests capture:
/// - Initial analyzing state
/// - Progress indicators at various stages
/// - Loading animations (where possible in static snapshots)
/// - The transition from analyzing to complete
/// - Both light and dark modes for that mystical ambiance
final class AnalyzingStepSnapshotTests: XCTestCase {

    // MARK: - 🎨 Analyzing State Tests

    /// 🧠 Test the initial analyzing state
    /// When AI just begins its mystical analysis! ✨
    @MainActor
    func testAnalyzingStepInitial() {
        // 🎭 Arrange: Create wizard at analyzing step
        let viewModel = MockViewModelFactory.createWizardAtAnalyzing()
        let view = AnalyzingStepView(viewModel: viewModel)

        // 📸 Assert: Capture across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test analyzing step in dark mode
    /// AI magic looks even more mystical in the darkness! 🌟
    @MainActor
    func testAnalyzingStepDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtAnalyzing()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test analyzing step on iPad
    /// More space for those beautiful loading animations!
    @MainActor
    func testAnalyzingStepIPad() {
        let viewModel = MockViewModelFactory.createWizardAtAnalyzing()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertIPads(
            matching: view,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📊 Progress State Tests

    /// ⏳ Test analyzing step with early progress (25%)
    /// The journey of a thousand tokens begins with a single step! 🚶‍♂️
    @MainActor
    func testAnalyzingStepEarlyProgress() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        viewModel.analysisProgress = 0.25
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// ⏳ Test analyzing step mid-progress (50%)
    /// Halfway through the mystical journey! 🎭
    @MainActor
    func testAnalyzingStepMidProgress() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        viewModel.analysisProgress = 0.50
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// ⏳ Test analyzing step near completion (90%)
    /// Almost there! The anticipation builds! 🎉
    @MainActor
    func testAnalyzingStepNearlyComplete() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        viewModel.analysisProgress = 0.90
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 💥 Error State Tests

    /// 🌩️ Test analysis error state
    /// When AI encounters a creative challenge! 💫
    @MainActor
    func testAnalyzingStepWithError() {
        let viewModel = MockViewModelFactory.createWizardWithAnalysisError()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🌩️ Test error state in dark mode
    /// Errors look less scary in the dark! 🌙
    @MainActor
    func testAnalyzingStepErrorDarkMode() {
        let viewModel = MockViewModelFactory.createWizardWithAnalysisError()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .dark,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🌈 Both Color Schemes Test

    /// 🎨 Test both light and dark modes together
    /// The analyzing step should shine in both! ✨
    @MainActor
    func testAnalyzingStepBothColorSchemes() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        viewModel.analysisProgress = 0.65
        let view = AnalyzingStepView(viewModel: viewModel)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📱 Device Size Variations

    /// 📱 Test on smallest iPhone (SE)
    /// Even compact devices deserve mystical AI experiences!
    @MainActor
    func testAnalyzingStepCompactDevice() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhoneSE3rd,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test on largest iPhone (Pro Max)
    /// Maximum screen = maximum magic! 🌟
    @MainActor
    func testAnalyzingStepLargeDevice() {
        let viewModel = MockViewModelFactory.createWizardAnalyzing()
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone15ProMax,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎭 Loading State Variations

    /// ⏳ Test with isLoading flag set
    /// The canonical loading state! 🔄
    @MainActor
    func testAnalyzingStepLoading() {
        let viewModel = MockViewModelFactory.createWizardAtAnalyzing()
        viewModel.isLoading = true
        viewModel.analysisProgress = 0.35
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🎯 Test just-started state (0% progress)
    /// The very beginning of the AI journey! 🚀
    @MainActor
    func testAnalyzingStepJustStarted() {
        let viewModel = MockViewModelFactory.createWizardAtAnalyzing()
        viewModel.isLoading = true
        viewModel.analysisProgress = 0.0
        let view = AnalyzingStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🔧 Test Configuration

    override var isRecordingSnapshots: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORDING"] == "true"
    }
}
