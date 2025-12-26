/**
 * 🎭 The Upload Step Snapshot Tests - Visual Regression Testing Magic
 *
 * "Where pixels meet precision! These tests capture the Upload Step's visual essence
 * across devices and states, ensuring every button, gradient, and animation
 * performs its visual symphony consistently across the Apple ecosystem."
 *
 * - The Spellbinding Museum Director of Visual Testing
 */

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CMS_Manager

// MARK: - 🎭 Upload Step Snapshot Tests

/// 📸 Visual regression tests for the UploadStepView
///
/// These tests capture and compare snapshots of the upload step in various states:
/// - Empty state (no image selected)
/// - Image selected state
/// - Uploading state (with progress)
/// - Error states
///
/// Each state is tested across multiple devices and color schemes
/// to ensure pixel-perfect consistency! ✨
final class UploadStepSnapshotTests: XCTestCase {

    // MARK: - 🎨 Empty State Tests

    /// 📭 Test the empty state (no image selected)
    /// This is what users see when they first enter the upload step
    @MainActor
    func testUploadStepEmpty() {
        // 🎭 Arrange: Create a fresh wizard at the upload step
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        let view = UploadStepView(viewModel: viewModel)

        // 📸 Assert: Capture snapshots across essential iPhone sizes
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test the empty state in dark mode
    /// Because night owls deserve beautiful UI too! 🦉
    @MainActor
    func testUploadStepEmptyDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        let view = UploadStepView(viewModel: viewModel)

        // 🌙 Dark mode across all essential devices
        assertDarkMode(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            record: isRecordingSnapshots
        )
    }

    /// 📱 Test the empty state on iPad
    /// Testing the spacious canvas! 🎨
    @MainActor
    func testUploadStepEmptyIPad() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        let view = UploadStepView(viewModel: viewModel)

        // 📱 iPad sizes in light mode
        assertIPads(
            matching: view,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🖼️ Image Selected State Tests

    /// ✅ Test with an image selected
    /// The happy path where users have picked their artwork!
    @MainActor
    func testUploadStepWithImage() {
        // 🎭 Arrange: Create a wizard with a selected image
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createLabeledImage(
            size: CGSize(width: 800, height: 600),
            color: .systemPurple,
            text: "Test Artwork"
        )
        let view = UploadStepView(viewModel: viewModel)

        // 📸 Assert: Capture across essential devices
        assertAllDevices(
            matching: view,
            devices: DeviceConfiguration.iPhoneEssentials,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🌙 Test with image selected in dark mode
    @MainActor
    func testUploadStepWithImageDarkMode() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createLabeledImage(
            size: CGSize(width: 800, height: 600),
            color: .systemBlue,
            text: "Night Art"
        )
        let view = UploadStepView(viewModel: viewModel)

        assertDarkMode(
            matching: view,
            devices: [.iPhone13Pro],
            record: isRecordingSnapshots
        )
    }

    // MARK: - 📤 Upload Progress Tests

    /// ⏳ Test the uploading state with progress
    /// Capturing the magic of progress bars in action! ✨
    @MainActor
    func testUploadStepUploading() {
        // 🎭 Arrange: Create a wizard in mid-upload
        let viewModel = MockViewModelFactory.createWizardLoading()
        viewModel.selectedImage = MockImageFactory.createLabeledImage(
            color: .systemGreen,
            text: "Uploading..."
        )
        let view = UploadStepView(viewModel: viewModel)

        // 📸 Assert: Snapshot on iPhone 13 Pro (our baseline)
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    /// 🎉 Test upload at 90% completion
    /// Almost there! The anticipation builds! 🚀
    @MainActor
    func testUploadStepNearlyComplete() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createMockImage()
        viewModel.uploadProgress = 0.9
        let view = UploadStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 💥 Error State Tests

    /// 🌩️ Test upload error state
    /// When things go wrong, the UI should still look good! 💅
    @MainActor
    func testUploadStepWithError() {
        let viewModel = MockViewModelFactory.createWizardWithUploadError()
        let view = UploadStepView(viewModel: viewModel)

        // 📸 Capture error state on baseline device
        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: isRecordingSnapshots
        )
    }

    // MARK: - 🎨 Edge Cases & Variations

    /// 📐 Test with portrait-oriented image
    @MainActor
    func testUploadStepPortraitImage() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createMockImage(
            size: CGSize(width: 600, height: 900),
            color: .systemIndigo
        )
        let view = UploadStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// 📐 Test with landscape-oriented image
    @MainActor
    func testUploadStepLandscapeImage() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createMockImage(
            size: CGSize(width: 1200, height: 600),
            color: .systemTeal
        )
        let view = UploadStepView(viewModel: viewModel)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            record: isRecordingSnapshots
        )
    }

    /// ⬛ Test with square image
    @MainActor
    func testUploadStepSquareImage() {
        let viewModel = MockViewModelFactory.createWizardAtUpload()
        viewModel.selectedImage = MockImageFactory.createMockImage(
            size: CGSize(width: 800, height: 800),
            color: .systemOrange
        )
        let view = UploadStepView(viewModel: viewModel)

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
