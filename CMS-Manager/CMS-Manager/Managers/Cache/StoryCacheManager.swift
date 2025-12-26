//
//  StoryCacheManager.swift
//  CMS-Manager
//
//  💎 The Story Cache Manager - Master Curator of Offline Treasures
//
//  "When networks fail and connections waver, this mystical guardian
//   ensures stories live on in local storage. Like a librarian of the digital age,
//   it orchestrates the sacred dance between cloud and device,
//   preserving tales for those moments when the internet sleeps."
//
//  - The Spellbinding Museum Director of Offline Excellence
//

import Foundation
import SwiftData
import ArtfulArchivesCore
import UIKit

// MARK: - 💎 Story Cache Manager

/// 💎 Thread-safe manager for comprehensive story and image caching
/// Handles both story data and associated images for full offline support
actor StoryCacheManager {

    // MARK: - 🏺 Properties

    /// 📦 The SwiftData model container
    private let modelContainer: ModelContainer

    /// 📁 The cache directory for storing images
    private let cacheDirectory: URL

    /// 🧙‍♂️ URL session for downloading images
    private let urlSession: URLSession

    /// 📊 Maximum cache size in bytes (default: 500 MB)
    private let maxCacheSize: Int64 = 500 * 1024 * 1024

    // MARK: - 🎭 Initialization

    /// 🌟 Initialize the cache manager
    init(modelContainer: ModelContainer) {
        print("💎 ✨ STORY CACHE MANAGER AWAKENS!")

        self.modelContainer = modelContainer

        // 📁 Set up cache directory
        let fileManager = FileManager.default
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.cacheDirectory = cacheDir.appendingPathComponent("StoryImages", isDirectory: true)

        // 🏗️ Create cache directory if needed
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)

        // 🌐 Configure URL session for image downloads
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.urlSession = URLSession(configuration: config)

        print("📁 Cache directory: \(cacheDirectory.path)")
        print("🎉 Cache manager ready for mystical preservation!")
    }

    // MARK: - 📚 Story Caching

    /// 💾 Cache a story (without downloading images)
    /// Use this for quick caching when images aren't needed immediately
    func cacheStory(_ story: ArtfulArchivesCore.Story) async throws {
        print("🔮 ✨ STORY CACHING RITUAL COMMENCES for '\(story.title)'")

        let context = ModelContext(modelContainer)

        // 🔍 Check if story is already cached
        let descriptor = FetchDescriptor<CachedStory>(
            predicate: #Predicate { $0.id == story.id }
        )

        let existingStories = try context.fetch(descriptor)

        // 🗑️ Remove existing cache entry if present
        if let existing = existingStories.first {
            print("🌙 Updating existing cache entry...")
            context.delete(existing)
        }

        // 💎 Create new cached story
        let cachedStory = CachedStory(from: story)
        context.insert(cachedStory)

        // 💾 Save to persistent store
        try context.save()

        print("🎉 ✨ STORY CACHING MASTERPIECE COMPLETE! Story #\(story.id) preserved")
    }

    /// 🖼️ Cache a story WITH all its images downloaded
    /// This is the full offline experience - story data + all visual treasures
    func cacheStoryWithImages(_ story: ArtfulArchivesCore.Story) async throws {
        print("🌐 ✨ FULL STORY CACHING RITUAL AWAKENS! Story: '\(story.title)'")

        // 📚 First, cache the story data
        try await cacheStory(story)

        // 🖼️ Then download and cache all images
        try await downloadAndCacheImages(for: story)

        print("🎉 ✨ FULL STORY CACHING MASTERPIECE COMPLETE! Story and images secured")
    }

    /// 🔍 Get cached story by ID
    func getCachedStory(id: Int) async throws -> ArtfulArchivesCore.Story? {
        print("🔮 Searching cache vault for story #\(id)...")

        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedStory>(
            predicate: #Predicate { $0.id == id }
        )

        let results = try context.fetch(descriptor)

        guard let cachedStory = results.first else {
            print("🌙 No cached version found for story #\(id)")
            return nil
        }

        print("💎 Found cached story: '\(cachedStory.title)'")
        print("📅 Cache age: \(Int(cachedStory.cacheAge / 3600)) hours")

        return cachedStory.toStory()
    }

    /// 📚 Get all cached stories
    func getAllCachedStories() async throws -> [ArtfulArchivesCore.Story] {
        print("🔮 ✨ RETRIEVING ALL CACHED WISDOM...")

        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedStory>(
            sortBy: [SortDescriptor(\.cachedAt, order: .reverse)]
        )

        let cachedStories = try context.fetch(descriptor)

        print("💎 Found \(cachedStories.count) cached stories")

        let stories = cachedStories.compactMap { $0.toStory() }

        print("🎉 Successfully resurrected \(stories.count) stories from cache")
        return stories
    }

    /// 🗑️ Clear all cached stories and images
    func clearCache() async throws {
        print("🧹 ✨ CACHE PURIFICATION RITUAL AWAKENS!")

        let context = ModelContext(modelContainer)

        // 🗑️ Delete all cached stories
        let storyDescriptor = FetchDescriptor<CachedStory>()
        let allStories = try context.fetch(storyDescriptor)

        for story in allStories {
            context.delete(story)
        }

        // 🗑️ Delete all cached images metadata
        let imageDescriptor = FetchDescriptor<CachedImage>()
        let allImages = try context.fetch(imageDescriptor)

        for image in allImages {
            context.delete(image)
        }

        try context.save()

        // 🗑️ Delete all cached image files from disk
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.removeItem(at: cacheDirectory)
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }

        print("🎉 Cache vault cleansed! Removed \(allStories.count) stories and \(allImages.count) images")
    }

    /// ✅ Check if a story is cached
    func isStoryCached(id: Int) async throws -> Bool {
        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedStory>(
            predicate: #Predicate { $0.id == id }
        )

        let count = try context.fetchCount(descriptor)
        return count > 0
    }

    // MARK: - 🖼️ Image Caching

    /// 🖼️ Download and cache all images for a story
    /// This ensures full offline access with visual richness intact
    func downloadAndCacheImages(for story: ArtfulArchivesCore.Story) async throws {
        print("🖼️ ✨ IMAGE CACHING RITUAL COMMENCES! Story: '\(story.title)'")

        var downloadedCount = 0
        var failedCount = 0

        // 🖼️ Download main image
        if let mainImage = story.image {
            do {
                try await downloadAndCacheImage(
                    url: mainImage.url,
                    storyId: story.id,
                    imageType: .main,
                    metadata: (
                        width: mainImage.width,
                        height: mainImage.height,
                        alternativeText: mainImage.alternativeText,
                        caption: mainImage.caption
                    )
                )
                downloadedCount += 1
                print("✨ Main image cached successfully")
            } catch {
                print("🌩️ Failed to cache main image: \(error.localizedDescription)")
                failedCount += 1
            }
        }

        // 🖼️ Download gallery images
        if let galleryImages = story.images {
            for (index, image) in galleryImages.enumerated() {
                do {
                    try await downloadAndCacheImage(
                        url: image.url,
                        storyId: story.id,
                        imageType: .gallery,
                        metadata: (
                            width: image.width,
                            height: image.height,
                            alternativeText: image.alternativeText,
                            caption: image.caption
                        )
                    )
                    downloadedCount += 1
                    print("✨ Gallery image \(index + 1)/\(galleryImages.count) cached")
                } catch {
                    print("🌩️ Failed to cache gallery image \(index + 1): \(error.localizedDescription)")
                    failedCount += 1
                }
            }
        }

        print("🎉 ✨ IMAGE CACHING COMPLETE! Downloaded: \(downloadedCount), Failed: \(failedCount)")
    }

    /// 🖼️ Download and cache a single image
    private func downloadAndCacheImage(
        url: URL,
        storyId: Int,
        imageType: ImageType,
        metadata: (width: Int?, height: Int?, alternativeText: String?, caption: String?)
    ) async throws {
        // 📥 Download the image data
        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CacheError.downloadFailed(url: url)
        }

        // 📊 Get content type and size
        let contentType = httpResponse.mimeType
        let fileSize = Int64(data.count)

        // 📁 Generate unique filename
        let filename = generateImageFilename(for: url, storyId: storyId, type: imageType)
        let localFilePath = filename
        let fileURL = cacheDirectory.appendingPathComponent(filename)

        // 💾 Save image to disk
        try data.write(to: fileURL)

        // 💾 Save metadata to SwiftData
        let context = ModelContext(modelContainer)

        // 🔍 Check if this image is already cached
        let descriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.networkURL == url && $0.storyId == storyId }
        )

        let existingImages = try context.fetch(descriptor)

        // 🗑️ Remove existing entry if present
        for existing in existingImages {
            context.delete(existing)
        }

        // 💎 Create new cached image entry
        let cachedImage = CachedImage(
            networkURL: url,
            localFilePath: localFilePath,
            storyId: storyId,
            imageType: imageType,
            width: metadata.width,
            height: metadata.height,
            alternativeText: metadata.alternativeText,
            caption: metadata.caption,
            contentType: contentType,
            fileSize: fileSize
        )

        context.insert(cachedImage)
        try context.save()

        print("💎 Image cached: \(filename) (\(formatBytes(fileSize)))")
    }

    /// 🔍 Get cached image for a URL
    func getCachedImage(for url: URL, storyId: Int) async throws -> CachedImage? {
        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.networkURL == url && $0.storyId == storyId }
        )

        let results = try context.fetch(descriptor)
        return results.first
    }

    /// 🖼️ Get all cached images for a story
    func getCachedImages(for storyId: Int) async throws -> [CachedImage] {
        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.storyId == storyId },
            sortBy: [SortDescriptor(\.cachedAt, order: .forward)]
        )

        return try context.fetch(descriptor)
    }

    // MARK: - 📊 Cache Statistics

    /// 📊 Get comprehensive cache statistics
    func getCacheStats() async throws -> CacheStats {
        print("📊 Gathering cache statistics...")

        let context = ModelContext(modelContainer)

        // 📚 Story stats
        let storyDescriptor = FetchDescriptor<CachedStory>()
        let allStories = try context.fetch(storyDescriptor)

        let totalStories = allStories.count
        let freshStories = allStories.filter { $0.isCacheFresh }.count
        let staleStories = totalStories - freshStories

        // 🖼️ Image stats
        let imageDescriptor = FetchDescriptor<CachedImage>()
        let allImages = try context.fetch(imageDescriptor)

        let totalImages = allImages.count
        let totalImageSize = allImages.reduce(Int64(0)) { $0 + ($1.fileSize ?? 0) }

        // 📊 Calculate disk usage
        let diskUsage = calculateDiskUsage()

        let stats = CacheStats(
            totalCachedStories: totalStories,
            freshCachedStories: freshStories,
            staleCachedStories: staleStories,
            totalCachedImages: totalImages,
            totalImageSize: totalImageSize,
            diskUsage: diskUsage,
            oldestCacheDate: allStories.map { $0.cachedAt }.min(),
            newestCacheDate: allStories.map { $0.cachedAt }.max()
        )

        print("💎 Cache Stats: \(totalStories) stories, \(totalImages) images, \(formatBytes(diskUsage))")
        return stats
    }

    /// 📊 Calculate actual disk usage
    private func calculateDiskUsage() -> Int64 {
        let fileManager = FileManager.default

        guard let enumerator = fileManager.enumerator(
            at: cacheDirectory,
            includingPropertiesForKeys: [.fileSizeKey],
            options: [.skipsHiddenFiles]
        ) else {
            return 0
        }

        var totalSize: Int64 = 0

        for case let fileURL as URL in enumerator {
            if let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
               let fileSize = resourceValues.fileSize {
                totalSize += Int64(fileSize)
            }
        }

        return totalSize
    }

    // MARK: - 🧹 Cache Maintenance

    /// 🧹 Remove stale cache entries (older than specified days)
    func removeStaleCache(olderThanDays days: Int) async throws {
        print("🧹 Removing cache entries older than \(days) days...")

        let context = ModelContext(modelContainer)
        let cutoffDate = Date().addingTimeInterval(-TimeInterval(days * 24 * 60 * 60))

        // 🗑️ Remove stale stories
        let storyDescriptor = FetchDescriptor<CachedStory>(
            predicate: #Predicate { $0.cachedAt < cutoffDate }
        )

        let staleStories = try context.fetch(storyDescriptor)

        for story in staleStories {
            context.delete(story)
        }

        // 🗑️ Remove stale images
        let imageDescriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.cachedAt < cutoffDate }
        )

        let staleImages = try context.fetch(imageDescriptor)

        for image in staleImages {
            // Delete file from disk
            if let fileURL = image.localFileURL {
                try? FileManager.default.removeItem(at: fileURL)
            }
            context.delete(image)
        }

        try context.save()

        print("🎉 Removed \(staleStories.count) stale stories and \(staleImages.count) stale images")
    }

    /// 🧹 Enforce cache size limit
    func enforceCacheSizeLimit() async throws {
        let stats = try await getCacheStats()

        if stats.diskUsage > maxCacheSize {
            print("⚠️ Cache size (\(formatBytes(stats.diskUsage))) exceeds limit (\(formatBytes(maxCacheSize)))")
            print("🧹 Removing oldest entries...")

            // Remove oldest 25% of cache
            try await removeOldestCacheEntries(percentage: 0.25)
        }
    }

    /// 🗑️ Remove oldest cache entries by percentage
    private func removeOldestCacheEntries(percentage: Double) async throws {
        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CachedStory>(
            sortBy: [SortDescriptor(\.cachedAt, order: .forward)]
        )

        let allStories = try context.fetch(descriptor)
        let countToRemove = Int(Double(allStories.count) * percentage)
        let storiesToRemove = Array(allStories.prefix(countToRemove))

        for story in storiesToRemove {
            // Remove associated images
            let imageDescriptor = FetchDescriptor<CachedImage>(
                predicate: #Predicate { $0.storyId == story.id }
            )
            let images = try context.fetch(imageDescriptor)

            for image in images {
                if let fileURL = image.localFileURL {
                    try? FileManager.default.removeItem(at: fileURL)
                }
                context.delete(image)
            }

            context.delete(story)
        }

        try context.save()
        print("🎉 Removed \(storiesToRemove.count) oldest cache entries")
    }

    // MARK: - 🛠️ Utilities

    /// 📁 Generate a unique filename for an image
    private func generateImageFilename(for url: URL, storyId: Int, type: ImageType) -> String {
        let urlHash = String(url.absoluteString.hashValue)
        let fileExtension = url.pathExtension.isEmpty ? "jpg" : url.pathExtension
        return "story_\(storyId)_\(type.rawValue)_\(urlHash).\(fileExtension)"
    }

    /// 📊 Format bytes into human-readable string
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - 📊 Cache Statistics

