//
//  AudioStepView.swift
//  CMS-Manager
//
//  🔊 The Audio Step - Where Stories Find Their Voice
//
//  "In the grand concert hall of digital storytelling, words transform into melody,
//   each language singing with its own unique voice—a symphony of Nova, Fable, and more,
//   conducting the tempo of imagination from whispered 0.25x to brisk 4.0x."
//
//  - The Spellbinding Museum Director of Auditory Experiences
//

import SwiftUI
import ArtfulArchivesCore

/// 🔊 Audio Generation Step View - Step 6 of the Wizard
struct AudioStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The wizard's grand orchestrator
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 Local State

    /// 🎬 Is audio generation in progress?
    @State private var isGenerating = false

    /// 🔊 Currently previewing voice
    @State private var previewingVoice: TTSVoice?

    /// ⏱️ Waveform animation phase
    @State private var wavePhase: Double = 0

    // MARK: - 🎨 Body

    var body: some View {
        VStack(spacing: 24) {
            // 📜 Header Section
            headerSection

            ScrollView {
                VStack(spacing: 20) {
                    // 🎤 Voice Picker Section
                    voicePickerSection

                    // ⚡ Speed Control Section
                    speedControlSection

                    // 📊 Audio Progress Section
                    if isGenerating || !viewModel.audioProgress.isEmpty {
                        audioProgressSection
                    }

                    // 🎵 Playback Preview Section
                    if !viewModel.audioUrls.isEmpty {
                        playbackPreviewSection
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
            // Start the waveform animation
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                wavePhase = .pi * 2
            }
        }
    }

    // MARK: - 📜 Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🔊 Audio Generation")
                .font(.system(size: 32, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            Text("Bring your stories to life with text-to-speech")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 🎤 Voice Picker Section

    private var voicePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Voice Selection")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(TTSVoice.allCases, id: \.rawValue) { voice in
                    VoiceSelectionCard(
                        voice: voice,
                        isSelected: viewModel.selectedVoice == voice,
                        isPreviewing: previewingVoice == voice
                    ) {
                        selectVoice(voice)
                    } onPreview: {
                        previewVoice(voice)
                    }
                }
            }
        }
    }

    // MARK: - ⚡ Speed Control Section

    private var speedControlSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Playback Speed")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 12) {
                // 📊 Speed Slider
                HStack {
                    Text("0.25x")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Slider(
                        value: Binding(
                            get: { viewModel.audioSpeed },
                            set: { viewModel.audioSpeed = $0 }
                        ),
                        in: 0.25...4.0,
                        step: 0.25
                    )
                    .accessibilityLabel("Playback speed")
                    .accessibilityValue("\(String(format: "%.2f", viewModel.audioSpeed))x")

                    Text("4.0x")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // 🎯 Current Speed Display
                HStack {
                    Spacer()

                    Text(String(format: "%.2fx", viewModel.audioSpeed))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )

                    Spacer()
                }

                // ⚡ Speed Presets
                HStack(spacing: 12) {
                    SpeedPresetButton(title: "Slow", value: 0.5) {
                        withAnimation(.spring()) {
                            viewModel.audioSpeed = 0.5
                        }
                    }

                    SpeedPresetButton(title: "Normal", value: 1.0) {
                        withAnimation(.spring()) {
                            viewModel.audioSpeed = 1.0
                        }
                    }

                    SpeedPresetButton(title: "Fast", value: 1.5) {
                        withAnimation(.spring()) {
                            viewModel.audioSpeed = 1.5
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.05))
            )
        }
    }

    // MARK: - 📊 Audio Progress Section

    private var audioProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Generation Progress")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            ForEach(sortedLanguagesWithAudio, id: \.id) { language in
                AudioGenerationProgressCard(
                    language: language,
                    progress: viewModel.audioProgress[language] ?? 0,
                    isComplete: viewModel.audioUrls[language] != nil,
                    isCancelled: viewModel.cancelledAudio.contains(language),
                    onCancel: {
                        viewModel.cancelAudioGeneration(language)
                    }
                )
            }

            // 🎉 All complete message
            if allAudioComplete {
                HStack {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundStyle(.purple)
                    Text("All audio generation complete!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - 🎵 Playback Preview Section

    private var playbackPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preview Audio")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            ForEach(sortedLanguagesWithAudio, id: \.id) { language in
                if let audioUrl = viewModel.audioUrls[language] {
                    AudioPreviewPlayer(
                        language: language,
                        audioUrl: audioUrl,
                        isPlaying: viewModel.currentlyPlayingAudio == language && viewModel.isAudioPlaying,
                        onPlayPause: {
                            togglePlayback(for: language)
                        }
                    )
                }
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
            .disabled(isGenerating)

            // ➡️ Generate Audio / Next Button
            Button {
                if isGenerating || !viewModel.audioProgress.isEmpty {
                    // Already generated or in progress - move to next step
                    viewModel.goToNextStep()
                } else {
                    // Start audio generation
                    startAudioGeneration()
                }
            } label: {
                Label(
                    isGenerating || !viewModel.audioProgress.isEmpty ? "Continue" : "Generate Audio",
                    systemImage: isGenerating || !viewModel.audioProgress.isEmpty ? "chevron.right" : "speaker.wave.3"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.translations.isEmpty)
        }
    }

    // MARK: - 🎯 Helper Computed Properties

    /// 📊 Languages with audio, sorted
    private var sortedLanguagesWithAudio: [LanguageCode] {
        viewModel.translations.keys.sorted(by: { $0.name < $1.name })
    }

    /// ✅ Is all audio generation complete?
    private var allAudioComplete: Bool {
        guard !viewModel.translations.isEmpty else { return false }
        return viewModel.translations.keys.allSatisfy { viewModel.audioUrls[$0] != nil }
    }

    // MARK: - 🎯 Actions

    /// 🎤 Select a voice
    private func selectVoice(_ voice: TTSVoice) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.selectedVoice = voice
        }
    }

    /// 🔊 Preview a voice (simulated)
    private func previewVoice(_ voice: TTSVoice) {
        previewingVoice = voice

        // 🎭 Simulate preview playing
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            await MainActor.run {
                previewingVoice = nil
            }
        }
    }

    /// 🚀 Start audio generation
    private func startAudioGeneration() {
        isGenerating = true

        Task {
            await viewModel.startAudioGeneration()

            await MainActor.run {
                isGenerating = false
            }
        }
    }

    /// ▶️ Toggle audio playback for a language
    private func togglePlayback(for language: LanguageCode) {
        if viewModel.currentlyPlayingAudio == language && viewModel.isAudioPlaying {
            viewModel.stopAudio()
        } else {
            viewModel.playAudio(for: language)
        }
    }
}

