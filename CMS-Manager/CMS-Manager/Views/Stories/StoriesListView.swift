//
//  StoriesListView.swift
//  CMS-Manager
//
//  📚 The Stories List - Grand Gallery of Digital Tales
//
//  "Where all stories gather in splendid array,
//   each card a doorway to worlds unknown.
//   Search, filter, sort - the curator's dream come true."
//
//  - The Spellbinding Museum Director of Collections
//

import SwiftUI
import ArtfulArchivesCore

// MARK: - 📚 Stories List View

/// 📚 The main view for browsing all stories in the collection
struct StoriesListView: View {

    // MARK: - 🏺 Environment

    /// 🏭 App dependencies
    @Environment(\.dependencies) private var dependencies

    // MARK: - 🌟 State

    /// 📖 The stories we've fetched (using ArtfulArchivesCore Story model)
    @State private var stories: [ArtfulArchivesCore.Story] = []

    /// ⏳ Are we currently fetching?
    @State private var isLoading = false

    /// 🌩️ Any error that occurred
    @State private var error: APIError?

    /// 🔄 Pull to refresh state
    @State private var isRefreshing = false

    /// 📄 Are we loading more pages? (pagination loading indicator)
    @State private var isLoadingMore = false

    /// 💎 Are we showing cached data?
    @State private var isShowingCachedData = false

    /// 🔄 Is background sync in progress?
    @State private var isBackgroundSyncing = false

    /// 🎭 Currently selected view mode (persisted across app launches!)
    @AppStorage("storiesViewMode") private var viewMode: ViewMode = .list

    /// 📝 Search query text
    @State private var searchText = ""

    /// 🎭 Filter by workflow stage
    @State private var selectedStage: WorkflowStage?

    /// 👁️ Filter by visibility
    @State private var visibilityFilter: VisibilityFilter = .all

    /// 🎵 Filter by audio presence
    @State private var audioFilter: AudioFilter = .all

    /// 🔢 Sort option
    @State private var sortOption: SortOption = .newest

    /// 📄 Current page for pagination
    @State private var currentPage = 1

    /// 📊 Items per page
    private let pageSize = 20

    /// ⏱️ Search debounce task - preventing overeager API calls
    @State private var searchDebounceTask: Task<Void, Never>?

    // MARK: - 🎬 Animation State

    /// 🌟 Namespace for matched geometry effects (smooth layout transitions)
    @Namespace private var animation

    /// 🎭 Has the initial load animation been shown?
    @State private var hasShownInitialAnimation = false

    /// 🎨 Active filter count for animation tracking
    @State private var previousFilterCount = 0

    // MARK: - 🧮 Computed Properties

    /// 🧮 Count of active filters (excluding "All" selections)
    private var activeFilterCount: Int {
        var count = 0
        if selectedStage != nil { count += 1 }
        if visibilityFilter != .all { count += 1 }
        if audioFilter != .all { count += 1 }
        if !searchText.isEmpty { count += 1 }
        return count
    }

    /// 📊 Filtered stories based on client-side filters (visibility & audio)
    private var filteredStories: [ArtfulArchivesCore.Story] {
        stories.filter { story in
            // 👁️ Filter by visibility
            switch visibilityFilter {
            case .all: break
            case .visible where !story.visible: return false
            case .hidden where story.visible: return false
            default: break
            }

            // 🎵 Filter by audio presence
            let hasAudio = story.audio != nil && (
                story.audio?.english != nil ||
                story.audio?.spanish != nil ||
                story.audio?.hindi != nil
            )

            switch audioFilter {
            case .all: break
            case .hasAudio where !hasAudio: return false
            case .noAudio where hasAudio: return false
            default: break
            }

            return true
        }
    }

    // MARK: - 🎨 View Mode

    /// 🎨 The different ways to display stories (Codable for @AppStorage magic!)
    enum ViewMode: String, CaseIterable, Codable {
        case list = "list.bullet"
        case grid = "square.grid.2x2"

        var icon: String { rawValue }
        var name: String {
            switch self {
            case .list: "List"
            case .grid: "Grid"
            }
        }
    }

