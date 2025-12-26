//
//  UploadStepView.swift
//  CMS-Manager
//
//  📸 The Upload Step - Where Your Art Begins Its Journey
//
//  "Ah, the sacred moment of creation! Bring forth your image from the
//   gallery of your device, validate it through mystical checks,
//   and let the upload commence with grace and resilience!"
//
//  - The Spellbinding Museum Director of Upload Ceremonies
//

import SwiftUI
import PhotosUI

/// 📸 Upload Step View - Step 1 of the Story Wizard (Production-Ready Edition)
///
/// Features:
/// - PhotosPicker for iOS image selection
/// - Image validation (size, format, dimensions)
/// - Reusable ImagePreviewCard component
/// - Enhanced UploadProgressView with animations
/// - ErrorRetryView for graceful error handling
/// - Retry mechanism for failed uploads
/// - Accessibility support throughout
public struct UploadStepView: View {

    // MARK: - 🎭 Dependencies

    /// 🧠 The view model that holds our story's fate
    @Bindable var viewModel: StoryWizardViewModel

    // MARK: - 📊 State

    /// 🎨 Local state for the selected picker item
    @State private var selectedItem: PhotosPickerItem?

    /// 🎯 Is the upload in progress?
    @State private var isUploading = false

    /// 📊 Image validation result
    @State private var validationResult: ImageValidationResult?

    /// 📦 Temporary image data for upload
    @State private var imageData: Data?

    /// 📁 Temporary file URL for upload
    @State private var temporaryFileURL: URL?

    /// 🌩️ Upload error (separate from validation errors)
    @State private var uploadError: APIError?

    /// 🔄 Is retry in progress?
    @State private var isRetrying = false

    // MARK: - ✨ Animation State

    /// 🎪 Show validation success animation
    @State private var showSuccessAnimation = false

    /// 🌊 Pulsing animation for drop zone
    @State private var isDropZonePulsing = false

    /// ✨ Scale for image preview entrance
    @State private var imagePreviewScale: CGFloat = 0.8

    // MARK: - 🎨 Body

    public var body: some View {
        VStack(spacing: 32) {
            // 📜 Header Section
            headerSection

            ScrollView {
                VStack(spacing: 24) {
                    // 🖼️ Image Selection Zone
                    imageSelectionZone

                    // ✅ Validation Success / Error Display
                    if let result = validationResult {
                        validationResultSection(result)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity),
                                removal: .scale(scale: 0.8).combined(with: .opacity)
                            ))
                    }

                    // 🌩️ Upload Error Display
                    if let error = uploadError {
                        ErrorRetryView(
                            error: error,
                            isRetrying: isRetrying,
                            onRetry: {
                                await retryUpload()
                            },
                            onDismiss: {
                                withAnimation(AnimationConstants.smoothSpring) {
                                    uploadError = nil
                                }
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        ))
                    }

                    // 📊 Upload Progress
                    if isUploading && uploadError == nil {
                        UploadProgressView(
                            progress: viewModel.uploadProgress,
                            style: .linear,
                            onCancel: {
                                cancelUpload()
                            }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // 📤 Upload Button
                    if viewModel.selectedImage != nil && uploadError == nil && !isUploading {
                        uploadButton
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 20)
                .animation(AnimationConstants.smoothSpring, value: uploadError != nil)
                .animation(AnimationConstants.smoothSpring, value: isUploading)
                .animation(AnimationConstants.smoothSpring, value: validationResult?.isValid)
            }
        }
        .onAppear {
            startDropZonePulse()
        }
        .onChange(of: selectedItem) { _, newItem in
            // 🎯 When the user picks an image, load and validate it!
            Task {
                await loadAndValidateImage(from: newItem)
            }
        }
    }

    // MARK: - 📜 Header Section

