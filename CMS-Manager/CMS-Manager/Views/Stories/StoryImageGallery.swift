//
//  StoryImageGallery.swift
//  CMS-Manager
//
//  🖼️ The Image Gallery - A Canvas of Visual Splendor
//
//  "Where every swipe unveils a new masterpiece,
//   every pinch brings you closer to artistic truth,
//   and parallax scrolling adds depth to the digital canvas."
//
//  - The Spellbinding Museum Director of Visual Exhibition
//

import SwiftUI
import ArtfulArchivesCore

// MARK: - 🖼️ Story Image Gallery

/// 🖼️ An immersive image gallery with parallax, zoom, and swipe gestures
/// ✨ Features: horizontal scrolling, page indicators, pinch-to-zoom, double-tap zoom, parallax effects
struct StoryImageGallery: View {

    // MARK: - 🏺 Properties

    /// 🖼️ The images to display
    let images: [StoryMedia]

    /// 🎭 Namespace for matched geometry effects
    var namespace: Namespace.ID?

    // MARK: - 🌟 State

    /// 📍 Current page index
    @State private var currentPage = 0

    /// 🔍 Zoom scale for current image
    @State private var scale: CGFloat = 1.0

    /// 📐 Offset for panning zoomed image
    @State private var offset: CGSize = .zero

    /// 🎯 Last scale (for gesture)
    @State private var lastScale: CGFloat = 1.0

    /// 🎨 Parallax scroll offset
    @State private var parallaxOffset: CGFloat = 0

    /// 💫 Show full-screen viewer
    @State private var showFullScreen = false

    /// 🌟 Image loading states
    @State private var imageLoadingStates: [Int: Bool] = [:]

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 16) {
            // 🖼️ Main gallery
            TabView(selection: $currentPage) {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, image in
                    galleryImage(image, at: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            .onChange(of: currentPage) { oldValue, newValue in
                // 🎵 Haptic feedback on page change
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()

                // 🔄 Reset zoom when changing pages
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    scale = 1.0
                    offset = .zero
                    lastScale = 1.0
                }
            }

            // 📍 Custom page indicators with animation
            if images.count > 1 {
                pageIndicators
            }
        }
        .sheet(isPresented: $showFullScreen) {
            fullScreenViewer
        }
    }

    // MARK: - 🖼️ Gallery Image

    /// 🖼️ A single gallery image with parallax and zoom
    private func galleryImage(_ image: StoryMedia, at index: Int) -> some View {
        GeometryReader { geometry in
            AsyncImage(url: image.url) { phase in
                switch phase {
                case .empty:
                    // ✨ Shimmer loading effect
                    ZStack {
                        shimmerGradient
                            .frame(width: geometry.size.width, height: geometry.size.height)

                        ProgressView()
                            .tint(.white)
                    }
                    .onAppear {
                        imageLoadingStates[index] = false
                    }

                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(zoomGesture)
                        .gesture(panGesture)
                        .onTapGesture(count: 2) {
                            // 🎯 Double-tap to zoom
                            doubleTapToZoom()
                        }
                        .onTapGesture(count: 1) {
                            // 👆 Single tap to show full screen
                            showFullScreen = true
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.4)) {
                                imageLoadingStates[index] = true
                            }
                        }

                case .failure:
                    // 🌩️ Error placeholder
                    ZStack {
                        Color.gray.opacity(0.2)

                        VStack(spacing: 12) {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.tertiary)

                            Text("Image unavailable")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }

                @unknown default:
                    EmptyView()
                }
            }
            // 🌊 Parallax effect - image scrolls slower than container
            .offset(x: parallaxEffect(for: index, in: geometry))
        }
        .clipped()
        .accessibilityLabel(image.alternativeText ?? "Gallery image \(index + 1)")
    }

    // MARK: - 📍 Page Indicators

    /// 📍 Custom animated page indicators
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<images.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                    .frame(width: index == currentPage ? 8 : 6, height: index == currentPage ? 8 : 6)
                    .overlay {
                        if index == currentPage {
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                .scaleEffect(1.5)
                        }
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        )
    }

    // MARK: - 🌊 Parallax Effect

    /// 🌊 Calculate parallax offset for image
    private func parallaxEffect(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        // Calculate the horizontal position of this page relative to the screen
        let minX = geometry.frame(in: .global).minX
        let width = geometry.size.width

        // Parallax multiplier (0.2 means image moves 20% of scroll distance)
        let parallaxMultiplier: CGFloat = 0.2

        return -minX * parallaxMultiplier
    }

    // MARK: - 🔍 Zoom Gestures

    /// 🔍 Pinch to zoom gesture
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value

                // 🎯 Limit zoom range (0.5x to 4x)
                let newScale = scale * delta
                scale = max(0.5, min(4.0, newScale))
            }
            .onEnded { _ in
                lastScale = 1.0

                // 🔄 Reset zoom if less than 1x
                if scale < 1.0 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 1.0
                        offset = .zero
                    }
                }
            }
    }

    /// 📐 Pan gesture for zoomed image
    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // Only allow panning when zoomed in
                if scale > 1.0 {
                    offset = value.translation
                }
            }
            .onEnded { _ in
                // Snap back if panned too far
                if scale <= 1.0 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = .zero
                    }
                }
            }
    }

    /// 🎯 Double-tap to zoom action
    private func doubleTapToZoom() {
        // 🎵 Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            if scale > 1.0 {
                // Zoom out
                scale = 1.0
                offset = .zero
            } else {
                // Zoom in to 2x
                scale = 2.0
            }
        }
    }

    // MARK: - ✨ Shimmer Effect

    /// ✨ Animated shimmer gradient for loading state
    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.5),
                Color.gray.opacity(0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .overlay {
            GeometryReader { geometry in
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geometry.size.width / 2)
                .offset(x: shimmerOffset(for: geometry.size.width))
            }
        }
    }

    /// 🌟 Calculate shimmer animation offset
    @State private var shimmerAnimation = false

    private func shimmerOffset(for width: CGFloat) -> CGFloat {
        shimmerAnimation ? width : -width / 2
    }

    // MARK: - 🖼️ Full Screen Viewer

    /// 🖼️ Full-screen image viewer with dismiss gesture
    private var fullScreenViewer: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            TabView(selection: $currentPage) {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, image in
                    AsyncImage(url: image.url) { phase in
                        if case .success(let loadedImage) = phase {
                            loadedImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)

            VStack {
                HStack {
                    Spacer()

                    Button {
                        showFullScreen = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }
                    .padding()
                }

                Spacer()
            }
        }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview {
    @Previewable @Namespace var namespace

    StoryImageGallery(
        images: [
            StoryMedia(
                id: 1,
                name: "image1.jpg",
                alternativeText: "First image",
                url: URL(string: "https://picsum.photos/800/600")!
            ),
            StoryMedia(
                id: 2,
                name: "image2.jpg",
                alternativeText: "Second image",
                url: URL(string: "https://picsum.photos/800/601")!
            ),
            StoryMedia(
                id: 3,
                name: "image3.jpg",
                alternativeText: "Third image",
                url: URL(string: "https://picsum.photos/800/602")!
            )
        ],
        namespace: namespace
    )
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
