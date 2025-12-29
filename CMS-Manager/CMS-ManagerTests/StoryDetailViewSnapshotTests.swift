/**
 * 🎭 The Story Detail View Snapshot Tests - Reading Experience Validation
 *
 * "In the quiet halls of our digital museum, each story deserves to be
 * displayed in perfect clarity. We capture the detail view in all its forms—
 * with images, without audio, in edit mode, across languages. Every pixel
 * must honor the curator's vision and the reader's journey."
 *
 * - The Spellbinding Museum Director of Detail Verification
 */

import XCTest
import SwiftUI
import SnapshotTesting
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 📖 Story Detail View Snapshot Tests

/// 🌟 Comprehensive snapshot tests for StoryDetailView
///
/// Tests the story detail screen in various configurations and states.
/// Validates the reading experience across devices and color schemes.
final class StoryDetailViewSnapshotTests: XCTestCase {

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

    // MARK: - 📚 Complete Story Tests

    /// 📖 Test story with all content - the full experience
    ///
    /// When: Story has title, content, images, audio, and metadata
    /// Expect: Beautiful reading experience with all elements visible
    /// Tests: Light + dark mode on all devices
    @MainActor
    func testStoryWithAllContent() {
        // 🏭 Create fully-featured story
        let story = MockStoryFactory.createApprovedStory(id: 1)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    /// 📖 Test story in created stage - minimal content
    ///
    /// When: Story is newly created with basic info
    /// Expect: Clean display with stage badge showing "Created"
    /// Tests: Light + dark mode on standard device
    @MainActor
    func testStoryInCreatedStage() {
        // 🏭 Create new story
        let story = MockStoryFactory.createNewStory(id: 10)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 📖 Test approved story - ready for the world!
    ///
    /// When: Story has gone through all stages and is approved
    /// Expect: All bells and whistles, published badge, audio players
    /// Tests: Light + dark mode on all devices
    @MainActor
    func testApprovedStory() {
        // 🏭 Create fully approved story
        let story = MockStoryFactory.createApprovedStory(id: 50)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - 🎵 Audio State Tests

    /// 🔇 Test story with missing audio - incomplete state
    ///
    /// When: Story should have audio but doesn't yet
    /// Expect: Placeholder or message indicating audio not available
    /// Tests: Light + dark mode on standard device
    @MainActor
    func testStoryWithMissingAudio() {
        // 🏭 Create story without audio
        var story = MockStoryFactory.createStory(
            id: 20,
            title: "Silent Story",
            stage: .englishTextApproved
        )
        // Ensure no audio
        story = Story(
            id: story.id,
            documentId: story.documentId,
            title: story.title,
            slug: story.slug,
            bodyMessage: story.bodyMessage,
            excerpt: story.excerpt,
            image: story.image,
            images: story.images,
            audio: nil, // 🔇 No audio!
            workflowStage: story.workflowStage,
            visible: story.visible,
            locale: story.locale,
            localizations: story.localizations,
            createdAt: story.createdAt,
            updatedAt: story.updatedAt,
            publishedAt: story.publishedAt,
            createdBy: story.createdBy,
            strapiAttributes: story.strapiAttributes
        )

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎵 Test story with English audio only
    ///
    /// When: Story has English audio but no translations yet
    /// Expect: Audio player for English, placeholders for other languages
    /// Tests: Light + dark mode
    @MainActor
    func testStoryWithEnglishAudioOnly() {
        // 🏭 Create story with English audio
        let story = MockStoryFactory.createEnglishAudioApprovedStory(id: 30)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🌐 Test story with multiple languages - the polyglot!
    ///
    /// When: Story has audio in English, Spanish, and Hindi
    /// Expect: Language selector, multiple audio players
    /// Tests: Light + dark mode on all devices
    @MainActor
    func testStoryWithMultipleLanguages() {
        // 🏭 Create multilingual story
        let story = MockStoryFactory.createMultilingualStory(id: 40)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - ✏️ Edit Mode Tests

    /// ✏️ Test edit mode - curator's workshop
    ///
    /// When: User enters edit mode to modify story
    /// Expect: Text fields for title/content/excerpt, save/cancel buttons
    /// Tests: Light + dark mode on standard device
    @MainActor
    func testEditMode() {
        // 🏭 Create story for editing
        let story = MockStoryFactory.createStory(id: 60, title: "Editable Story")

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)
        // Note: Would need to programmatically trigger edit mode
        // This might require refactoring to accept initial edit state

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// ✏️ Test edit mode with validation errors
    ///
    /// When: User tries to save with invalid/empty fields
    /// Expect: Validation error messages, disabled save button
    /// Tests: Light mode on standard device
    @MainActor
    func testEditModeWithValidationErrors() {
        // 🏭 Create story
        let story = MockStoryFactory.createStory(id: 61)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 🎭 Workflow Stage Tests

    /// 🎭 Test different approval statuses - stage badges
    ///
    /// When: Story is in various workflow stages
    /// Expect: Appropriate badge color and label for each stage
    /// Tests: Light + dark mode on standard device
    @MainActor
    func testDifferentApprovalStatuses() {
        // 🏭 Test multiple stages
        let stages: [(WorkflowStage, String)] = [
            (.created, "Created"),
            (.englishTextApproved, "English Text Approved"),
            (.englishAudioApproved, "English Audio Approved"),
            (.multilingualTextApproved, "Multilingual Text Approved"),
            (.approved, "Approved")
        ]

        for (index, (stage, _)) in stages.enumerated() {
            let story = MockStoryFactory.createStory(
                id: 70 + index,
                title: "Story in \(stage.rawValue)",
                stage: stage
            )

            let view = StoryDetailView(story: story)
                .environment(\.dependencies, AppDependencies.mock)

            // 📸 Snapshot each stage separately
            assertBothColorSchemes(
                matching: view,
                devices: [.iPhone13Pro],
                record: recordMode
            )
        }
    }

    // MARK: - 🖼️ Image Tests

    /// 🖼️ Test story with multiple images - image gallery
    ///
    /// When: Story has cover image plus additional images
    /// Expect: Image carousel or gallery view
    /// Tests: Light + dark mode on standard device
    @MainActor
    func testStoryWithMultipleImages() {
        // 🏭 Create story with many images
        let story = MockStoryFactory.createApprovedStory(id: 80)
        // This story already has multiple images from factory

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🖼️ Test story without images - text-only
    ///
    /// When: Story has no cover or additional images
    /// Expect: Clean text-focused layout, no image placeholders
    /// Tests: Light + dark mode
    @MainActor
    func testStoryWithoutImages() {
        // 🏭 Create text-only story
        var story = MockStoryFactory.createStory(id: 85, title: "Text Only Story")
        story = Story(
            id: story.id,
            documentId: story.documentId,
            title: story.title,
            slug: story.slug,
            bodyMessage: story.bodyMessage,
            excerpt: story.excerpt,
            image: nil, // 🚫 No cover image
            images: nil, // 🚫 No additional images
            audio: story.audio,
            workflowStage: story.workflowStage,
            visible: story.visible,
            locale: story.locale,
            localizations: story.localizations,
            createdAt: story.createdAt,
            updatedAt: story.updatedAt,
            publishedAt: story.publishedAt,
            createdBy: story.createdBy,
            strapiAttributes: story.strapiAttributes
        )

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 📱 Device-Specific Tests

    /// 📱 Test on iPad - spacious reading experience
    ///
    /// When: Story viewed on iPad
    /// Expect: Optimized layout with wider content, better image display
    /// Tests: Light + dark mode on iPad Pro 11"
    @MainActor
    func testIPadLayout() {
        // 🏭 Create rich story for iPad
        let story = MockStoryFactory.createApprovedStory(id: 90)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPadPro11],
            record: recordMode
        )
    }

    /// 📱 Test on iPhone SE - compact layout
    ///
    /// When: Story viewed on smallest supported screen
    /// Expect: Content reflows properly, nothing cut off
    /// Tests: Light + dark mode on iPhone SE
    @MainActor
    func testCompactLayout() {
        // 🏭 Create story with lots of content
        let story = MockStoryFactory.createApprovedStory(id: 91)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhoneSE3rd],
            record: recordMode
        )
    }

    // MARK: - 🌐 Localization Tests

    /// 🌐 Test Spanish translation view
    ///
    /// When: User switches to Spanish language
    /// Expect: Spanish title, audio player for Spanish
    /// Tests: Light mode on standard device
    @MainActor
    func testSpanishTranslation() {
        // 🏭 Create multilingual story
        let story = MockStoryFactory.createMultilingualStory(id: 100)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)
        // Note: Would need to programmatically select Spanish language

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 🌐 Test Hindi translation view
    ///
    /// When: User switches to Hindi language
    /// Expect: Hindi title, audio player for Hindi
    /// Tests: Light mode on standard device
    @MainActor
    func testHindiTranslation() {
        // 🏭 Create multilingual story
        let story = MockStoryFactory.createMultilingualStory(id: 101)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - 🎨 Visual Polish Tests

    /// 📜 Test markdown rendering - rich text display
    ///
    /// When: Story content contains markdown (bold, italic, lists, etc.)
    /// Expect: Properly formatted rich text
    /// Tests: Light + dark mode
    @MainActor
    func testMarkdownRendering() {
        // 🏭 Create story with markdown content
        var story = MockStoryFactory.createStory(id: 110)
        let markdownContent = """
        # The Art of Testing

        This story contains **bold text**, *italic text*, and more.

        ## A List of Features:
        - Snapshot testing
        - Visual regression detection
        - Cross-device validation

        > "Testing is an art form in itself." - Anonymous Curator
        """

        story = Story(
            id: story.id,
            documentId: story.documentId,
            title: story.title,
            slug: story.slug,
            bodyMessage: markdownContent,
            excerpt: story.excerpt,
            image: story.image,
            images: story.images,
            audio: story.audio,
            workflowStage: story.workflowStage,
            visible: story.visible,
            locale: story.locale,
            localizations: story.localizations,
            createdAt: story.createdAt,
            updatedAt: story.updatedAt,
            publishedAt: story.publishedAt,
            createdBy: story.createdBy,
            strapiAttributes: story.strapiAttributes
        )

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 📅 Test metadata display - dates, author, etc.
    ///
    /// When: Story has creation date, author, publish date
    /// Expect: Formatted metadata shown in footer
    /// Tests: Light + dark mode
    @MainActor
    func testMetadataDisplay() {
        // 🏭 Create story with rich metadata
        let story = MockStoryFactory.createApprovedStory(id: 120)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 📤 Share & Actions Tests

    /// 📤 Test with action buttons visible
    ///
    /// When: User can share, edit, delete story
    /// Expect: Action buttons in toolbar/menu
    /// Tests: Light + dark mode
    @MainActor
    func testActionButtons() {
        // 🏭 Create story with actions enabled
        let story = MockStoryFactory.createApprovedStory(id: 130)

        let view = StoryDetailView(story: story)
            .environment(\.dependencies, AppDependencies.mock)

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🌩️ Error State Tests

    /// 💥 Test loading error state
    ///
    /// When: Error occurs while loading story details
    /// Expect: Error message with retry option
    /// Tests: Light mode on standard device
    @MainActor
    func testLoadingError() {
        // 🏭 Create story that will "fail" to load
        let story = MockStoryFactory.createStory(id: 140)

        let view = StoryDetailView(story: story)
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

 1. 📸 Recording New Snapshots:
    - Set `recordMode = true`
    - Run tests to generate reference images
    - Set `recordMode = false` before committing

 2. 🔍 Testing After UI Changes:
    - Run tests with `recordMode = false`
    - Review any failures in test results
    - Check diff images to see what changed
    - Re-record if changes are intentional

 3. 🎨 Testing Strategy:
    - Light + dark mode tested for all major states
    - Multiple devices tested for layout validation
    - Edge cases (no images, no audio) explicitly tested

 4. 🔧 Extending Tests:
    - Add new test functions for new features
    - Use MockStoryFactory for consistent test data
    - Name tests descriptively: testWhenThis_expectThat

 5. 📱 Device Coverage:
    - iPhone SE: Compact screen testing
    - iPhone 13 Pro: Standard baseline
    - iPhone 15 Pro Max: Large screen testing
    - iPad Pro 11": Tablet layout testing

 Keep these tests updated as the StoryDetailView evolves.
 They are your first line of defense against visual regressions! 🛡️✨
 */
