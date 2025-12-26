//
//  InlineLoadingStates.swift
//  CMS-Manager
//
//  🎯 The Inline Loading Maestro - Contextual Loading Magic
//
//  "Not all loading happens full-screen - sometimes we need
//   subtle spinners in buttons, shimmering images,
//   and animated placeholders that live inline with content."
//
//  - The Spellbinding Museum Director of Micro-Interactions
//

import SwiftUI

// MARK: - 🔘 Inline Button Loading

/// 🔘 Loading state for inline buttons
/// Shrinks the label and shows a spinner - smooth as butter! 🧈
struct InlineButtonLoading: View {

    let isLoading: Bool
    let label: String
    let icon: String?

    /// 🔘 Create an inline button with loading state
    /// - Parameters:
    ///   - isLoading: Whether button is loading
    ///   - label: Button text
    ///   - icon: Optional SF Symbol name
    init(
        isLoading: Bool,
        label: String,
        icon: String? = nil
    ) {
        self.isLoading = isLoading
        self.label = label
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                    .transition(.scale.combined(with: .opacity))
            } else if let icon = icon {
                Image(systemName: icon)
                    .transition(.scale.combined(with: .opacity))
            }

            Text(label)
                .opacity(isLoading ? 0.6 : 1.0)
        }
        .animation(.spring(response: 0.3), value: isLoading)
    }
}

// MARK: - 🖼️ Inline Image Loading

/// 🖼️ Loading state for inline images
/// Shows shimmer while loading, then fades to actual image! 🎨
struct InlineImageLoading: View {

    let url: URL?
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    /// 🖼️ Create an inline image with loading state
    /// - Parameters:
    ///   - url: Image URL
    ///   - width: Fixed width (nil = flexible)
    ///   - height: Fixed height
    ///   - cornerRadius: Corner radius (default: 8)
    init(
        url: URL?,
        width: CGFloat? = nil,
        height: CGFloat,
        cornerRadius: CGFloat = 8
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholderView
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .transition(.opacity)
                    case .failure:
                        errorView
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    /// 📦 Placeholder while loading
    private var placeholderView: some View {
        SkeletonImage(width: width, height: height, cornerRadius: cornerRadius)
    }

    /// ❌ Error state
    private var errorView: some View {
        ZStack {
            Color.gray.opacity(0.2)

            Image(systemName: "photo.fill")
                .font(.system(size: height * 0.3))
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - 📝 Inline Text Loading

/// 📝 Loading text with animated dots
/// Classic "Loading..." with dancing dots! 💃
struct InlineTextLoading: View {

    let text: String
    let showDots: Bool

    @State private var dotCount: Int = 0

    /// 📝 Create inline loading text
    /// - Parameters:
    ///   - text: Base text (e.g., "Loading")
    ///   - showDots: Whether to show animated dots (default: true)
    init(_ text: String = "Loading", showDots: Bool = true) {
        self.text = text
        self.showDots = showDots
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            if showDots {
                Text(String(repeating: ".", count: dotCount))
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(width: 20, alignment: .leading)
                    .onAppear {
                        startDotAnimation()
                    }
            }
        }
    }

    /// 💫 Animate the dots
    private func startDotAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            dotCount = (dotCount + 1) % 4
        }
    }
}

// MARK: - 🔄 Inline Refresh Icon

/// 🔄 Rotating refresh icon
/// Perfect for refresh buttons and update indicators! 🔃
struct InlineRefreshIcon: View {

    let isRotating: Bool
    let size: CGFloat
    let color: Color

    @State private var rotation: Double = 0

    /// 🔄 Create a rotating refresh icon
    /// - Parameters:
    ///   - isRotating: Whether icon should rotate
    ///   - size: Icon size (default: 16)
    ///   - color: Icon color (default: secondary)
    init(
        isRotating: Bool,
        size: CGFloat = 16,
        color: Color = .secondary
    ) {
        self.isRotating = isRotating
        self.size = size
        self.color = color
    }

    var body: some View {
        Image(systemName: "arrow.clockwise")
            .font(.system(size: size))
            .foregroundStyle(color)
            .rotationEffect(.degrees(rotation))
            .onChange(of: isRotating) { _, newValue in
                if newValue {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                } else {
                    withAnimation(.spring(response: 0.3)) {
                        rotation = 0
                    }
                }
            }
    }
}

// MARK: - 💬 Inline Status Badge

/// 💬 Status badge with loading state
/// Shows shimmer when loading, then actual status! 🏷️
struct InlineStatusBadge: View {

    let isLoading: Bool
    let status: String?
    let color: Color

    /// 💬 Create a status badge with loading state
    /// - Parameters:
    ///   - isLoading: Whether badge is loading
    ///   - status: Status text (nil = loading)
    ///   - color: Badge color (default: blue)
    init(
        isLoading: Bool,
        status: String? = nil,
        color: Color = .blue
    ) {
        self.isLoading = isLoading
        self.status = status
        self.color = color
    }

