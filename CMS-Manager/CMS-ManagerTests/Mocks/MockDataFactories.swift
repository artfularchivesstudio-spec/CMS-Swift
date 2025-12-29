//
//  MockDataFactories.swift
//  CMS-ManagerTests
//
//  🎨 The Data Factories - Alchemists of Test Fixtures
//
//  "In this mystical workshop, we transmute simple bytes into
//   images, audio, and all manner of digital artifacts needed
//   for testing. No pixels harmed, no audio recorded—just pure
//   programmatic magic creating realistic test data on demand!"
//
//  - The Spellbinding Museum Director of Test Data Synthesis
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
@testable import CMS_Manager
import ArtfulArchivesCore

// MARK: - 🖼️ Mock Test Image Factory

/// 🎨 A factory for creating test images
///
/// Generates various types of test images without needing actual image files.
/// Perfect for testing image upload, analysis, and display components! ✨
struct MockTestImageFactory {

    // MARK: - 🎨 Image Creators

    #if os(iOS)
    /// 📸 Create a test UIImage with a specific color
    /// - Parameters:
    ///   - color: The fill color (default: blue)
    ///   - size: The image size (default: 300x300)
    /// - Returns: A UIImage filled with the specified color
    static func createImage(color: UIColor = .systemBlue, size: CGSize = CGSize(width: 300, height: 300)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // 🎭 Add some visual interest - a circle in the center
            UIColor.white.setFill()
            let circleRect = CGRect(
                x: size.width / 2 - 50,
                y: size.height / 2 - 50,
                width: 100,
                height: 100
            )
            context.cgContext.fillEllipse(in: circleRect)
        }
    }

    /// 🌈 Create a gradient test image
    static func createGradientImage(size: CGSize = CGSize(width: 300, height: 300)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0.0, 1.0]
            )!

            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
        }
    }

    /// 🖼️ Create a test image with text overlay
    /// Perfect for simulating artwork with labels! 📝
    static func createImageWithText(_ text: String, size: CGSize = CGSize(width: 400, height: 300)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Background
            UIColor.systemTeal.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Text
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let textSize = attributedString.size()
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            attributedString.draw(in: textRect)
        }
    }

    #elseif os(macOS)
    /// 📸 Create a test NSImage with a specific color
    static func createImage(color: NSColor = .systemBlue, size: CGSize = CGSize(width: 300, height: 300)) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        color.setFill()
        NSRect(origin: .zero, size: size).fill()

        // Add a circle for visual interest
        NSColor.white.setFill()
        let circleRect = NSRect(
            x: size.width / 2 - 50,
            y: size.height / 2 - 50,
            width: 100,
            height: 100
        )
        NSBezierPath(ovalIn: circleRect).fill()

        image.unlockFocus()
        return image
    }

    /// 🌈 Create a gradient test image
    static func createGradientImage(size: CGSize = CGSize(width: 300, height: 300)) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        let gradient = NSGradient(colors: [.systemPurple, .systemPink])
        gradient?.draw(
            from: NSPoint(x: 0, y: 0),
            to: NSPoint(x: size.width, y: size.height),
            options: []
        )

        image.unlockFocus()
        return image
    }
    #endif

    // MARK: - 💾 File Helpers

    /// 📁 Create a temporary file URL for a test image
    /// Returns a file URL that can be used for upload testing ✨
    static func createTemporaryImageFile(
        named filename: String = "test-image.jpg",
        color: PlatformColor = .systemBlue
    ) -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)

        let image = createImage(color: color)

        #if os(iOS)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
        #elseif os(macOS)
        if let tiffData = image.tiffRepresentation,
           let bitmapImage = NSBitmapImageRep(data: tiffData),
           let jpegData = bitmapImage.representation(using: .jpeg, properties: [:]) {
            try? jpegData.write(to: fileURL)
        }
        #endif

        return fileURL
    }

    /// 🧹 Clean up a temporary image file
    static func deleteTemporaryFile(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - 🧪 Mock Analysis Factory

/// 🔍 A factory for creating mock image analysis responses
///
/// Generates realistic AI vision analysis results for testing
/// the story creation wizard's analysis step. No actual AI needed! 🤖
struct MockAnalysisFactory {

    /// 🎨 Create a standard analysis response for artwork
    static func createArtworkAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: true,
            data: CMS_Manager.ImageAnalysisResponse.AnalysisData(
                title: "The Starry Night Reimagined",
                content: """
                This captivating piece features swirling celestial patterns reminiscent of Van Gogh's \
                masterwork, but rendered with a modern digital aesthetic. The interplay of deep blues \
                and vibrant yellows creates a sense of cosmic wonder and timeless beauty.

                The composition draws the viewer's eye in a circular motion, suggesting both the \
                rotation of the heavens and the eternal cycle of artistic inspiration across generations.
                """,
                tags: ["digital art", "astronomy", "impressionism", "night sky", "masterpiece"],
                category: "art",
                mood: "cosmic"
            ),
            message: nil
        )
    }

    /// 🏛️ Create an analysis response for architectural photography
    static func createArchitectureAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: true,
            data: CMS_Manager.ImageAnalysisResponse.AnalysisData(
                title: "Modern Lines: The Glass Cathedral",
                content: """
                Towering geometric forms of glass and steel reach toward the clouds in this \
                architectural marvel. The interplay of transparency and reflection creates an \
                ever-changing canvas that responds to light, weather, and the passage of time.
                """,
                tags: ["architecture", "modern", "glass", "geometric", "urban"],
                category: "architecture",
                mood: "inspiring"
            ),
            message: nil
        )
    }

    /// 🖼️ Create an analysis response for abstract art
    static func createAbstractAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: true,
            data: CMS_Manager.ImageAnalysisResponse.AnalysisData(
                title: "Chaos and Harmony: A Study in Contrasts",
                content: """
                Bold splashes of color collide and merge in this abstract exploration of emotion \
                and energy. The composition balances chaotic gestural marks with areas of serene \
                negative space, inviting the viewer to find their own meaning in the interplay.
                """,
                tags: ["abstract", "expressionism", "color", "emotion", "contemporary"],
                category: "art",
                mood: "dynamic"
            ),
            message: nil
        )
    }

    /// 🌿 Create an analysis response for nature photography
    static func createNatureAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: true,
            data: CMS_Manager.ImageAnalysisResponse.AnalysisData(
                title: "Dawn's First Light: Misty Forest Awakening",
                content: """
                Soft morning light filters through ancient trees, their silhouettes emerging from \
                a veil of mist. This ethereal scene captures nature's quiet majesty at the threshold \
                between night and day, when the forest holds its breath before awakening.
                """,
                tags: ["nature", "photography", "forest", "mist", "morning", "landscape"],
                category: "landscape",
                mood: "peaceful"
            ),
            message: nil
        )
    }

    /// 💥 Create a failed analysis response (for error testing)
    static func createFailedAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: false,
            data: nil,
            message: "AI service temporarily unavailable. Please try again in a moment."
        )
    }

    /// 🎯 Create a minimal analysis response (bare minimum data)
    static func createMinimalAnalysis() -> CMS_Manager.ImageAnalysisResponse {
        CMS_Manager.ImageAnalysisResponse(
            success: true,
            data: CMS_Manager.ImageAnalysisResponse.AnalysisData(
                title: "Untitled Artwork",
                content: "An interesting visual composition.",
                tags: ["art"],
                category: "other",
                mood: "neutral"
            ),
            message: nil
        )
    }
}

