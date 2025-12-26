//
//  ReviewStepView.swift
//  CMS-Manager
//
//  ✏️ The Review Step - Where Stories Are Refined to Perfection
//
//  "Ah, the editing table! Here you shall sculpt the raw AI output into
//   a masterpiece of storytelling. Polish your title, enhance your prose,
//   and tag your creation for the world to discover."
//
//  - The Spellbinding Museum Director of Editorial Excellence
//

import SwiftUI

/// ✏️ Review Step View - Step 3 of the Story Wizard
///
/// Features:
/// - Title editor with character count
/// - Markdown content preview
/// - Tag chips editor
/// - Image sidebar
/// - "Continue to Translate" button
/// - Accessibility support
public struct ReviewStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The view model holding our story's state
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 State

    /// 📝 Focus state for title field
    @FocusState private var isTitleFocused: Bool

    /// 📝 Focus state for content field
    @FocusState private var isContentFocused: Bool

    /// 🏷️ Focus state for tag input
    @FocusState private var isTagFocused: Bool

    /// 📊 Preferred column size for the image sidebar
    @State private var sidebarWidth: CGFloat = 200

    // MARK: - 🎨 Body

    public var body: some View {
        VStack(spacing: 0) {
            // 📜 Header Section
            headerSection
                .padding(.bottom, 20)

            // 📊 Main Content Area
            if UIDevice.current.userInterfaceIdiom == .pad {
                // 💻 iPad: Split view with image sidebar
                iPadLayout
            } else {
                // 📱 iPhone: Stacked layout
                iPhoneLayout
            }

            Spacer()

            // 🚀 Continue Button
            continueButtonSection
        }
        .onAppear {
            // 🎯 Auto-populate from analysis if empty
            if viewModel.storyTitle.isEmpty {
                viewModel.populateFromAnalysis()
            }
        }
    }

    // MARK: - 📜 Header Section

    /// 🎭 The title and description
    private var headerSection: some View {
        VStack(spacing: 12) {
            // 🎨 Icon
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 40))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // 📝 Title
            Text("Review & Refine")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            // 📖 Description
            Text("Edit the AI-generated content or add your own creative touch")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - 📱 iPhone Layout

    /// 📱 Stacked layout for smaller screens
    private var iPhoneLayout: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🖼️ Image Preview
                if let image = viewModel.selectedImage {
                    imagePreviewCard(image)
                        .padding(.horizontal, 20)
                }

                // ✏️ Title Editor
                titleEditorSection
                    .padding(.horizontal, 20)

                // 📖 Content Editor
                contentEditorSection
                    .padding(.horizontal, 20)

                // 🏷️ Tags Editor
                tagsEditorSection
                    .padding(.horizontal, 20)

                // 🔗 Slug Preview
                slugPreviewSection
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - 💻 iPad Layout

    /// 💻 Split layout for larger screens
    private var iPadLayout: some View {
        HStack(spacing: 20) {
            // 📝 Main Editor
            ScrollView {
                VStack(spacing: 20) {
                    titleEditorSection
                    contentEditorSection
                    tagsEditorSection
                    slugPreviewSection
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity)

            // 🖼️ Image Sidebar
            if let image = viewModel.selectedImage {
                imageSidebar(image)
                    .frame(width: sidebarWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.trailing, 20)
            }
        }
    }

    // MARK: - 🖼️ Image Preview Card

    /// 🎨 A card displaying the uploaded image
    private func imagePreviewCard(_ image: PlatformImage) -> some View {
        VStack(spacing: 12) {
            // 🖼️ The Image
            Group {
                #if os(iOS)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                #elseif os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                #endif
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

            // 📝 Image Info
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Image uploaded successfully")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }

    /// 🖼️ Sidebar image preview for iPad
    private func imageSidebar(_ image: PlatformImage) -> some View {
        VStack(spacing: 16) {
            Text("Image")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                #if os(iOS)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                #elseif os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                #endif
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 10)

            Spacer()
        }
        .padding(16)
    }

    // MARK: - ✏️ Title Editor Section

    /// 📝 The title input with character counter
    private var titleEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📋 Label
            Label("Story Title", systemImage: "textformat")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            // ✏️ Text Field
            TextField("Enter a captivating title", text: $viewModel.storyTitle)
                .focused($isTitleFocused)
                .font(.system(size: 16))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.isTitleTooLong ? .red : .clear, lineWidth: 2)
                )
                .onChange(of: viewModel.storyTitle) { _, _ in
                    // 🔗 Auto-generate slug as user types
                    viewModel.generateSlug()
                }

            // 📊 Character Count
            HStack {
                Spacer()

                Text("\(viewModel.titleCharacterCount)/100")
                    .font(.system(size: 13))
                    .foregroundStyle(viewModel.isTitleTooLong ? .red : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(viewModel.isTitleTooLong ? Color.red.opacity(0.1) : Color.secondary.opacity(0.2))
                    )
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - 📖 Content Editor Section

    /// 📜 The markdown content editor
    private var contentEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📋 Label
            Label("Story Content", systemImage: "doc.text")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            // 🎨 Markdown Toolbar
            markdownToolbar

            // ✏️ Text Editor
            TextEditor(text: $viewModel.storyContent)
                .focused($isContentFocused)
                .font(.system(size: 15))
                .scrollContentBackground(.hidden)
                .padding(16)
                .frame(minHeight: 180)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.2))
                )
                .overlay(
                    // Placeholder when empty
                    Group {
                        if viewModel.storyContent.isEmpty {
                            VStack {
                                Text("Write your story here using Markdown...")
                                    .foregroundStyle(.tertiary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                    .padding(.top, 16)
                                Spacer()
                            }
                        }
                    }
                )

            // 📝 Markdown Hint
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                Text("Markdown supported: **bold**, *italic*, # headings, etc.")
                    .font(.system(size: 12))
                Spacer()
            }
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - 🎨 Markdown Toolbar

    /// ✨ The Markdown Formatting Toolbar - Where Plain Text Becomes Art
    /// A spellbinding row of formatting tools to enchant your prose! ✍️
    private var markdownToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // **Bold** button
                MarkdownToolButton(
                    icon: "bold",
                    title: "Bold",
                    syntax: "**text**"
                )

                // *Italic* button
                MarkdownToolButton(
                    icon: "italic",
                    title: "Italic",
                    syntax: "*text*"
                )

                // # Heading button
                MarkdownToolButton(
                    icon: "textformat.size",
                    title: "Heading",
                    syntax: "# Heading"
                )

                // [Link](url) button
                MarkdownToolButton(
                    icon: "link",
                    title: "Link",
                    syntax: "[text](url)"
                )

                // - List button
                MarkdownToolButton(
                    icon: "list.bullet",
                    title: "List",
                    syntax: "- item"
                )

                // > Quote button
                MarkdownToolButton(
                    icon: "text.quote",
                    title: "Quote",
                    syntax: "> quote"
                )
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - 🔗 Slug Preview Section

    /// 🔗 The Slug Preview - A Crystal Ball Showing Your Story's Future URL
    /// Watch the mystical transformation as your title morphs into a web-friendly slug! 🌐
    private var slugPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📋 Label
            Label("URL Slug", systemImage: "link")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            // 🔗 The Slug Preview
            HStack(spacing: 8) {
                Text("artful-archives.com/stories/")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)

                Text(viewModel.storySlug.isEmpty ? "your-story-title" : viewModel.storySlug)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(viewModel.storySlug.isEmpty ? .secondary : .blue)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.1))
            )
        }
        .padding(.vertical, 8)
    }

    // MARK: - 🏷️ Tags Editor Section

    /// 🏷️ The tag chips editor
    private var tagsEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 📋 Label
            Label("Tags", systemImage: "tag")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            // 🎯 Tag Input Row
            HStack(spacing: 12) {
                // ✏️ Tag Input
                TextField("Add a tag", text: $viewModel.pendingTag)
                    .focused($isTagFocused)
                    .font(.system(size: 15))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.secondary.opacity(0.2))
                    )
                    .onSubmit {
                        viewModel.addTag()
                    }

                // ➕ Add Button
                Button {
                    viewModel.addTag()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.pendingTag.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            // 🏷️ Tag Chips
            if !viewModel.storyTags.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(viewModel.storyTags, id: \.self) { tag in
                        TagChip(
                            tag: tag,
                            onDelete: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.removeTag(tag)
                                }
                            }
                        )
                    }
                }
            } else {
                // 📭 Empty State
                HStack(spacing: 8) {
                    Image(systemName: "tag")
                        .font(.system(size: 14))
                    Text("No tags yet. Add some to help categorize your story!")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - 🚀 Continue Button Section

    /// ➡️ The button to proceed to translation
    private var continueButtonSection: some View {
        VStack(spacing: 16) {
            // ⚠️ Validation Warning
            if !viewModel.canProceedToReview {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Please add a title and content to continue")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }

            // 🚀 Continue Button
            Button {
                viewModel.generateSlug()
                viewModel.nextStep()
            } label: {
                HStack(spacing: 12) {
                    Text("Continue to Translate")
                        .font(.system(size: 16, weight: .semibold))

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: viewModel.canProceedToReview ? [.orange, .pink] : [.gray, .gray],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canProceedToReview)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Initialize with a view model
    init(viewModel: StoryWizardViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - 🎨 Markdown Tool Button Component

/// ✨ The Markdown Tool Button - A Mystical Formatting Enchantment
/// Each button whispers the secrets of markdown syntax to eager creators! 📝
struct MarkdownToolButton: View {
    let icon: String
    let title: String
    let syntax: String

    var body: some View {
        Button {
            // 🎯 For Phase 1, show tooltip or visual feedback
            // In Phase 2, this could insert the syntax directly
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)

                Text(title)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 64, height: 52)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.15))
            )
        }
        .buttonStyle(.plain)
        .help(syntax) // 💡 Tooltip shows the syntax on hover (macOS) or long-press (iOS)
    }
}

// MARK: - 🏷️ Tag Chip Component

/// 🏷️ A removable tag chip
struct TagChip: View {
    let tag: String
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(tag)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)

            Button {
                onDelete()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.secondary.opacity(0.3))
        )
    }
}

// MARK: - 🌊 Flow Layout

/// 🌊 A layout that arranges children in a flowing manner
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// MARK: - 🧪 Preview

#Preview("Review Step") {
    @MainActor func makeViewModel() -> StoryWizardViewModel {
        let viewModel = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        viewModel.storyTitle = "The Enchanted Forest"
        viewModel.storyContent = "**Once upon a time**, in a land far away..."
        viewModel.storyTags = ["fantasy", "adventure", "magic"]
        return viewModel
    }
    return ReviewStepView(viewModel: makeViewModel())
}

#Preview("Empty State") {
    ReviewStepView(viewModel: StoryWizardViewModel(
        apiClient: MockAPIClient(),
        toastManager: ToastManager(),
        audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
    ))
}
