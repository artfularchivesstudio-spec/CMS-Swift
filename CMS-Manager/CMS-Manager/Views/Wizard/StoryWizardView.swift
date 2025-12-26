//
//  StoryWizardView.swift
//  CMS-Manager
//
//  🎭 The Story Wizard View - Grand Stage of the 7-Act Play
//
//  "Welcome to the grand theater of storytelling! Like a magnificent
//   7-act play, your artwork shall journey through upload, analysis,
//   review, translation, audio, and final curtain call. Each step
//   builds upon the last, weaving a tapestry of digital wonder."
//
//  - The Spellbinding Museum Director of Wizard Orchestrations
//

import SwiftUI

// MARK: - 🎭 Story Wizard View

/// 🌟 The grand container for the 7-step story creation journey
///
/// Features:
/// - Step-by-step navigation with progress indicator
/// - Beautiful transition animations between steps
/// - Back/Continue navigation buttons
/// - Sheet dismissal support
/// - Full accessibility support
/// - Preview with mock data
public struct StoryWizardView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The view model orchestrating our 7-act play
    @Bindable internal var viewModel: StoryWizardViewModel

    /// 🏭 The dependency container from the environment
    @Environment(\.dependencies) private var dependencies

    /// 🚪 The dismiss mode for sheet presentation
    @Environment(\.dismiss) private var dismiss

    // MARK: - 📊 State

    /// ✨ Animation state for step transitions
    @State private var transitionOffset: CGFloat = 0

    /// 🎯 Whether we're currently animating between steps
    @State private var isTransitioning = false

    /// 📊 Current progress value (0.0 to 1.0)
    private var overallProgress: Double {
        Double(viewModel.currentStep.rawValue) / Double(StoryWizardViewModel.Step.allCases.count - 1)
    }

    // MARK: - 🎨 Body

    public var body: some View {
        NavigationStack {
            ZStack {
                // 🌌 Background gradient
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 📊 Progress & Step Indicator
                    stepIndicatorSection
                        .padding(.top, 16)
                        .padding(.horizontal, 20)

                    // 🎭 Main Content Area
                    ScrollView {
                        stepContent
                            .frame(maxWidth: .infinity)
                    }
                    .scrollDisabled(true)

                    Spacer()

                    // 🎯 Navigation Buttons
                    navigationButtonsSection
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("Story Wizard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        handleDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Close wizard")
                }
            }
            .disabled(viewModel.isLoading)
        }
        .toast(dependencies.toastManager)
    }

    // MARK: - 🌌 Background Gradient

    /// 🌈 A subtle gradient that sets the mood
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground).opacity(0.3),
                Color(.systemBackground).opacity(0.8),
                Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - 📊 Step Indicator Section

    /// 🎯 The progress bar and step dots at the top
    private var stepIndicatorSection: some View {
        VStack(spacing: 16) {
            // 📊 Overall Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 🌑 Background Track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.quaternary)
                        .frame(height: 6)

                    // 🌕 Progress Fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * overallProgress)
                        .frame(height: 6)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: overallProgress)
                }
            }
            .frame(height: 6)

            // 🎯 Step Dots Row
            HStack(spacing: 12) {
                ForEach(Array(StoryWizardViewModel.Step.allCases.enumerated()), id: \.element) { index, step in
                    stepDot(for: step, at: index)
                }
            }
            .padding(.horizontal, 8)
        }
    }

    /// 🎯 A single step indicator dot
    private func stepDot(for step: StoryWizardViewModel.Step, at index: Int) -> some View {
        let isActive = viewModel.currentStep == step
        let isPast = viewModel.currentStep.rawValue > index

        return Button {
            // Only allow going back to completed steps
            if isPast || isActive {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    viewModel.goToStep(step)
                }
            }
        } label: {
            VStack(spacing: 6) {
                // 🎯 The dot itself
                ZStack {
                    // 🌕 Active/Past state - filled circle
                    if isActive || isPast {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isActive ? [.blue, .purple] : [.green, .green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                            .shadow(color: isActive ? .blue.opacity(0.4) : .clear, radius: 6)

                        // 🔢 Step number
                        Text("\(index + 1)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)

                        // ✅ Checkmark for past steps
                        if isPast && !isActive {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    } else {
                        // 🌑 Future state - hollow circle
                        Circle()
                            .stroke(.quaternary, lineWidth: 2)
                            .frame(width: 28, height: 28)

                        Text("\(index + 1)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.tertiary)
                    }
                }
                .scaleEffect(isActive ? 1.15 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActive)

                // 📝 Step name (only show for active and adjacent steps)
                if isActive || isPast || abs(viewModel.currentStep.rawValue - index) == 1 {
                    Text(step.title)
                        .font(.system(size: 9, weight: isActive ? .semibold : .regular))
                        .foregroundStyle(isActive ? .primary : .secondary)
                        .lineLimit(1)
                        .fixedSize()
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isPast && !isActive)
        .accessibilityLabel("Step \(index + 1): \(step.title)")
        .accessibilityHint(isActive ? "Current step" : (isPast ? "Completed step, tap to review" : "Not yet reached"))
    }

    // MARK: - 🎭 Step Content

    /// 🎬 The main stage where each step performs
    private var stepContent: some View {
        Group {
            switch viewModel.currentStep {
            case .upload:
                UploadStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .analyzing:
                AnalyzingStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .review:
                ReviewStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .translation:
                TranslationStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .translationReview:
                TranslationReviewStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .audio:
                AudioStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .finalize:
                FinalizeStepView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentStep)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    /// 🎭 A placeholder view for steps not yet implemented
    private func placeholderStepView(icon: String, title: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 32) {
            Spacer()

            // 🎨 Icon
            ZStack {
                // 🌟 Background glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 140, height: 140)

                // 🎯 Icon
                Image(systemName: icon)
                    .font(.system(size: 56))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 10)
            }

            // 📝 Title
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // 🏗️ Under Construction Badge
            HStack(spacing: 8) {
                Image(systemName: "hammer.fill")
                Text("Under Construction")
                Image(systemName: "wrench.fill")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.quaternary.opacity(0.5))
            )

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 🎯 Navigation Buttons Section

    /// 🎮 The control center for wizard navigation
    private var navigationButtonsSection: some View {
        HStack(spacing: 16) {
            // ⬅️ Back Button
            if viewModel.currentStep != .upload {
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        viewModel.previousStep()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quaternary.opacity(0.7))
                    )
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading)
            }

            // ➡️ Continue / Skip / Create Button
            Button {
                handleContinueButton()
            } label: {
                HStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(continueButtonText)
                            .font(.system(size: 16, weight: .semibold))

                        if viewModel.currentStep != .finalize {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: continueButtonGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading || !canContinue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }

    /// 📜 The text for the continue button changes per step
    private var continueButtonText: String {
        switch viewModel.currentStep {
        case .upload:
            "Continue"
        case .analyzing:
            "Continue"
        case .review:
            "Continue"
        case .translation:
            "Generate Translations"
        case .translationReview:
            "Continue to Audio"
        case .audio:
            "Generate Audio"
        case .finalize:
            "Create Story"
        }
    }

    /// 🎨 The gradient color for the continue button
    private var continueButtonGradient: [Color] {
        if canContinue {
            switch viewModel.currentStep {
            case .finalize:
                return [.green, .green.opacity(0.8)]
            default:
                return [.blue, .purple]
            }
        } else {
            return [.gray, .gray]
        }
    }

    /// 🎯 Whether we can proceed to the next step
    private var canContinue: Bool {
        switch viewModel.currentStep {
        case .upload:
            return viewModel.selectedImage != nil
        case .analyzing:
            return viewModel.analysisResult != nil
        case .review:
            return !viewModel.storyTitle.isEmpty && !viewModel.storyContent.isEmpty
        case .translation:
            return !viewModel.selectedLanguages.isEmpty
        case .translationReview:
            return true
        case .audio:
            return true
        case .finalize:
            return !viewModel.isPublished
        }
    }

    // MARK: - 🎯 Actions

    /// 🎮 Handle the continue button press
    private func handleContinueButton() {
        // Trigger step-specific actions
        switch viewModel.currentStep {
        case .upload:
            // Upload logic is handled in UploadStepView
            break

        case .analyzing:
            // Auto-advances after analysis completes
            break

        case .review:
            // Proceed to translation step
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                viewModel.nextStep()
            }

        case .translation:
            // Generate translations
            Task {
                await viewModel.generateTranslations()
                if !viewModel.translations.isEmpty {
                    await MainActor.run {
                        viewModel.nextStep()
                    }
                }
            }

        case .translationReview:
            // Proceed to audio step
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                viewModel.nextStep()
            }

        case .audio:
            // Generate audio
            Task {
                await viewModel.generateAudio()
                if !viewModel.audioUrls.isEmpty {
                    await MainActor.run {
                        viewModel.nextStep()
                    }
                }
            }

        case .finalize:
            // Create the story
            Task {
                await viewModel.createStory()
                if viewModel.isPublished {
                    await MainActor.run {
                        dismiss()
                    }
                }
            }
        }
    }

    /// 🚪 Handle wizard dismissal
    private func handleDismiss() {
        // Check if there's unsaved work
        let hasUnsavedWork = viewModel.selectedImage != nil ||
                           viewModel.analysisResult != nil ||
                           !viewModel.storyTitle.isEmpty

        if hasUnsavedWork {
            // TODO: Show confirmation alert
            // For now, just dismiss
            dismiss()
        } else {
            dismiss()
        }
    }

    // MARK: - 🎭 Initialization

    /// ✨ Initialize with a story ID for editing (optional)
    /// - Parameters:
    ///   - storyId: Optional ID of existing story to edit
    ///   - dependencies: The app dependencies container
    init(storyId: Int? = nil, dependencies: AppDependencies) {
        let viewModel = StoryWizardViewModel(
            apiClient: dependencies.apiClient,
            toastManager: dependencies.toastManager,
            audioPlayer: dependencies.audioPlayer,
            hapticManager: dependencies.hapticManager
        )
        self._viewModel = Bindable(viewModel)

        // TODO: Load existing story if storyId is provided
    }
}

// MARK: - 🧪 Preview

#Preview("Story Wizard - Upload") {
    let dependencies = AppDependencies.mock
    StoryWizardView(dependencies: dependencies)
}

#Preview("Story Wizard - Analyzing") {
    @MainActor func makeView() -> some View {
        let dependencies = AppDependencies.mock
        let view = StoryWizardView(dependencies: dependencies)
        // Simulate being on analyzing step
        view.viewModel.goToStep(.analyzing)
        return view
    }
    return makeView()
}

#Preview("Story Wizard - Review") {
    @MainActor func makeView() -> some View {
        let dependencies = AppDependencies.mock
        let view = StoryWizardView(dependencies: dependencies)
        // Set up mock data
        view.viewModel.goToStep(.review)
        view.viewModel.storyTitle = "The Enchanted Forest"
        view.viewModel.storyContent = "Once upon a time..."
        return view
    }
    return makeView()
}

#Preview("Story Wizard - All Steps") {
    @MainActor func makeView(for step: StoryWizardViewModel.Step) -> some View {
        let dependencies = AppDependencies.mock
        let view = StoryWizardView(dependencies: dependencies)
        view.viewModel.goToStep(step)
        return VStack {
            Text("Step: \(step.title)")
                .font(.title)
            view
        }
        .tabItem {
            Label(step.title, systemImage: step.iconName)
        }
    }
    return TabView {
        ForEach(StoryWizardViewModel.Step.allCases, id: \.self) { step in
            makeView(for: step)
        }
    }
}
