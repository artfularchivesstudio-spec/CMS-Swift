//
//  StoryDetailView.swift
//  CMS-Manager
//
//  📖 The Story Detail - Immersive Reading Experience
//
//  "Where stories unfold in their full glory,
//   words dance on the screen with sequential grace,
//   and audio whispers tales in every language the soul can understand.
//   Each scroll reveals new depth, each tap brings new delight."
//
//  - The Spellbinding Museum Director of Story Presentation
//

import SwiftUI
import ArtfulArchivesCore
import MarkdownUI

// Resolve LanguageCode ambiguity - use the ArtfulArchivesCore enum that has .english
public typealias LocalLanguageCode = ArtfulArchivesCore.LanguageCode

// MARK: - 📖 Story Detail View

/// 📖 Full story display with magical animations and immersive experience
/// ✨ Features: hero transitions, sequential animations, parallax scrolling, enhanced audio player
struct StoryDetailView: View {

    // MARK: - 🏺 Properties

    /// 📖 The story to display (using ArtfulArchivesCore Story model)
    let story: ArtfulArchivesCore.Story

    /// 🎭 Namespace for matched geometry effects (passed from list)
    var namespace: Namespace.ID?

    init(story: ArtfulArchivesCore.Story, namespace: Namespace.ID? = nil) {
        self.story = story
        self.namespace = namespace

        // 🎭 Setup persisted language storage
        _lastPlayedLanguage = AppStorage(wrappedValue: nil, "lastAudioLanguage_\(story.id)")

        // 🌟 Determine initial language (persisted > locale > first available)
        let initialLang: LocalLanguageCode
        if let lastPlayed = _lastPlayedLanguage.wrappedValue,
           let persistedLanguage = LocalLanguageCode(rawValue: lastPlayed) {
            initialLang = persistedLanguage
        } else {
            initialLang = StoryDetailView.initialLanguage(for: story)
        }

        _selectedLanguage = State(initialValue: initialLang)
    }

    // MARK: - 🏺 Environment

    /// 🏭 App dependencies
    @Environment(\.dependencies) private var dependencies

    /// 🌙 Presentation mode (for dismissal)
    @Environment(\.dismiss) private var dismiss

    // MARK: - 🌟 State

    /// ✏️ Edit mode
    @State private var isEditing = false

    /// ⏳ Loading state for actions
    @State private var isLoading = false

    /// 🌩️ Error state
    @State private var error: APIError?

    /// 🎵 Currently selected language for audio
    @State private var selectedLanguage: LocalLanguageCode = .english

    /// 🎵 Persisted last played language per story
    @AppStorage private var lastPlayedLanguage: String?

    /// 📄 Edit mode text fields
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    @State private var editedExcerpt: String = ""

    /// 📤 Showing share sheet
    @State private var showingShareSheet = false

    /// 🎭 Selected stage for editing
    @State private var selectedStageForEdit: WorkflowStage = .created

    /// 🗑️ Showing delete confirmation dialog
    @State private var showingDeleteConfirmation = false

    /// 💾 Auto-cache stories setting
    @AppStorage("autoCacheStories") private var autoCacheStories = true

    // MARK: - 🎬 Animation States

    /// 🎬 Sequential animation triggers
    @State private var showImage = false
    @State private var showHeader = false
    @State private var showContent = false
    @State private var showMetadata = false
    @State private var showAudio = false

    /// 📊 Scroll offset for parallax
    @State private var scrollOffset: CGFloat = 0

    /// 🎵 Audio player expanded state
    @State private var audioPlayerExpanded = false

    /// 📸 Delete button press progress (for long-press)
    @State private var deleteProgress: CGFloat = 0
    @State private var isPressingDelete = false

    /// 🎉 Celebration states
    @State private var showSuccessConfetti = false
    @State private var validationErrorTrigger = 0

    // MARK: - 🎭 Body

