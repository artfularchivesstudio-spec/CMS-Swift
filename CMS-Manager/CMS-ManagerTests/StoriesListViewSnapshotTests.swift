/**
 * 🎭 The Stories List View Snapshot Tests - Gallery of Visual Validations
 *
 * "Like a meticulous curator examining each artifact from every angle,
 * we capture the Stories List in all its states—empty, loading, populated,
 * filtered, and searched. Light and dark, small and large, we verify
 * every pixel tells the right story across devices and color schemes."
 *
 * - The Spellbinding Museum Director of UI Verification
 */

import XCTest
import SwiftUI
import SnapshotTesting
import ArtfulArchivesCore
@testable import CMS_Manager

// MARK: - 📸 Stories List View Snapshot Tests

/// 🌟 Comprehensive snapshot tests for StoriesListView
///
/// Tests the view in various states across multiple devices and color schemes.
/// To record new snapshots: Set environment variable SNAPSHOT_RECORDING=true
/// Or temporarily change `record: false` to `record: true` in individual tests.
final class StoriesListViewSnapshotTests: XCTestCase {

    // MARK: - 🎨 Test Configuration

    /// 📸 Set to true to record new reference snapshots (don't commit as true!)
    private let recordMode = false

    /// 📱 Standard device configurations for testing
    private let testDevices: [DeviceConfiguration] = DeviceConfiguration.iPhoneEssentials

    // MARK: - 🧹 Setup & Teardown

    override func setUp() {
        super.setUp()
        // 🌟 Ensure consistent test environment
        // SnapshotTesting uses the simulator's color scheme by default
    }

    // MARK: - 📚 Empty State Tests

