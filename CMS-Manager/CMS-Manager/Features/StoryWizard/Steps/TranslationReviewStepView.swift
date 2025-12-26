//
//  TranslationReviewStepView.swift
//  CMS-Manager
//
//  📝 The Translation Review Step - Where Words Meet Their Reflections
//
//  "Side by side, original and translation gaze into each other's eyes,
//   like twins separated at birth, reunited in the mirror of understanding.
//   Here, the curator's pen refines what the AI translator began."
//
//  - The Spellbinding Museum Director of Linguistic Reflections
//

import SwiftUI
import ArtfulArchivesCore

/// 📝 Translation Review Step View - Step 5 of the Wizard
struct TranslationReviewStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The wizard's grand orchestrator
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 Local State

    /// 🎯 Currently selected language for review
    @State private var selectedLanguage: LanguageCode?

    /// 📝 In-memory edits for each language's content
    @State private var editedContents: [LanguageCode: String] = [:]

    /// 📝 In-memory edits for each language's title
    @State private var editedTitles: [LanguageCode: String] = [:]

    /// 📊 Track which translations have unsaved changes
    @State private var hasUnsavedChanges: Set<LanguageCode> = []

    /// 🔄 Track which languages are being regenerated
    @State private var regeneratingLanguages: Set<LanguageCode> = []

    /// ✨ Animation state
    @State private var showSaveConfirmation = false

    // MARK: - 🎨 Body

    var body: some View {
        VStack(spacing: 0) {
            // 📜 Header Section
            headerSection

            // 🌐 Language Picker Tabs
            languagePickerSection

            // 📝 Side-by-Side Comparison
            if let selected = selectedLanguage {
                comparisonView(for: selected)
            } else {
                emptyStateView
            }

            Spacer()

            // 🎯 Action Buttons
            actionButtonsSection
        }
        .padding()
        .onAppear {
            initializeTranslations()
        }
        .onChange(of: viewModel.selectedLanguages) { _, newLanguages in
            // Update selection if current selection is no longer valid
            if selectedLanguage == nil, let firstLang = newLanguages.first {
                selectedLanguage = firstLang
            }
        }
    }

    // MARK: - 📜 Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("📝 Review Translations")
                .font(.system(size: 32, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            Text("Compare original text with translations and make edits")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 🌐 Language Picker Section

    private var languagePickerSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sortedSelectedLanguages, id: \.id) { language in
                    LanguageTab(
                        language: language,
                        isSelected: selectedLanguage == language,
                        hasEdits: hasUnsavedChanges.contains(language),
                        isRegenerating: regeneratingLanguages.contains(language)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedLanguage = language
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }

    // MARK: - 📝 Comparison View

    @ViewBuilder
    private func comparisonView(for language: LanguageCode) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // 📄 Original Text Card
                OriginalTextCard(
                    title: viewModel.storyTitle,
                    content: viewModel.storyContent
                )

                // 🔄 Translation Card (Editable)
                TranslationEditCard(
                    language: language,
                    originalTitle: viewModel.storyTitle,
                    originalContent: viewModel.storyContent,
                    translatedTitle: Binding(
                        get: { editedTitles[language] ?? viewModel.translatedTitles[language] ?? viewModel.storyTitle },
                        set: { newTitle in
                            editedTitles[language] = newTitle
                            markAsEdited(language)
                        }
                    ),
                    translatedContent: Binding(
                        get: { editedContents[language] ?? viewModel.translations[language] ?? "" },
                        set: { newContent in
                            editedContents[language] = newContent
                            markAsEdited(language)
                        }
                    ),
                    hasUnsavedChanges: hasUnsavedChanges.contains(language),
                    isRegenerating: regeneratingLanguages.contains(language),
                    onSave: { saveChanges(for: language) },
                    onDiscard: { discardChanges(for: language) },
                    onRegenerate: { regenerateTranslation(for: language) }
                )
            }
            .padding()
        }
    }

    // MARK: - 🌙 Empty State View

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.multiple")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No Translations to Review")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Complete the translation step first")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - 🎯 Action Buttons Section

    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            // ⚠️ Unsaved changes warning
            if !hasUnsavedChanges.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("You have unsaved changes in \(hasUnsavedChanges.count) language(s)")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .padding(.vertical, 8)
            }

            HStack(spacing: 16) {
                // ⬅️ Back Button
                Button {
                    viewModel.previousStep()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                // 💾 Save All & Continue Button
                Button {
                    saveAllTranslations()
                } label: {
                    Label("Save All & Continue", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canProceed)
            }
        }
    }

    // MARK: - 🎯 Helper Properties

    /// 📊 Sorted selected languages
    private var sortedSelectedLanguages: [LanguageCode] {
        viewModel.selectedLanguages.sorted(by: { $0.name < $1.name })
    }

    /// ✅ Can we proceed to the next step?
    private var canProceed: Bool {
        // Must have at least one translation
        guard !viewModel.translations.isEmpty else { return false }

        // All translations must be non-empty
        for language in viewModel.selectedLanguages {
            let content = editedContents[language] ?? viewModel.translations[language] ?? ""
            if content.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
        }

        return true
    }

    // MARK: - 🎯 Actions

    /// 🌟 Initialize translations from view model - the awakening ceremony
    private func initializeTranslations() {
        // Select first language if available
        if selectedLanguage == nil, let firstLang = viewModel.selectedLanguages.first {
            selectedLanguage = firstLang
        }

        // Initialize edited state from view model's stored edits
        editedContents = [:]
        editedTitles = [:]
        hasUnsavedChanges = []
    }

    /// ✏️ Mark a language as having unsaved edits - tracking the dance of change
    private func markAsEdited(_ language: LanguageCode) {
        hasUnsavedChanges.insert(language)
    }

    /// 💾 Save changes for a specific language - crystallizing the wisdom
    private func saveChanges(for language: LanguageCode) {
        print("💾 ✨ Saving changes for \(language.name)...")

        // Apply edited content to view model
        if let editedContent = editedContents[language] {
            viewModel.translations[language] = editedContent
        }

        // Apply edited title to view model
        if let editedTitle = editedTitles[language] {
            viewModel.translatedTitles[language] = editedTitle
        }

        // Clear local edits and unsaved flag
        editedContents.removeValue(forKey: language)
        editedTitles.removeValue(forKey: language)
        hasUnsavedChanges.remove(language)

        print("✨ Changes saved for \(language.name)")
    }

    /// 🗑️ Discard changes for a specific language - returning to the original vision
    private func discardChanges(for language: LanguageCode) {
        print("🗑️ Discarding changes for \(language.name)...")

        // Remove local edits
        editedContents.removeValue(forKey: language)
        editedTitles.removeValue(forKey: language)
        hasUnsavedChanges.remove(language)

        print("✨ Changes discarded for \(language.name)")
    }

    /// 🔄 Regenerate translation for a language - summoning the translator anew
    private func regenerateTranslation(for language: LanguageCode) {
        print("🔄 ✨ REGENERATING TRANSLATION for \(language.name)...")

        regeneratingLanguages.insert(language)

        Task {
            // Call view model's retry translation
            await viewModel.retryTranslation(language)

            await MainActor.run {
                regeneratingLanguages.remove(language)

                // Clear any edits since we have a fresh translation
                editedContents.removeValue(forKey: language)
                editedTitles.removeValue(forKey: language)
                hasUnsavedChanges.remove(language)
            }
        }
    }

    /// 💾 Save all edited translations and proceed - the grand finale
    private func saveAllTranslations() {
        print("💾 ✨ SAVING ALL TRANSLATIONS...")

        // Save all languages with unsaved changes
        for language in hasUnsavedChanges {
            saveChanges(for: language)
        }

        // Show confirmation animation
        withAnimation(.spring(response: 0.3)) {
            showSaveConfirmation = true
        }

        // Move to next step after a brief delay
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                showSaveConfirmation = false
                viewModel.nextStep()
            }
        }

        print("🎉 ✨ ALL TRANSLATIONS SAVED!")
    }
}

