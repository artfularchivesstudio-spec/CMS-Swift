# 🎭 Loading States & Skeleton Screens

Beautiful, delightful loading experiences that make waiting feel premium!

## 🌟 Overview

This directory contains a comprehensive library of loading states, skeleton screens, and custom progress indicators. Every component is designed to:

- Make waiting feel delightful, not frustrating
- Respect accessibility preferences (reduced motion, VoiceOver)
- Maintain visual consistency across the app
- Provide smooth, 60fps animations
- Support both light and dark mode

## 📁 Components

### 🎨 Core Components

#### `ShimmerModifier.swift`
- Diagonal gradient sweep animation
- Reusable modifier: `.shimmer(duration: 1.5)`
- Automatically respects reduced motion preferences
- Adaptive colors for light/dark mode

#### `SkeletonView.swift`
- Base skeleton shapes (rectangle, circle, capsule, rounded rectangle)
- `SkeletonLine` - for text placeholders
- `SkeletonImage` - for image placeholders
- `SkeletonBadge` - for badge/tag placeholders

### 📇 Content Skeletons

#### `StoryCardSkeleton.swift`
- Matches `StoryRowView` layout (list & grid)
- `StoriesListSkeleton` - full list with 5-8 cards
- Staggered fade-in animations
- Responsive grid columns

#### `StoryDetailSkeleton.swift`
- Full detail view skeleton
- Cover image, title, content paragraphs
- Audio player, workflow, metadata sections
- Realistic content proportions

#### `WizardSkeletons.swift`
- `UploadStepSkeleton` - pulsing upload area
- `AnalyzingStepSkeleton` - image with progress
- `ReviewStepSkeleton` - form fields
- `TranslationStepSkeleton` - language cards
- `AudioStepSkeleton` - voice cards with waveforms

#### `SearchResultsSkeleton.swift`
- `SearchResultsSkeleton` - compact result cards
- `EmptySearchSkeleton` - initial state
- `SearchingStateSkeleton` - active search animation
- Filter chips and search bar skeletons

### 🌀 Custom Loaders

#### `CustomProgressViews.swift`
- `CircularGradientProgress` - gradient circular spinner
- `DotsLoader` - bouncing dots sequence
- `WaveLoader` - undulating wave animation
- `PulseLoader` - breathing circle
- `GradientLinearProgress` - linear progress with gradient
- `CircularPercentageProgress` - circular with percentage text

### 🔘 Interactive Loading

#### `LoadingButton.swift`
- `LoadingButton` - async action with loading state
- `AsyncButton` - clean API for async buttons
- `loadingButtonStyle` modifier
- Replaces label with spinner while loading

#### `PullToRefreshCustom.swift`
- `CustomPullToRefresh` - elastic spring physics
- `RefreshSuccessAnimation` - burst of joy on complete
- `LoadingStateView` - idle/loading/success/error states
- Pull progress indicator with messages

### 🎯 Inline States

#### `InlineLoadingStates.swift`
- `InlineButtonLoading` - for toolbar/navigation buttons
- `InlineImageLoading` - AsyncImage with skeleton
- `InlineTextLoading` - animated dots
- `InlineRefreshIcon` - rotating refresh icon
- `InlineStatusBadge` - badge with loading state
- `InlineProgressCounter` - current/total with percentage
- `InlineDataPlaceholder` - generic content placeholder

### ♿ Accessibility

#### `LoadingAccessibility.swift`
- `AccessibleLoadingView` - respects reduce motion
- `AccessibleSkeleton` - reduced animation intensity
- `LoadingStateAnnouncement` - VoiceOver announcements
- `.announceLoadingState()` view modifier

### 🎪 Showcase

#### `LoadingStatesShowcase.swift`
- Comprehensive demo of all loading states
- Organized by category (skeletons, spinners, progress, inline, buttons)
- Interactive controls for testing
- Perfect for design reviews and testing

## 🎨 Usage Examples

### Basic Skeleton

```swift
if isLoading {
    StoryCardSkeleton(layoutStyle: .list)
} else {
    StoryRowView(story: story, layoutStyle: .list)
}
```

