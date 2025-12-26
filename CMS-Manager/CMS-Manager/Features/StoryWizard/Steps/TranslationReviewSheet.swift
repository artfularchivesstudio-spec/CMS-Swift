//
//  TranslationReviewSheet.swift
//  CMS-Manager
//
//  📝 The Translation Review Sheet - Where Tales Are Perfected
//
//  "In the grand editorial chamber, creators wield their pens,
//   refining each translation with the precision of a master craftsperson.
//   Side by side, the original and translated dance in harmony!"
//
//  - The Spellbinding Museum Director of Linguistic Refinement
//

import SwiftUI
import ArtfulArchivesCore

/// 📝 Translation Review Sheet - Modal for reviewing and editing translations
struct TranslationReviewSheet: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The wizard's grand orchestrator
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 Local State

    /// 🌐 Currently selected language for review
    @State private var selectedLanguage: LanguageCode?

    /// 📝 Local editing state for the current translation content
    @State private var editingContent: String = ""

    /// 🎨 Local editing state for the current translation title
    @State private var editingTitle: String = ""

    /// ✨ Has the current translation been modified?
    @State private var hasChanges: Bool = false

    /// 🎪 Show save confirmation
    @State private var showSaveConfirmation: Bool = false

    /// 🚫 Dismiss action
    @Environment(\.dismiss) private var dismiss

    // MARK: - 🎨 Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🌐 Language Tabs
                languageTabsSection

                Divider()

                // 📝 Editor Section
                if let language = selectedLanguage {
                    editorSection(for: language)
                } else {
                    emptyStateView
                }
            }
            .navigationTitle("Review Translations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        if hasChanges {
                            showSaveConfirmation = true
                        } else {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save All") {
                        saveAllChanges()
                        dismiss()
                    }
                    .disabled(!hasAnyEdits)
                }
            }
            .onAppear {
                // 🎯 Auto-select the first language
                if selectedLanguage == nil {
                    selectedLanguage = sortedTranslatedLanguages.first
                }
            }
            .confirmationDialog("Unsaved Changes", isPresented: $showSaveConfirmation) {
                Button("Save Changes") {
                    saveAllChanges()
                    dismiss()
                }
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You have unsaved changes. What would you like to do?")
            }
        }
    }

    // MARK: - 🌐 Language Tabs Section

    private var languageTabsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sortedTranslatedLanguages, id: \.id) { language in
                    LanguageTabButton(
                        language: language,
                        isSelected: selectedLanguage == language,
                        isEdited: isLanguageEdited(language),
                        onTap: {
                            selectLanguage(language)
                        }
                    )
                }
            }
            .padding()
        }
        .background(Color.secondary.opacity(0.05))
    }

    // MARK: - 📝 Editor Section

    /// 🎨 The grand editing canvas for a specific language
    private func editorSection(for language: LanguageCode) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // 📊 Stats Card
                translationStatsCard(for: language)

                // 🎨 Title Editor
                titleEditorSection(for: language)

                // 📝 Content Editor
                contentEditorSection(for: language)

                // 🎯 Action Buttons
                actionButtonsSection(for: language)
            }
            .padding()
        }
    }

    // MARK: - 📊 Translation Stats Card

    /// 📊 Display statistics comparing original and translated text
    private func translationStatsCard(for language: LanguageCode) -> some View {
        let originalLength = viewModel.storyContent.count
        let translatedLength = editingContent.count
        let difference = translatedLength - originalLength
        let percentageDiff = originalLength > 0 ? abs(Double(difference) / Double(originalLength)) * 100 : 0

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 Translation Statistics")
                    .font(.headline)
                Spacer()
                Text(language.flag)
                    .font(.title3)
            }

            HStack(spacing: 20) {
                StatPill(label: "Original", value: "\(originalLength)", color: .blue)
                StatPill(label: "Translation", value: "\(translatedLength)", color: .purple)

                if percentageDiff > 30 {
                    StatPill(
                        label: "Warning",
                        value: String(format: "%.0f%%", percentageDiff),
                        color: .orange,
                        icon: "exclamationmark.triangle.fill"
                    )
                }
            }

            // ⚠️ Length warning
            if percentageDiff > 30 {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.orange)
                    Text("Translation length differs significantly from original")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - 🎨 Title Editor Section

    /// 🎨 Side-by-side title editor
    private func titleEditorSection(for language: LanguageCode) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📝 Story Title")
                .font(.headline)

            #if os(macOS)
            // 💻 macOS: Side-by-side layout
            HStack(alignment: .top, spacing: 16) {
                // Original (English)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original (English)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(viewModel.storyTitle)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }

                // Translation (Editable)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation (\(language.name))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextField("Translated title", text: $editingTitle, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        .onChange(of: editingTitle) { _, newValue in
                            detectChanges(for: language)
                        }
                }
            }
            #else
            // 📱 iOS: Stacked layout
            VStack(alignment: .leading, spacing: 12) {
                // Original (English)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original (English)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(viewModel.storyTitle)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }

                // Translation (Editable)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation (\(language.name))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextField("Translated title", text: $editingTitle, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        .onChange(of: editingTitle) { _, newValue in
                            detectChanges(for: language)
                        }
                }
            }
            #endif

            // Character count
            HStack {
                Spacer()
                Text("\(editingTitle.count) characters")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - 📝 Content Editor Section

    /// 📝 Side-by-side content editor - the main attraction!
    private func contentEditorSection(for language: LanguageCode) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📖 Story Content")
                .font(.headline)

            #if os(macOS)
            // 💻 macOS: Side-by-side layout
            HStack(alignment: .top, spacing: 16) {
                // Original (English)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original (English)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ScrollView {
                        Text(viewModel.storyContent)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 300)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }

                // Translation (Editable)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation (\(language.name))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextEditor(text: $editingContent)
                        .frame(height: 300)
                        .padding(4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        .onChange(of: editingContent) { _, newValue in
                            detectChanges(for: language)
                        }
                }
            }
            #else
            // 📱 iOS: Stacked layout with scroll
            VStack(alignment: .leading, spacing: 12) {
                // Original (English)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original (English)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ScrollView {
                        Text(viewModel.storyContent)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 200)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }

                // Translation (Editable)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation (\(language.name))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextEditor(text: $editingContent)
                        .frame(height: 200)
                        .padding(4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        .onChange(of: editingContent) { _, newValue in
                            detectChanges(for: language)
                        }
                }
            }
            #endif

            // Character count
            HStack {
                Spacer()
                Text("\(editingContent.count) characters")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - 🎯 Action Buttons Section

    /// 🎯 Save and reset buttons for the current language
    private func actionButtonsSection(for language: LanguageCode) -> some View {
        HStack(spacing: 12) {
            // 🔄 Reset Button
            Button(role: .destructive) {
                resetToOriginal(for: language)
            } label: {
                Label("Reset to Original", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isCurrentLanguageModified(language))

            // 💾 Save Button
            Button {
                saveChanges(for: language)
            } label: {
                Label("Save Changes", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isCurrentLanguageModified(language))
        }
    }

    // MARK: - 🌟 Empty State View

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Select a language to review")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - 🎯 Helper Computed Properties

    /// 📊 Sorted list of languages that have translations
    private var sortedTranslatedLanguages: [LanguageCode] {
        viewModel.selectedLanguages
            .filter { viewModel.translations[$0] != nil }
            .sorted { $0.name < $1.name }
    }

    /// ✅ Has any language been edited?
    private var hasAnyEdits: Bool {
        !viewModel.editedTranslations.isEmpty
    }

    // MARK: - 🎯 Actions

    /// 🎯 Select a language for editing
    /// - Parameter language: The language to edit
    private func selectLanguage(_ language: LanguageCode) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedLanguage = language
            loadEditingState(for: language)
        }
    }

    /// 📥 Load the editing state for a language
    /// - Parameter language: The language to load
    private func loadEditingState(for: LanguageCode) {
        guard let language = selectedLanguage else { return }

        // 📝 Load content - use edited version if available, otherwise original translation
        let contentKey = "\(language.rawValue)-content"
        editingContent = viewModel.editedTranslations[contentKey] ?? viewModel.translations[language] ?? ""

        // 🎨 Load title - use edited version if available, otherwise original translated title
        let titleKey = "\(language.rawValue)-title"
        editingTitle = viewModel.editedTranslations[titleKey] ?? viewModel.translatedTitles[language] ?? viewModel.storyTitle

        // 🧹 Reset change detection
        hasChanges = false
    }

    /// 🔍 Detect if the current editing state differs from the original
    /// - Parameter language: The language being edited
    private func detectChanges(for language: LanguageCode) {
        let contentKey = "\(language.rawValue)-content"
        let titleKey = "\(language.rawValue)-title"

        let originalContent = viewModel.translations[language] ?? ""
        let originalTitle = viewModel.translatedTitles[language] ?? viewModel.storyTitle

        let hasContentChanged = editingContent != originalContent
        let hasTitleChanged = editingTitle != originalTitle

        hasChanges = hasContentChanged || hasTitleChanged
    }

    /// ✅ Check if a specific language has been edited
    /// - Parameter language: The language to check
    /// - Returns: True if edited
    private func isLanguageEdited(_ language: LanguageCode) -> Bool {
        let contentKey = "\(language.rawValue)-content"
        let titleKey = "\(language.rawValue)-title"
        return viewModel.editedTranslations[contentKey] != nil || viewModel.editedTranslations[titleKey] != nil
    }

    /// 🔍 Check if current editing state is modified
    /// - Parameter language: The language to check
    /// - Returns: True if modified
    private func isCurrentLanguageModified(_ language: LanguageCode) -> Bool {
        let originalContent = viewModel.translations[language] ?? ""
        let originalTitle = viewModel.translatedTitles[language] ?? viewModel.storyTitle

        return editingContent != originalContent || editingTitle != originalTitle
    }

    /// 💾 Save changes for a specific language
    /// - Parameter language: The language to save
    private func saveChanges(for language: LanguageCode) {
        // ⚠️ Validation: Don't save empty translations
        guard !editingContent.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("⚠️ Cannot save empty translation for \(language.name)")
            return
        }

        let contentKey = "\(language.rawValue)-content"
        let titleKey = "\(language.rawValue)-title"

        // 💾 Save content if changed
        if editingContent != viewModel.translations[language] {
            viewModel.editedTranslations[contentKey] = editingContent
            print("💾 ✨ Saved edited content for \(language.name)")
        }

        // 💾 Save title if changed
        if editingTitle != viewModel.translatedTitles[language] {
            viewModel.editedTranslations[titleKey] = editingTitle
            print("💾 ✨ Saved edited title for \(language.name)")
        }

        hasChanges = false
    }

    /// 💾 Save all changes across all languages
    private func saveAllChanges() {
        if let language = selectedLanguage, hasChanges {
            saveChanges(for: language)
        }
        print("🎉 ✨ ALL TRANSLATION EDITS SAVED!")
    }

    /// 🔄 Reset to the original translation
    /// - Parameter language: The language to reset
    private func resetToOriginal(for language: LanguageCode) {
        let contentKey = "\(language.rawValue)-content"
        let titleKey = "\(language.rawValue)-title"

        // 🧹 Remove edits
        viewModel.editedTranslations.removeValue(forKey: contentKey)
        viewModel.editedTranslations.removeValue(forKey: titleKey)

        // 📥 Reload original
        loadEditingState(for: language)

        print("🔄 ✨ Reset \(language.name) to original translation")
    }
}

