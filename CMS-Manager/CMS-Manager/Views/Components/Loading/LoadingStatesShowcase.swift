//
//  LoadingStatesShowcase.swift
//  CMS-Manager
//
//  🎪 The Loading States Gallery - A Museum of Wait Experiences
//
//  "Step right up and witness every loading state imaginable!
//   From skeletons to spinners, from shimmers to success animations,
//   this showcase proves that waiting can be beautiful."
//
//  - The Spellbinding Museum Director of Loading State Excellence
//

import SwiftUI

// MARK: - 🎪 Loading States Showcase

/// 🎪 A comprehensive showcase of all loading states and animations
/// Perfect for testing, demos, and design reviews! 🎨
struct LoadingStatesShowcase: View {

    // MARK: - 🌟 State

    @State private var selectedTab: ShowcaseTab = .skeletons
    @State private var demoProgress: Double = 0.3
    @State private var isRefreshing: Bool = false
    @State private var pullProgress: Double = 0.5

    // MARK: - 🎨 Tabs

    enum ShowcaseTab: String, CaseIterable {
        case skeletons = "Skeletons"
        case spinners = "Spinners"
        case progress = "Progress"
        case inline = "Inline"
        case buttons = "Buttons"

        var icon: String {
            switch self {
            case .skeletons: return "rectangle.3.group"
            case .spinners: return "circle.dotted"
            case .progress: return "gauge.with.dots.needle.50percent"
            case .inline: return "text.alignleft"
            case .buttons: return "button.programmable"
            }
        }
    }

