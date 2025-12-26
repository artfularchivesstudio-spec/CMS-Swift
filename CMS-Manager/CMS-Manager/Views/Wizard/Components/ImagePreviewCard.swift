//
//  ImagePreviewCard.swift
//  CMS-Manager
//
//  🖼️ The Image Preview Card - Where Visual Treasures Are Displayed
//
//  "Behold your chosen artwork in all its glory! This mystical card reveals
//   your image with elegant borders and delightful interactions, making the
//   preview experience as enchanting as the art itself."
//
//  - The Spellbinding Museum Director of Visual Previews
//

import SwiftUI

/// 🖼️ Image Preview Card - A reusable component for displaying selected images
///
/// Features:
/// - Platform-agnostic image display (iOS/macOS)
/// - Elegant shadow and border styling
/// - File size and format information
/// - Error state visualization
/// - Accessibility support
public struct ImagePreviewCard: View {

    // MARK: - 🎯 Properties

    /// 🖼️ The image to display
    let image: PlatformImage

    /// 📏 File size in bytes (optional)
    let fileSize: Int?

    /// 📄 File format/extension (optional)
    let fileFormat: String?

    /// 🌩️ Error message to display (if any)
    let errorMessage: String?

    /// 🔄 Action when change button is tapped
    let onChangeImage: () -> Void

    // MARK: - 🎨 State

    /// ✨ Hover state for macOS interactions
    @State private var isHovered = false

    // MARK: - 🎨 Body

    public var body: some View {
        VStack(spacing: 16) {
            // 🖼️ Image Display Zone
            imageDisplay

            // 📊 File Information
            if fileSize != nil || fileFormat != nil {
                fileInfoSection
            }

            // 🌩️ Error Display
            if let errorMessage {
                errorSection(errorMessage)
            }

            // 🔄 Change Image Button
            changeImageButton
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(
                    color: errorMessage != nil ? .red.opacity(0.2) : .black.opacity(0.1),
                    radius: errorMessage != nil ? 15 : 20,
                    y: 10
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    errorMessage != nil ?
                        LinearGradient(
                            colors: [.red.opacity(0.5), .orange.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: errorMessage != nil ? 2 : 0
                )
        )
    }

    // MARK: - 🖼️ Image Display

    /// 🎨 The image preview section with platform-specific rendering
    private var imageDisplay: some View {
        GeometryReader { geometry in
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
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
        }
        .frame(height: 300)
        .accessibilityLabel("Selected artwork preview")
        .accessibilityHint("The image you selected for upload")
    }

    // MARK: - 📊 File Information Section

    /// 📝 Display file metadata (size, format)
    private var fileInfoSection: some View {
        HStack(spacing: 16) {
            // 📏 File Size
            if let fileSize {
                Label {
                    Text(formatFileSize(fileSize))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 12))
                        .foregroundStyle(.blue)
                }
            }

            // 📄 File Format
            if let fileFormat {
                Label {
                    Text(fileFormat.uppercased())
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.purple)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - 🌩️ Error Section

    /// 💥 Display error message with icon and styling
    private func errorSection(_ message: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundStyle(.red)

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.red)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.red.opacity(0.1))
        )
        .accessibilityLabel("Error: \(message)")
    }

    // MARK: - 🔄 Change Image Button

    /// 🎯 Button to select a different image
    private var changeImageButton: some View {
        Button {
            onChangeImage()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14, weight: .medium))

                Text("Choose Different Image")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(.blue.opacity(isHovered ? 0.15 : 0.1))
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        #if os(macOS)
        .onHover { hovering in
            isHovered = hovering
        }
        #endif
        .accessibilityLabel("Choose different image")
        .accessibilityHint("Opens photo picker to select a new image")
    }

    // MARK: - 🔧 Helper Methods

    /// 📏 Format file size in human-readable format
    /// - Parameter bytes: File size in bytes
    /// - Returns: Formatted string (e.g., "2.5 MB")
    private func formatFileSize(_ bytes: Int) -> String {
        let kb = Double(bytes) / 1024
        let mb = kb / 1024

        if mb >= 1 {
            return String(format: "%.2f MB", mb)
        } else if kb >= 1 {
            return String(format: "%.1f KB", kb)
        } else {
            return "\(bytes) bytes"
        }
    }

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new image preview card
    /// - Parameters:
    ///   - image: The image to display
    ///   - fileSize: Optional file size in bytes
    ///   - fileFormat: Optional file format/extension
    ///   - errorMessage: Optional error message to display
    ///   - onChangeImage: Action when change button is tapped
    init(
        image: PlatformImage,
        fileSize: Int? = nil,
        fileFormat: String? = nil,
        errorMessage: String? = nil,
        onChangeImage: @escaping () -> Void
    ) {
        self.image = image
        self.fileSize = fileSize
        self.fileFormat = fileFormat
        self.errorMessage = errorMessage
        self.onChangeImage = onChangeImage
    }
}

// MARK: - 🧪 Previews

#Preview("Image Preview - No Error") {
    #if os(iOS)
    let sampleImage = UIImage(systemName: "photo")!
    #else
    let sampleImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
    #endif

    return ImagePreviewCard(
        image: sampleImage,
        fileSize: 2_500_000,  // 2.5 MB
        fileFormat: "jpg",
        errorMessage: nil,
        onChangeImage: {
            print("🔄 Change image tapped")
        }
    )
    .padding()
}

#Preview("Image Preview - With Error") {
    #if os(iOS)
    let sampleImage = UIImage(systemName: "photo")!
    #else
    let sampleImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
    #endif

    return ImagePreviewCard(
        image: sampleImage,
        fileSize: 12_000_000,  // 12 MB - too large!
        fileFormat: "png",
        errorMessage: "File is too large. Maximum size is 10MB.",
        onChangeImage: {
            print("🔄 Change image tapped")
        }
    )
    .padding()
}