// MARK: - 🎤 Voice Selection Card

/// 🎭 Individual voice selection card
struct VoiceSelectionCard: View {
    let voice: TTSVoice
    let isSelected: Bool
    let isPreviewing: Bool
    let onSelect: () -> Void
    let onPreview: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // 🎭 Voice Icon
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
                    .frame(width: 60, height: 60)

                Image(systemName: "speaker.wave.2")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .secondary)
            }

            // 📝 Voice Name
            Text(voice.name)
                .font(.subheadline)
                .fontWeight(.medium)

            // 🔊 Preview Button
            Button {
                onPreview()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isPreviewing ? "speaker.wave.3.fill" : "play.circle.fill")
                        .symbolEffect(.pulse, options: .repeating, isActive: isPreviewing)
                    Text("Preview")
                        .font(.caption)
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onSelect()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(voice.name) voice")
        .accessibilityHint(isSelected ? "Selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - ⚡ Speed Preset Button

/// 🎯 Quick preset button for common speeds
struct SpeedPresetButton: View {
    let title: String
    let value: Double
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
    }
}

// MARK: - 📊 Audio Generation Progress Card

/// 📊 Progress card for audio generation
struct AudioGenerationProgressCard: View {
    let language: LanguageCode
    let progress: Double
    let isComplete: Bool
    let isCancelled: Bool
    let onCancel: () -> Void

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

                Spacer()

                // ✅ Status Icon
                if isCancelled {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.red)
                } else if isComplete {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundStyle(.purple)
                        .symbolEffect(.bounce)
                } else {
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }

            // 📊 Progress Bar with Waveform
            if !isCancelled && !isComplete {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // 🌙 Background track
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))

                        // 🌟 Progress fill with gradient
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress)
                            .animation(.easeInOut, value: progress)
                    }
                }
                .frame(height: 8)
            }

            // ❌ Cancel Button (only show if in progress)
            if !isComplete && !isCancelled && progress > 0 {
                HStack {
                    Spacer()

                    Button("Cancel", role: .destructive) {
                        onCancel()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isComplete ? Color.purple.opacity(0.1) : Color.secondary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isComplete ? Color.purple.opacity(0.3) :
                        isCancelled ? Color.red.opacity(0.3) : Color.clear,
                    lineWidth: 1
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(language.name) audio generation")
        .accessibilityValue(isComplete ? "Complete" : isCancelled ? "Cancelled" : "\(Int(progress * 100)) percent")
    }
}

// MARK: - 🎵 Audio Preview Player

/// ▶️ Audio player for previewing generated audio
struct AudioPreviewPlayer: View {
    let language: LanguageCode
    let audioUrl: String
    let isPlaying: Bool
    let onPlayPause: () -> Void

    @State private var playbackProgress: Double = 0

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

                Spacer()

                // ▶️ Play/Pause Button
                Button {
                    onPlayPause()
                } label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
                .buttonStyle(.plain)
            }

            // 📊 Playback Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 🌙 Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.2))

                    // 🌟 Progress fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.purple)
                        .frame(width: geometry.size.width * playbackProgress)
                }
            }
            .frame(height: 6)

            // ⏱️ Time indicators
            HStack {
                Text("0:00")
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)

                Spacer()

                Text("2:30")
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(language.name) audio player")
        .accessibilityValue(isPlaying ? "Playing" : "Paused")
        .accessibilityAddTraits(.isButton)
        .onTapGesture {
            onPlayPause()
        }
        .onChange(of: isPlaying) { _, playing in
            // 🎭 Animate progress when playing
            if playing {
                withAnimation(.linear(duration: 150).repeatForever(autoreverses: false)) {
                    playbackProgress = 1.0
                }
            } else {
                playbackProgress = 0
            }
        }
    }
}

// MARK: - 🧪 Preview

//#Preview {
//    AudioStepView(viewModel: {
//        let vm = StoryWizardViewModel(
//            apiClient: MockAPIClient(),
//            toastManager: ToastManager(),
//            audioPlayer: AudioPlayer(),
//        hapticManager: HapticManager()
//        )
//        vm.translations = [
//            .en: "The Starry Night is a masterpiece...",
//            .es: "La noche estrellada es una obra maestra...",
//            .hi: "स्टाररी नाइट एक उत्कृष्ट कृति है..."
//        ]
//        return vm
//    }())
//}
