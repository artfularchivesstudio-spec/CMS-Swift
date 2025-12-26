//
//  StoryMetadataCard.swift
//  CMS-Manager
//
//  🏷️ The Metadata Card - Chronicles of Creation
//
//  "Where badges cascade like autumn leaves,
//   dates whisper tales of time's passage,
//   and author names glow with creative pride."
//
//  - The Spellbinding Museum Director of Information Architecture
//

import SwiftUI
import ArtfulArchivesCore

// MARK: - 🏷️ Story Metadata Card

/// 🏷️ An elegant metadata display with cascading animations
/// ✨ Features: sequential badge animations, pulsing status, fade-in dates
struct StoryMetadataCard: View {

    // MARK: - 🏺 Properties

    /// 📖 The story to display metadata for
    let story: ArtfulArchivesCore.Story

    /// 🎭 Whether to animate on appear
    var animateOnAppear: Bool = true

    // MARK: - 🌟 State

    /// 🎨 Animation trigger states
    @State private var showStatus = false
    @State private var showLanguages = false
    @State private var showDates = false
    @State private var showAuthor = false
    @State private var statusPulse = false

    // MARK: - 🎭 Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 🎭 Status and visibility row
            statusRow

            // 🌐 Languages section (if multilingual)
            if hasMultipleLanguages {
                languagesSection
            }

            // 📅 Dates section
            datesSection

            // 👤 Author section
            if let author = story.createdBy {
                authorSection(author)
            }