    var body: some View {
        ZStack(alignment: .bottom) {
            // 🌊 Main scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 🖼️ Hero image gallery with parallax
                    if let images = allImages, !images.isEmpty {
                        heroImageSection(images: images)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        // 🏷️ Header section
                        headerSection
                            .opacity(showHeader ? 1 : 0)
                            .offset(y: showHeader ? 0 : 20)

                        // 📝 Content section
                        contentSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)

                        // 🏷️ Metadata card
                        StoryMetadataCard(story: story, animateOnAppear: showMetadata)
                            .opacity(showMetadata ? 1 : 0)
                            .offset(y: showMetadata ? 0 : 20)
                    }
                    .padding(20)
                }
            }
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            })
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .ignoresSafeArea(edges: .top)

            // 🎵 Floating audio player (when scrolled)
            if story.audio != nil && showAudio {
                floatingAudioPlayer
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // 🎭 Title that fades in when scrolled
                Text(story.title)
                    .font(.system(size: 17, weight: .semibold))
                    .opacity(scrollOffset < -200 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: scrollOffset)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarActions
            }
        }
        .task {
            // 🎬 Start animation sequence
            startAnimationSequence()

            // 💾 Auto-cache story when viewing (if enabled)
            if autoCacheStories {
                await cacheStoryInBackground()
            }
        }
        .toast(dependencies.toastManager)
        .sheet(isPresented: $isEditing) {
            editSheet
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            if let error {
                Text(error.localizedDescription)
            }
        }
        .confirmationDialog(
            "Delete Story?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                Task { await deleteStory() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. The story '\(story.title)' will be permanently deleted.")
        }
        .confetti(isPresented: $showSuccessConfetti, style: .success)
    }

    // MARK: - 🖼️ Hero Image Section

    /// 🖼️ Hero image gallery with parallax effect
    private func heroImageSection(images: [StoryMedia]) -> some View {
        ZStack(alignment: .bottom) {
            // 🌊 Parallax scrolling image
            GeometryReader { geometry in
                StoryImageGallery(images: images, namespace: namespace)
                    .frame(height: 350)
                    .offset(y: parallaxOffset)
                    .clipped()
            }
            .frame(height: 350)

            // 🌈 Gradient overlay for text readability
            LinearGradient(
                colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
        }
        .opacity(showImage ? 1 : 0)
        .scaleEffect(showImage ? 1 : 0.95)
    }

    /// 🌊 Calculate parallax offset based on scroll
    private var parallaxOffset: CGFloat {
        // Image moves slower than scroll (0.5x speed)
        let offset = scrollOffset > 0 ? -scrollOffset * 0.5 : 0
        return offset
    }

    /// 🖼️ Get all images (main + gallery)
    private var allImages: [StoryMedia]? {
        var images: [StoryMedia] = []

        if let mainImage = story.image {
            images.append(mainImage)
        }

        if let galleryImages = story.images {
            images.append(contentsOf: galleryImages)
        }

        return images.isEmpty ? nil : images
    }

    // MARK: - 🏷️ Header Section

    /// 🏷️ Title, status badge, and excerpt
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 📜 Title with emphasis
            Text(story.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)

            // ✂️ Excerpt with styling
            if !story.excerpt.isEmpty {
                Text(story.excerpt)
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(Color.accentColor.opacity(0.5))
                            .frame(width: 4)
                    }
            }
        }
    }

    // MARK: - 📝 Content Section

    /// 📝 The main story content (markdown rendering with mystical flair)
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 📚 Section header
            HStack(spacing: 8) {
                Image(systemName: "book.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)

                Text("Story")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }

            // 📜 Rendered content (MarkdownUI - for that spellbinding prose experience)
            Markdown(story.bodyMessage)
                .markdownTheme(.gitHub)
                .markdownBlockStyle(\.blockquote) { configuration in
                    configuration.label
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(Color.accentColor.opacity(0.5))
                                .frame(width: 4)
                        }
                }
                .markdownBlockStyle(\.codeBlock) { configuration in
                    configuration.label
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.quaternary)
                        )
                }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Story content")
    }

    // MARK: - 🎵 Floating Audio Player

    /// 🎵 Floating audio player that appears when scrolled
    private var floatingAudioPlayer: some View {
        VStack(spacing: 0) {
            // 🎵 Compact player bar
            if !audioPlayerExpanded {
                compactAudioBar
            } else {
                // 🎵 Full expanded player
                expandedAudioPlayer
            }
        }
        .background(
            RoundedRectangle(cornerRadius: audioPlayerExpanded ? 0 : 20, style: .continuous)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.2), radius: 20, y: -5)
        )
        .ignoresSafeArea(edges: audioPlayerExpanded ? [.bottom] : [])
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: audioPlayerExpanded)
    }

    /// 🎵 Compact audio bar
    private var compactAudioBar: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                audioPlayerExpanded = true
            }
            // 🎵 Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 16) {
                // 🌊 Mini waveform indicator
                HStack(spacing: 2) {
                    ForEach(0..<4) { _ in
                        Capsule()
                            .fill(.blue)
                            .frame(width: 3, height: CGFloat.random(in: 8...20))
                    }
                }
                .frame(width: 20)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Audio Available")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(selectedLanguage.nativeName)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }

    /// 🎵 Expanded audio player
    private var expandedAudioPlayer: some View {
        VStack(spacing: 0) {
            // 🎭 Header with close button
            HStack {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioPlayerExpanded = false
                    }
                    // 🎵 Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Text("Audio Player")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // 🗣️ Language picker
            languagePicker
                .padding(.horizontal, 20)
                .padding(.top, 20)

            // 🎵 Audio player
            if let coreLanguageCode = ArtfulArchivesCore.LanguageCode(rawValue: selectedLanguage.rawValue),
               let audioUrl = story.audio?.audioURL(for: coreLanguageCode) {
                StoryAudioPlayerView(audioURL: audioUrl, language: selectedLanguage)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            } else {
                noAudioPlaceholder
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
        }
    }

    /// 🗣️ Language picker with smooth transitions
    private var languagePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Language")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LocalLanguageCode.allCases, id: \.self) { language in
                        languageChip(language)
                    }
                }
            }
        }
    }

    /// 🏳️ Language selection chip
    private func languageChip(_ language: LocalLanguageCode) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedLanguage = language
            }
            // 🎵 Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()

            // 💾 Persist the language choice
            lastPlayedLanguage = language.rawValue
        } label: {
            HStack(spacing: 8) {
                Text(language.flag)
                    .font(.system(size: 16))

                Text(language.nativeName)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(selectedLanguage == language ? Color.blue : Color(.quaternarySystemFill))
            )
            .foregroundStyle(selectedLanguage == language ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    /// 🔊 Placeholder when no audio available
    private var noAudioPlaceholder: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.circle")
                .font(.system(size: 60))
                .foregroundStyle(.tertiary)
                .symbolEffect(.pulse)

            Text("No audio available for \(selectedLanguage.nativeName)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                dependencies.toastManager.info("Audio Generation", message: "Feature coming soon!")
                // 🎵 Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("Generate Audio")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(.blue.gradient)
                )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - 🛠️ Toolbar Actions

    /// 🛠️ Edit, Delete, and Share buttons with animations
    private var toolbarActions: some View {
        Menu {
            Button {
                startEditing()
                // 🎵 Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            } label: {
                Label("Edit", systemImage: "pencil")
            }

            Divider()

            Button {
                showingShareSheet = true
                // 🎵 Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Divider()

            Button(role: .destructive) {
                showingDeleteConfirmation = true
                // 🎵 Haptic feedback
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.warning)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.system(size: 18))
                .symbolEffect(.bounce, value: showingShareSheet)
                .accessibilityLabel("Story options")
        }
    }

    // MARK: - 📤 Share Items

    /// 📤 Items to share
    private var shareItems: [Any] {
        var items: [Any] = []

        // Title and excerpt
        items.append("\(story.title)\n\n\(story.excerpt)")

        // URL
        if let url = URL(string: "https://artfularchives.com\(story.webURL)") {
            items.append(url)
        }

        // Image
        if let imageURL = story.previewImageURL {
            items.append(imageURL)
        }

        return items
    }

    // MARK: - ✏️ Edit Sheet

    /// ✏️ The edit sheet with smooth transitions
    private var editSheet: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Story title", text: $editedTitle)
                        .font(.system(size: 17))
                        .shake(trigger: validationErrorTrigger)
                }

                Section("Excerpt") {
                    TextField("Brief summary", text: $editedExcerpt, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.system(size: 15))
                }

                Section("Content") {
                    TextEditor(text: $editedContent)
                        .frame(minHeight: 250)
                        .font(.system(size: 15))
                }

                // 🎭 Workflow stage picker
                Section("Workflow Stage") {
                    Picker("Stage", selection: $selectedStageForEdit) {
                        ForEach(WorkflowStage.allCases, id: \.self) { stage in
                            HStack {
                                Image(systemName: stage.icon)
                                Text(stage.name)
                            }
                            .tag(stage)
                        }
                    }
                    .accessibilityLabel("Workflow stage")
                }

                // 📊 Character counts
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        characterCount(label: "Title", count: editedTitle.count, limit: 200)
                        characterCount(label: "Excerpt", count: editedExcerpt.count, limit: 500)
                        characterCount(label: "Content", count: editedContent.count, limit: 10000)
                    }
                } header: {
                    Text("Character Counts")
                }
            }
            .navigationTitle("Edit Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isEditing = false
                        // 🎵 Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                    .accessibilityLabel("Cancel editing")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // 🌊 Validate before saving
                        if editedTitle.isEmpty {
                            validationErrorTrigger += 1
                        } else {
                            Task { await saveEdits() }
                            // 🎵 Haptic feedback
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                        }
                    }
                    .accessibilityLabel("Save changes")
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    /// 📊 Character count display
    private func characterCount(label: String, count: Int, limit: Int) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()

            Text("\(count) / \(limit)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(count > limit ? .red : .secondary)
                .monospacedDigit()
        }
    }

    // MARK: - 🧙‍♂️ Actions

    /// ✏️ Start editing
    private func startEditing() {
        editedTitle = story.title
        editedContent = story.bodyMessage
        editedExcerpt = story.excerpt
        selectedStageForEdit = story.workflowStage
        isEditing = true
    }

    /// 💾 Save edits
    private func saveEdits() async {
        isLoading = true

        do {
            let updates = StoryUpdate(
                title: editedTitle.isEmpty ? nil : editedTitle,
                bodyMessage: editedContent.isEmpty ? nil : editedContent,
                excerpt: nil,
                workflowStage: selectedStageForEdit.rawValue,
                visible: story.visible
            )
            _ = try await dependencies.apiClient.updateStory(id: story.id, updates: updates)

            dependencies.toastManager.success("Story Updated")
            isEditing = false

            // 🎉 Success haptic and confetti!
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)

            showSuccessConfetti = true

            print("🎉 ✨ STORY UPDATE MASTERPIECE COMPLETE!")
        } catch let apiError as APIError {
            self.error = apiError
            dependencies.toastManager.error("Update Failed", message: apiError.localizedDescription)

            // 🌩️ Error haptic
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        } catch {
            dependencies.toastManager.error("Update Failed", message: error.localizedDescription)

            // 🌩️ Error haptic
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }

        isLoading = false
    }

    /// 🗑️ Delete the story
    private func deleteStory() async {
        isLoading = true

        do {
            _ = try await dependencies.apiClient.deleteStory(id: story.id)
            dependencies.toastManager.success("Story Deleted")

            // 🎉 Success haptic
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)

            dismiss()
            print("🎉 ✨ STORY DELETION MASTERPIECE COMPLETE!")
        } catch let apiError as APIError {
            self.error = apiError
            dependencies.toastManager.error("Delete Failed", message: apiError.localizedDescription)

            // 🌩️ Error haptic
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        } catch {
            dependencies.toastManager.error("Delete Failed", message: error.localizedDescription)

            // 🌩️ Error haptic
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }

        isLoading = false
    }

    /// 💾 Cache story in background (for offline access)
    private func cacheStoryInBackground() async {
        print("💎 Auto-caching story '\(story.title)' for offline access...")

        do {
            // 📚 Cache the story data
            try await dependencies.storyCacheManager.cacheStory(story)
            print("💎 Story cached successfully")
        } catch {
            print("🌩️ Failed to cache story: \(error.localizedDescription)")
        }
    }

    // MARK: - 🎬 Animation Sequence

    /// 🎬 Start the magical animation sequence
    private func startAnimationSequence() {
        // 1️⃣ Image appears first (hero animation)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showImage = true
        }

        // 2️⃣ Header fades in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.4)) {
                showHeader = true
            }
        }

        // 3️⃣ Content fades in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.4)) {
                showContent = true
            }
        }

        // 4️⃣ Metadata cascades in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.4)) {
                showMetadata = true
            }
        }

        // 5️⃣ Audio player appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showAudio = true
            }
        }
    }

    // MARK: - 🎨 Helpers

    /// Picks the most relevant starting language based on locale or available audio
    private static func initialLanguage(for story: ArtfulArchivesCore.Story) -> LocalLanguageCode {
        if let localeLanguage = localeLanguage(from: story.locale!) {
            return localeLanguage
        }

        if let availableLanguage = firstAvailableAudioLanguage(in: story.audio) {
            return availableLanguage
        }

        return .english
    }

    private static func localeLanguage(from locale: String) -> LocalLanguageCode? {
        let normalizedLocale = locale.lowercased()
        if let exactMatch = LocalLanguageCode(rawValue: normalizedLocale) {
            return exactMatch
        }

        if let prefixMatch = LocalLanguageCode(rawValue: String(normalizedLocale.prefix(2))) {
            return prefixMatch
        }

        return nil
    }

    private static func firstAvailableAudioLanguage(in audio: ArtfulArchivesCore.StoryAudio?) -> LocalLanguageCode? {
        guard let audio else { return nil }

        if let english = audio.english, !english.isEmpty {
            return .english
        }

        if let spanish = audio.spanish, !spanish.isEmpty {
            return .spanish
        }

        if let hindi = audio.hindi, !hindi.isEmpty {
            return .hindi
        }

        return nil
    }
}