/// 📊 Comprehensive statistics about the cache state
struct CacheStats {
    /// 📚 Total number of cached stories
    let totalCachedStories: Int

    /// ✨ Number of fresh stories (< 24 hours old)
    let freshCachedStories: Int

    /// 🌙 Number of stale stories (≥ 24 hours old)
    let staleCachedStories: Int

    /// 🖼️ Total number of cached images
    let totalCachedImages: Int

    /// 📊 Total size of cached images in bytes
    let totalImageSize: Int64

    /// 💾 Total disk usage in bytes
    let diskUsage: Int64

    /// 📅 Date of oldest cached story
    let oldestCacheDate: Date?

    /// 📅 Date of newest cached story
    let newestCacheDate: Date?

    /// 🎨 Human-readable description
    var formattedDescription: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file

        return """
        📊 Cache Statistics

        Stories:
          • Total: \(totalCachedStories)
          • Fresh: \(freshCachedStories) ✨
          • Stale: \(staleCachedStories) 🌙

        Images:
          • Count: \(totalCachedImages)
          • Size: \(formatter.string(fromByteCount: totalImageSize))

        Storage:
          • Disk Usage: \(formatter.string(fromByteCount: diskUsage))

        Dates:
          • Oldest: \(oldestCacheDate?.formatted() ?? "N/A")
          • Newest: \(newestCacheDate?.formatted() ?? "N/A")
        """
    }
}

// MARK: - 🌩️ Cache Errors

/// 🌩️ Errors that can occur during cache operations
enum CacheError: Error, LocalizedError {
    case downloadFailed(url: URL)
    case fileWriteFailed(path: String)
    case invalidImageData
    case cacheLimitExceeded

    var errorDescription: String? {
        switch self {
        case .downloadFailed(let url):
            "Failed to download image from \(url.absoluteString)"
        case .fileWriteFailed(let path):
            "Failed to write file to \(path)"
        case .invalidImageData:
            "Invalid image data received"
        case .cacheLimitExceeded:
            "Cache size limit exceeded"
        }
    }
}
