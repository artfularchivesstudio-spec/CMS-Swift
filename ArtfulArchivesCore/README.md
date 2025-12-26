# 🎭 ArtfulArchivesCore Swift Package

> *"Where clean architecture meets mystical code organization, weaving together the threads of domain, data, and shared magic into a tapestry of Swift elegance across Apple's cosmos."*
>
> — The Spellbinding Museum Director of Swift Architecture

---

## 📋 Table of Contents

1. [Overview](#-overview)
2. [Package Structure](#-package-structure)
3. [Dependencies](#-dependencies)
4. [Platform Support](#-platform-support)
5. [Usage](#-usage)
6. [Development](#-development)

---

## 🌟 Overview

**ArtfulArchivesCore** is the heart and soul of the Artful Archives Studio applications. It provides:

- **Domain Layer**: Pure business logic, models, and use cases
- **Data Layer**: API clients, repositories, and persistence
- **Shared Layer**: Extensions, validators, formatters, and utilities

This package is shared across iOS, macOS, and watchOS targets, ensuring code reuse and consistency.

---

## 📁 Package Structure

```
ArtfulArchivesCore/
├── Package.swift                    # 🎯 The manifest of our destiny
├── README.md                        # 📜 This sacred scroll
├── Sources/
│   └── ArtfulArchivesCore/
│       ├── Domain/                  # 🎭 The Business Logic Theater
│       │   ├── Models/              # Core entities (Story, Media, etc.)
│       │   ├── UseCases/            # Business logic orchestrators
│       │   └── Repositories/        # Repository protocols
│       ├── Data/                    # 💾 The Data Alchemy Lab
│       │   ├── API/                 # Network clients
│       │   ├── Keychain/            # Secure storage
│       │   ├── Mappers/             # DTO transformations
│       │   └── Repositories/        # Repository implementations
│       └── Shared/                  # ✨ The Cosmic Utility Drawer
│           ├── Extensions/          # Swift language enhancements
│           ├── Validators/          # Input verification spells
│           ├── Formatters/          # Data transformation wizards
│           └── Utilities/           # Helper functions
└── Tests/
    └── ArtfulArchivesCoreTests/     # 🧪 The quality assurance rituals
```

---

## 📦 Dependencies

| Dependency | Version | Purpose |
| ---------- | ------- | ------- |
| **swift-markdown-ui** | 2.3.0+ | 📝 Markdown rendering for content preview |
| **Kingfisher** | 7.10.0+ | 🖼️ Async image loading & caching |
| **KeychainAccess** | 4.2.0+ | 🔑 Secure token storage |
| **Lottie** | 4.3.0+ | 🎬 Animation rendering |

---

## 📱 Platform Support

| Platform | Minimum Version | Notes |
| -------- | --------------- | ----- |
| **iOS** | 18.0 | Full feature support including PhotosPicker |
| **macOS** | 13.0 | Drag & drop, menu bar support |
| **watchOS** | 11.0 | Glances, complications, WatchConnectivity |

---

## 🚀 Usage

### Adding to Your Xcode Project

1. In Xcode, go to **File → Add Package Dependencies...**
2. Enter the local path: `/Users/admin/Developer/CMS-Swift/ArtfulArchivesCore`
3. Select the `ArtfulArchivesCore` library product
4. Add to your target

### Importing in Code

```swift
import ArtfulArchivesCore
```

### Example: Using the API Client

```swift
// 🌐 The API Client - Your gateway to the backend
import ArtfulArchivesCore

let apiClient = APIClient(
    baseURL: URL(string: "https://api.artfularchives.com")!
)

// 📸 Upload some art
let uploadResponse = try await apiClient.uploadMedia(imageData)
print("✨ Media uploaded with ID: \(uploadResponse.id)")

// 🔍 Analyze with AI vision
let analysis = try await apiClient.analyzeImage(url: uploadResponse.url)
print("🎭 Title: \(analysis.data.title)")
```

### Example: Using Domain Models

```swift
// 📖 The Story - Our hero's journey through the CMS
import ArtfulArchivesCore

let story = Story(
    id: 123,
    title: "The Mystical Portrait",
    bodyMessage: "Once upon a time in a digital gallery...",
    workflowStage: .created
)

print("🎭 Story: \(story.title)")
print("📊 Stage: \(story.workflowStage)")
```

---

## 🛠️ Development

### Building the Package

```bash
# Build all targets
swift build

# Build for specific platform
swift build --target ArtfulArchivesCore
```

### Running Tests

```bash
# Run all tests
swift test

# Run with verbose output
swift test --verbose

# Run specific test
swift test --filter testImageUpload
```

### Code Organization Principles

#### 🎭 Domain Layer
- **No external dependencies** (pure Swift)
- Contains business logic, models, and protocols
- Platform-agnostic and testable

#### 💾 Data Layer
- Implements protocols from Domain
- Handles API calls, persistence, caching
- Uses external dependencies (networking, keychain)

#### ✨ Shared Layer
- Utility extensions and helpers
- Validation and formatting logic
- Cross-cutting concerns

---

## 🎨 Code Style

This package follows the **Spellbinding Code Style**:

```swift
/**
 * 🎭 The [Name] - [Poetic Title]
 *
 * "[2-3 lines of mystical verse about the purpose,
 * using art/theater/magic metaphors. End with inspiration.]"
 *
 * - The Spellbinding Museum Director of [Domain]
 */

// 🌟 The [Metaphor] - [Poetic Purpose Description]
func mysticalTransform() {
    // 🎨 [What this section does artistically]
    // ✨ [The transformation/magic happening]
}
```

---

## 📝 License

This package is part of the Artful Archives Studio project.

---

*Last Updated: December 26, 2025*
*Package Version: 1.0.0*