// MARK: - 📊 Scroll Offset Preference Key

/// 📊 Preference key for tracking scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - 🎵 Story Audio Player View

/// 🎵 A dedicated audio player for story audio with enhanced controls
/// ✨ Features: speed control, volume control, scrubbing, waveform visualization, and more
/// 🎭 The Digital Maestro orchestrates the symphony of spoken words!
struct StoryAudioPlayerView: View {
    let audioURL: String
    let language: LocalLanguageCode

    @Environment(\.audioPlayer) private var player
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLoading = false
    @State private var error: AudioError?
    @State private var showingSpeedPicker = false
    @State private var isDragging = false
    @State private var volume: Double = 1.0

    // 🌊 Waveform animation
    @State private var waveformPhase: Double = 0
    @State private var waveformTimer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            // 🌊 Waveform visualization (when playing)
            if player.isPlaying && player.currentURL == audioURL {
                enhancedWaveformVisualization
                    .transition(.opacity.combined(with: .scale))
            }

            // 📊 Interactive Progress bar with time labels
            VStack(spacing: 10) {
                // 🎯 Draggable progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(.quaternary)
                            .frame(height: 6)

                        // Progress fill
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * player.currentProgress, height: 6)

                        // Playhead indicator
                        Circle()
                            .fill(.white)
                            .frame(width: 16, height: 16)
                            .shadow(color: .blue.opacity(0.5), radius: 4)
                            .offset(x: geometry.size.width * player.currentProgress - 8)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isDragging = true
                                let progress = max(0, min(1, value.location.x / geometry.size.width))
                                let newTime = progress * player.duration
                                player.seek(to: newTime)

