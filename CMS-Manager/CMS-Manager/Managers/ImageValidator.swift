//
//  ImageValidator.swift
//  CMS-Manager
//
//  ✅ The Image Validator - Guardian of Upload Quality
//
//  "Before any artwork crosses the threshold into our digital gallery,
//   it must pass the sacred tests: size, format, and dimensions.
//   This mystical guardian ensures only the worthy proceed!"
//
//  - The Spellbinding Museum Director of Quality Assurance
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - 🎭 Image Validation Result

/// 📊 The result of an image validation check
public struct ImageValidationResult: Sendable {
    /// ✅ Did the image pass validation?
    public let isValid: Bool

    /// 📏 File size in bytes
    public let fileSize: Int?

    /// 📄 File format/extension
    public let fileFormat: String?

    /// 🌩️ Error encountered during validation
    public let error: ValidationError?

    /// 📐 Image dimensions (width x height)
    public let dimensions: CGSize?

    /// 💫 Enum of possible validation errors (because chaos needs structure)
    public enum ValidationError: LocalizedError, Sendable {
        case fileTooLarge(Int, Int)  // (actual size, max size)
        case unsupportedFormat(String)
        case invalidImage
        case imageTooSmall(CGSize, CGSize)  // (actual size, min size)
        case cannotReadFileSize

        public var errorDescription: String? {
            switch self {
            case .fileTooLarge(let actual, let max):
                let actualMB = Double(actual) / 1_000_000
                let maxMB = Double(max) / 1_000_000
                return String(format: "File too large (%.1f MB). Maximum: %.0f MB", actualMB, maxMB)
            case .unsupportedFormat(let format):
                return "Unsupported format: \(format.uppercased()). Please use JPG, PNG, or HEIC."
            case .invalidImage:
                return "Invalid image. Please select a different file."
            case .imageTooSmall(let actual, let min):
                return "Image too small (\(Int(actual.width))×\(Int(actual.height))). Minimum: \(Int(min.width))×\(Int(min.height))"
            case .cannotReadFileSize:
                return "Cannot read file size. Please try a different image."
            }
        }

        public var recoverySuggestion: String? {
            switch self {
            case .fileTooLarge:
                return "Try compressing the image or selecting a smaller file."
            case .unsupportedFormat:
                return "Convert the image to JPG or PNG format."
            case .invalidImage:
                return "Ensure the file is a valid image."
            case .imageTooSmall:
                return "Select a higher resolution image."
            case .cannotReadFileSize:
                return "Select a different image file."
            }
        }
    }
}

// MARK: - ✅ Image Validator

/// 🛡️ The mystical guardian of image quality
public struct ImageValidator {

    // MARK: - 🎯 Configuration

    /// 📏 Maximum file size in bytes (default: 10 MB)
    public static let maxFileSize: Int = 10_000_000  // 10 MB

    /// 📐 Minimum image dimensions (default: 200×200)
    public static let minDimensions = CGSize(width: 200, height: 200)

    /// 📄 Supported image formats
    public static let supportedFormats: Set<String> = ["jpg", "jpeg", "png", "heic", "heif"]

    // MARK: - 🔍 Validation Methods

