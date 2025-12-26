/**
 * 🎭 The Review Step Snapshot Tests - Capturing Editorial Excellence
 *
 * "Where AI-generated tales meet human refinement! These tests preserve
 * the visual integrity of our review interface, ensuring every text field,
 * tag chip, and editing control appears pixel-perfect across all devices."
 *
 * - The Spellbinding Museum Director of Content Review
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🎭 Review Step Snapshot Tests

/// 📝 Visual regression tests for the ReviewStepView
///
/// The review step is where users refine AI-generated content, so the UI
/// must be pristine! These tests capture:
/// - Populated review form with AI-generated content
/// - Empty state variations
/// - Long content scenarios
/// - Tag management UI
/// - Both light and dark modes
final class ReviewStepSnapshotTests: XCTestCase {

    // MARK: - 🎨 Standard Review State Tests

    /// 📝 Test the review step with AI-generated content
    /// This is the typical state after AI analysis completes
    @MainActor
    func testReviewStepPopulated() {
        // 🎭 Arrange: Create wizard at review step with AI content
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        // 📸 Assert: Capture across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test review step in dark mode
    /// Editing content at night should be visually comfortable! 💅
    @MainActor
    func testReviewStepPopulatedDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test review step on iPad
    /// More screen real estate = more content visible!
    @MainActor
    func testReviewStepIPad() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        assertIPads(
            matching: view,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📊 Content Variations

    /// 📚 Test with very long content
    /// Testing text field scrolling and layout with verbose AI output
    @MainActor
    func testReviewStepLongContent() {
        let viewModel = MockViewModelFactory.createWizardAtReview()

        // 🎨 Create a verbose story description
        viewModel.storyContent = """
        In the golden hour of a summer evening, as the sun painted the sky in shades of amber and rose, \
        a solitary figure stood upon the ancient bridge. The river below whispered secrets of centuries past, \
        its gentle currents carrying memories downstream like fallen leaves in autumn.

        The scene captured in this remarkable photograph speaks to the eternal dialogue between humanity \
        and nature, between the constructed world of stone and steel and the organic rhythms of water and wind. \
        Here, architecture becomes poetry, and the ordinary moment transforms into something profound.

        This image invites contemplation, a pause in our hurried lives to consider the beauty that surrounds us, \
        often unnoticed in the rush of daily existence. It is a reminder that magic exists in the simple act \
        of observation, in the willingness to see what has always been there, waiting to be discovered.
        """

        viewModel.storyTags = [
            "photography", "nature", "contemplation", "architecture",
            "sunset", "bridge", "river", "golden-hour", "serenity"
        ]

        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🏷️ Test with many tags
    /// Ensuring tag chips wrap properly and remain readable
    @MainActor
    func testReviewStepManyTags() {
        let viewModel = MockViewModelFactory.createWizardAtReview()

        viewModel.storyTags = [
            "art", "painting", "impressionism", "landscape", "nature",
            "mountains", "sunset", "colors", "vibrant", "peaceful",
            "serene", "inspiring", "masterpiece", "gallery"
        ]

        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 📝 Test with minimal content
    /// Short and sweet story!
    @MainActor
    func testReviewStepMinimalContent() {
        let viewModel = MockViewModelFactory.createWizardAtReview()

        viewModel.storyTitle = "Sunset"
        viewModel.storyContent = "A beautiful moment captured in time."
        viewModel.storyTags = ["sunset", "nature"]

        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Edge Cases

    /// ⚠️ Test with empty title
    /// This should show validation feedback or disabled state
    @MainActor
    func testReviewStepEmptyTitle() {
        let viewModel = MockViewModelFactory.createWizardWithEmptyTitle()
        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 📏 Test with very long title
    /// Testing title truncation or wrapping
    @MainActor
    func testReviewStepLongTitle() {
        let viewModel = MockViewModelFactory.createWizardWithLongTitle()
        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 🏷️ Test with no tags
    /// Empty tag state should still look good!
    @MainActor
    func testReviewStepNoTags() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        viewModel.storyTags = []
        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🌈 Both Color Schemes Test

    /// 🎨 Test both light and dark modes together
    /// Ensuring consistency across appearance modes
    @MainActor
    func testReviewStepBothColorSchemes() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📱 Device Size Variations

    /// 📱 Test on smallest iPhone (SE)
    /// Content should remain accessible even on compact screens
    @MainActor
    func testReviewStepCompactDevice() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhoneSE3rd,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test on largest iPhone (Pro Max)
    /// Taking advantage of that spacious display! 🎨
    @MainActor
    func testReviewStepLargeDevice() {
        let viewModel = MockViewModelFactory.createWizardAtReview()
        let view = ReviewStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone15ProMax,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🔧 Test Configuration

    override var isRecordingSnapshots: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORDING"] == "true"
    }
}
