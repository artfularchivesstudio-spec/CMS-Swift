# 🎨 Local Assets - Public Domain Art Collection

This folder contains public domain artworks for the Artful Archives Studio project.

## 📋 Metadata File

The `art_metadata.json` file contains information about all artworks including:
- **id**: Unique identifier
- **title**: Artwork title
- **artist**: Artist name
- **year**: Creation year(s)
- **filename**: Local image filename
- **sourceURL**: Original source page URL
- **imageURL**: Direct image download URL

## 📥 Downloading Images

Images are downloaded from Wikimedia Commons and other public domain sources. Due to rate limiting, you may need to download images in batches or manually.

To download remaining images, you can:
1. Use the provided download script with delays between requests
2. Manually download from the URLs in the metadata file
3. Use Wikimedia Commons API with proper rate limiting

## 🎯 Usage in Swift

The `ArtPiece` model in `ArtPiece.swift` provides Codable support for loading this metadata:

```swift
if let artworks = ArtCollection.loadFromBundle() {
    for artwork in artworks {
        print("\(artwork.title) by \(artwork.artist)")
    }
}
```


