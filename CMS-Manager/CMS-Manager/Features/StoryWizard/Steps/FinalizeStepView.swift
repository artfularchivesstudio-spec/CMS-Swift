//
//  FinalizeStepView.swift
//  CMS-Manager
//
//  🎉 The Finalize Step - Where Masterpieces Meet Their Audience
//
//  "The curtain rises on your creation! A symphony of image, text, translations,
//   and audio—all woven together into a tapestry of digital storytelling.
//   Behold the summary, celebrate with confetti, and share your art with the world!"
//
//  - The Spellbinding Museum Director of Grand Finales
//

import SwiftUI
import ArtfulArchivesCore

/// 🎉 Finalize Step View - Step 7 of the Wizard
struct FinalizeStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The wizard's grand orchestrator
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 Local State

    /// 📤 Share sheet presentation
    @State private var showShareSheet = false

    /// 🎊 Confetti celebration
    @State private var showConfetti = false

    /// ✨ Success checkmark
    @State private var showCheckmark = false

    /// 💫 Sparkles for each stat card
    @State private var showSparkles = false

    /// 🎯 Navigation to story detail
    @State private var navigateToStory = false

    /// 🚨 Show error alert
    @State private var showErrorAlert = false

    // MARK: - 🧮 Computed Properties

    /// ✅ Can we publish the story? - All required data must be present
    private var canPublish: Bool {
        guard !viewModel.storyTitle.trimmingCharacters(in: .whitespaces).isEmpty,
              !viewModel.storyContent.trimmingCharacters(in: .whitespaces).isEmpty,
              viewModel.uploadedMediaId != nil,
              !viewModel.isLoading else {
            return false
        }
        return true
    }

    // MARK: - 🎨 Body

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // 📜 Header Section
                headerSection

                ScrollView {
                    VStack(spacing: 20) {
                        // 🎉 Success Animation
                        if viewModel.isPublished {
                            successAnimationView
                        }

                        // 📊 Summary Cards
                        summarySection

                        // 📋 Story Preview Card
                        storyPreviewSection

                        // 🌐 Translations Summary
                        translationsSummarySection

                        // 🔊 Audio Summary
                        audioSummarySection
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // 🎯 Action Buttons
                actionButtonsSection
            }
            .padding()
        }
        .confetti(isActive: $showConfetti)
        .sheet(isPresented: $showShareSheet) {
            shareSheet
        }
        .alert("Publication Failed", isPresented: $showErrorAlert) {
            Button("Retry", role: .none) {
                publishStory()
            }
            Button("Cancel", role: .cancel) {
                showErrorAlert = false
            }
        } message: {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                Text("An unknown error occurred while publishing your story.")
            }
        }
        .onAppear {
            // Trigger confetti if already published
            if viewModel.isPublished {
                triggerCelebration()
            }
        }
        .onChange(of: viewModel.isPublished) { _, isPublished in
            if isPublished {
                triggerCelebration()
            }
        }
        // TODO: Re-enable onChange when APIError Equatable is properly exposed
        // .onChange(of: viewModel.error) { error in
        //     if error != nil && !viewModel.isPublished {
        //         showErrorAlert = true
        //     }
        // }
    }

    // MARK: - 📜 Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🎉 Finalize & Publish")
                .font(.system(size: 32, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            Text("Review your story and share it with the world")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 🎉 Success Animation View

    private var successAnimationView: some View {
        VStack(spacing: 16) {
            // 🎊 Success Checkmark with our reusable component!
            SuccessCheckmark(
                isVisible: $showCheckmark,
                style: .filled,
                size: 100,
                color: .green
            )

            // 🎉 Success message
            VStack(spacing: 8) {
                Text("Story Published Successfully!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)

                Text("Your masterpiece is now live and ready to inspire!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // 📊 Published Story Details with sparkle effect
            VStack(spacing: 8) {
                if let storyId = viewModel.createdStoryId {
                    HStack(spacing: 4) {
                        Image(systemName: "number.circle.fill")
                            .foregroundStyle(.blue)
                        Text("Story ID:")
                            .fontWeight(.medium)
                        Text("\(storyId)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                }

                if !viewModel.storySlug.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "link.circle.fill")
                            .foregroundStyle(.purple)
                        Text("Slug:")
                            .fontWeight(.medium)
                        Text(viewModel.storySlug)
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                }

                HStack(spacing: 4) {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(.orange)
                    Text("Status:")
                        .fontWeight(.medium)
                    Text("Draft")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
            .sparkle(isActive: $showSparkles)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green.opacity(0.1))
        )
    }

    // MARK: - 📊 Summary Section

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Story Summary")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 12) {
                // 📊 Stats Card
                SummaryStatCard(
                    icon: "doc.text",
                    title: "Original",
                    value: "English",
                    color: .blue
                )

                SummaryStatCard(
                    icon: "globe",
                    title: "Translations",
                    value: "\(viewModel.storySummary.translationsCount)",
                    color: .purple
                )

                SummaryStatCard(
                    icon: "speaker.wave.2",
                    title: "Audio Files",
                    value: "\(viewModel.storySummary.audioCount)",
                    color: .orange
                )
            }
        }
    }

    // MARK: - 📋 Story Preview Section

    private var storyPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Story Preview")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 12) {
                // 📜 Title
                Text(viewModel.storyTitle)
                    .font(.title3)
                    .fontWeight(.semibold)

                // 📖 Content Preview
                Text(viewModel.storyContent)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                // 🏷️ Tags
                if !viewModel.storyTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.storyTags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.secondary.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.05))
            )
        }
    }

    // MARK: - 🌐 Translations Summary Section

    private var translationsSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Translations")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if viewModel.storySummary.selectedLanguages.isEmpty {
                Text("No translations created")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.05))
                    )
            } else {
                ForEach(Array(viewModel.storySummary.selectedLanguages), id: \.id) { language in
                    HStack {
                        Text(language.flag)
                            .font(.title2)

                        Text(language.name)
                            .font(.subheadline)

                        Spacer()

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.05))
                    )
                }
            }
        }
    }

    // MARK: - 🔊 Audio Summary Section

    private var audioSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Audio Files")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if viewModel.audioUrls.isEmpty {
                Text("No audio files generated")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.05))
                    )
            } else {
                ForEach(viewModel.audioUrls.keys.sorted(by: { $0.name < $1.name }), id: \.id) { language in
                    HStack {
                        Text(language.flag)
                            .font(.title2)

                        Text(language.name)
                            .font(.subheadline)

                        Spacer()

                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.purple)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple.opacity(0.05))
                    )
                }
            }
        }
    }

    // MARK: - 🎯 Action Buttons Section

    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            // 🎉 Success Actions (when published)
            if viewModel.isPublished {
                VStack(spacing: 12) {
                    // 👁️ View Story Button
                    Button {
                        // TODO: Navigate to story detail view
                        navigateToStory = true
                    } label: {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("View Story")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.bouncy)

                    HStack(spacing: 12) {
                        // 📤 Share Button
                        Button {
                            showShareSheet = true
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bouncy(scale: 0.96, haptic: .medium))

                        // 🔄 Create Another Button
                        Button {
                            createAnother()
                        } label: {
                            Label("Create Another", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bouncy(scale: 0.96, haptic: .medium))
                    }
                }
            } else {
                // 🚀 Publishing Actions (before publish)
                VStack(spacing: 12) {
                    // 🚀 Publish Button with loading state and pulse animation
                    Button {
                        publishStory()
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .tint(.white)
                                Text("Publishing...")
                            } else {
                                Image(systemName: "paperplane.fill")
                                Text("Publish Story")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: canPublish ? [.green, .green.opacity(0.8)] : [.gray, .gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.bouncy(scale: 0.97, haptic: .heavy))
                    .attentionPulse(color: canPublish ? .green : .gray)
                    .disabled(!canPublish || viewModel.isLoading)

                    // ⬅️ Back Button
                    Button {
                        viewModel.previousStep()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bouncy(scale: 0.96, haptic: .light))
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }

    // MARK: - 📤 Share Sheet

    private var shareSheet: some View {
        let shareText = "Check out my story: \(viewModel.storyTitle)"
        let shareUrl = URL(string: "https://artfularchives.com/stories/\(viewModel.createdStoryId ?? 0)")!

        return ActivityViewController(activityItems: [shareText, shareUrl])
    }

    // MARK: - 🎯 Actions

    /// 🚀 Publish the story
    /// The grand moment of truth—let's make this special! 🎭
    private func publishStory() {
        HapticManager.shared.mediumImpact()

        Task {
            await viewModel.publishStory()

            await MainActor.run {
                if viewModel.isPublished {
                    triggerCelebration()
                }
            }
        }
    }

    /// 🎉 Trigger celebration animation
    /// A choreographed sequence of joy and triumph! 🎊
    private func triggerCelebration() {
        // 🎵 Success haptic
        HapticManager.shared.success()

        // 🎊 Show confetti explosion
        showConfetti = true

        // ✅ Show checkmark with delay for dramatic effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showCheckmark = true
            }
        }

        // ✨ Show sparkles on details with stagger
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showSparkles = true
        }
    }

    /// 🔄 Create another story - Reset wizard and start fresh
    /// Time to begin a new creative journey! 🌟
    private func createAnother() {
        HapticManager.shared.lightImpact()

        // 🧹 Clean up local state
        showConfetti = false
        showCheckmark = false
        showSparkles = false
        showShareSheet = false
        showErrorAlert = false

        // 🌟 Reset the wizard to begin anew
        viewModel.reset()
    }
}