// MARK: - 🌐 Mock Translation Factory

/// 🗣️ A factory for creating mock translation responses
///
/// Generates realistic translation results without calling actual translation APIs.
/// Perfect for testing the multilingual workflow! 🌍
struct MockTranslationFactory {

    /// 🇪🇸 Create a Spanish translation response
    static func createSpanishTranslation(for content: String) -> CMS_Manager.TranslationResponse {
        // In a real scenario, this would be the actual translation
        // For mocks, we'll just add a prefix to make it obvious it's "translated"
        CMS_Manager.TranslationResponse(
            success: true,
            translatedContent: "[ES] \(content)",
            originalLanguage: "en",
            targetLanguage: "es",
            message: nil
        )
    }

    /// 🇮🇳 Create a Hindi translation response
    static func createHindiTranslation(for content: String) -> CMS_Manager.TranslationResponse {
        CMS_Manager.TranslationResponse(
            success: true,
            translatedContent: "[HI] \(content)",
            originalLanguage: "en",
            targetLanguage: "hi",
            message: nil
        )
    }

    /// 🇫🇷 Create a French translation response
    static func createFrenchTranslation(for content: String) -> CMS_Manager.TranslationResponse {
        CMS_Manager.TranslationResponse(
            success: true,
            translatedContent: "[FR] \(content)",
            originalLanguage: "en",
            targetLanguage: "fr",
            message: nil
        )
    }

