//
//  TranslationStepView.swift
//  CMS-Manager
//
//  🌐 The Translation Step - Where Stories Speak in Many Tongues
//
//  "In the grand bazaar of languages, our story dons new garments,
//   wearing Spanish flamenco, Hindi classical, and keeping its English mother tongue.
//   Watch as parallel threads weave translations in real-time magic!"
//
//  - The Spellbinding Museum Director of Multilingual Tales
//

import SwiftUI
import ArtfulArchivesCore

/// 🌐 Translation Step View - Step 4 of the Wizard
struct TranslationStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The wizard's grand orchestrator
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 Local State

    /// ✨ Animation state for language selection
    @State private var selectedLanguageIds: Set<String> = []

    /// 🎪 Is translation in progress?
    @State private var isTranslating = false

    /// 📝 Show translation review sheet
    @State private var showReviewSheet = false

    // MARK: - 🎨 Body

    var body: some View {
        VStack(spacing: 24) {
            // 📜 Header Section
            headerSection

            ScrollView {
                VStack(spacing: 20) {
                    // 🌐 Language Selection Cards
                    languageSelectionSection

                    // 📊 Translation Progress Section
                    if isTranslating || !viewModel.translationProgress.isEmpty {
                        translationProgressSection
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // 🎯 Action Buttons
            actionButtonsSection
        }
        .padding()
        .onAppear {
            selectedLanguageIds = Set(viewModel.selectedLanguages.map(\.id))
        }
        .sheet(isPresented: $showReviewSheet) {
            TranslationReviewSheet(viewModel: viewModel)
        }
    }

    // MARK: - 📜 Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🌐 Translation")
                .font(.system(size: 32, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            Text("Select languages to translate your story into")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 🌐 Language Selection Section

    private var languageSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Languages")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 12) {
                ForEach(Array(sortedLanguages.enumerated()), id: \.element.id) { index, language in
                    LanguageSelectionCard(
                        language: language,
                        isSelected: selectedLanguageIds.contains(language.id),
                        isTranslating: viewModel.translationProgress[language] != nil,
                        progress: viewModel.translationProgress[language] ?? 0
                    ) {
                        toggleLanguage(language)
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(
                        AnimationConstants.smoothSpring.delay(Double(index) * AnimationConstants.staggerDelay),
                        value: sortedLanguages.count
                    )
                }
            }
        }
    }

    /// 📊 Available languages sorted by display name (computed to avoid compiler timeout)
    private var sortedLanguages: [ArtfulArchivesCore.LanguageCode] {
        ArtfulArchivesCore.LanguageCode.allCases.filter { $0 != .english }
            .sorted { $0.name < $1.name }
    }

    // MARK: - 📊 Translation Progress Section

    private var translationProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Translation Progress")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            ForEach(sortedSelectedLanguages, id: \.id) { language in
                TranslationProgressCard(
                    language: language,
                    progress: viewModel.translationProgress[language] ?? 0,
                    isComplete: viewModel.translations[language] != nil,
                    isCancelled: viewModel.cancelledTranslations.contains(language),
                    errorMessage: viewModel.translationErrors[language],
                    isEdited: isTranslationEdited(language),
                    onCancel: {
                        viewModel.cancelTranslation(language)
                    },
                    onRetry: {
                        Task {
                            await viewModel.retryTranslation(language)
                        }
                    }
                )
            }

            // 🎉 All complete message with review button
            if allTranslationsComplete {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("All translations complete!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }

                    // ✏️ Review Translations Button
                    Button {
                        showReviewSheet = true
                    } label: {
                        Label("Review Translations", systemImage: "doc.text.magnifyingglass")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - 🎯 Action Buttons Section

    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            // ⬅️ Back Button
            Button {
                viewModel.goToPreviousStep()
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(isTranslating)

            // ➡️ Start Translations / Next Button
            Button {
                if isTranslating || !viewModel.translationProgress.isEmpty {
                    // Already translated or in progress - move to next step
                    viewModel.goToNextStep()
                } else {
                    // Start translations
                    startTranslations()
                }
            } label: {
                Label(
                    isTranslating || !viewModel.translationProgress.isEmpty ? "Continue" : "Start Translations",
                    systemImage: isTranslating || !viewModel.translationProgress.isEmpty ? "chevron.right" : "globe"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.selectedLanguages.isEmpty && !isTranslating && viewModel.translationProgress.isEmpty)
        }
    }

    // MARK: - 🎯 Helper Computed Properties

    /// ✅ Are all translations complete?
    private var allTranslationsComplete: Bool {
        guard !viewModel.selectedLanguages.isEmpty else { return false }
        return viewModel.selectedLanguages.allSatisfy { viewModel.translations[$0] != nil }
    }

    /// 📊 Selected languages sorted by display name
    private var sortedSelectedLanguages: [LanguageCode] {
        viewModel.selectedLanguages.sorted { $0.name < $1.name }
    }

    /// ✏️ Check if a translation has been edited by the user
    /// - Parameter language: The language to check
    /// - Returns: True if the translation has been edited
    private func isTranslationEdited(_ language: LanguageCode) -> Bool {
        let contentKey = "\(language.rawValue)-content"
        let titleKey = "\(language.rawValue)-title"
        return viewModel.editedTranslations[contentKey] != nil || viewModel.editedTranslations[titleKey] != nil
    }

    // MARK: - 🎯 Actions

    /// 🔄 Toggle language selection
    private func toggleLanguage(_ language: LanguageCode) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedLanguageIds.contains(language.id) {
                selectedLanguageIds.remove(language.id)
                viewModel.selectedLanguages.remove(language)
            } else {
                selectedLanguageIds.insert(language.id)
                viewModel.selectedLanguages.insert(language)
            }
        }
    }

    /// 🚀 Start the translation process
    private func startTranslations() {
        isTranslating = true

        Task {
            await viewModel.startTranslations()

            await MainActor.run {
                isTranslating = false
            }
        }
    }
}

// MARK: - 🌐 Language Selection Card

/// 🎭 Individual language selection card with flag and info
struct LanguageSelectionCard: View {
    let language: LanguageCode
    let isSelected: Bool
    let isTranslating: Bool
    let progress: Double
    let onTap: () -> Void

    var body: some View {
        Button {
            withAnimation(AnimationConstants.bouncySpring) {
                onTap()
            }
        } label: {
            cardContent
        }
        .buttonStyle(.plain)
        .disabled(isTranslating)
        .scaleEffect(isSelected ? AnimationConstants.subtleScaleUp : 1.0)
        .animation(AnimationConstants.quickEaseOut, value: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(language.name) language")
        .accessibilityHint(isSelected ? "Selected for translation" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - Helper Views

    private var cardContent: some View {
        HStack(spacing: 16) {
            flagView
            languageInfoView
            Spacer()
            selectionIndicator
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
    }

    private var flagView: some View {
        Text(language.flag)
            .font(.system(size: 40))
            .frame(width: 60, height: 60)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
    }

    private var languageInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(language.name)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("Tap to select for translation")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var selectionIndicator: some View {
        if isSelected {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .symbolEffect(.bounce, value: isSelected)
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isSelected ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
    }
}

// MARK: - 📊 Translation Progress Card

/// 📊 Progress card showing translation status for a language
/// Now with error tracking, retry magic, and edit badges! 🌩️✨✏️
struct TranslationProgressCard: View {
    let language: LanguageCode
    let progress: Double
    let isComplete: Bool
    let isCancelled: Bool
    let errorMessage: String?
    let isEdited: Bool
    let onCancel: () -> Void
    let onRetry: () -> Void

    @State private var isPulsing = false
    @State private var isRetrying = false

    // 🎭 Is this translation in an error state?
    private var hasError: Bool {
        errorMessage != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // 🏳️ Flag
                Text(language.flag)
                    .font(.title2)

                // 📝 Language Name
                Text(language.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                // ✏️ Edited Badge (only show if complete and edited)
                if isComplete && isEdited {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.caption2)
                        Text("Edited")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(6)
                }

                Spacer()

                // ✅ Status Icon
                statusIcon
            }

            // 🌩️ Error Message Display
            if let errorMessage = errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)

                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }

            // 📊 Progress Bar (only show if actively translating)
            if !isCancelled && !isComplete && !hasError && progress > 0 {
                progressBar
            }

            // 🎯 Action Buttons
            actionButtonsSection
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(language.name) translation progress")
        .accessibilityValue(accessibilityStatusValue)
    }

    // MARK: - 🎨 View Components

    @ViewBuilder
    private var statusIcon: some View {
        if isCancelled {
            Image(systemName: "xmark.circle")
                .foregroundStyle(.red)
        } else if hasError {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .symbolEffect(.pulse)
        } else if isComplete {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .symbolEffect(.bounce)
        } else if isRetrying {
            ProgressView()
                .controlSize(.small)
        } else {
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 🌙 Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.2))

                // 🌟 Progress fill with shimmer magic! ✨
                RoundedRectangle(cornerRadius: 4)
                    .fill(progressGradient)
                    .frame(width: geometry.size.width * progress)
                    .animation(AnimationConstants.standardEaseInOut, value: progress)
                    .shimmer()
            }
        }
        .frame(height: 8)
    }

    @ViewBuilder
    private var actionButtonsSection: some View {
        // ❌ Cancel Button (only show if in progress and not errored)
        if !isComplete && !isCancelled && !hasError && progress > 0 {
            HStack {
                Spacer()

                Button("Cancel", role: .destructive) {
                    onCancel()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }

        // 🔄 Retry Button (only show if there's an error)
        if hasError {
            HStack {
                Spacer()

                Button {
                    isRetrying = true
                    onRetry()
                    // Reset retrying state after a delay
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        isRetrying = false
                    }
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .disabled(isRetrying)
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                isComplete ? Color.green.opacity(0.1) :
                hasError ? Color.orange.opacity(0.1) :
                Color.secondary.opacity(0.05)
            )
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                isComplete ? Color.green.opacity(0.3) :
                hasError ? Color.orange.opacity(0.5) :
                isCancelled ? Color.red.opacity(0.3) :
                Color.clear,
                lineWidth: hasError ? 2 : 1
            )
    }

    // MARK: - 🎨 Helper Properties

    private var progressGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var accessibilityStatusValue: String {
        if isComplete {
            return "Complete"
        } else if isCancelled {
            return "Cancelled"
        } else if hasError {
            return "Error: \(errorMessage ?? "Unknown error"). Double tap retry button to try again."
        } else {
            return "\(Int(progress * 100)) percent complete"
        }
    }
}

// MARK: - 🧪 Preview

#Preview {
    TranslationStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.storyTitle = "The Starry Night"
        vm.storyContent = "A beautiful painting of a night sky..."
        return vm
    }())
}
