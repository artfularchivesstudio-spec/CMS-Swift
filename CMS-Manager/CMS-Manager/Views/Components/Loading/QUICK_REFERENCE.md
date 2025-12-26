# ⚡ Loading States Quick Reference

One-page cheat sheet for beautiful loading states!

## 🎯 Choose Your Loader

| Scenario | Component | Usage |
|----------|-----------|-------|
| **Full stories list loading** | `StoriesListSkeleton` | `StoriesListSkeleton(viewMode: .list, count: 6)` |
| **Story detail loading** | `StoryDetailSkeleton` | `StoryDetailSkeleton()` |
| **Wizard step loading** | `UploadStepSkeleton`, etc. | `AnalyzingStepSkeleton()` |
| **Search results** | `SearchResultsSkeleton` | `SearchResultsSkeleton(count: 5)` |
| **Small spinner** | `CircularGradientProgress` | `CircularGradientProgress(size: 40)` |
| **Dots animation** | `DotsLoader` | `DotsLoader(dotSize: 10)` |
| **Wave animation** | `WaveLoader` | `WaveLoader(barCount: 5)` |
| **Pulse animation** | `PulseLoader` | `PulseLoader(size: 60)` |
| **Progress bar** | `GradientLinearProgress` | `GradientLinearProgress(progress: 0.5)` |
| **Circular progress** | `CircularPercentageProgress` | `CircularPercentageProgress(progress: 0.75)` |
| **Button loading** | `LoadingButton` | `LoadingButton { await save() } label: { Text("Save") }` |
| **Async button** | `AsyncButton` | `AsyncButton("Delete") { await delete() }` |
| **Image placeholder** | `InlineImageLoading` | `InlineImageLoading(url: url, height: 80)` |
| **Text loading** | `InlineTextLoading` | `InlineTextLoading("Loading")` |
| **Data placeholder** | `InlineDataPlaceholder` | `InlineDataPlaceholder(isLoading: true) { Text(data) }` |

## 🎨 Quick Patterns

### Full Page Skeleton
```swift
if isLoading {
    StoryDetailSkeleton()
} else {
    content
}
```

### List Skeleton
```swift
if stories.isEmpty && isLoading {
    StoriesListSkeleton(viewMode: .list)
} else {
    ForEach(stories) { StoryRowView(story: $0) }
}
```

### Loading Button
```swift
LoadingButton { await save() } label: {
    Label("Save", systemImage: "checkmark")
}
.buttonStyle(.borderedProminent)
```

### Inline Data
```swift
InlineDataPlaceholder(isLoading: isLoading, skeletonWidth: 100) {
    Text(data)
}
```

### Shimmer Any View
```swift
MyPlaceholder()
    .shimmer()
```

### Progress with Percentage
```swift
CircularPercentageProgress(progress: progress, size: 80)
```

## ♿ Accessibility

```swift
// Auto-respects reduce motion
AccessibleLoadingView(message: "Loading...")

// Announce state changes
.announceLoadingState(
    isLoading,
    startMessage: "Loading stories",
    completeMessage: "Stories loaded"
)
```

## 🎭 Transitions

```swift
// Smooth fade + scale
.transition(.opacity.combined(with: .scale(scale: 0.98)))
.animation(.easeOut(duration: 0.3), value: isLoading)

// Staggered list
ForEach(items.indices, id: \.self) { index in
    ItemView(items[index])
        .transition(.opacity)
        .animation(.easeOut.delay(Double(index) * 0.05), value: items.count)
}
```

## 📊 Common Use Cases

### Stories List
```swift
if isLoading && stories.isEmpty {
    StoriesListSkeleton(viewMode: viewMode == .list ? .list : .grid, count: 6)
} else {
    storiesList
}
```

### Story Detail
```swift
Group {
    if let story = story {
        StoryDetailView(story: story)
    } else {
        StoryDetailSkeleton()
    }
}
.animation(.easeOut(duration: 0.3), value: story != nil)
```

### Upload Image
```swift
VStack {
    CircularPercentageProgress(progress: uploadProgress, size: 100)
    Text("Uploading \(Int(uploadProgress * 100))%")
}
```

### Refreshing Data
```swift
HStack {
    InlineRefreshIcon(isRotating: isRefreshing)
    Text("Refresh")
}
```

### Author Loading
```swift
HStack {
    Text("By")
    InlineDataPlaceholder(isLoading: isLoadingAuthor, skeletonWidth: 120) {
        Text(author.name)
    }
}
```

## 🎨 Customization

### Custom Colors
```swift
CircularGradientProgress(size: 50, colors: [.purple, .pink])
GradientLinearProgress(progress: 0.5, colors: [.orange, .red])
```

### Custom Duration
```swift
.shimmer(duration: 2.0)
```

### Custom Size
```swift
DotsLoader(dotSize: 12, color: .blue)
PulseLoader(size: 80, color: .purple)
```

## 🧪 Preview/Test

```swift
#Preview {
    LoadingStatesShowcase() // See all states
}

#Preview("Skeleton") {
    StoryCardSkeleton(layoutStyle: .list)
}
```

## 💡 Tips

✅ **DO:**
- Use skeletons for initial page loads
- Match skeleton dimensions to real content
- Add smooth transitions
- Respect reduce motion
- Show progress when known

❌ **DON'T:**
- Show skeleton for < 300ms loads
- Mix different loading styles on same screen
- Block entire UI for partial updates
- Forget accessibility
- Use tiny spinners in large empty spaces

## 📏 Sizing Guide

| Content Type | Recommended Skeleton |
|--------------|---------------------|
| List item | `StoryCardSkeleton(layoutStyle: .list)` |
| Grid item | `StoryCardSkeleton(layoutStyle: .grid)` |
| Full page | `StoryDetailSkeleton()` |
| Thumbnail 80x80 | `SkeletonImage(width: 80, height: 80)` |
| Title line | `SkeletonLine(height: 20)` |
| Body text | `SkeletonLine(height: 14)` |
| Badge | `SkeletonBadge(width: 80)` |

## 🔄 State Transitions

```swift
enum LoadingState {
    case idle
    case loading
    case success
    case error
}

LoadingStateView(state: currentState)
```

---

**Quick Reference - Print and Keep Handy!** 🚀✨