    /// 💥 Create a failed translation response
    static func createFailedTranslation() -> CMS_Manager.TranslationResponse {
        CMS_Manager.TranslationResponse(
            success: false,
            translatedContent: nil,
            originalLanguage: "en",
            targetLanguage: "unknown",
            message: "Translation service unavailable"
        )
    }

    /// 🌐 Create translation for any language code
    static func createTranslation(for content: String, language: LanguageCode) -> CMS_Manager.TranslationResponse {
        CMS_Manager.TranslationResponse(
            success: true,
            translatedContent: "[\(language.rawValue.uppercased())] \(content)",
            originalLanguage: "en",
            targetLanguage: language.rawValue,
            message: nil
        )
    }
}

// MARK: - 🔊 Mock Audio Factory

/// 🎤 A factory for creating mock audio generation responses
///
/// Generates realistic audio URLs (base64 data URLs) for testing
/// the audio generation workflow. No actual TTS required! 🎵
struct MockAudioFactory {

    /// 🎵 Create a successful audio generation response
    static func createAudioResponse(
        for language: LanguageCode,
        voice: CMS_Manager.TTSVoice = .nova
    ) -> CMS_Manager.AudioGenerationResponse {
        CMS_Manager.AudioGenerationResponse(
            success: true,
            audioUrl: "data:audio/mpeg;base64,\(mockBase64AudioData(for: language))",
            duration: 10.5,
            language: language.rawValue,
            voice: voice.rawValue,
            message: nil
        )
    }

    /// 💥 Create a failed audio generation response
    static func createFailedAudioResponse() -> CMS_Manager.AudioGenerationResponse {
        CMS_Manager.AudioGenerationResponse(
            success: false,
            audioUrl: nil,
            duration: nil,
            language: nil,
            voice: nil,
            message: "TTS service temporarily unavailable"
        )
    }

    /// 🎧 Create an audio response with a remote URL (CDN-hosted)
    static func createRemoteAudioResponse(for language: LanguageCode) -> CMS_Manager.AudioGenerationResponse {
        CMS_Manager.AudioGenerationResponse(
            success: true,
            audioUrl: "https://cdn.example.com/audio/\(language.rawValue)/story-123.mp3",
            duration: 15.3,
            language: language.rawValue,
            voice: "alloy",
            message: nil
        )
    }

    /// 📊 Generate mock base64 audio data string
    /// In reality this would be actual audio bytes, but for testing we use a placeholder ✨
    private static func mockBase64AudioData(for language: LanguageCode) -> String {
        // A tiny bit of mock base64 data to simulate an audio file
        // In real testing, you might use an actual small audio sample
        return "SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU4Ljc2LjEwMAAAAAAAAAAAAAAA//tQAAAAAAAA"
    }
}

// MARK: - 📦 Mock Response Factory

/// 📮 A factory for creating various API response models
///
/// Generates complete response objects for all API endpoints,
/// making it easy to test success and failure scenarios! ✨
struct MockResponseFactory {

    /// 📤 Create a media upload response
    static func createUploadResponse(
        id: Int = 42,
        filename: String = "test-image.jpg"
    ) -> CMS_Manager.MediaUploadResponse {
        CMS_Manager.MediaUploadResponse(
            id: id,
            url: "https://cdn.example.com/uploads/\(filename)",
            name: filename,
            mime: "image/jpeg",
            size: 2048576 // 2MB
        )
    }

    /// 🚀 Create a story creation response
    static func createStoryCreationResponse(
        storyId: Int = 123,
        includeStoryData: Bool = true
    ) -> StoryCreateResponse {
        StoryCreateResponse(
            success: true,
            storyId: storyId,
            storyData: includeStoryData ? MockStoryFactory.createStory(id: storyId) : nil,
            message: "Story created successfully"
        )
    }

    /// 📚 Create a stories list response
    static func createStoriesResponse(
        stories: [Story]? = nil,
        page: Int = 1,
        pageSize: Int = 20
    ) -> StoriesResponse {
        let storyList = stories ?? MockStoryFactory.createStoryCollection()
        return StoriesResponse(
            stories: storyList,
            pagination: StoriesResponse.PaginationInfo(
                page: page,
                limit: pageSize,
                total: storyList.count,
                totalPages: 1
            )
        )
    }

    /// 💥 Create an error response for failure scenarios
    static func createErrorResponse(message: String = "Something went wrong") -> CMS_Manager.APIError {
        .serverError(500)
    }
}

// MARK: - 🎨 Platform Type Alias

#if os(iOS)
typealias PlatformColor = UIColor
#elseif os(macOS)
typealias PlatformColor = NSColor
#endif
