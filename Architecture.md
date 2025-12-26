# 🎭 Artful Archives Studio - Comprehensive Architecture Document

> *"Where digital dreams become mystical masterpieces across the Apple cosmos"*
>
> — The Spellbinding Museum Director of Architecture

---

## 📋 Table of Contents

1. [System Overview](#system-overview)
2. [Backend API Reference](#backend-api-reference-live-on-vps)
3. [Enhanced Swift Package Dependencies](#enhanced-swift-package-dependencies)
4. [Sequence Diagrams](#sequence-diagrams)
5. [Data Flow Architecture](#data-flow-architecture)
6. [Snapshot Testing Strategy](#snapshot-testing-strategy)
7. [Implementation Checklists](#implementation-checklists)
8. [Platform-Specific Considerations](#platform-specific-considerations)
9. [Security Architecture](#security-architecture)
10. [Error Handling Strategy](#error-handling-strategy)

---

## 🌟 System Overview

### High-Level Architecture

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                         APPLE NATIVE ECOSYSTEM                                │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐                  │
│  │    iOS App     │  │   macOS App    │  │  watchOS App   │                  │
│  │   (SwiftUI)    │  │   (SwiftUI)    │  │   (SwiftUI)    │                  │
│  │                │  │                │  │                │                  │
│  │ • PhotosPicker │  │ • Drag & Drop  │  │ • Glances      │                  │
│  │ • Dynamic Isle │  │ • Menu Bar     │  │ • Complications│                  │
│  │ • Live Activity│  │ • Split View   │  │ • WatchConnect │                  │
│  │ • Haptics      │  │ • Keyboard     │  │ • Haptics      │                  │
│  └───────┬────────┘  └───────┬────────┘  └───────┬────────┘                  │
│          │                   │                   │                           │
│          └───────────────────┼───────────────────┘                           │
│                              │                                               │
│  ┌───────────────────────────┴───────────────────────────────────┐          │
│  │            ArtfulArchivesCore (Swift Package)                  │          │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐│          │
│  │  │   Domain    │  │    Data     │  │        Shared          ││          │
│  │  │  ─────────  │  │  ─────────  │  │  ─────────────────     ││          │
│  │  │ • Models    │  │ • APIClient │  │ • Extensions           ││          │
│  │  │ • UseCases  │  │ • Keychain  │  │ • Validators           ││          │
│  │  │ • Repos     │  │ • Mappers   │  │ • Formatters           ││          │
│  │  └─────────────┘  └─────────────┘  └─────────────────────────┘│          │
│  └───────────────────────────┬───────────────────────────────────┘          │
└──────────────────────────────┼───────────────────────────────────────────────┘
                               │ HTTPS (Port 8999)
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                    PYTHON BACKEND (FastAPI) - Port 8999                       │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                           API Endpoints                                 │  │
│  │  POST /api/v1/upload-media      →  Strapi Media Library Upload         │  │
│  │  POST /api/v1/analyze-image     →  OpenAI Vision (gpt-4o)              │  │
│  │  POST /api/v1/translate         →  OpenAI Translation                  │  │
│  │  POST /api/v1/generate-audio    →  OpenAI TTS (gpt-4o-mini-tts)        │  │
│  │  POST /api/v1/create-story      →  Strapi REST API                     │  │
│  │  POST /api/v1/stories/{id}/translations → Strapi i18n                  │  │
│  │  GET/PUT/PATCH/DELETE /api/v1/stories/{id}                             │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                    │                                          │
│  ┌─────────────────────────────────┼─────────────────────────────────────┐   │
│  │                    StoryHandler (story_handler.py)                     │   │
│  │  • OpenAI Client (Vision + TTS + Translation)                         │   │
│  │  • Strapi HTTP Client (httpx async)                                    │   │
│  │  • Supabase Client (direct DB access)                                  │   │
│  └─────────────────────────────────┬─────────────────────────────────────┘   │
└────────────────────────────────────┼─────────────────────────────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
┌─────────────────────────┐ ┌─────────────────┐ ┌─────────────────────────────┐
│   OpenAI APIs           │ │  Strapi CMS     │ │       Supabase              │
│  ────────────────────   │ │  Port 1337      │ │  ────────────────────────   │
│  • gpt-4o (Vision)      │ │  ────────────   │ │  • PostgreSQL Database      │
│  • gpt-4o (Translation) │ │  • REST API     │ │  • Real-time Subscriptions  │
│  • gpt-4o-mini-tts      │ │  • Media Library│ │  • Row Level Security       │
│                         │ │  • i18n Plugin  │ │  • Storage (images/audio)   │
└─────────────────────────┘ └─────────────────┘ └─────────────────────────────┘
```

### 🧠 ONE BRAIN Architecture Pattern

The backend follows a "One Brain" pattern where:

- **All writes** go through Strapi → Supabase (never direct)
- **Python API** is the orchestration layer
- **Strapi** is the single source of truth for content
- **Supabase** provides real-time subscriptions and storage

---

## 🔌 Backend API Reference (Live on VPS)

### Verified Endpoints from Production Backend

| Endpoint | Method | Purpose | Request Body | Response |
| -------- | ------ | ------- | ------------ | -------- |
| `/api/v1/health` | GET | Health check | - | Service status, versions |
| `/api/v1/upload-media` | POST | Upload to Strapi Media | `multipart/form-data` | `{id, url, name, mime, size}` |
| `/api/v1/analyze-image` | POST | OpenAI Vision analysis | `{image_url, prompt?}` | `{success, data: {title, content, tags}}` |
| `/api/v1/translate` | POST | Content translation | `{content, target_language}` | `{success, translated_content}` |
| `/api/v1/generate-audio` | POST | OpenAI TTS generation | `{text, language, voice?}` | `{success, audio_url}` |
| `/api/v1/create-story-complete` | POST | Full story pipeline | See below | `{success, story_id, story_data}` |
| `/api/v1/stories` | GET | List all stories | Query params | `{stories[], pagination}` |
| `/api/v1/stories/{id}` | GET | Get single story | - | `{story, savedPostId}` |
| `/api/v1/stories/{id}` | PUT | Update story | Story fields | `{story, message}` |
| `/api/v1/stories/{id}` | PATCH | Partial update | Fields to update | `{success, data}` |
| `/api/v1/stories/{id}` | DELETE | Delete story | - | `{message}` |
| `/api/v1/stories/{id}/translations` | POST | Create translation | `{locale, title, content}` | `{success, data, action}` |

### Request/Response Models

```swift
// 🎨 Media Upload Response
struct MediaUploadResponse: Codable {
    let id: Int
    let url: String
    let name: String
    let mime: String
    let size: Int
}

// 🔍 Image Analysis Response
struct ImageAnalysisResponse: Codable {
    let success: Bool
    let data: AnalysisData?
    let error: String?

    struct AnalysisData: Codable {
        let title: String
        let content: String
        let tags: [String]
    }
}

// 🌐 Translation Response
struct TranslationResponse: Codable {
    let success: Bool
    let translatedContent: String?
    let error: String?
}

// 🔊 Audio Generation Response
struct AudioGenerationResponse: Codable {
    let success: Bool
    let audioUrl: String?  // Base64 data URL or CDN URL
    let error: String?
}

// 📖 Story Create Request
struct StoryCreateRequest: Codable {
    let title: String
    let content: String
    let imageId: Int?        // Strapi media ID
    let imageUrl: String?    // Alternative: direct URL
    let audioDuration: Int?
}

// 📚 Story Response
struct StoryResponse: Codable {
    let id: Int
    let documentId: String
    let title: String
    let slug: String
    let bodyMessage: String
    let excerpt: String
    let workflowStage: WorkflowStage
    let visible: Bool
    let createdAt: Date
    let updatedAt: Date
}

// 🎭 Workflow Stages (from Strapi)
enum WorkflowStage: String, Codable, CaseIterable {
    case created
    case englishTextApproved = "english_text_approved"
    case englishAudioApproved = "english_audio_approved"
    case englishVersionApproved = "english_version_approved"
    case multilingualTextApproved = "multilingual_text_approved"
    case multilingualAudioApproved = "multilingual_audio_approved"
    case pendingFinalReview = "pending_final_review"
    case approved
}
```

---

## 📦 Enhanced Swift Package Dependencies

### Core Dependencies (From README)

```swift
// Package.swift
let package = Package(
    name: "ArtfulArchivesCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v13),
        .watchOS(.v11)
    ],
    products: [
        .library(name: "ArtfulArchivesCore", targets: ["ArtfulArchivesCore"])
    ],
    dependencies: [
        // 📝 Markdown rendering for content preview
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.3.0"),

        // 🖼️ Async image loading & caching
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.10.0"),

        // 🎵 Audio playback (consider alternatives below)
        .package(url: "https://github.com/AudioKit/AudioKit", from: "5.6.0"),
    ],
    targets: [
        .target(
            name: "ArtfulArchivesCore",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                "Kingfisher",
                "AudioKit"
            ]
        )
    ]
)
```

### 🎬 Animation Libraries (RECOMMENDED ADDITIONS)

```swift
dependencies: [
    // 🎭 Lottie - Industry-standard for complex animations
    // Use for: wizard transitions, success celebrations, loading states
    .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.0"),

    // ✨ Pow - SwiftUI-native effects and transitions
    // Use for: particle effects, sparkles, shake animations
    .package(url: "https://github.com/movingparts-io/Pow", from: "1.0.0"),

    // 🌊 Liquid - Fluid animations and morphing shapes
    // Use for: background blobs, organic transitions
    .package(url: "https://github.com/maustinstar/liquid", from: "0.0.4"),

    // 🎪 ConfettiSwiftUI - Celebration effects
    // Use for: wizard completion, story published
    .package(url: "https://github.com/simibac/ConfettiSwiftUI", from: "1.1.0"),
]
```

### 📷 Snapshot Testing (PLAYWRIGHT REPLACEMENT)

```swift
dependencies: [
    // 📸 Swift Snapshot Testing by Point-Free
    // THE standard for iOS snapshot testing
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0"),

    // 🎯 InlineSnapshotTesting - Inline assertions
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0"),
]

// Test target
.testTarget(
    name: "ArtfulArchivesCoreTests",
    dependencies: [
        "ArtfulArchivesCore",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
    ]
)
```

### 🌐 Networking (Alternative Options)

```swift
dependencies: [
    // 🚀 Alamofire - If you need more than URLSession
    // Consider for: complex retry logic, request adapters
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),

    // 📡 Get - Lightweight async networking by Kean
    // Perfect for: simple REST APIs, minimal footprint
    .package(url: "https://github.com/kean/Get", from: "2.1.0"),
]
```

### 🔐 Security & Storage

```swift
dependencies: [
    // 🔑 KeychainAccess - Simple Keychain wrapper
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.0"),

    // 🗄️ GRDB - SQLite database (if local persistence needed)
    .package(url: "https://github.com/groue/GRDB.swift", from: "6.24.0"),
]
```

### 🎨 UI Components

```swift
dependencies: [
    // 📊 Charts - Apple's native charts (iOS 16+)
    // Built-in, no package needed - use import Charts

    // 🎨 SwiftUIX - Extended SwiftUI components
    .package(url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.1.9"),

    // 📝 RichTextKit - Rich text editing
    .package(url: "https://github.com/danielsaidi/RichTextKit", from: "1.0.0"),

    // 🖼️ Nuke - Alternative image loading (lighter than Kingfisher)
    .package(url: "https://github.com/kean/Nuke", from: "12.4.0"),
]
```

### 🎵 Audio Alternatives

```swift
dependencies: [
    // 🎧 AudioKit - Full-featured audio (heavyweight)
    .package(url: "https://github.com/AudioKit/AudioKit", from: "5.6.0"),

    // OR: Lighter alternatives

    // 🔊 AVFAudio (built-in) - For simple playback
    // No package needed - use AVAudioPlayer directly

    // 📻 AudioStreaming - For streaming audio
    .package(url: "https://github.com/nickkramer/AudioStreaming", from: "0.1.0"),
]
```

---

## 📊 Sequence Diagrams

### 1. Media Upload Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  iOS App    │     │ Python API  │     │   Strapi    │     │   Storage   │
│             │     │  Port 8999  │     │  Port 1337  │     │  (Media)    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ POST /upload-media│                   │                   │
       │ (multipart/form)  │                   │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │                   │ POST /api/upload  │                   │
       │                   │ (multipart/form)  │                   │
       │                   │──────────────────>│                   │
       │                   │                   │                   │
       │                   │                   │  Save file to     │
       │                   │                   │  /uploads/        │
       │                   │                   │──────────────────>│
       │                   │                   │                   │
       │                   │                   │<──────────────────│
       │                   │                   │  File saved       │
       │                   │                   │                   │
       │                   │ {id, url, name}   │                   │
       │                   │<──────────────────│                   │
       │                   │                   │                   │
       │ {success: true,   │                   │                   │
       │  data: {id, url}} │                   │                   │
       │<──────────────────│                   │                   │
       │                   │                   │                   │
```

### 2. Image Analysis Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  iOS App    │     │ Python API  │     │   Strapi    │     │   OpenAI    │
│             │     │  Port 8999  │     │  Port 1337  │     │  gpt-4o     │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ POST /analyze-image                   │                   │
       │ {image_url: "/uploads/xyz.jpg"}       │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │                   │ Strapi upload?    │                   │
       │                   │ → Fetch image     │                   │
       │                   │──────────────────>│                   │
       │                   │                   │                   │
       │                   │ Binary image data │                   │
       │                   │<──────────────────│                   │
       │                   │                   │                   │
       │                   │ Convert to Base64 │                   │
       │                   │                   │                   │
       │                   │ POST /chat/completions                │
       │                   │ {model: "gpt-4o", │                   │
       │                   │  messages: [      │                   │
       │                   │    {image: base64}│                   │
       │                   │  ]}               │                   │
       │                   │──────────────────────────────────────>│
       │                   │                   │                   │
       │                   │ {title, content, tags}                │
       │                   │<──────────────────────────────────────│
       │                   │                   │                   │
       │ {success: true,   │                   │                   │
       │  data: {title,    │                   │                   │
       │   content, tags}} │                   │                   │
       │<──────────────────│                   │                   │
       │                   │                   │                   │
```

### 3. Translation Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  iOS App    │     │ Python API  │     │   OpenAI    │
│             │     │  Port 8999  │     │  gpt-4o     │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │ POST /translate   │                   │
       │ {content: "...",  │                   │
       │  target_language: │                   │
       │  "es"}            │                   │
       │──────────────────>│                   │
       │                   │                   │
       │                   │ POST /chat/completions
       │                   │ {model: "gpt-4o", │
       │                   │  messages: [      │
       │                   │    "Translate to  │
       │                   │     Spanish..."   │
       │                   │  ]}               │
       │                   │──────────────────>│
       │                   │                   │
       │                   │ Translated text   │
       │                   │<──────────────────│
       │                   │                   │
       │ {success: true,   │                   │
       │  translated_content: │                │
       │  "..."}           │                   │
       │<──────────────────│                   │
       │                   │                   │
```

### 4. Audio Generation Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  iOS App    │     │ Python API  │     │   OpenAI    │
│             │     │  Port 8999  │     │  TTS API    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │ POST /generate-audio                  │
       │ {text: "...",     │                   │
       │  language: "en",  │                   │
       │  voice: "nova"}   │                   │
       │──────────────────>│                   │
       │                   │                   │
       │                   │ Map voice for     │
       │                   │ language:         │
       │                   │ EN→nova           │
       │                   │ ES→nova           │
       │                   │ HI→fable          │
       │                   │                   │
       │                   │ POST /audio/speech│
       │                   │ {model: "gpt-4o-  │
       │                   │   mini-tts",      │
       │                   │  voice, speed:0.9}│
       │                   │──────────────────>│
       │                   │                   │
       │                   │ Binary audio (MP3)│
       │                   │<──────────────────│
       │                   │                   │
       │                   │ Encode to Base64  │
       │                   │                   │
       │ {success: true,   │                   │
       │  audio_url:       │                   │
       │  "data:audio/     │                   │
       │   mpeg;base64,..."│                   │
       │<──────────────────│                   │
       │                   │                   │
```

### 5. Complete Story Creation Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  iOS App    │     │ Python API  │     │   Strapi    │     │  Supabase   │
│             │     │  Port 8999  │     │  Port 1337  │     │    (DB)     │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ POST /create-story-complete           │                   │
       │ {title, content,  │                   │                   │
       │  imageId, ...}    │                   │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │                   │ Clean title       │                   │
       │                   │ (remove markdown) │                   │
       │                   │                   │                   │
       │                   │ Generate unique   │                   │
       │                   │ slug + timestamp  │                   │
       │                   │                   │                   │
       │                   │ POST /api/stories │                   │
       │                   │ {data: {title,    │                   │
       │                   │  slug, body_message,                  │
       │                   │  image, ...}}     │                   │
       │                   │──────────────────>│                   │
       │                   │                   │                   │
       │                   │                   │ INSERT INTO       │
       │                   │                   │ stories           │
       │                   │                   │──────────────────>│
       │                   │                   │                   │
       │                   │                   │<──────────────────│
       │                   │                   │ {id, documentId}  │
       │                   │                   │                   │
       │                   │ {data: {id,       │                   │
       │                   │  documentId, ...}}│                   │
       │                   │<──────────────────│                   │
       │                   │                   │                   │
       │ {success: true,   │                   │                   │
       │  story_id: 123,   │                   │                   │
       │  story_data: {...}│                   │                   │
       │<──────────────────│                   │                   │
       │                   │                   │                   │
```

### 6. Full 7-Step Wizard Flow

```text
┌────────────────────────────────────────────────────────────────────────────────┐
│                           WIZARD FLOW STATE MACHINE                             │
└────────────────────────────────────────────────────────────────────────────────┘

┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Step 1  │────>│  Step 2  │────>│  Step 3  │────>│  Step 4  │
│  UPLOAD  │     │ ANALYZE  │     │  REVIEW  │     │TRANSLATE │
│          │     │          │     │          │     │          │
│ • Photos │     │ • OpenAI │     │ • Edit   │     │ • Select │
│   Picker │     │   Vision │     │   Title  │     │   Langs  │
│ • Drag   │     │ • Progress│    │ • Edit   │     │ • Queue  │
│   Drop   │     │   Animate │    │   Content│     │   Jobs   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     │ /upload-media  │ /analyze-image │                │ /translate
     ▼                ▼                │                ▼ (per language)
  imageId         analysisData         │           translations{}
  imageUrl        title, content       │                │
                  tags                 │                │
                                       │                │
┌──────────┐     ┌──────────┐     ┌────┴─────┐         │
│  Step 7  │<────│  Step 6  │<────│  Step 5  │<────────┘
│ FINALIZE │     │  AUDIO   │     │ REVIEW   │
│          │     │          │     │TRANSLATE │
│ • Summary│     │ • Voice  │     │          │
│ • Publish│     │   Select │     │ • Side-  │
│ • 🎉     │     │ • Speed  │     │   by-side│
└──────────┘     └──────────┘     └──────────┘
     │                │                │
     │/create-story   │ /generate-audio│ /stories/{id}
     │-complete       │ (per language) │ /translations
     ▼                ▼                ▼
  Story saved     audioUrls{}      Translations
  in Strapi                        saved to DB
```

---

## 🔄 Data Flow Architecture

### State Management with @Observable

```swift
// 🎭 The Wizard View Model - Orchestrator of the 7-Step Dance
@Observable
final class StoryWizardViewModel {
    // MARK: - 🌟 Step Navigation
    enum Step: Int, CaseIterable {
        case upload = 0
        case analyzing = 1
        case review = 2
        case translation = 3
        case translationReview = 4
        case audio = 5
        case finalize = 6

        var title: String {
            switch self {
            case .upload: "Upload"
            case .analyzing: "Analyzing"
            case .review: "Review"
            case .translation: "Translate"
            case .translationReview: "Review Translations"
            case .audio: "Audio"
            case .finalize: "Finalize"
            }
        }
    }

    // MARK: - 📊 State
    var currentStep: Step = .upload
    var isLoading = false
    var error: AppError?

    // MARK: - 📸 Step 1: Upload
    var selectedImage: PlatformImage?
    var uploadedMediaId: Int?
    var uploadedMediaUrl: String?

    // MARK: - 🔍 Step 2: Analyze
    var analysisProgress: Double = 0
    var analysisResult: ImageAnalysisResponse.AnalysisData?

    // MARK: - ✏️ Step 3: Review
    var storyTitle: String = ""
    var storyContent: String = ""
    var storyTags: [String] = []
    var storySlug: String = ""

    // MARK: - 🌐 Step 4: Translation
    var selectedLanguages: Set<LanguageCode> = []
    var translationProgress: [LanguageCode: Double] = [:]
    var translations: [LanguageCode: String] = [:]

    // MARK: - 📝 Step 5: Translation Review
    var editedTranslations: [LanguageCode: String] = [:]

    // MARK: - 🔊 Step 6: Audio
    var selectedVoice: TTSVoice = .nova
    var audioSpeed: Double = 0.9
    var audioProgress: [LanguageCode: Double] = [:]
    var audioUrls: [LanguageCode: String] = [:]

    // MARK: - 🎉 Step 7: Finalize
    var createdStoryId: Int?
    var isPublished = false

    // MARK: - 🔗 Dependencies
    private let apiClient: APIClientProtocol
    private let toastManager: ToastManager

    init(apiClient: APIClientProtocol, toastManager: ToastManager) {
        self.apiClient = apiClient
        self.toastManager = toastManager
    }
}
```

### Dependency Injection Pattern

```swift
// 🏭 The Dependency Container - Where All Magic Components Live
@Observable
final class AppDependencies {
    // MARK: - 🌐 Network
    let apiClient: APIClientProtocol

    // MARK: - 🔐 Security
    let keychainManager: KeychainManagerProtocol

    // MARK: - 💾 Persistence
    let modelContainer: ModelContainer

    // MARK: - 🎨 UI
    let toastManager: ToastManager

    // MARK: - 🎵 Audio
    let audioPlayer: AudioPlayerProtocol

    init() {
        self.keychainManager = KeychainManager()
        self.apiClient = APIClient(keychain: keychainManager)
        self.modelContainer = try! ModelContainer(for: Story.self)
        self.toastManager = ToastManager()
        self.audioPlayer = AudioPlayer()
    }
}
```

---

## 📸 Snapshot Testing Strategy

### Why Snapshot Testing (Replacing Playwright)

| Playwright (Web) | Swift Snapshot Testing |
| ---------------- | ---------------------- |
| Browser-based rendering | Native SwiftUI rendering |
| Network requests | Mocked data layers |
| Cross-browser testing | Cross-device testing |
| Slow CI/CD | Fast local tests |
| Flaky selectors | Deterministic captures |

### Implementation

```swift
import SnapshotTesting
import XCTest
@testable import ArtfulArchivesApp

// 🎭 Snapshot Test Theater - Where Every Frame Tells a Story
final class WizardSnapshotTests: XCTestCase {

    // 🌟 Test each wizard step in all states
    func testUploadStepEmpty() {
        let view = UploadStepView(viewModel: .mock())

        assertSnapshot(
            of: view,
            as: .image(
                layout: .device(config: .iPhone13Pro),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }

    func testUploadStepWithImage() {
        let vm = StoryWizardViewModel.mock()
        vm.selectedImage = UIImage(named: "test-artwork")

        let view = UploadStepView(viewModel: vm)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testAnalyzingStepProgress50() {
        let vm = StoryWizardViewModel.mock()
        vm.analysisProgress = 0.5

        let view = AnalyzingStepView(viewModel: vm)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // 📱 Test all device sizes
    func testUploadStepAllDevices() {
        let view = UploadStepView(viewModel: .mock())

        let devices: [ViewImageConfig] = [
            .iPhone13Pro,
            .iPhone8,
            .iPhoneSe,
            .iPad10_2,
            .iPadPro11
        ]

        for device in devices {
            assertSnapshot(
                of: view,
                as: .image(layout: .device(config: device)),
                named: device.name
            )
        }
    }

    // 🌙 Test dark mode
    func testUploadStepDarkMode() {
        let view = UploadStepView(viewModel: .mock())

        assertSnapshot(
            of: view,
            as: .image(
                layout: .device(config: .iPhone13Pro),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "dark"
        )
    }

    // ♿ Test accessibility sizes
    func testUploadStepAccessibilityXXL() {
        let view = UploadStepView(viewModel: .mock())

        assertSnapshot(
            of: view,
            as: .image(
                layout: .device(config: .iPhone13Pro),
                traits: .init(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            ),
            named: "a11y-xxl"
        )
    }
}
```

### Snapshot Test Configuration

```swift
// 🔧 Configure test precision and recording
extension XCTestCase {
    func assertSnapshotWithTolerance<V: View>(
        of view: V,
        precision: Float = 0.99,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: view,
            as: .image(precision: precision, perceptualPrecision: 0.98),
            file: file,
            testName: testName,
            line: line
        )
    }
}
```

### CI/CD Integration

```yaml
# .github/workflows/snapshot-tests.yml
name: Snapshot Tests

on: [pull_request]

jobs:
  snapshots:
    runs-on: macos-14

    steps:
      - uses: actions/checkout@v4

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.2.app

      - name: Run Snapshot Tests
        run: |
          xcodebuild test \
            -scheme ArtfulArchivesApp \
            -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.2' \
            -only-testing:ArtfulArchivesAppTests/SnapshotTests

      - name: Upload Failed Snapshots
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: failed-snapshots
          path: |
            **/Failures/**
```

---

## ✅ Implementation Checklists

### Phase 1: Foundation

- [ ] **Project Setup**
  - [ ] Create Xcode project with iOS, macOS, watchOS targets
  - [ ] Configure Swift 6.x with strict concurrency
  - [ ] Set up ArtfulArchivesCore Swift Package
  - [ ] Configure minimum deployment targets (iOS 18, macOS 13, watchOS 11)

- [ ] **Swift Package Dependencies**
  - [ ] Add Kingfisher for image caching
  - [ ] Add swift-markdown-ui for content rendering
  - [ ] Add Lottie for animations
  - [ ] Add Pow for SwiftUI effects
  - [ ] Add swift-snapshot-testing for tests
  - [ ] Add KeychainAccess for secure storage

- [ ] **Core Infrastructure**
  - [ ] Implement `APIClient` actor with URLSession
  - [ ] Create all endpoint definitions
  - [ ] Implement `KeychainManager` for token storage
  - [ ] Build `ToastManager` for notifications
  - [ ] Create `AppDependencies` container

- [ ] **Domain Models**
  - [ ] `Story` model matching Strapi schema
  - [ ] `MediaUploadResponse` for uploads
  - [ ] `ImageAnalysisResponse` for analysis
  - [ ] `TranslationResponse` for translations
  - [ ] `AudioGenerationResponse` for audio
  - [ ] `WorkflowStage` enum
  - [ ] `LanguageCode` enum (en, es, hi)

### Phase 2: Wizard Flow

- [ ] **Step 1: Upload**
  - [ ] PhotosPicker integration (iOS)
  - [ ] Drag & drop support (macOS)
  - [ ] Image preview with Kingfisher
  - [ ] Upload progress indicator
  - [ ] Error handling with retry

- [ ] **Step 2: Analyzing**
  - [ ] Lottie animation for processing
  - [ ] Progress percentage display
  - [ ] Shimmer loading effect
  - [ ] Cancel capability

- [ ] **Step 3: Review**
  - [ ] Title editor with character count
  - [ ] Markdown content editor
  - [ ] Tag chips editor
  - [ ] Slug preview (auto-generated)
  - [ ] Image preview sidebar

- [ ] **Step 4: Translation**
  - [ ] Language selection (EN, ES, HI flags)
  - [ ] Parallel translation progress bars
  - [ ] Cancel individual translations
  - [ ] Queue management

- [ ] **Step 5: Translation Review**
  - [ ] Side-by-side comparison view
  - [ ] Inline editing per language
  - [ ] Original text reference
  - [ ] Save to Strapi button

- [ ] **Step 6: Audio**
  - [ ] Voice picker (Nova, Fable, etc.)
  - [ ] Speed slider (0.25 - 4.0)
  - [ ] Audio preview playback
  - [ ] Progress per language

- [ ] **Step 7: Finalize**
  - [ ] Summary card view
  - [ ] Confetti celebration
  - [ ] Publish button
  - [ ] Share sheet

### Phase 3: Stories Management

- [ ] **Stories List**
  - [ ] Grid/List toggle view
  - [ ] Search functionality
  - [ ] Filter by workflow stage
  - [ ] Sort options (date, title)
  - [ ] Pull-to-refresh
  - [ ] Pagination/infinite scroll

- [ ] **Story Detail**
  - [ ] Full content display with Markdown
  - [ ] Audio player for each language
  - [ ] Edit mode toggle
  - [ ] Delete with confirmation
  - [ ] Workflow stage indicator

- [ ] **Offline Support**
  - [ ] SwiftData local cache
  - [ ] Sync queue for pending operations
  - [ ] Conflict resolution
  - [ ] Background sync

### Phase 4: Platform Extensions

- [ ] **iOS Live Activity**
  - [ ] Audio generation progress
  - [ ] Compact view (waveform + %)
  - [ ] Expanded view (full progress)
  - [ ] Dynamic Island integration

- [ ] **watchOS App**
  - [ ] Story list with complications
  - [ ] Audio playback controls
  - [ ] WatchConnectivity sync
  - [ ] Haptic notifications

- [ ] **macOS Specifics**
  - [ ] Menu bar quick actions
  - [ ] Keyboard shortcuts
  - [ ] Touch Bar support (if applicable)
  - [ ] Notification Center widgets

- [ ] **Widgets**
  - [ ] Home screen widget (recent story)
  - [ ] Lock screen widget (audio status)
  - [ ] Large widget (story preview)

### Phase 5: Polish & Testing

- [ ] **Animations**
  - [ ] SparkleModifier (success burst)
  - [ ] ShimmerModifier (loading)
  - [ ] PulseModifier (breathing)
  - [ ] SuccessCheckmark (path animation)
  - [ ] Page transitions (wizard steps)

- [ ] **Haptics**
  - [ ] Light: button taps
  - [ ] Medium: step transitions
  - [ ] Success: wizard completion
  - [ ] Error: validation failures

- [ ] **Snapshot Tests**
  - [ ] All wizard steps
  - [ ] Stories list/detail
  - [ ] Dark mode variants
  - [ ] Accessibility sizes
  - [ ] All device sizes

- [ ] **Unit Tests**
  - [ ] APIClient mocked responses
  - [ ] ViewModel state transitions
  - [ ] Model encoding/decoding
  - [ ] Keychain operations

- [ ] **UI Tests**
  - [ ] Wizard flow end-to-end
  - [ ] Error state handling
  - [ ] Offline behavior

- [ ] **Accessibility**
  - [ ] VoiceOver labels
  - [ ] Dynamic Type support
  - [ ] Color contrast compliance
  - [ ] Reduce Motion support

---

## 📱 Platform-Specific Considerations

### iOS 18+

```swift
// 🎯 PhotosPicker with transferable
import PhotosUI

struct UploadStepView: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            DropZoneView()
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}
```

### macOS 13+

```swift
// 🖥️ Drag and Drop with NSItemProvider
struct DropZoneView: View {
    @Binding var droppedImage: NSImage?
    @State private var isTargeted = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isTargeted ? Color.accentColor : Color.gray, lineWidth: 2)
                .fill(isTargeted ? Color.accentColor.opacity(0.1) : Color.clear)

            // ... content
        }
        .dropDestination(for: Data.self) { items, _ in
            guard let item = items.first,
                  let image = NSImage(data: item) else { return false }
            droppedImage = image
            return true
        } isTargeted: { isTargeted in
            self.isTargeted = isTargeted
        }
    }
}
```

### watchOS 11+

```swift
// ⌚ WatchConnectivity for sync
import WatchConnectivity

actor WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()

    private var session: WCSession?

    func activate() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    nonisolated func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        // 🎵 Receive audio progress updates
        if let progress = applicationContext["audioProgress"] as? [String: Double] {
            Task { @MainActor in
                // Update UI
            }
        }
    }
}
```

---

## 🔐 Security Architecture

### Keychain Storage

```swift
// 🔑 KeychainManager Actor - Thread-safe secrets vault
actor KeychainManager: KeychainManagerProtocol {
    enum Key: String {
        case apiToken = "com.artfularchives.apiToken"
        case refreshToken = "com.artfularchives.refreshToken"
        case userId = "com.artfularchives.userId"
    }

    private let keychain = Keychain(
        service: "com.artfularchives.studio"
    )
    .accessibility(.afterFirstUnlock)

    func save(_ value: String, for key: Key) throws {
        try keychain.set(value, key: key.rawValue)
    }

    func retrieve(for key: Key) throws -> String? {
        try keychain.get(key.rawValue)
    }

    func delete(for key: Key) throws {
        try keychain.remove(key.rawValue)
    }
}
```

### API Authentication

```swift
// 🛡️ Auth interceptor for all requests
extension APIClient {
    private func addAuthHeader(to request: inout URLRequest) async throws {
        guard let token = try await keychainManager.retrieve(for: .apiToken) else {
            throw APIError.unauthorized
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    private func handleUnauthorized() async throws {
        // Attempt token refresh
        guard let refreshToken = try await keychainManager.retrieve(for: .refreshToken) else {
            throw APIError.unauthorized
        }

        // Call refresh endpoint...
    }
}
```

---

## 🌩️ Error Handling Strategy

### Error Types

```swift
// 🎭 The Error Taxonomy - Every failure has a story
enum AppError: LocalizedError, Identifiable {
    case network(NetworkError)
    case api(APIError)
    case validation(ValidationError)
    case storage(StorageError)
    case unknown(Error)

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .network(let error): error.localizedDescription
        case .api(let error): error.localizedDescription
        case .validation(let error): error.localizedDescription
        case .storage(let error): error.localizedDescription
        case .unknown(let error): error.localizedDescription
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network(.noConnection):
            "Check your internet connection and try again"
        case .api(.unauthorized):
            "Please sign in again"
        case .api(.rateLimited):
            "Too many requests. Please wait a moment"
        default:
            "Please try again"
        }
    }

    var icon: String {
        switch self {
        case .network: "wifi.slash"
        case .api(.unauthorized): "lock.shield"
        case .api(.serverError): "server.rack"
        default: "exclamationmark.triangle"
        }
    }
}

enum NetworkError: LocalizedError {
    case noConnection
    case timeout
    case cancelled

    var errorDescription: String? {
        switch self {
        case .noConnection: "No internet connection"
        case .timeout: "Request timed out"
        case .cancelled: "Request was cancelled"
        }
    }
}

enum APIError: LocalizedError {
    case unauthorized
    case notFound
    case serverError(Int)
    case rateLimited
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .unauthorized: "Authentication required"
        case .notFound: "Resource not found"
        case .serverError(let code): "Server error (\(code))"
        case .rateLimited: "Rate limit exceeded"
        case .invalidResponse: "Invalid server response"
        case .decodingError(let error): "Data parsing error: \(error.localizedDescription)"
        }
    }
}
```

### Toast System

```swift
// 🍞 The Toast Orchestra - Notifying users with style
@Observable
final class ToastManager {
    var currentToast: Toast?
    private var dismissTask: Task<Void, Never>?

    func show(_ toast: Toast, duration: TimeInterval = 3.0) {
        dismissTask?.cancel()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentToast = toast
        }

        dismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(duration))
            withAnimation(.easeOut(duration: 0.2)) {
                currentToast = nil
            }
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        withAnimation(.easeOut(duration: 0.2)) {
            currentToast = nil
        }
    }
}

struct Toast: Identifiable, Equatable {
    let id = UUID()
    let type: ToastType
    let title: String
    let message: String

    enum ToastType {
        case success, error, warning, info

        var icon: String {
            switch self {
            case .success: "checkmark.circle.fill"
            case .error: "xmark.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            case .info: "info.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .success: .green
            case .error: .red
            case .warning: .orange
            case .info: .blue
            }
        }
    }
}
```

---

## 🎬 Lottie Assets Recommendations

### Free Lottie Assets Sources

| Source | URL | Best For |
| -------- | ----- | ---------- |
| LottieFiles | <https://lottiefiles.com> | All animations |
| IconScout | <https://iconscout.com/lottie-animations> | Icons |
| Lordicon | <https://lordicon.com> | Micro-interactions |

### Recommended Animations

| Use Case | Animation Type | File Name |
| ---------- | --------------- | ----------- |
| Upload | Cloud with arrow | `upload-cloud.json` |
| Analyzing | Brain/thinking | `ai-analyzing.json` |
| Success | Confetti burst | `success-confetti.json` |
| Loading | Spinner/orbit | `loading-orbit.json` |
| Error | Sad face/warning | `error-alert.json` |
| Audio wave | Waveform equalizer | `audio-wave.json` |
| Translation | Globe/languages | `translate-globe.json` |

---

## 📋 API Configuration

### Environment Setup

```swift
// 🌍 Environment Configuration - The Cosmic Settings
enum AppEnvironment {
    case development
    case staging
    case production

    var baseURL: URL {
        switch self {
        case .development: URL(string: "http://localhost:8999")!
        case .staging: URL(string: "https://staging-api.artfularchives.com")!
        case .production: URL(string: "https://api.artfularchives.com")!
        }
    }

    var strapiURL: URL {
        switch self {
        case .development: URL(string: "http://localhost:1337")!
        case .staging: URL(string: "https://staging-cms.artfularchives.com")!
        case .production: URL(string: "https://cms.artfularchives.com")!
        }
    }

    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}
```

### VPS Connection Details

```text
Production Server: hostinger-vps
├── Python API: Port 8999
├── Strapi CMS: Port 1337
├── Supabase: External (cloud hosted)
└── OpenAI: External API
```

---

*Last Updated: December 26, 2025*
*Architecture Version: 1.0.0*