### Shimmer Effect

```swift
RoundedRectangle(cornerRadius: 8)
    .fill(Color.gray.opacity(0.2))
    .frame(height: 100)
    .shimmer()
```

### Loading Button

```swift
LoadingButton {
    await saveChanges()
} label: {
    HStack {
        Image(systemName: "checkmark.circle")
        Text("Save")
    }
}
.buttonStyle(.borderedProminent)
```

### Custom Progress

```swift
CircularPercentageProgress(
    progress: uploadProgress,
    size: 80,
    color: .blue
)
```

### Inline Loading

```swift
InlineDataPlaceholder(
    isLoading: isLoadingAuthor,
    skeletonWidth: 120
) {
    Text(author.name)
        .font(.caption)
}
```

### Accessible Loading

```swift
AccessibleLoadingView(
    message: "Loading stories...",
    style: .spinner
)
.announceLoadingState(
    isLoading,
    startMessage: "Loading stories",
    completeMessage: "Stories loaded successfully"
)
```

## 🎭 Design Principles

### 1. Realistic Proportions
Skeleton screens match actual content dimensions and spacing for seamless transitions.

### 2. Smooth Animations
- 60fps target
- Spring physics for natural movement
- Staggered delays for list items (50ms per item)
- 1.5s shimmer sweep

### 3. Accessibility First
- Reduced motion support
- VoiceOver announcements
- Sufficient color contrast
- Clear loading state labels

### 4. Visual Hierarchy
- Important content loads first
- Progressive disclosure
- Maintain layout stability
- Avoid cumulative layout shift

### 5. Performance
- Efficient CAGradientLayer for shimmers
- Lazy rendering for lists
- Debounced state updates
- Background caching

## 🎨 Color Schemes

### Light Mode
- Base: `Gray.opacity(0.15)`
- Shimmer: `White.opacity(0.4)`

### Dark Mode
- Base: `Gray.opacity(0.2)`
- Shimmer: `White.opacity(0.15)`

## ⏱️ Animation Timings

- **Shimmer sweep**: 1.5s linear, infinite
- **Skeleton fade-in**: 0.3s ease-out + (index * 50ms delay)
- **Content transition**: 0.3s ease-out with 0.98→1.0 scale
- **Button loading**: 0.3s spring (response: 0.3, damping: 0.7)
- **Success animation**: 0.4s spring + 0.5s fade out

## 🧪 Testing

Use `LoadingStatesShowcase` to:
- Preview all loading states
- Test accessibility features
- Verify dark mode support
- Check animation performance
- Review design consistency

```swift
#Preview {
    LoadingStatesShowcase()
}
```

## 📊 Best Practices

### When to Use Skeletons
- Initial page load (0-2 seconds expected)
- List views with multiple items
- Content-heavy detail views
- After navigation transitions

### When to Use Spinners
- Quick operations (< 1 second)
- Small UI areas (buttons, badges)
- Indeterminate progress
- Refresh operations

### When to Use Progress Bars
- File uploads/downloads
- Multi-step processes
- Known duration tasks
- Bulk operations

### When to Use Inline States
- Contextual loading (specific fields)
- Non-blocking operations
- Secondary content
- Toolbar actions

## 🎯 Performance Tips

1. **Limit simultaneous animations** - Don't show 50 shimmers at once
2. **Use LazyVStack/LazyVGrid** - Only render visible skeletons
3. **Debounce state changes** - Avoid rapid loading → loaded → loading cycles
4. **Cache skeleton views** - Reuse skeleton components
5. **Test on device** - Simulator doesn't show real performance

## 🌟 Future Enhancements

- [ ] Lottie animation support for complex loaders
- [ ] Custom skeleton templates builder
- [ ] A/B testing different loading styles
- [ ] Loading analytics (time spent, user perception)
- [ ] Skeleton screenshot testing
- [ ] Loading state presets for common patterns

---

**✨ Make waiting beautiful! ✨**

*Created by The Spellbinding Museum Director of Loading Experiences*
