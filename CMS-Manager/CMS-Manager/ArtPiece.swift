//
//  ArtPiece.swift
//  CMS-Manager
//
//  🎨 The Art Piece Model - The Mystical Canvas of Digital Archives
//
//  "A Codable representation of public domain artworks,
//   carrying the soul of each masterpiece through time and bytes."
//
//  - The Spellbinding Museum Director of Art Collections
//

import Foundation

/// 🎭 Art Piece Model - Represents a public domain artwork in our collection
struct ArtPiece: Codable, Identifiable {
    /// 🌟 Unique identifier for the artwork
    let id: Int
    
    /// 📜 The title of the artwork
    let title: String
    
    /// 🎨 The artist who created this masterpiece
    let artist: String
    
    /// 📅 The year(s) when the artwork was created
    let year: String
    
    /// 📁 The local filename of the image file
    let filename: String
    
    /// 🔗 The source URL where this artwork can be found online
    let sourceURL: String
    
    /// 🖼️ The original image URL from Wikimedia Commons or other source
    let imageURL: String
    
    /// 🎯 Computed property to get the local image path
    var localImagePath: String {
        "local-assets/\(filename)"
    }
    
    /// 🌟 Display name combining artist and title
    var displayName: String {
        "\(title) by \(artist)"
    }
}

/// 📚 Art Collection - Container for multiple artworks
struct ArtCollection: Codable {
    /// 🎨 Array of art pieces in the collection
    let artworks: [ArtPiece]
    
    /// 🔮 Load art collection from local JSON metadata file
    static func loadFromBundle() -> [ArtPiece]? {
        guard let url = Bundle.main.url(forResource: "art_metadata", withExtension: "json", subdirectory: "local-assets"),
              let data = try? Data(contentsOf: url) else {
            print("💥 😭 ART METADATA LOADING TEMPORARILY HALTED!")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let artworks = try decoder.decode([ArtPiece].self, from: data)
            print("🎉 ✨ ART COLLECTION MASTERPIECE COMPLETE! Loaded \(artworks.count) artworks")
            return artworks
        } catch {
            print("🌩️ Temporary setback: \(error.localizedDescription)")
            return nil
        }
    }
}