    var body: some View {
        Group {
            if isLoading || status == nil {
                SkeletonBadge(width: 80)
            } else {
                Text(status!)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(color)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: isLoading)
    }
}

// MARK: - 📊 Inline Progress Counter

/// 📊 Progress counter with percentage
/// Shows current progress with smooth number transitions! 🔢
struct InlineProgressCounter: View {

    let current: Int
    let total: Int
    let isLoading: Bool

    /// 📊 Create a progress counter
    /// - Parameters:
    ///   - current: Current progress
    ///   - total: Total items
    ///   - isLoading: Whether still loading
    init(current: Int, total: Int, isLoading: Bool = false) {
        self.current = current
        self.total = total
        self.isLoading = isLoading
    }

    var body: some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.7)
            }

            Text("\(current)/\(total)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: current)

            if total > 0 {
                Text("(\(Int((Double(current) / Double(total)) * 100))%)")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.tertiary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: current)
            }
        }
    }
}

// MARK: - 🎯 Inline Data Placeholder

/// 🎯 Placeholder for inline data that's loading
/// Shows skeleton, then fades to actual content! 📊
struct InlineDataPlaceholder<Content: View>: View {

    let isLoading: Bool
    let skeletonWidth: CGFloat
    let skeletonHeight: CGFloat
    @ViewBuilder let content: () -> Content

    /// 🎯 Create an inline data placeholder
    /// - Parameters:
    ///   - isLoading: Whether data is loading
    ///   - skeletonWidth: Width of skeleton (default: 100)
    ///   - skeletonHeight: Height of skeleton (default: 14)
    ///   - content: Actual content to show when loaded
    init(
        isLoading: Bool,
        skeletonWidth: CGFloat = 100,
        skeletonHeight: CGFloat = 14,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isLoading = isLoading
        self.skeletonWidth = skeletonWidth
        self.skeletonHeight = skeletonHeight
        self.content = content
    }

    var body: some View {
        Group {
            if isLoading {
                SkeletonLine(width: skeletonWidth, height: skeletonHeight)
                    .transition(.opacity)
            } else {
                content()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(response: 0.3), value: isLoading)
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Inline Loading States") {
    ScrollView {
        VStack(spacing: 30) {
            // 🔘 Button Loading
            VStack(alignment: .leading, spacing: 12) {
                Text("Button Loading")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Button {} label: {
                        InlineButtonLoading(
                            isLoading: false,
                            label: "Save",
                            icon: "checkmark"
                        )
                    }
                    .buttonStyle(.borderedProminent)

                    Button {} label: {
                        InlineButtonLoading(
                            isLoading: true,
                            label: "Saving...",
                            icon: "checkmark"
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
                }
            }

            Divider()

            // 🖼️ Image Loading
            VStack(alignment: .leading, spacing: 12) {
                Text("Image Loading")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    InlineImageLoading(
                        url: nil,
                        width: 80,
                        height: 80
                    )

                    InlineImageLoading(
                        url: URL(string: "https://picsum.photos/200"),
                        width: 80,
                        height: 80
                    )
                }
            }

            Divider()

            // 📝 Text Loading
            VStack(alignment: .leading, spacing: 12) {
                Text("Text Loading")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                InlineTextLoading("Loading stories")
                InlineTextLoading("Syncing", showDots: true)
            }

            Divider()

            // 🔄 Refresh Icon
            VStack(alignment: .leading, spacing: 12) {
                Text("Refresh Icon")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 20) {
                    InlineRefreshIcon(isRotating: false)
                    InlineRefreshIcon(isRotating: true)
                }
            }

            Divider()

            // 💬 Status Badges
            VStack(alignment: .leading, spacing: 12) {
                Text("Status Badges")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    InlineStatusBadge(isLoading: true)
                    InlineStatusBadge(isLoading: false, status: "Approved", color: .green)
                }
            }

            Divider()

            // 📊 Progress Counter
            VStack(alignment: .leading, spacing: 12) {
                Text("Progress Counter")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                InlineProgressCounter(current: 7, total: 10, isLoading: false)
                InlineProgressCounter(current: 3, total: 10, isLoading: true)
            }

            Divider()

            // 🎯 Data Placeholder
            VStack(alignment: .leading, spacing: 12) {
                Text("Data Placeholder")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                InlineDataPlaceholder(isLoading: true, skeletonWidth: 150) {
                    Text("Loaded Content")
                        .font(.system(size: 14))
                }

                InlineDataPlaceholder(isLoading: false, skeletonWidth: 150) {
                    Text("Loaded Content")
                        .font(.system(size: 14))
                }
            }
        }
        .padding()
    }
    .background(Color(uiColor: .systemGroupedBackground))
}