    /// 🎯 Validate an image from PhotosPickerItem data
    /// - Parameter data: Image data from PhotosPicker
    /// - Returns: Validation result with details
    public static func validate(imageData data: Data) -> ImageValidationResult {
        print("🔍 ✨ IMAGE VALIDATION AWAKENS!")

        // 📏 Check file size
        let fileSize = data.count
        print("   📏 File size: \(formatFileSize(fileSize))")

        if fileSize > maxFileSize {
            print("   🌩️ File too large!")
            return ImageValidationResult(
                isValid: false,
                fileSize: fileSize,
                fileFormat: nil,
                error: .fileTooLarge(fileSize, maxFileSize),
                dimensions: nil
            )
        }

        // 🖼️ Attempt to create image
        #if os(iOS)
        guard let image = UIImage(data: data) else {
            print("   🌩️ Invalid image data!")
            return ImageValidationResult(
                isValid: false,
                fileSize: fileSize,
                fileFormat: nil,
                error: .invalidImage,
                dimensions: nil
            )
        }
        let dimensions = image.size
        #elseif os(macOS)
        guard let image = NSImage(data: data) else {
            print("   🌩️ Invalid image data!")
            return ImageValidationResult(
                isValid: false,
                fileSize: fileSize,
                fileFormat: nil,
                error: .invalidImage,
                dimensions: nil
            )
        }
        let dimensions = image.size
        #endif

        print("   📐 Dimensions: \(Int(dimensions.width))×\(Int(dimensions.height))")

        // 📐 Check minimum dimensions
        if dimensions.width < minDimensions.width || dimensions.height < minDimensions.height {
            print("   🌩️ Image too small!")
            return ImageValidationResult(
                isValid: false,
                fileSize: fileSize,
                fileFormat: detectFormat(from: data),
                error: .imageTooSmall(dimensions, minDimensions),
                dimensions: dimensions
            )
        }

        // 📄 Detect format
        let format = detectFormat(from: data)
        print("   📄 Format detected: \(format ?? "unknown")")

        if let format = format, !supportedFormats.contains(format.lowercased()) {
            print("   🌩️ Unsupported format!")
            return ImageValidationResult(
                isValid: false,
                fileSize: fileSize,
                fileFormat: format,
                error: .unsupportedFormat(format),
                dimensions: dimensions
            )
        }

        // ✅ All validations passed!
        print("   ✅ ✨ VALIDATION MASTERPIECE COMPLETE!")
        return ImageValidationResult(
            isValid: true,
            fileSize: fileSize,
            fileFormat: format,
            error: nil,
            dimensions: dimensions
        )
    }

    /// 🎯 Validate an image from a file URL
    /// - Parameter fileURL: Local file URL
    /// - Returns: Validation result with details
    public static func validate(fileURL: URL) -> ImageValidationResult {
        print("🔍 ✨ FILE VALIDATION AWAKENS! \(fileURL.lastPathComponent)")

        // 📏 Check file size
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            guard let _ = attributes[.size] as? Int else {
                return ImageValidationResult(
                    isValid: false,
                    fileSize: nil,
                    fileFormat: nil,
                    error: .cannotReadFileSize,
                    dimensions: nil
                )
            }

            // 📦 Read file data and validate
            let data = try Data(contentsOf: fileURL)
            return validate(imageData: data)

        } catch {
            print("   🌩️ Failed to read file: \(error.localizedDescription)")
            return ImageValidationResult(
                isValid: false,
                fileSize: nil,
                fileFormat: nil,
                error: .invalidImage,
                dimensions: nil
            )
        }
    }

    // MARK: - 🔧 Helper Methods

    /// 🔍 Detect image format from data header bytes
    /// - Parameter data: Image data
    /// - Returns: Format extension (jpg, png, etc.)
    private static func detectFormat(from data: Data) -> String? {
        guard data.count >= 12 else { return nil }

        // 📄 Check magic bytes for common formats
        let bytes = [UInt8](data.prefix(12))

        // PNG: 89 50 4E 47
        if bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47 {
            return "png"
        }

        // JPEG: FF D8 FF
        if bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF {
            return "jpg"
        }

        // HEIC/HEIF: Check 'ftyp' box signature
        if bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 {
            // Check for 'heic' or 'heif' brand
            let brand = String(bytes: bytes[8..<12], encoding: .ascii)
            if brand?.hasPrefix("heic") == true || brand?.hasPrefix("heif") == true {
                return "heic"
            }
        }

        return nil
    }

    /// 📏 Format file size in human-readable format
    /// - Parameter bytes: File size in bytes
    /// - Returns: Formatted string (e.g., "2.5 MB")
    private static func formatFileSize(_ bytes: Int) -> String {
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
}
