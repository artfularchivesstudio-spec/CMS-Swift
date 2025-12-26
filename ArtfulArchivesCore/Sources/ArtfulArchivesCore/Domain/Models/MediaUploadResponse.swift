/**
 * 🎨 The Media Upload Response - The Aftermath of Digital Creation
 *
 * "When images transcend the physical realm and enter the digital cosmos,
 * this response bears the coordinates of their new existence."
 *
 * - The Spellbinding Museum Director of Digital Assets
 */

import Foundation

// 🎨 The Media Upload Response - What we get after uploading media
public struct MediaUploadResponse: Codable, Equatable, Identifiable, Sendable {

    // MARK: - 🌟 Core Identity

    /// 🎭 The unique identifier in Strapi's Media Library
    public let id: Int

    // MARK: - 📝 Media Information

    /// ✨ The URL where the media can be accessed
    public let url: String

    /// 📜 The filename
    public let name: String

    /// 🎭 The MIME type (e.g., "image/jpeg", "image/png")
    public let mime: String

    /// 📏 The file size in bytes
    public let size: Int

    /// 🖼️ Additional metadata (optional)
    public let width: Int?
    public let height: Int?
    public let alternativeText: String?
    public let caption: String?

    // MARK: - 🎨 Computed Properties

    /// 🌐 Convert string URL to URL type
    public var mediaURL: URL? {
        URL(string: url)
    }

    /// 📊 File size in human-readable format
    public var fileSizeFormatted: String {
        ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }

    /// 🎭 Display name with fallback
    public var displayName: String {
        alternativeText ?? name
    }

    /// 🖼️ Whether this is an image
    public var isImage: Bool {
        mime.hasPrefix("image/")
    }

    /// 🎵 Whether this is audio
    public var isAudio: Bool {
        mime.hasPrefix("audio/")
    }

    /// 🎬 Whether this is video
    public var isVideo: Bool {
        mime.hasPrefix("video/")
    }

    // MARK: - 🌙 Initialization

    public init(
        id: Int,
        url: String,
        name: String,
        mime: String,
        size: Int,
        width: Int? = nil,
        height: Int? = nil,
        alternativeText: String? = nil,
        caption: String? = nil
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.mime = mime
        self.size = size
        self.width = width
        self.height = height
        self.alternativeText = alternativeText
        self.caption = caption
    }

    // MARK: - 🎭 Codable Support

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case mime
        case size
        case width
        case height
        case alternativeText = "alternativeText"
        case caption
    }
}

// MARK: - 📤 Media Upload Request

/// 📤 Request wrapper for uploading media
public struct MediaUploadRequest: Sendable {

    /// 📁 The file data to upload
    public let fileData: Data

    /// 📜 The filename
    public let fileName: String

    /// 🎭 The MIME type
    public let mimeType: String

    /// 📝 Optional alt text for accessibility
    public let altText: String?

    /// 💬 Optional caption
    public let caption: String?

    public init(
        fileData: Data,
        fileName: String,
        mimeType: String,
        altText: String? = nil,
        caption: String? = nil
    ) {
        self.fileData = fileData
        self.fileName = fileName
        self.mimeType = mimeType
        self.altText = altText
        self.caption = caption
    }

    /// 🎨 Detect MIME type from file extension
    public static func mimeType(for fileExtension: String) -> String {
        let ext = fileExtension.lowercased()

        switch ext {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "webp":
            return "image/webp"
        case "svg":
            return "image/svg+xml"
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "m4a":
            return "audio/mp4"
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        default:
            return "application/octet-stream"
        }
    }

    /// 🎨 Create from file URL
    public static func from(fileURL: URL, altText: String? = nil, caption: String? = nil) throws -> Self {
        let data = try Data(contentsOf: fileURL)
        let fileName = fileURL.lastPathComponent
        let fileExtension = fileURL.pathExtension
        let mimeType = self.mimeType(for: fileExtension)

        return Self(
            fileData: data,
            fileName: fileName,
            mimeType: mimeType,
            altText: altText,
            caption: caption
        )
    }
}

// MARK: - 📊 Batch Upload Response

/// 📊 Response for multiple media uploads
public struct BatchMediaUploadResponse: Codable, Equatable, Sendable {
    public let uploads: [MediaUploadResponse]
    public let successCount: Int
    public let failureCount: Int
    public let errors: [UploadError]?

    public init(uploads: [MediaUploadResponse], errors: [UploadError]? = nil) {
        self.uploads = uploads
        self.successCount = uploads.count
        self.failureCount = errors?.count ?? 0
        self.errors = errors
    }

    /// 🎭 Whether all uploads succeeded
    public var isCompleteSuccess: Bool {
        failureCount == 0
    }
}

/// 🌩️ Individual upload error
public struct UploadError: Codable, Equatable, Error, Sendable {
    public let fileName: String
    public let message: String
    public let code: String?

    public init(fileName: String, message: String, code: String? = nil) {
        self.fileName = fileName
        self.message = message
        self.code = code
    }

    public var localizedDescription: String {
        "\(fileName): \(message)"
    }
}