    /// 🎭 The grand title of this step
    private var headerSection: some View {
        VStack(spacing: 12) {
            // 🎨 Icon
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.bounce, value: viewModel.selectedImage != nil)

            // 📝 Title
            Text("Upload Your Artwork")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            // 📖 Description
            Text("Choose an image from your photo library to begin the story creation process")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.top, 20)
    }

    // MARK: - 🖼️ Image Selection Zone

    /// 🎯 The drop zone / picker area
    private var imageSelectionZone: some View {
        VStack(spacing: 16) {
            if let image = viewModel.selectedImage {
                // 🖼️ Image Preview Card with hero animation entrance! ✨
                ImagePreviewCard(
                    image: image,
                    fileSize: validationResult?.fileSize,
                    fileFormat: validationResult?.fileFormat,
                    errorMessage: validationResult?.error?.errorDescription,
                    onChangeImage: {
                        withAnimation(AnimationConstants.smoothSpring) {
                            resetSelection()
                        }
                    }
                )
                .scaleEffect(imagePreviewScale)
                .onAppear {
                    withAnimation(AnimationConstants.bouncySpring) {
                        imagePreviewScale = 1.0
                    }
                }
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
                .sparkleEffect(isActive: showSuccessAnimation)
            } else {
                // 📭 Empty State with breathing animation
                emptyDropZone
            }
        }
    }

    /// 📭 The empty state prompting user to select
    private var emptyDropZone: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            VStack(spacing: 20) {
                // 🎨 Drop Zone
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 3, dash: [12, 8])
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 300)
                    .scaleEffect(isDropZonePulsing ? 1.02 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isDropZonePulsing
                    )
                    .overlay {
                        VStack(spacing: 16) {
                            // 📷 Icon with breathing animation
                            Image(systemName: "photo.stack")
                                .font(.system(size: 56))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .symbolRenderingMode(.hierarchical)
                                .symbolEffect(.bounce, value: isDropZonePulsing)

                            // 📝 Instructions
                            VStack(spacing: 8) {
                                Text("Tap to Browse Photos")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.primary)

                                Text("Select an image to get started")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }

                            // 📋 Supported Formats & Limits
                            VStack(spacing: 6) {
                                HStack(spacing: 8) {
                                    Label("JPG", systemImage: "doc.fill")
                                    Label("PNG", systemImage: "doc.fill")
                                    Label("HEIC", systemImage: "doc.fill")
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(.tertiary)

                                Text("Max 10 MB • Min 200×200px")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.quaternary)
                            }
                            .padding(.top, 8)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Select image from photo library")
        .accessibilityHint("Double tap to open photo picker")
    }

    // MARK: - ✅ Validation Result Section

    /// 🎯 Display validation result (success or specific errors)
    private func validationResultSection(_ result: ImageValidationResult) -> some View {
        Group {
            if result.isValid {
                // ✅ Validation Success Message with shimmer effect! 💎
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: result.isValid)
                        .symbolEffect(.pulse.byLayer, options: .repeating)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Image Ready to Upload")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)

                        if let dimensions = result.dimensions {
                            Text("\(Int(dimensions.width))×\(Int(dimensions.height)) pixels")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.green.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.green.opacity(0.3), lineWidth: 2)
                )
                .onAppear {
                    // ✨ Trigger success shimmer briefly
                    showSuccessAnimation = true
                    Task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        await MainActor.run {
                            showSuccessAnimation = false
                        }
                    }
                }
            }
        }
    }

    // MARK: - 📤 Upload Button

    /// 🚀 The mystical upload button with pulsing glow effect! ✨
    private var uploadButton: some View {
        Button {
            Task {
                await performUpload()
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 20))

                Text("Upload Image")
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
        .buttonStyle(.plain)
        .disabled(validationResult?.isValid != true)
        .opacity(validationResult?.isValid == true ? 1.0 : 0.5)
        .accessibilityLabel("Upload image to server")
        .accessibilityHint("Double tap to begin upload")
    }

    // MARK: - 🎯 Actions

    /// 🎨 Load and validate the selected image from the picker
    private func loadAndValidateImage(from item: PhotosPickerItem?) async {
        print("🎨 ✨ IMAGE LOADING AWAKENS!")

        guard let item else {
            resetSelection()
            return
        }

        do {
            // 📥 Load the image data
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("   🌩️ Failed to load image data")
                validationResult = ImageValidationResult(
                    isValid: false,
                    fileSize: nil,
                    fileFormat: nil,
                    error: .invalidImage,
                    dimensions: nil
                )
                return
            }

            print("   📦 Image data loaded: \(data.count) bytes")
            imageData = data

            // 🔍 Validate the image
            let result = ImageValidator.validate(imageData: data)
            validationResult = result

            if result.isValid {
                // ✅ Valid image - set it in the view model
                #if os(iOS)
                if let uiImage = UIImage(data: data) {
                    viewModel.selectedImage = uiImage
                    print("   ✅ ✨ IMAGE VALIDATION MASTERPIECE COMPLETE!")
                }
                #elseif os(macOS)
                if let nsImage = NSImage(data: data) {
                    viewModel.selectedImage = nsImage
                    print("   ✅ ✨ IMAGE VALIDATION MASTERPIECE COMPLETE!")
                }
                #endif

                // 💾 Save to temporary file for upload
                try await saveToTemporaryFile(data: data, format: result.fileFormat ?? "jpg")

            } else {
                // ❌ Invalid image - show error
                print("   🌩️ Validation failed: \(result.error?.errorDescription ?? "Unknown error")")
                viewModel.selectedImage = nil
            }

        } catch {
            print("   💥 😭 IMAGE LOADING TEMPORARILY HALTED! \(error.localizedDescription)")
            validationResult = ImageValidationResult(
                isValid: false,
                fileSize: nil,
                fileFormat: nil,
                error: .invalidImage,
                dimensions: nil
            )
        }
    }

    /// 💾 Save image data to a temporary file for upload
    private func saveToTemporaryFile(data: Data, format: String) async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "upload_\(UUID().uuidString).\(format)"
        let fileURL = tempDir.appendingPathComponent(fileName)

        try data.write(to: fileURL)
        temporaryFileURL = fileURL

        print("   💾 Saved to temporary file: \(fileURL.lastPathComponent)")
    }

    /// 🚀 Perform the actual upload to the server
    private func performUpload() async {
        print("🚀 ✨ UPLOAD RITUAL COMMENCES!")

        guard let fileURL = temporaryFileURL else {
            uploadError = .uploadFailed("No file available to upload")
            return
        }

        isUploading = true
        uploadError = nil
        viewModel.uploadProgress = 0

        do {
            // 🎯 Call the real upload method from view model
            await viewModel.uploadImage(fileURL: fileURL)

            print("🎉 ✨ UPLOAD MASTERPIECE COMPLETE!")

            // 🧹 Clean up temporary file
            cleanupTemporaryFile()

        } catch {
            print("🌩️ Upload failed: \(error.localizedDescription)")
            uploadError = error as? APIError ?? .unknown(error)
        }

        isUploading = false
    }

    /// 🔄 Retry a failed upload
    private func retryUpload() async {
        print("🔄 ✨ RETRY RITUAL AWAKENS!")

        isRetrying = true
        uploadError = nil

        await performUpload()

        isRetrying = false
    }

    /// ❌ Cancel the current upload
    private func cancelUpload() {
        print("❌ Upload cancelled by user")
        isUploading = false
        viewModel.uploadProgress = 0
        cleanupTemporaryFile()
    }

    /// 🔄 Reset image selection
    private func resetSelection() {
        print("🔄 Resetting selection...")
        selectedItem = nil
        viewModel.selectedImage = nil
        validationResult = nil
        imageData = nil
        uploadError = nil
        cleanupTemporaryFile()
    }

    /// 🧹 Clean up the temporary file
    private func cleanupTemporaryFile() {
        guard let fileURL = temporaryFileURL else { return }

        do {
            try FileManager.default.removeItem(at: fileURL)
            print("   🧹 Temporary file cleaned up")
            temporaryFileURL = nil
        } catch {
            print("   🌩️ Failed to clean up temporary file: \(error.localizedDescription)")
        }
    }

    /// 🌊 Start the drop zone pulsing animation
    private func startDropZonePulse() {
        isDropZonePulsing = true
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Initialize with a view model
    init(viewModel: StoryWizardViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - 🧪 Preview

#Preview("Empty State") {
    UploadStepView(viewModel: StoryWizardViewModel(
        apiClient: MockAPIClient(),
        toastManager: ToastManager(),
        audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
    ))
}

#Preview("With Valid Image") {
    @MainActor func makeViewModel() -> StoryWizardViewModel {
        let viewModel = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        #if os(iOS)
        viewModel.selectedImage = UIImage(systemName: "photo")
        #else
        viewModel.selectedImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)
        #endif
        return viewModel
    }
    return UploadStepView(viewModel: makeViewModel())
}

#Preview("Uploading") {
    @MainActor func makeViewModel() -> StoryWizardViewModel {
        let viewModel = StoryWizardViewModel(
            apiClient: MockAPIClient(),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
        hapticManager: HapticManager()
        )
        viewModel.uploadProgress = 0.6
        #if os(iOS)
        viewModel.selectedImage = UIImage(systemName: "photo")
        #else
        viewModel.selectedImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)
        #endif
        return viewModel
    }
    return UploadStepView(viewModel: makeViewModel())
}