                                // 🎵 Haptic ticks
                                if Int(progress * 100) % 5 == 0 {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                }
                .frame(height: 16)

                // ⏰ Time labels
                HStack {
                    Text(AudioDurationFormatter.format(player.currentTime))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(AudioDurationFormatter.format(player.duration))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }

            // 🎮 Main controls row
            HStack(spacing: 32) {
                // ⏪ Skip back 15s
                Button {
                    player.skipBackward()
                    // 🎵 Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    Image(systemName: "gobackward.15")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Skip back 15 seconds")

                Spacer()

                // ▶️ Play/Pause button with animation
                Button {
                    if player.isPlaying && player.currentURL == audioURL {
                        player.pause()
                    } else if player.currentURL == audioURL {
                        player.resume()
                    } else {
                        Task {
                            await playAudio()
                        }
                    }
                    // 🎵 Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 70, height: 70)
                            .shadow(color: .blue.opacity(0.4), radius: 12, y: 6)

                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: player.isPlaying && player.currentURL == audioURL ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .contentTransition(.symbolEffect(.replace))
                                .symbolEffect(.bounce, value: player.isPlaying)
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(isLoading)
                .accessibilityLabel(player.isPlaying && player.currentURL == audioURL ? "Pause" : "Play")

                Spacer()

                // ⏩ Skip forward 15s
                Button {
                    player.skipForward()
                    // 🎵 Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    Image(systemName: "goforward.15")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Skip forward 15 seconds")
            }

            // 🔊 Volume Control
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    Image(systemName: volume > 0.5 ? "speaker.wave.2.fill" : (volume > 0 ? "speaker.wave.1.fill" : "speaker.slash.fill"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 24)

                    Slider(value: $volume, in: 0...1) { _ in
                        player.setVolume(Float(volume))
                    }
                    .tint(.blue)
                    .accessibilityLabel("Volume")
                    .accessibilityValue("\(Int(volume * 100)) percent")

                    Text("\(Int(volume * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 40)
                        .monospacedDigit()
                }
            }

            // 🐌 Playback speed control
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "gauge.with.dots.needle.33percent")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Playback Speed")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()
                }

                // Speed buttons in a scrollable row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach([0.5, 0.75, 1.0, 1.25, 1.5, 2.0], id: \.self) { speed in
                            Button {
                                player.setRate(Float(speed))
                                // 🎵 Haptic feedback
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            } label: {
                                Text(String(format: "%.2gx", speed))
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(player.playbackRate == Float(speed) ? .white : .primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(player.playbackRate == Float(speed) ? .blue.gradient : Color(.quaternarySystemFill))
                                    )
                                    .scaleEffect(player.playbackRate == Float(speed) ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: player.playbackRate)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Playback speed \(String(format: "%.2gx", speed))")
                        }
                    }
                }
            }

            // 🌩️ Error display
            if let error {
                HStack(spacing: 10) {
                    Image(systemName: error.icon)
                        .foregroundStyle(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(.top, 8)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Audio player for \(language.nativeName)")
        .onAppear {
            startWaveformAnimation()
        }
        .onDisappear {
            // 🎭 Pause playback when view disappears (lifecycle management)
            if player.isPlaying && player.currentURL == audioURL {
                player.pause()
            }
            stopWaveformAnimation()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // 🌙 Handle app backgrounding
            if newPhase == .background && player.isPlaying && player.currentURL == audioURL {
                player.pause()
            }
        }
    }

    // MARK: - 🌊 Enhanced Waveform Visualization

    /// 🌊 Animated waveform bars that dance to the music with gradient colors
    private var enhancedWaveformVisualization: some View {
        HStack(spacing: 4) {
            ForEach(0..<40, id: \.self) { index in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: waveformColors(for: index),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 4)
                    .frame(height: waveHeight(for: index))
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.03),
                        value: waveformPhase
                    )
            }
        }
        .frame(height: 60)
        .padding(.vertical, 10)
    }

    /// 🎨 Calculate waveform bar height with sine wave pattern
    private func waveHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 10
        let maxHeight: CGFloat = 60
        let phase = waveformPhase + Double(index) * 0.2
        let height = baseHeight + (maxHeight - baseHeight) * abs(sin(phase))
        return height
    }

    /// 🌈 Get gradient colors based on position
    private func waveformColors(for index: Int) -> [Color] {
        let progress = Double(index) / 40.0
        let hue = 0.5 + (progress * 0.3) // Blue to purple range

        return [
            Color(hue: hue, saturation: 0.8, brightness: 0.9),
            Color(hue: hue, saturation: 0.6, brightness: 0.7)
        ]
    }

    /// 🌀 Start the waveform animation loop - the visual heartbeat of our audio
    private func startWaveformAnimation() {
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [self] _ in
            waveformPhase += 0.15
        }
    }

    /// 🛑 Stop the waveform animation - silence the visual symphony
    private func stopWaveformAnimation() {
        waveformTimer?.invalidate()
        waveformTimer = nil
    }

    // MARK: - 🧙‍♂️ Playback Helper

    /// 🎵 Play the audio file
    private func playAudio() async {
        isLoading = true
        error = nil

        do {
            try await player.play(url: audioURL)
            print("🎉 ✨ AUDIO PLAYBACK MASTERPIECE COMPLETE!")
        } catch let audioError as AudioError {
            self.error = audioError
            print("💥 😭 AUDIO PLAYBACK TEMPORARILY HALTED! \(audioError.localizedDescription)")
        } catch {
            self.error = .playbackFailed(error)
            print("💥 😭 AUDIO PLAYBACK TEMPORARILY HALTED! \(error.localizedDescription)")
        }

        isLoading = false
    }
}