    // MARK: - 🔢 Sort Options

    /// 🔢 Ways to order the stories
    enum SortOption: String, CaseIterable {
        case newest = "Newest"
        case oldest = "Oldest"
        case titleAZ = "Title (A-Z)"
        case titleZA = "Title (Z-A)"

        var apiValue: String {
            switch self {
            case .newest: return "createdAt:desc"
            case .oldest: return "createdAt:asc"
            case .titleAZ: return "title:asc"
            case .titleZA: return "title:desc"
            }
        }
    }

    // MARK: - 👁️ Visibility Filter

    /// 👁️ Filter stories by their visibility status
    enum VisibilityFilter: String, CaseIterable {
        case all = "All"
        case visible = "Visible"
        case hidden = "Hidden"

        var icon: String {
            switch self {
            case .all: "eye.slash"
            case .visible: "eye"
            case .hidden: "eye.slash.fill"
            }
        }
    }

    // MARK: - 🎵 Audio Filter

    /// 🎵 Filter stories by audio presence
    enum AudioFilter: String, CaseIterable {
        case all = "All"
        case hasAudio = "Has Audio"
        case noAudio = "No Audio"

        var icon: String {
            switch self {
            case .all: "speaker.slash"
            case .hasAudio: "speaker.wave.2.fill"
            case .noAudio: "speaker.slash.fill"
            }
        }
    }

    // MARK: - 🎭 Body

