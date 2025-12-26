# 🚀 Loading States Integration Guide

Quick guide for integrating beautiful loading states into existing views!

## 📚 StoriesListView Integration

### Before (Basic Loading)
```swift
var body: some View {
    if isLoading {
        ProgressView("Loading...")
    } else {
        // Stories list
    }
}
```

### After (Beautiful Skeleton)
```swift
var body: some View {
    if isLoading && stories.isEmpty {
        StoriesListSkeleton(
            viewMode: viewMode == .list ? .list : .grid,
            count: 6
        )
    } else {
        // Stories list with smooth fade-in
        storiesContent
            .transition(.opacity.combined(with: .scale(scale: 0.98)))
    }
}
```

## 📖 StoryDetailView Integration

### Before
```swift
var body: some View {
    if let story = story {
        // Detail content
    } else {
        ProgressView()
    }
}
```

### After
```swift
var body: some View {
    Group {
        if let story = story {
            detailContent(for: story)
                .transition(.opacity)
        } else {
            StoryDetailSkeleton()
                .transition(.opacity)
        }
    }
    .animation(.easeOut(duration: 0.3), value: story != nil)
}
```

## 🧙 Wizard Steps Integration

### Upload Step
```swift
var body: some View {
    if isInitializing {
        UploadStepSkeleton()
    } else {
        uploadContent
    }
}
```

### Analyzing Step
```swift
var body: some View {
    if isAnalyzing {
        AnalyzingStepSkeleton()
    } else {
        analysisResults
    }
}
```

### Translation Step
```swift
var body: some View {
    if isLoadingTranslations {
        TranslationStepSkeleton()
    } else {
        translationCards
    }
}
```

## 🔘 Button Loading States

### Simple Button
```swift
// Before
Button("Save") {
    Task { await save() }
}

// After
LoadingButton {
    await save()
} label: {
    HStack {
        Image(systemName: "checkmark.circle")
        Text("Save")
    }
}
.buttonStyle(.borderedProminent)
```

### Async Button
```swift
AsyncButton("Delete", role: .destructive) {
    await deleteStory()
}
.buttonStyle(.bordered)
```

## 🔄 Pull to Refresh

### Integration with ScrollView
```swift
ScrollView {
    // Content
}
.refreshable {
    await refreshStories()
}
// Native refreshable modifier already looks great!
// Use CustomPullToRefresh only if you need custom styling
```

## 🎯 Inline Loading States

### Loading Author Name
```swift
HStack {
    Text("Author:")
    InlineDataPlaceholder(
        isLoading: isLoadingAuthor,
        skeletonWidth: 100
    ) {
        Text(author.name)
    }
}
```

### Status Badge
```swift
InlineStatusBadge(
    isLoading: isUpdatingStatus,
    status: story.workflowStage.displayName,
    color: stageColor(for: story.workflowStage)
)
```

### Refresh Icon
```swift
Button {
    Task { await refresh() }
} label: {
    HStack {
        InlineRefreshIcon(isRotating: isRefreshing)
        Text("Refresh")
    }
}
```

## 📊 Progress Indicators

### Upload Progress
```swift
VStack(spacing: 12) {
    CircularPercentageProgress(
        progress: uploadProgress,
        size: 100,
        color: .blue
    )

    Text("Uploading \(Int(uploadProgress * 100))%")
        .font(.caption)
}
```

### Linear Progress
```swift
VStack(spacing: 8) {
    HStack {
        Text("Processing")
        Spacer()
        Text("\(currentItem)/\(totalItems)")
    }
    .font(.caption)

    GradientLinearProgress(
        progress: Double(currentItem) / Double(totalItems),
        colors: [.blue, .purple]
    )
}
```

## 🖼️ Image Loading

### Story Thumbnail
```swift
// Before
AsyncImage(url: imageURL) { image in
    image.resizable()
} placeholder: {
    ProgressView()
}

// After
InlineImageLoading(
    url: imageURL,
    width: 80,
    height: 80,
    cornerRadius: 8
)
```

## 🔍 Search Integration

### Search Results
```swift
var body: some View {
    Group {
        if isSearching {
            SearchingStateSkeleton()
        } else if searchResults.isEmpty && !searchText.isEmpty {
            // Empty state
        } else if searchResults.isEmpty {
            EmptySearchSkeleton()
        } else {
            searchResultsList
        }
    }
}
```

## ♿ Accessibility Support

### Add Loading Announcements
```swift
.task {
    await fetchData()
}
.announceLoadingState(
    isLoading,
    startMessage: "Loading stories",
    completeMessage: "Stories loaded successfully"
)
```

### Use Accessible Loaders
```swift
// Automatically adapts to reduced motion
AccessibleLoadingView(
    message: "Loading content...",
    style: .spinner
)
```

## 🎨 Custom Shimmer

### Any View
```swift
MyCustomView()
    .shimmer() // Default 1.5s
    .shimmer(duration: 2.0) // Custom duration
```

## 💡 Best Practices

### 1. Show Skeleton on Initial Load
```swift
.task {
    if stories.isEmpty {
        // Shows skeleton during first load
        await fetchStories()
    }
}
```

### 2. Use Inline States for Partial Updates
```swift
// Don't replace entire view with spinner
// Just show loading in affected area
HStack {
    Image(systemName: "clock")
    InlineTextLoading("Updating")
}
```

### 3. Smooth Transitions
```swift
.transition(.opacity.combined(with: .scale(scale: 0.98)))
.animation(.easeOut(duration: 0.3), value: isLoading)
```

### 4. Avoid Layout Shifts
```swift
// Skeleton should match real content size
// Use same padding, spacing, frame sizes
```

### 5. Debounce Rapid Changes
```swift
@State private var loadingTask: Task<Void, Never>?

func load() {
    loadingTask?.cancel()
    loadingTask = Task {
        try? await Task.sleep(for: .milliseconds(200))
        guard !Task.isCancelled else { return }
        await actualLoad()
    }
}
```

## 🧪 Testing Loading States

### Preview with Delay
```swift
#Preview("Loading State") {
    StoriesListView()
        .task {
            try? await Task.sleep(for: .seconds(2))
            // Simulates 2-second load
        }
}
```

### Showcase View
```swift
#Preview {
    LoadingStatesShowcase()
}
```

## 🚀 Quick Wins

### Replace all ProgressView with:
1. **Full screen**: Use skeleton screens
2. **Small areas**: Use custom spinners (DotsLoader, CircularGradientProgress)
3. **Buttons**: Use LoadingButton or AsyncButton
4. **Images**: Use InlineImageLoading
5. **Text/Data**: Use InlineDataPlaceholder

### Add these modifiers:
- `.shimmer()` - Instant polish on placeholders
- `.announceLoadingState()` - Better accessibility
- `.transition(.opacity.combined(with: .scale))` - Smooth reveals

---

**✨ Transform every loading experience into a delightful moment! ✨**