            // 🎭 Workflow progress
            workflowProgressSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        )
        .onAppear {
            if animateOnAppear {
                startAnimationSequence()
            } else {
                showAllImmediately()
            }
        }
    }

    // MARK: - 🎭 Status Row

    /// 🎭 Status badge and visibility indicator
    private var statusRow: some View {
        HStack(spacing: 12) {
            // 🎭 Status badge with pulse
            HStack(spacing: 8) {
                Image(systemName: story.workflowStage.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .symbolEffect(.pulse, options: .repeating, value: statusPulse)

                Text(story.workflowStage.displayName)
                    .font(.system(size: 15, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(stageColor(for: story.workflowStage).opacity(0.15))
            )
            .foregroundStyle(stageColor(for: story.workflowStage))
            .overlay {
                if !story.workflowStage.isFinal {
                    Capsule()
                        .stroke(stageColor(for: story.workflowStage).opacity(0.3), lineWidth: 1.5)
                        .scaleEffect(statusPulse ? 1.1 : 1.0)
                        .opacity(statusPulse ? 0 : 1)
                }
            }

            Spacer()

            // 👁️ Visibility indicator
            HStack(spacing: 6) {
                Image(systemName: story.visible ? "eye.fill" : "eye.slash.fill")
                    .font(.system(size: 12))

                Text(story.visible ? "Public" : "Hidden")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(story.visible ? .green : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(story.visible ? Color.green.opacity(0.1) : Color.secondary.opacity(0.1))
            )
        }
        .opacity(showStatus ? 1 : 0)
        .offset(y: showStatus ? 0 : -10)
    }

    // MARK: - 🌐 Languages Section

    /// 🌐 Available languages with cascading flags
    private var languagesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Available Languages")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .opacity(showLanguages ? 1 : 0)

            HStack(spacing: 12) {
                // 🇬🇧 English (always available)
                languageChip(
                    code: ArtfulArchivesCore.LanguageCode(rawValue: "en")!,
                    index: 0,
                    hasAudio: story.audio?.english != nil
                )

                // 🌐 Other localizations
                if let localizations = story.localizations {
                    ForEach(Array(localizations.enumerated()), id: \.element.id) { index, localization in
                        if let languageCode = LanguageCode(code: localization.locale) {
                            languageChip(
                                code: languageCode,
                                index: index + 1,
                                hasAudio: hasAudio(for: languageCode)
                            )
                        }
                    }
                }
            }
        }
    }

    /// 🏳️ A single language chip with flag and audio indicator
    private func languageChip(code: ArtfulArchivesCore.LanguageCode, index: Int, hasAudio: Bool) -> some View {
        HStack(spacing: 6) {
            Text(code.flag)
                .font(.system(size: 16))

            Text(code.name)
                .font(.system(size: 13, weight: .medium))

            if hasAudio {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.quaternary)
        )
        .opacity(showLanguages ? 1 : 0)
        .offset(x: showLanguages ? 0 : -20)
        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05), value: showLanguages)
    }

    // MARK: - 📅 Dates Section

    /// 📅 Important dates with fade-in animation
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 📅 Created
            dateRow(
                icon: "calendar.badge.plus",
                label: "Created",
                date: story.createdAt,
                delay: 0
            )

            // 🔄 Updated
            dateRow(
                icon: "calendar.badge.clock",
                label: "Updated",
                date: story.updatedAt,
                delay: 0.05
            )

            // 🌟 Published
            if let publishedAt = story.publishedAt {
                dateRow(
                    icon: "calendar.badge.checkmark",
                    label: "Published",
                    date: publishedAt,
                    delay: 0.1,
                    color: .green
                )
            }
        }
        .opacity(showDates ? 1 : 0)
        .offset(y: showDates ? 0 : 10)
    }

    /// 📅 A single date row
    private func dateRow(
        icon: String,
        label: String,
        date: Date,
        delay: Double,
        color: Color = .secondary
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(color)
                .frame(width: 20)

            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()

            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
                .monospacedDigit()
        }
        .opacity(showDates ? 1 : 0)
        .animation(.easeOut(duration: 0.3).delay(delay), value: showDates)
    }

    // MARK: - 👤 Author Section

    /// 👤 Author information with subtle emphasis
    private func authorSection(_ author: StoryAuthor) -> some View {
        HStack(spacing: 12) {
            // 🎨 Author avatar placeholder
            Circle()
                .fill(
                    LinearGradient(
                        colors: [stageColor(for: story.workflowStage), stageColor(for: story.workflowStage).opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .overlay {
                    Text(author.name.prefix(1).uppercased())
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text("Author")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text(author.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
        .opacity(showAuthor ? 1 : 0)
        .offset(x: showAuthor ? 0 : -20)
    }

    // MARK: - 🎭 Workflow Progress Section

    /// 🎭 Workflow progress visualization
    private var workflowProgressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Workflow Progress")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(Int(story.workflowProgress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(stageColor(for: story.workflowStage))
                    .monospacedDigit()
            }

            // 📊 Animated progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(.quaternary)
                        .frame(height: 8)

                    // Progress fill with gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    stageColor(for: story.workflowStage),
                                    stageColor(for: story.workflowStage).opacity(0.7)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * (showStatus ? story.workflowProgress : 0), height: 8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: showStatus)
                }
            }
            .frame(height: 8)

            // 💡 Suggested action (if not final)
            if !story.workflowStage.isFinal {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.yellow)

                    Text(story.workflowStage.suggestedAction)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
                .opacity(showStatus ? 1 : 0)
                .animation(.easeOut.delay(0.4), value: showStatus)
            }
        }
    }

    // MARK: - 🎨 Helpers

    /// 🎨 Get the color for a workflow stage
    private func stageColor(for stage: WorkflowStage) -> Color {
        switch stage {
        case .created: .blue
        case .englishTextApproved: .teal
        case .englishAudioApproved: .purple
        case .englishVersionApproved: .indigo
        case .multilingualTextApproved: .orange
        case .multilingualAudioApproved: .pink
        case .pendingFinalReview: .yellow
        case .approved: .green
        }
    }

    /// 🌐 Check if story has multiple languages
    private var hasMultipleLanguages: Bool {
        guard let localizations = story.localizations else { return false }
        return !localizations.isEmpty
    }

    /// 🎵 Check if audio exists for language
    private func hasAudio(for language: ArtfulArchivesCore.LanguageCode) -> Bool {
        // Convert CMS_Manager.LanguageCode to ArtfulArchivesCore.LanguageCode
        guard let coreLanguageCode = ArtfulArchivesCore.LanguageCode(rawValue: language.rawValue) else {
            return false
        }
        return story.audio?.audioURL(for: coreLanguageCode) != nil
    }

    // MARK: - 🎬 Animation Sequence

    /// 🎬 Start the cascading animation sequence
    private func startAnimationSequence() {
        // 1️⃣ Status appears first
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1)) {
            showStatus = true
        }

        // 🎵 Start status pulse for non-final stages
        if !story.workflowStage.isFinal {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    statusPulse = true
                }
            }
        }

        // 2️⃣ Languages cascade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showLanguages = true
            }
        }

        // 3️⃣ Dates fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.3)) {
                showDates = true
            }
        }

        // 4️⃣ Author slides in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showAuthor = true
            }
        }
    }

    /// 🎬 Show all elements immediately (no animation)
    private func showAllImmediately() {
        showStatus = true
        showLanguages = true
        showDates = true
        showAuthor = true

        if !story.workflowStage.isFinal {
            statusPulse = true
        }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Approved Story") {
    StoryMetadataCard(story: .mock)
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Pending Review") {
    StoryMetadataCard(story: .mockPendingReview)
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}

#Preview("Multilingual") {
    StoryMetadataCard(story: .mockWithTranslations)
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}