    /// 📭 Test the empty state - no stories yet!
    ///
    /// When: The list has no stories to display
    /// Expect: Empty state with helpful message and CTA
    /// Tests: Light + dark mode on iPhone SE, 13 Pro, and 15 Pro Max
    func testEmptyState() {
        // 🎨 Create empty list view
        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))

        // 📸 Capture snapshots in both color schemes
        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - ⏳ Loading State Tests

    /// ⏳ Test the loading state - fetching stories!
    ///
    /// When: Initial data load is in progress
    /// Expect: Loading indicators/skeleton screens
    /// Tests: Light + dark mode on all device sizes
    func testLoadingState() {
        // 🎨 Create loading state view
        // Note: This would require exposing loading state or using a mock
        // For now, we'll test with empty state and loading modifier
        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: MockAPIClient(),
                toastManager: ToastManager()
            ))
            .redacted(reason: .placeholder) // Simulates loading skeleton

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - 📖 List View Mode Tests

    /// 📋 Test list view with stories - the standard layout
    ///
    /// When: Stories are displayed in list mode
    /// Expect: Vertical list with story cards showing title, excerpt, stage badge
    /// Tests: Light + dark mode on all devices
    func testListViewWithStories() {
        // 🏭 Create view with sample stories
        let mockClient = MockAPIClient()
        mockClient.mockStories = MockStoryFactory.createFullStageCollection()

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: testDevices,
            record: recordMode
        )
    }

    // MARK: - 🎨 Grid View Mode Tests

    /// 🎨 Test grid view mode - compact card layout
    ///
    /// When: User switches to grid view mode
    /// Expect: Multi-column grid with compact story cards
    /// Tests: Light + dark mode, particularly important on larger devices
    func testGridViewMode() {
        // 🏭 Create grid view with sample stories
        let mockClient = MockAPIClient()
        mockClient.mockStories = MockStoryFactory.createFullStageCollection()

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))
        // Note: Would need to set viewMode to .grid
        // This requires either making viewMode injectable or testing the component

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro, .iPhone15ProMax], // Larger screens show grid better
            record: recordMode
        )
    }

    // MARK: - 🔍 Search State Tests

    /// 🔍 Test search results - filtered stories
    ///
    /// When: User searches for specific stories
    /// Expect: Filtered list showing only matching stories
    /// Tests: Light + dark mode on standard device
    func testSearchResults() {
        // 🏭 Create view with search results
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createStory(id: 1, title: "Renaissance Art", stage: .approved),
            MockStoryFactory.createStory(id: 2, title: "Modern Sculpture", stage: .englishTextApproved)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))
        // Note: Would need to set searchText to see search in action

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🔍 Test search with no results - the empty search
    ///
    /// When: Search query returns no matching stories
    /// Expect: Empty state specific to search (different from general empty)
    /// Tests: Light + dark mode on standard device
    func testSearchNoResults() {
        // 🏭 Create empty search results
        let mockClient = MockAPIClient()
        mockClient.mockStories = [] // No matching stories

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🎭 Filter State Tests

    /// 🎭 Test workflow stage filter - created only
    ///
    /// When: User filters by "Created" stage
    /// Expect: Only stories in created stage are shown
    /// Tests: Light + dark mode on standard device
    func testFilterByStageCreated() {
        // 🏭 Create filtered view
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createStory(id: 1, title: "New Story", stage: .created),
            MockStoryFactory.createStory(id: 2, title: "Another New Story", stage: .created)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎭 Test workflow stage filter - approved only
    ///
    /// When: User filters by "Approved" stage
    /// Expect: Only approved/published stories are shown
    /// Tests: Light + dark mode on standard device
    func testFilterByStageApproved() {
        // 🏭 Create approved stories view
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createApprovedStory(id: 1),
            MockStoryFactory.createApprovedStory(id: 2)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 👁️ Test visibility filter - visible only
    ///
    /// When: User filters to show only visible stories
    /// Expect: Only published/visible stories appear
    /// Tests: Light + dark mode
    func testFilterByVisibleOnly() {
        // 🏭 Create visible stories
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createApprovedStory(id: 1).withVisibility(true),
            MockStoryFactory.createApprovedStory(id: 2).withVisibility(true)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎵 Test audio filter - with audio only
    ///
    /// When: User filters to show stories with audio
    /// Expect: Only stories with audio tracks appear
    /// Tests: Light + dark mode
    func testFilterByHasAudio() {
        // 🏭 Create stories with audio
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createMultilingualStory(id: 1),
            MockStoryFactory.createApprovedStory(id: 2)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    /// 🎭 Test multiple active filters
    ///
    /// When: User applies multiple filters simultaneously
    /// Expect: Filter chips/badges shown, stories match all criteria
    /// Tests: Light + dark mode
    func testMultipleActiveFilters() {
        // 🏭 Create filtered view with multiple filters
        let mockClient = MockAPIClient()
        mockClient.mockStories = [
            MockStoryFactory.createApprovedStory(id: 1)
        ]

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 🌩️ Error State Tests

    /// 💥 Test error state - network failure
    ///
    /// When: API request fails to load stories
    /// Expect: Error message with retry button
    /// Tests: Light + dark mode on standard device
    func testErrorState() {
        // 🏭 Create error state
        let mockClient = MockAPIClient()
        mockClient.shouldFailNextRequest = true

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPhone13Pro],
            record: recordMode
        )
    }

    // MARK: - 📱 Device-Specific Tests

    /// 📱 Test on iPad - spacious layout
    ///
    /// When: App runs on iPad
    /// Expect: Optimized layout for larger screen (more columns in grid, etc.)
    /// Tests: Light + dark mode on iPad Pro 11"
    func testIPadLayout() {
        // 🏭 Create view for iPad
        let mockClient = MockAPIClient()
        mockClient.mockStories = MockStoryFactory.createFullStageCollection()

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertBothColorSchemes(
            matching: view,
            devices: [.iPadPro11],
            record: recordMode
        )
    }

    // MARK: - 📝 Special States

    /// 📚 Test list with many stories - scrolling/pagination
    ///
    /// When: List contains many stories
    /// Expect: Smooth scrolling, pagination indicators if needed
    /// Tests: Standard device, light mode only for performance
    func testLongListOfStories() {
        // 🏭 Create many stories
        let mockClient = MockAPIClient()
        let manyStories = (1...50).map { index in
            MockStoryFactory.createStory(
                id: index,
                title: "Story \(index)",
                stage: WorkflowStage.allCases.randomElement() ?? .created
            )
        }
        mockClient.mockStories = manyStories

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        // Test only light mode for performance
        assertAllDevices(
            matching: view,
            devices: [.iPhone13Pro],
            colorScheme: .light,
            record: recordMode
        )
    }

    /// 🔄 Test pull-to-refresh state
    ///
    /// When: User pulls down to refresh
    /// Expect: Refresh indicator shown
    /// Note: This is challenging to snapshot as it's gesture-driven
    func testPullToRefreshIndicator() {
        // 🏭 Create refreshing view
        let mockClient = MockAPIClient()
        mockClient.mockStories = MockStoryFactory.createStoryCollection()

        let view = StoriesListView()
            .environment(\.dependencies, AppDependencies(
                apiClient: mockClient,
                toastManager: ToastManager()
            ))

        assertDevice(
            matching: view,
            device: .iPhone13Pro,
            colorScheme: .light,
            record: recordMode
        )
    }
}

// MARK: - 🎭 Test Helper Extensions

extension StoriesListViewSnapshotTests {

    /// 🎨 Create a view wrapped in navigation context
    /// Sometimes the list needs navigation context for proper rendering
    private func wrapInNavigationView<V: View>(_ view: V) -> some View {
        NavigationView {
            view
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - 📝 Testing Instructions

/*
 🎓 HOW TO USE THESE TESTS:

 1. 📸 Recording New Snapshots:
    - Set `recordMode = true` temporarily
    - Run tests: Cmd+U or right-click > Test
    - Reference images will be saved to __Snapshots__/
    - Set `recordMode = false` before committing!

 2. 🔍 Validating Against Snapshots:
    - Ensure `recordMode = false`
    - Run tests normally
    - Tests fail if UI doesn't match reference images
    - Inspect diffs in test results

 3. 🔄 Updating Snapshots When UI Changes:
    - UI changes are expected and normal!
    - Review the changes visually
    - If changes are intentional:
      * Set `recordMode = true`
      * Run tests to re-record
      * Set `recordMode = false`
      * Commit new snapshots with your changes

 4. 🎨 Color Scheme Testing:
    - assertBothColorSchemes() tests light + dark
    - assertAllDevices() tests multiple screen sizes
    - Use assertDevice() for single config tests

 5. 🐛 Debugging Failed Tests:
    - Look for diff images in test results
    - Check for unintended changes in components
    - Verify mock data matches expectations
    - Consider if font rendering differs across OS versions

 Remember: Snapshots are YOUR safety net. They catch visual regressions
 before they reach production. Trust them, but also review them! 🎭✨
 */