// MARK: - 📤 Share Sheet

/// 📤 Simple share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - 🧙‍♂️ Preview

#Preview {
    NavigationStack {
        StoryDetailView(story: .mockForDetail)
    }
    .withDependencies(.mock)
}

// MARK: - 🧪 Mock Extension

extension ArtfulArchivesCore.Story {
    /// 🎭 A mock story for detail view previews
    static var mockForDetail: ArtfulArchivesCore.Story {
        ArtfulArchivesCore.Story(
            id: 1,
            documentId: "doc-1",
            title: "The Mona Lisa's Secret Smile",
            slug: "mona-lisa-secret-smile",
            bodyMessage: """
            # The Enigmatic Smile

            For centuries, art historians have debated the meaning behind the Mona Lisa's enigmatic expression. Now, new research reveals...

            ## What We Know

            - Painted by Leonardo da Vinci
            - Created during the Renaissance
            - Currently housed in the Louvre Museum

            > "Every act of creation is first an act of destruction." - Pablo Picasso

            ### The Mystery Deepens

            Recent analysis using modern imaging techniques has uncovered hidden layers beneath the visible surface...
            """,
            excerpt: "A groundbreaking discovery about Da Vinci's most famous masterpiece.",
            image: nil,
            images: nil,
            audio: ArtfulArchivesCore.StoryAudio(english: "https://example.com/audio.mp3"),
            workflowStage: .approved,
            visible: true,
            locale: "en",
            localizations: nil,
            createdAt: Date(),
            updatedAt: Date().addingTimeInterval(-86400),
            publishedAt: Date(),
            createdBy: ArtfulArchivesCore.StoryAuthor(id: 1, name: "Art Curator"),
            strapiAttributes: nil
        )
    }
}