    // MARK: - 🎭 Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🏷️ Tab Picker
                Picker("Category", selection: $selectedTab) {
                    ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                        Label(tab.rawValue, systemImage: tab.icon)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // 📜 Content
                ScrollView {
                    Group {
                        switch selectedTab {
                        case .skeletons:
                            skeletonsSection
                        case .spinners:
                            spinnersSection
                        case .progress:
                            progressSection
                        case .inline:
                            inlineSection
                        case .buttons:
                            buttonsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🎪 Loading States Showcase")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }

    // MARK: - 💀 Skeletons Section

    private var skeletonsSection: some View {
        VStack(spacing: 24) {
            showcaseCard(title: "Story Card Skeleton - List") {
                StoryCardSkeleton(layoutStyle: .list)
            }

            showcaseCard(title: "Story Card Skeleton - Grid") {
                StoryCardSkeleton(layoutStyle: .grid)
            }

            showcaseCard(title: "Search Results Skeleton") {
                SearchResultsSkeleton(count: 3, showSearchBar: true)
                    .frame(height: 400)
            }

            showcaseCard(title: "Upload Step Skeleton") {
                UploadStepSkeleton()
                    .frame(height: 400)
            }

            showcaseCard(title: "Analyzing Step Skeleton") {
                AnalyzingStepSkeleton()
                    .frame(height: 400)
            }
        }
    }

    // MARK: - 🌀 Spinners Section

    private var spinnersSection: some View {
        VStack(spacing: 24) {
            showcaseCard(title: "Circular Gradient Progress") {
                HStack(spacing: 30) {
                    CircularGradientProgress(size: 40)
                    CircularGradientProgress(size: 60, colors: [.purple, .pink])
                    CircularGradientProgress(size: 80, colors: [.orange, .red])
                }
                .padding()
            }

            showcaseCard(title: "Dots Loader") {
                VStack(spacing: 20) {
                    DotsLoader(dotSize: 8)
                    DotsLoader(dotSize: 10, color: .purple)
                    DotsLoader(dotSize: 12, color: .orange)
                }
                .padding()
            }

            showcaseCard(title: "Wave Loader") {
                VStack(spacing: 20) {
                    WaveLoader()
                    WaveLoader(barCount: 7, color: .purple)
                    WaveLoader(barCount: 9, barHeight: 40, color: .orange)
                }
                .padding()
            }

            showcaseCard(title: "Pulse Loader") {
                HStack(spacing: 30) {
                    PulseLoader(size: 50)
                    PulseLoader(size: 70, color: .purple)
                    PulseLoader(size: 90, color: .orange)
                }
                .padding()
            }
        }
    }

    // MARK: - 📊 Progress Section

    private var progressSection: some View {
        VStack(spacing: 24) {
            showcaseCard(title: "Gradient Linear Progress") {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("30% Complete")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        GradientLinearProgress(progress: 0.3)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("65% Complete")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        GradientLinearProgress(
                            progress: 0.65,
                            colors: [.purple, .pink]
                        )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("90% Complete")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        GradientLinearProgress(
                            progress: 0.9,
                            colors: [.orange, .red]
                        )
                    }
                }
                .padding()
            }

            showcaseCard(title: "Circular Percentage Progress") {
                HStack(spacing: 30) {
                    CircularPercentageProgress(progress: 0.25, size: 60)
                    CircularPercentageProgress(progress: 0.5, size: 70, color: .purple)
                    CircularPercentageProgress(progress: 0.75, size: 80, color: .orange)
                }
                .padding()
            }

            showcaseCard(title: "Interactive Progress") {
                VStack(spacing: 16) {
                    CircularPercentageProgress(progress: demoProgress, size: 100, color: .blue)

                    Slider(value: $demoProgress, in: 0...1)
                        .tint(.blue)

                    Text("Adjust slider to change progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }

            showcaseCard(title: "Pull to Refresh") {
                VStack(spacing: 30) {
                    CustomPullToRefresh(
                        progress: pullProgress,
                        isRefreshing: isRefreshing
                    )

                    VStack(spacing: 12) {
                        Slider(value: $pullProgress, in: 0...1)
                            .tint(.blue)

                        Toggle("Refreshing", isOn: $isRefreshing)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - 🎯 Inline Section

    private var inlineSection: some View {
        VStack(spacing: 24) {
            showcaseCard(title: "Inline Text Loading") {
                VStack(spacing: 12) {
                    InlineTextLoading("Loading")
                    InlineTextLoading("Syncing")
                    InlineTextLoading("Processing")
                }
                .padding()
            }

            showcaseCard(title: "Inline Status Badges") {
                VStack(spacing: 12) {
                    InlineStatusBadge(isLoading: true)
                    InlineStatusBadge(isLoading: false, status: "Approved", color: .green)
                    InlineStatusBadge(isLoading: false, status: "Pending", color: .orange)
                    InlineStatusBadge(isLoading: false, status: "Rejected", color: .red)
                }
                .padding()
            }

            showcaseCard(title: "Inline Progress Counter") {
                VStack(spacing: 12) {
                    InlineProgressCounter(current: 3, total: 10, isLoading: true)
                    InlineProgressCounter(current: 7, total: 10, isLoading: false)
                    InlineProgressCounter(current: 10, total: 10, isLoading: false)
                }
                .padding()
            }

            showcaseCard(title: "Inline Refresh Icon") {
                HStack(spacing: 30) {
                    VStack(spacing: 8) {
                        InlineRefreshIcon(isRotating: false)
                        Text("Idle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        InlineRefreshIcon(isRotating: true)
                        Text("Refreshing")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - 🔘 Buttons Section

    private var buttonsSection: some View {
        VStack(spacing: 24) {
            showcaseCard(title: "Loading Buttons") {
                VStack(spacing: 16) {
                    LoadingButton {
                        try? await Task.sleep(for: .seconds(2))
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Changes")
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    AsyncButton("Delete Item", role: .destructive) {
                        try? await Task.sleep(for: .seconds(2))
                    }
                    .buttonStyle(.bordered)

                    AsyncButton {
                        try? await Task.sleep(for: .seconds(2))
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh Data")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding()
            }

            showcaseCard(title: "Loading State Transitions") {
                VStack(spacing: 20) {
                    LoadingStateView(state: .idle, message: "Ready to go")
                    LoadingStateView(state: .loading, message: "Loading content...")
                    LoadingStateView(state: .success, message: "Success!")
                    LoadingStateView(state: .error, message: "Oops! Something went wrong")
                }
                .padding()
            }
        }
    }

    // MARK: - 🎨 Helper

    private func showcaseCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            content()
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview {
    LoadingStatesShowcase()
}