    var body: some View {
        NavigationStack {
            ZStack {
                // 🌙 Background
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                // 📚 Content
                Group {
                    if filteredStories.isEmpty && !isLoading {
                        emptyState
                    } else {
                        storiesContent
                    }
                }
            }
            .navigationTitle("Stories (\(filteredStories.count))")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    leadingToolbarItems
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingToolbarItems
                }
            }
            .searchable(text: $searchText, prompt: "Search stories...")
            .onChange(of: searchText) { oldValue, newValue in
                // 🎭 Cancel any existing search task - no double dipping!
                searchDebounceTask?.cancel()

                // ⏱️ Wait 300ms before searching - the mystical debounce dance
                searchDebounceTask = Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    guard !Task.isCancelled else { return }

                    currentPage = 1
                    await fetchStories()
                }
            }
            .task {
                await fetchStoriesWithCache()
            }
            .refreshable {
                await refreshStories()
            }
            .overlay(alignment: .top) {
                if isShowingCachedData {
                    cacheIndicatorBanner
                }
            }
        }
    }

    // MARK: - 📚 Stories Content

    /// 📚 The main content - list or grid of stories
    /// Smoothly transitions between layouts like a magical shapeshifter
    @ViewBuilder
    private var storiesContent: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                // 🎭 Filter chips
                Section {
                    Group {
                        if viewMode == .list {
                            storyList
                        } else {
                            storyGrid
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewMode)
                } header: {
                    filterChips
                }
            }
        }
        .overlay {
            if isLoading && stories.isEmpty {
                loadingView
            }
        }
    }

    // MARK: - 📋 Story List

    /// 📋 List layout with smooth entry animations
    /// Each row glides in like a performer taking the stage
    private var storyList: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(filteredStories.enumerated()), id: \.element.id) { index, story in
                NavigationLink(destination: StoryDetailView(story: story)) {
                    StoryRowView(story: story, layoutStyle: .list)
                        .matchedGeometryEffect(id: story.id, in: animation)
                }
                .buttonStyle(.plain)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            // 🌟 Selection haptic when tapping story card
                            dependencies.hapticManager.selection()
                        }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.75)
                        .delay(hasShownInitialAnimation ? 0 : Double(index) * 0.05),
                    value: filteredStories.count
                )

                // 📄 Load more when reaching the end (check against unfiltered stories)
                if story.id == stories.last?.id {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            Task { await loadMoreIfNeeded() }
                        }
                }
            }

            // ⏳ Pagination loading indicator - the mystical scroll spinner
            if isLoadingMore {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading more stories...")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .onAppear {
            // Mark initial animation as shown after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                hasShownInitialAnimation = true
            }
        }
    }

    // MARK: - 🎨 Story Grid

    /// 🎨 Grid layout with responsive columns (2 on iPhone, 3-4 on iPad/Mac)
    /// Because who doesn't love a grid that adapts like a mystical chameleon?
    private var storyGrid: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(Array(filteredStories.enumerated()), id: \.element.id) { index, story in
                    NavigationLink(destination: StoryDetailView(story: story)) {
                        StoryRowView(story: story, layoutStyle: .grid)
                            .matchedGeometryEffect(id: story.id, in: animation)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                // 🌟 Selection haptic when tapping story card
                                dependencies.hapticManager.selection()
                            }
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.75)
                            .delay(hasShownInitialAnimation ? 0 : Double(index) * 0.04),
                        value: filteredStories.count
                    )

                    // 📄 Load more when reaching the end (check against unfiltered stories)
                    if story.id == stories.last?.id {
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                Task { await loadMoreIfNeeded() }
                            }
                    }
                }
            }

            // ⏳ Pagination loading indicator - the mystical scroll spinner
            if isLoadingMore {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading more stories...")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    /// 📐 Responsive grid columns - adapts to device size like a mystical shapeshifter
    /// iPhone: 2 columns, iPad: 3-4 columns depending on width
    private var gridColumns: [GridItem] {
        #if os(iOS)
        let columnCount: Int
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 🎨 iPad magic: more columns for that spacious canvas
            columnCount = horizontalSizeClass == .regular ? 4 : 3
        } else {
            // 📱 iPhone: cozy 2-column layout
            columnCount = 2
        }
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)
        #else
        // 💻 Mac: generous 4-column spread
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        #endif
    }

    // MARK: - 🌐 Environment for Size Class Detection

    /// 📏 Horizontal size class for iPad detection (regular = full-width iPad)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - 🏷️ Filter Chips

    /// 🏷️ Comprehensive filter section with all filter options
    private var filterChips: some View {
        VStack(spacing: 12) {
            // 🎯 Filter summary bar with active count and clear button
            if activeFilterCount > 0 {
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 14))
                        Text("\(activeFilterCount) filter\(activeFilterCount == 1 ? "" : "s") active")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.secondary)

                    Spacer()

                    Button {
                        clearAllFilters()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Clear All")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // 🎭 Workflow Stage Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Workflow Stage")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterChip("All Stages", isSelected: selectedStage == nil) {
                            selectedStage = nil
                            currentPage = 1
                            Task { await fetchStories() }
                        }

                        ForEach(WorkflowStage.allCases, id: \.self) { stage in
                            filterChip(stage.displayName, isSelected: selectedStage == stage) {
                                selectedStage = stage
                                currentPage = 1
                                Task { await fetchStories() }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            // 👁️ Visibility Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Visibility")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(VisibilityFilter.allCases, id: \.self) { filter in
                            filterChip(
                                filter.rawValue,
                                icon: filter.icon,
                                isSelected: visibilityFilter == filter
                            ) {
                                visibilityFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            // 🎵 Audio Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Audio")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(AudioFilter.allCases, id: \.self) { filter in
                            filterChip(
                                filter.rawValue,
                                icon: filter.icon,
                                isSelected: audioFilter == filter
                            ) {
                                audioFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    /// 🏷️ A single filter chip (with optional icon)
    private func filterChip(
        _ title: String,
        icon: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            // 🌊 Haptic feedback on filter selection
            dependencies.hapticManager.selection()
            action()
        } label: {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                }
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .scaleEffect(isSelected ? 1.0 : 0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    /// 🧹 Clear all active filters - the mystical reset ritual
    private func clearAllFilters() {
        // 🌟 Light haptic for clearing filters
        dependencies.hapticManager.lightImpact()

        withAnimation(.spring(response: 0.3)) {
            searchText = ""
            selectedStage = nil
            visibilityFilter = .all
            audioFilter = .all
            currentPage = 1
        }
        Task { await fetchStories() }
    }

    // MARK: - 🛠️ Toolbar Items

    /// 🛠️ Leading toolbar items (view mode toggle)
    private var leadingToolbarItems: some View {
        HStack(spacing: 8) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                viewModeButton(for: mode)
            }
        }
    }

    /// 🎨 A single view mode toggle button
    private func viewModeButton(for mode: ViewMode) -> some View {
        let isSelected = viewMode == mode

        return Button {
            // 🌊 Haptic feedback on mode toggle
            dependencies.hapticManager.lightImpact()

            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewMode = mode
                hasShownInitialAnimation = false // Reset for new layout animation
            }

            // Re-enable initial animation after layout settles
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                hasShownInitialAnimation = true
            }
        } label: {
            Image(systemName: mode.icon)
                .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                )
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
    }

    /// 🛠️ Trailing toolbar items (sort menu)
    private var trailingToolbarItems: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button {
                    // 🌟 Selection haptic for sort change
                    dependencies.hapticManager.selection()

                    sortOption = option
                    currentPage = 1
                    Task { await fetchStories() }
                } label: {
                    HStack {
                        Text(option.rawValue)
                        if sortOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 🌙 Empty State

    /// 🌙 Shown when no stories match the filters
    @State private var emptyStateScale: CGFloat = 0.8

    private var emptyState: some View {
        VStack(spacing: 20) {
            // 🎨 Icon changes based on context with gentle breathing animation
            Image(systemName: activeFilterCount > 0 ? "line.3.horizontal.decrease.circle" : "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.tertiary)
                .scaleEffect(emptyStateScale)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.6)
                        .repeatForever(autoreverses: true),
                    value: emptyStateScale
                )
                .onAppear {
                    emptyStateScale = 1.0
                }

            Text(emptyStateTitle)
                .font(.system(size: 20, weight: .semibold))

            Text(emptyStateMessage)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            if activeFilterCount > 0 {
                Button {
                    clearAllFilters()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                        Text("Clear All Filters")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button {
                    Task { await refreshStories() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14))
                        Text("Refresh")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: filteredStories.isEmpty)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No stories found. Try adjusting your search or filters.")
    }

    /// 📝 Empty state title based on context
    private var emptyStateTitle: String {
        if activeFilterCount > 0 {
            return "No Stories Match Your Filters"
        } else if !searchText.isEmpty {
            return "No Stories Found"
        } else {
            return "No Stories Yet"
        }
    }

    /// 📝 Empty state message based on context
    private var emptyStateMessage: String {
        if activeFilterCount > 0 {
            return "Try adjusting your filters or clearing them to see more stories."
        } else if !searchText.isEmpty {
            return "We couldn't find any stories matching '\(searchText)'. Try a different search term."
        } else {
            return "Stories will appear here once they're created. Pull down to refresh."
        }
    }

    // MARK: - ⏳ Loading View

    /// ⏳ Shown while fetching initial data with beautiful skeleton cards
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Show skeleton cards based on current view mode
                ForEach(0..<6, id: \.self) { index in
                    if viewMode == .list {
                        SkeletonCard(layoutStyle: .list)
                            .transition(.opacity.combined(with: .scale))
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.75)
                                    .delay(Double(index) * 0.05),
                                value: isLoading
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .accessibilityLabel("Loading stories")
    }

    // MARK: - 💎 Cache Indicator Banner

    /// 💎 Banner shown when viewing cached data
    private var cacheIndicatorBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.clockwise.icloud")
                .font(.system(size: 13, weight: .medium))

            Text("Viewing cached stories")
                .font(.system(size: 13, weight: .medium))

            if isBackgroundSyncing {
                ProgressView()
                    .scaleEffect(0.7)
            }

            Spacer()

            Button {
                Task {
                    isShowingCachedData = false
                    await fetchFromNetworkAndSync()
                }
            } label: {
                Text("Refresh")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.orange.opacity(0.15))
        .overlay(
            Rectangle()
                .fill(Color.orange.opacity(0.3))
                .frame(height: 1),
            alignment: .bottom
        )
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(response: 0.3), value: isShowingCachedData)
    }

    // MARK: - 🌐 Fetch Stories

    /// 💎 Fetch stories with cache-first strategy
    /// Loads cached stories immediately for instant display, then syncs with network
    private func fetchStoriesWithCache() async {
        // 🎭 Step 1: Load from cache immediately (instant display!)
        await loadFromCache()

        // 🌐 Step 2: Fetch from network in background
        await fetchFromNetworkAndSync()
    }

    /// 💎 Load stories from cache
    private func loadFromCache() async {
        print("💎 ✨ LOADING STORIES FROM CACHE...")

        do {
            let cachedStories = try await dependencies.storyCacheManager.getAllCachedStories()

            if !cachedStories.isEmpty {
                stories = cachedStories
                isShowingCachedData = true
                print("💎 Loaded \(cachedStories.count) stories from cache")
            }
        } catch {
            print("🌩️ Failed to load from cache: \(error.localizedDescription)")
        }
    }

    /// 🌐 Fetch stories from the API and sync with cache
    private func fetchFromNetworkAndSync() async {
        isBackgroundSyncing = true
        if stories.isEmpty {
            isLoading = true
        }
        error = nil

        do {
            let response = try await dependencies.apiClient.fetchStories(
                page: currentPage,
                pageSize: pageSize,
                stage: selectedStage,
                search: searchText.isEmpty ? nil : searchText,
                sort: sortOption.apiValue
            )

            let networkStories = response.stories.map { convertToCoreStory($0) }

            if currentPage == 1 {
                stories = networkStories
            } else {
                stories.append(contentsOf: networkStories)
            }

            // 💾 Cache all fetched stories in background
            Task.detached { [stories = networkStories, dependencies] in
                for story in stories {
                    try? await dependencies.storyCacheManager.cacheStory(story)
                }
                print("💎 Cached \(stories.count) stories in background")
            }

            isShowingCachedData = false
            print("🎉 ✨ STORIES LIST MASTERPIECE COMPLETE! \(stories.count) stories loaded")
        } catch let apiError as APIError {
            self.error = apiError
            print("🌩️ STORIES LIST ERROR: \(apiError.localizedDescription)")

            // 🌙 If network failed but we have cached data, show a gentle toast
            if isShowingCachedData {
                await MainActor.run {
                    dependencies.toastManager.info("Viewing cached stories", message: "Network unavailable")
                }
            }
        } catch {
            print("💥 😭 STORIES FETCH FAILED! \(error.localizedDescription)")

            if isShowingCachedData {
                await MainActor.run {
                    dependencies.toastManager.info("Viewing cached stories", message: "Network unavailable")
                }
            }
        }

        isLoading = false
        isBackgroundSyncing = false
    }

    /// 🌐 Fetch stories from the API (for search/filter changes)
    private func fetchStories() async {
        await fetchFromNetworkAndSync()
    }

    /// 🔄 Convert API StoryResponse to core Story model
    private func convertToCoreStory(_ story: ArtfulArchivesCore.Story) -> ArtfulArchivesCore.Story {
        story
    }

    /// 🔄 Refresh stories (pull-to-refresh with visual feedback)
    private func refreshStories() async {
        isRefreshing = true

        // 🌟 Light haptic when pull-to-refresh starts
        dependencies.hapticManager.lightImpact()

        currentPage = 1
        isShowingCachedData = false // Force network refresh
        await fetchFromNetworkAndSync()
        isRefreshing = false

        // 🎉 Medium haptic feedback on successful refresh
        dependencies.hapticManager.mediumImpact()

        print("🔄 ✨ STORIES REFRESH COMPLETE! \(filteredStories.count) stories displayed")
    }

    /// 📄 Load more stories (pagination with that spellbinding spinner)
    private func loadMoreIfNeeded() async {
        guard !isLoading && !isLoadingMore else { return }

        isLoadingMore = true
        currentPage += 1
        await fetchStories()
        isLoadingMore = false
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview {
    StoriesListView()
        .withDependencies(.mock)
}