// MARK: - 🌐 Language Tab

/// 🎭 Individual language tab for the picker - the linguistic badge of honor
struct LanguageTab: View {
    let language: LanguageCode
    let isSelected: Bool
    let hasEdits: Bool
    let isRegenerating: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Text(language.flag)

                Text(language.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                // 🔄 Regenerating indicator
                if isRegenerating {
                    ProgressView()
                        .controlSize(.small)
                        .tint(isSelected ? .white : .blue)
                }
                // ✏️ Edit indicator
                else if hasEdits {
                    Image(systemName: "pencil.circle.fill")
                        .font(.caption)
                        .foregroundStyle(isSelected ? .white : .orange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(language.name)")
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - 📄 Original Text Card

/// 📜 Card showing the original English text
struct OriginalTextCard: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🏷️ Header
            HStack {
                Image(systemName: "doc.text")
                    .foregroundStyle(.blue)

                Text("Original (English)")
                    .font(.headline)

                Spacer()
            }

            Divider()

            // 📜 Title
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            // 📖 Content
            Text(content)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(6)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Original text")
    }
}

// MARK: - ✏️ Translation Edit Card

/// 📝 Editable card for translated content - the editor's sacred canvas
/// Where AI-generated translations meet the curator's refined touch! ✨
struct TranslationEditCard: View {
    let language: LanguageCode
    let originalTitle: String
    let originalContent: String
    @Binding var translatedTitle: String
    @Binding var translatedContent: String
    let hasUnsavedChanges: Bool
    let isRegenerating: Bool
    let onSave: () -> Void
    let onDiscard: () -> Void
    let onRegenerate: () -> Void

    @State private var isEditingTitle = false
    @State private var isEditingContent = false
    @FocusState private var focusedField: Field?

    enum Field {
        case title, content
    }

    /// 📊 Character count for title
    private var titleCharacterCount: Int {
        translatedTitle.count
    }

    /// 📊 Character count for content
    private var contentCharacterCount: Int {
        translatedContent.count
    }

    /// ⚠️ Validation: is title empty?
    private var isTitleEmpty: Bool {
        translatedTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// ⚠️ Validation: is content empty?
    private var isContentEmpty: Bool {
        translatedContent.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// ✅ Is the translation valid?
    private var isValid: Bool {
        !isTitleEmpty && !isContentEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 🏷️ Header with action buttons
            headerSection

            Divider()

            // 📜 Editable Title Section
            titleSection

            Divider()

            // 📖 Editable Content Section
            contentSection

            // 🎯 Action buttons (Save/Discard)
            if hasUnsavedChanges {
                actionButtonsSection
            }

            // 💡 Tip text when not editing
            if !hasUnsavedChanges && !isEditingTitle && !isEditingContent && !isRegenerating {
                tipSection
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    borderColor,
                    lineWidth: hasUnsavedChanges ? 2 : 1
                )
        )
        .opacity(isRegenerating ? 0.6 : 1.0)
        .disabled(isRegenerating)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(language.name) translation, editable")
    }

    // MARK: - 🎨 Subviews

    /// 🏷️ Header section with language info and regenerate button
    private var headerSection: some View {
        HStack {
            Text(language.flag)
                .font(.title3)

            Text("\(language.name) Translation")
                .font(.headline)

            Spacer()

            // 🔄 Regenerate button
            Button {
                onRegenerate()
            } label: {
                HStack(spacing: 4) {
                    if isRegenerating {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text(isRegenerating ? "Regenerating..." : "Regenerate")
                        .font(.caption)
                }
            }
            .buttonStyle(.bordered)
            .disabled(isRegenerating)
        }
    }

    /// 📜 Title editing section with character count
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Title")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                // 📊 Character count
                Text("\(titleCharacterCount) characters")
                    .font(.caption)
                    .foregroundStyle(isTitleEmpty ? .red : .secondary)
            }

            TextField("Translated title", text: $translatedTitle)
                .textFieldStyle(.roundedBorder)
                .font(.body)
                .focused($focusedField, equals: .title)
                .onChange(of: focusedField) { _, newFocus in
                    isEditingTitle = newFocus == .title
                }

            // ⚠️ Validation message
            if isTitleEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Title cannot be empty")
                        .font(.caption)
                }
                .foregroundStyle(.red)
            }
        }
    }

    /// 📖 Content editing section with character count
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Content")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                // 📊 Character count
                Text("\(contentCharacterCount) characters")
                    .font(.caption)
                    .foregroundStyle(isContentEmpty ? .red : .secondary)
            }

            ZStack(alignment: .topLeading) {
                // Background for TextEditor
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.05))
                    .stroke(focusedField == .content ? Color.blue : Color.secondary.opacity(0.2), lineWidth: 1)

                TextEditor(text: $translatedContent)
                    .font(.body)
                    .focused($focusedField, equals: .content)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(minHeight: 200)
                    .onChange(of: focusedField) { _, newFocus in
                        isEditingContent = newFocus == .content
                    }
            }

            // ⚠️ Validation message
            if isContentEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Content cannot be empty")
                        .font(.caption)
                }
                .foregroundStyle(.red)
            }
        }
    }

    /// 🎯 Save/Discard action buttons
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // 🗑️ Discard button
            Button {
                onDiscard()
            } label: {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Discard Changes")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.red)

            // 💾 Save button
            Button {
                onSave()
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save Changes")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isValid)
        }
    }

    /// 💡 Helpful tip section
    private var tipSection: some View {
        HStack {
            Image(systemName: "lightbulb.fill")
                .font(.caption)
                .foregroundStyle(.yellow)

            Text("Tap fields to edit • Click regenerate for a fresh translation")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    /// 🎨 Border color based on state
    private var borderColor: Color {
        if hasUnsavedChanges {
            return .orange
        } else if isEditingTitle || isEditingContent {
            return .blue
        } else {
            return .secondary.opacity(0.2)
        }
    }
}

// MARK: - 🧪 Preview

#Preview {
    TranslationReviewStepView(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.storyTitle = "The Starry Night"
        vm.storyContent = "The Starry Night is an oil-on-canvas painting by the Dutch Post-Impressionist painter Vincent van Gogh. Painted in June 1889, it depicts the view from the east-facing window of his asylum room at Saint-Rémy-de-Provence, just before sunrise, with the addition of an imaginary village."
        vm.selectedLanguages = [ArtfulArchivesCore.LanguageCode.spanish, ArtfulArchivesCore.LanguageCode.hindi]
        vm.translations = [
            .spanish: "La noche estrellada es un cuadro al oleo sobre lienzo...",
            .hindi: "स्टाररी नाइट एक तेल चित्रकला है..."
        ]
        return vm
    }())
}
