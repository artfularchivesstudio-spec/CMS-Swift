//
//  CachedImage.swift
//  CMS-Manager
//
//  🖼️ The Cached Image - Crystallized Visual Treasures for Offline Glory
//
//  "When the network slumbers and connectivity fades into the mist,
//   these preserved images spring forth like phoenixes from local storage,
//   each pixel a testament to our commitment to offline excellence."
//
//  - The Spellbinding Museum Director of Image Persistence
//

import Foundation
import SwiftData

// MARK: - 🖼️ Cached Image Model

/// 🖼️ Local metadata and file reference for cached images
/// Stores both the network URL and local file path for offline access
@Model
final class CachedImage {

    // MARK: - 🏺 Core Properties

    /// 🆔 Unique identifier for the image
    @Attribute(.unique) var id: UUID

    /// 🔗 Original network URL where this image lives in the cloud
    var networkURL: URL

    /// 📁 Local file path in the app's cache directory
    var localFilePath: String

    /// 🎭 The image type (main, gallery, thumbnail, etc.)
    var imageType: ImageType

    /// 📐 Width in pixels (for layout optimization)
    var width: Int?

    /// 📐 Height in pixels (for layout optimization)
    var height: Int?

    /// 📝 Alternative text for accessibility
    var alternativeText: String?

    /// 📝 Caption for the image
    var caption: String?

    /// 📦 Content type (e.g., "image/jpeg", "image/png")
    var contentType: String?

    /// 📊 File size in bytes
    var fileSize: Int64?

    // MARK: - 🔗 Relationships

    /// 🔗 The story ID this image belongs to
    var storyId: Int

    // MARK: - 📅 Timestamps

    /// 💾 When this image was cached locally
    var cachedAt: Date

    /// ✅ When this image was last verified (used for cache validation)
    var lastVerifiedAt: Date?

    // MARK: - 🎭 Initialization

    /// 🌟 Create a cached image entry
    init(
        networkURL: URL,
        localFilePath: String,
        storyId: Int,
        imageType: ImageType,
        width: Int? = nil,
        height: Int? = nil,
        alternativeText: String? = nil,
        caption: String? = nil,
        contentType: String? = nil,
        fileSize: Int64? = nil
    ) {
        self.id = UUID()
        self.networkURL = networkURL
        self.localFilePath = localFilePath
        self.storyId = storyId
        self.imageType = imageType
        self.width = width
        self.height = height
        self.alternativeText = alternativeText
        self.caption = caption
        self.contentType = contentType
        self.fileSize = fileSize
        self.cachedAt = Date()
        self.lastVerifiedAt = nil
    }

    // MARK: - 🌟 Computed Properties

    /// 📁 Get the full local URL for the cached file
    var localFileURL: URL? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheDirectory.appendingPathComponent(localFilePath)
    }

    /// ✅ Is the local file still present on disk?
    var isFilePresent: Bool {
        guard let fileURL = localFileURL else { return false }
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    /// ⏰ How long ago was this cached?
    var cacheAge: TimeInterval {
        Date().timeIntervalSince(cachedAt)
    }

    /// 📊 Is this cache fresh? (less than 7 days old)
    var isCacheFresh: Bool {
        cacheAge < (7 * 24 * 60 * 60) // 7 days in seconds
    }
}

// MARK: - 🎭 Image Type Enum

/// 🎭 The role this image plays in the story's visual narrative
enum ImageType: String, Codable {
    /// 🖼️ The main cover image
    case main = "main"

    /// 🎨 An image in the story's gallery
    case gallery = "gallery"

    /// 📐 A thumbnail/preview version
    case thumbnail = "thumbnail"

    /// 🎯 Other/custom image type
    case other = "other"
}

// MARK: - 🧙‍♂️ Extensions

extension CachedImage {
    /// 🎨 Quick description for debugging
    var debugDescription: String {
        """
        🖼️ CachedImage {
            id: \(id)
            type: \(imageType.rawValue)
            storyId: \(storyId)
            filePresent: \(isFilePresent ? "✅" : "❌")
            cached: \(cachedAt.formatted())
            age: \(Int(cacheAge / 3600))h
            fresh: \(isCacheFresh ? "✨" : "🌙")
        }
        """
    }
}