// MARK: - 🏷️ Language Tab Button

/// 🎨 Individual language tab button for selecting which language to edit
struct LanguageTabButton: View {
    let language: LanguageCode
    let isSelected: Bool
    let isEdited: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 8) {
                Text(language.flag)
                    .font(.title3)

                Text(language.name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)

                // ✏️ Edited indicator badge
                if isEdited {
                    Image(systemName: "pencil.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 📊 Stat Pill Component

/// 📊 Small pill-shaped stat display
struct StatPill: View {
    let label: String
    let value: String
    let color: Color
    var icon: String? = nil

    var body: some View {
        VStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
            }

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.15))
        .cornerRadius(8)
    }
}

// MARK: - 🧪 Preview

#Preview {
    TranslationReviewSheet(viewModel: {
        let vm = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        vm.storyTitle = "The Starry Night"
        vm.storyContent = "A beautiful painting depicting a night sky filled with swirling clouds and bright stars..."
        vm.selectedLanguages = [ArtfulArchivesCore.LanguageCode.spanish, ArtfulArchivesCore.LanguageCode.hindi]
        vm.translations[.spanish] = "Una hermosa pintura que representa un cielo nocturno lleno de nubes arremolinadas y estrellas brillantes..."
        vm.translations[.hindi] = "घूमते बादलों और चमकीले सितारों से भरे रात के आकाश को दर्शाने वाली एक सुंदर पेंटिंग..."
        vm.translatedTitles[.spanish] = "La Noche Estrellada"
        vm.translatedTitles[.hindi] = "तारों भरी रात"
        return vm
    }())
}