// MARK: - 📊 Summary Stat Card

/// 📭 Small stat card for summary section
/// Now with extra delightful micro-interactions! ✨
struct SummaryStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .scaleEffect(isHovering ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovering)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
        )
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
        .onTapGesture {
            // 🎪 Bounce on tap for fun!
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isHovering = true
            }

            HapticManager.shared.lightImpact()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isHovering = false
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

// MARK: - 📤 Activity View Controller (Share Sheet)

/// 📤 Wrapper for UIActivityViewController
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - 🧪 Preview

#Preview("Before Publish") {
    FinalizeStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.storyTitle = "The Starry Night"
        vm.storyContent = "The Starry Night is an oil-on-canvas painting by the Dutch Post-Impressionist painter Vincent van Gogh..."
        vm.storyTags = ["Art", "Impressionism", "Van Gogh"]
        vm.selectedLanguages = [ArtfulArchivesCore.LanguageCode.spanish, ArtfulArchivesCore.LanguageCode.hindi]
        vm.translations = [
            .spanish: "La noche estrellada es una obra maestra...",
            .hindi: "स्टाररी नाइट एक उत्कृष्ट कृति है..."
        ]
        vm.audioUrls = [
            .english: "https://example.com/audio/en.mp3",
            .spanish: "https://example.com/audio/es.mp3"
        ]
        vm.uploadedMediaId = 123
        return vm
    }())
}

#Preview("Published") {
    FinalizeStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.storyTitle = "The Starry Night"
        vm.storyContent = "The Starry Night is an oil-on-canvas painting by the Dutch Post-Impressionist painter Vincent van Gogh..."
        vm.storyTags = ["Art", "Impressionism", "Van Gogh"]
        vm.selectedLanguages = [ArtfulArchivesCore.LanguageCode.spanish, ArtfulArchivesCore.LanguageCode.hindi]
        vm.translations = [
            .spanish: "La noche estrellada es una obra maestra...",
            .hindi: "स्टाररी नाइट एक उत्कृष्ट कृति है..."
        ]
        vm.audioUrls = [
            .english: "https://example.com/audio/en.mp3",
            .spanish: "https://example.com/audio/es.mp3"
        ]
        vm.isPublished = true
        vm.createdStoryId = 1234
        return vm
    }())
}
