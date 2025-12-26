# 🎭 Artful Archives Studio - Apple Ecosystem Architecture

> **Comprehensive implementation plan for iOS 18+, macOS 13+, watchOS 11+ native apps**

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Architecture](#system-architecture)
3. [Swift Package Dependencies](#swift-package-dependencies)
4. [API Endpoint Mapping](#api-endpoint-mapping)
5. [Data Flow Diagrams](#data-flow-diagrams)
6. [Wizard Flow Sequence Diagrams](#wizard-flow-sequence-diagrams)
7. [Testing Strategy](#testing-strategy)
8. [Implementation Checklist](#implementation-checklist)
9. [Critical Files Reference](#critical-files-reference)

---

## Executive Summary

Build native Apple platform apps that interface with the existing Python FastAPI backend at `hostinger-vps`. The apps will provide a 7-step story creation wizard with AI-powered image analysis, multilingual translation, and audio generation.

### Current State (CMS-Swift)
- ✅ Xcode project scaffolding with iOS + watchOS targets
- ✅ SwiftData persistence foundation
- ✅ ArtPiece model demonstrating code style
- ❌ No networking layer
- ❌ No story wizard implementation
- ❌ No API integration

### Target Architecture
```
┌─────────────────────────────────────────────────────────────────────┐
│                        Apple Ecosystem                               │
├─────────────────┬─────────────────┬─────────────────────────────────┤
│   iOS 18+ App   │  macOS 13+ App  │        watchOS 11+ App          │
│  (Primary UX)   │ (Power Users)   │     (Companion/Status)          │
├─────────────────┴─────────────────┴─────────────────────────────────┤
│                   ArtfulArchivesCore (Swift Package)                 │
│   ┌─────────────┬─────────────────┬──────────────────┐              │
│   │   Domain    │      Data       │     Shared       │              │
│   │  (Models,   │  (APIClient,    │  (Extensions,    │              │
│   │  UseCases)  │  Keychain)      │   Helpers)       │              │
│   └─────────────┴─────────────────┴──────────────────┘              │
└─────────────────────────────────────────────────────────────────────┘
                              │ HTTPS
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Python FastAPI Backend                            │
│                  (hostinger-vps:8080)                                │
│  ┌──────────────┬───────────────┬────────────────┐                  │
│  │ StoryHandler │ Supabase DB   │ OpenAI APIs    │                  │
│  │              │               │ (Vision, TTS)  │                  │
│  └──────────────┴───────────────┴────────────────┘                  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## System Architecture

### Project Structure (Final)

```
/Users/admin/Developer/CMS-Swift/
├── CMS-Manager/
│   ├── CMS-Manager.xcodeproj           # Xcode project file
│   ├── CMS-Manager/                     # iOS/macOS multiplatform target
│   │   ├── CMS_ManagerApp.swift         # App entry point
│   │   ├── Features/
│   │   │   ├── StoryWizard/
│   │   │   │   ├── StoryWizardView.swift
│   │   │   │   ├── StoryWizardViewModel.swift
│   │   │   │   ├── Steps/
│   │   │   │   │   ├── UploadStepView.swift
│   │   │   │   │   ├── AnalyzingStepView.swift
│   │   │   │   │   ├── ReviewStepView.swift
│   │   │   │   │   ├── TranslationStepView.swift
│   │   │   │   │   ├── TranslationReviewStepView.swift
│   │   │   │   │   ├── AudioStepView.swift
│   │   │   │   │   └── FinalizeStepView.swift
│   │   │   ├── StoriesList/
│   │   │   │   ├── StoriesListView.swift
│   │   │   │   └── StoryDetailView.swift
│   │   │   └── Settings/
│   │   │       └── SettingsView.swift
│   │   ├── UI/
│   │   │   ├── Components/
│   │   │   │   ├── ToastView.swift
│   │   │   │   ├── ProgressIndicator.swift
│   │   │   │   └── LanguageSelector.swift
│   │   │   ├── Animations/
│   │   │   │   ├── SparkleModifier.swift
│   │   │   │   ├── ShimmerModifier.swift
│   │   │   │   └── PulseModifier.swift
│   │   │   └── Styles/
│   │   │       └── DesignSystem.swift
│   │   └── Assets.xcassets/
│   ├── CMS-Watch Watch App/             # watchOS target
│   ├── Packages/
│   │   └── ArtfulArchivesCore/          # Swift Package (shared code)
│   │       ├── Package.swift
│   │       └── Sources/
│   │           └── ArtfulArchivesCore/
│   │               ├── Domain/
│   │               │   ├── Models/
│   │               │   │   ├── Story.swift
│   │               │   │   ├── Translation.swift
│   │               │   │   ├── AudioAsset.swift
│   │               │   │   └── ImageAnalysis.swift
│   │               │   ├── UseCases/
│   │               │   │   ├── UploadMediaUseCase.swift
│   │               │   │   ├── AnalyzeImageUseCase.swift
│   │               │   │   ├── CreateStoryUseCase.swift
│   │               │   │   ├── TranslateContentUseCase.swift
│   │               │   │   └── GenerateAudioUseCase.swift
│   │               │   └── Repositories/
│   │               │       ├── StoryRepository.swift
│   │               │       └── MediaRepository.swift
│   │               ├── Data/
│   │               │   ├── API/
│   │               │   │   ├── APIClient.swift
│   │               │   │   ├── Endpoints.swift
│   │               │   │   ├── DTOs/
│   │               │   │   │   ├── MediaUploadDTO.swift
│   │               │   │   │   ├── ImageAnalysisDTO.swift
│   │               │   │   │   ├── TranslationDTO.swift
│   │               │   │   │   ├── AudioGenerationDTO.swift
│   │               │   │   │   └── StoryDTO.swift
│   │               │   │   └── Mappers/
│   │               │   │       └── StoryMapper.swift
│   │               │   └── Storage/
│   │               │       └── KeychainManager.swift
│   │               └── Shared/
│   │                   ├── Extensions/
│   │                   └── Helpers/
│   └── Tests/
│       ├── UnitTests/
│       └── SnapshotTests/
└── Architecture.md                       # THIS FILE
```

---

## Swift Package Dependencies

### Package.swift (ArtfulArchivesCore)

```swift
// swift-tools-version: 6.0
import PackageDescription

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
        // 🎨 ANIMATION & UI
        // Lottie - Complex animations from After Effects
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.3.0"),

        // ConfettiSwiftUI - Celebration effects
        .package(url: "https://github.com/simibac/ConfettiSwiftUI.git", from: "1.1.0"),

        // SwiftUI-Shimmer - Loading skeleton effects
        .package(url: "https://github.com/markiv/SwiftUI-Shimmer.git", from: "1.4.0"),

        // 🔊 AUDIO
        // DSWaveformImage - Audio waveform visualization
        .package(url: "https://github.com/dmrschmidt/DSWaveformImage.git", from: "14.0.0"),

        // 🖼️ IMAGE LOADING
        // Kingfisher - Async image loading with caching
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.12.0"),

        // 📝 MARKDOWN
        // swift-markdown-ui - Markdown rendering in SwiftUI
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", from: "2.4.0"),

        // 🔐 SECURITY
        // KeychainAccess - Simplified Keychain wrapper
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),

        // 🧪 TESTING (dev dependency)
        // SnapshotTesting - UI regression testing
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.0"),
    ],
    targets: [
        .target(
            name: "ArtfulArchivesCore",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "ConfettiSwiftUI", package: "ConfettiSwiftUI"),
                .product(name: "Shimmer", package: "SwiftUI-Shimmer"),
                .product(name: "DSWaveformImage", package: "DSWaveformImage"),
                .product(name: "DSWaveformImageViews", package: "DSWaveformImage"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
            ]
        ),
        .testTarget(
            name: "ArtfulArchivesCoreTests",
            dependencies: [
                "ArtfulArchivesCore",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)
```

### Additional Recommended Packages

| Purpose | Package | SPM URL | Version |
|---------|---------|---------|---------|
| Hero Transitions | Hero | `https://github.com/HeroTransitions/Hero.git` | 1.6.3+ |
| Toast Notifications | AlertToast | `https://github.com/elai950/AlertToast.git` | 1.3.9+ |
| Networking Logger | Pulse | `https://github.com/kean/Pulse.git` | 4.2.0+ |
| SwiftUI Extensions | SwiftUIX | `https://github.com/SwiftUIX/SwiftUIX.git` | 0.2.0+ |
| Date Formatting | SwiftDate | `https://github.com/malcommac/SwiftDate.git` | 7.0.0+ |

### Lottie Animation Assets (Free Sources)

| Animation | Source | Use Case |
|-----------|--------|----------|
| Loading Spinner | LottieFiles.com | Analyzing step |
| Success Checkmark | LottieFiles.com | Step completion |
| Sparkle/Magic | LottieFiles.com | Creation success |
| Audio Wave | LottieFiles.com | Audio generation |
| Language Globe | LottieFiles.com | Translation step |
| Upload Arrow | LottieFiles.com | Upload step |
| Celebration Confetti | LottieFiles.com | Finalize step |

---

## API Endpoint Mapping

### Python Backend Endpoints → Swift DTOs

```
┌──────────────────────────────────────────────────────────────────────┐
│                     Python FastAPI (Port 8080)                        │
├──────────────────────────┬───────────────────────────────────────────┤
│ Endpoint                 │ Swift DTO / Model                         │
├──────────────────────────┼───────────────────────────────────────────┤
│ POST /api/v1/upload-media│ MediaUploadRequest → MediaUploadResponse  │
│ POST /api/v1/analyze-image│ ImageAnalysisRequest → ImageAnalysisResp │
│ POST /api/v1/translate   │ TranslationRequest → TranslationResponse  │
│ POST /api/v1/generate-audio│ AudioGenRequest → AudioGenerationResp   │
│ POST /api/v1/create-story-complete│ StoryCreateRequest → StoryResp  │
│ GET  /api/v1/stories     │ — → [StoryDTO]                            │
│ GET  /api/v1/stories/{id}│ — → StoryDTO                              │
│ PUT  /api/v1/stories/{id}│ StoryUpdateRequest → StoryDTO             │
│ DELETE /api/v1/stories/{id}│ — → SuccessResponse                     │
│ POST /api/v1/stories/{id}/translations│ TranslationsReq → StoryDTO  │
│ GET  /api/v1/health      │ — → HealthCheckResponse                   │
└──────────────────────────┴───────────────────────────────────────────┘
```

### Domain Models (Swift)

```swift
// 🎭 Story - The Main Character
struct Story: Identifiable, Codable, Sendable {
    let id: Int
    let documentId: String
    let title: String
    let slug: String
    let content: String
    let workflowStage: WorkflowStage
    let translations: [LanguageCode: StoryTranslation]
    let audioAssets: [LanguageCode: AudioAsset]
    let coverImageUrl: String?
    let createdAt: Date
    let updatedAt: Date
}

// 🌐 Language - Our Multilingual Cast
enum LanguageCode: String, Codable, CaseIterable, Sendable {
    case en = "en"
    case es = "es"
    case hi = "hi"

    var flag: String {
        switch self {
        case .en: return "🇺🇸"
        case .es: return "🇪🇸"
        case .hi: return "🇮🇳"
        }
    }

    var displayName: String {
        switch self {
        case .en: return "English"
        case .es: return "Spanish"
        case .hi: return "Hindi"
        }
    }
}

// 🎬 Workflow Stage - The Story's Journey
enum WorkflowStage: String, Codable, Sendable {
    case draft = "draft"
    case analyzing = "analyzing"
    case reviewed = "reviewed"
    case translating = "translating"
    case translated = "translated"
    case generating_audio = "generating_audio"
    case complete = "complete"
    case published = "published"
}
```

---

## Data Flow Diagrams

### Overall System Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              iOS/macOS App                               │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                      StoryWizardViewModel                          │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐ │  │
│  │  │ Upload  │→ │ Analyze │→ │ Review  │→ │Translate│→ │  Audio  │ │  │
│  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘ │  │
│  └───────┼───────────┼───────────┼───────────┼───────────┼──────────┘  │
│          │           │           │           │           │              │
│          ▼           ▼           ▼           ▼           ▼              │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                        Use Cases Layer                             │  │
│  │  UploadMedia   AnalyzeImage  CreateStory  Translate  GenerateAudio │  │
│  └───────────────────────────────┬───────────────────────────────────┘  │
│                                  │                                       │
│                                  ▼                                       │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                       APIClient (Actor)                            │  │
│  │  • Thread-safe network requests                                    │  │
│  │  • Automatic token refresh                                         │  │
│  │  • Request/response logging                                        │  │
│  └───────────────────────────────┬───────────────────────────────────┘  │
└──────────────────────────────────┼───────────────────────────────────────┘
                                   │ HTTPS
                                   ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         Python FastAPI Backend                            │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────────────────┐  │
│  │  StoryHandler  │  │   Supabase     │  │       OpenAI APIs          │  │
│  │  (Orchestrator)│→ │  (Database)    │  │  • GPT-4o Vision           │  │
│  │                │  │  (Storage)     │  │  • Whisper TTS             │  │
│  └────────────────┘  └────────────────┘  └────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```

### Authentication Flow

```
┌─────────────┐          ┌─────────────┐          ┌─────────────┐
│   iOS App   │          │  Keychain   │          │  API Server │
└──────┬──────┘          └──────┬──────┘          └──────┬──────┘
       │                        │                        │
       │ 1. Check for token     │                        │
       │───────────────────────>│                        │
       │                        │                        │
       │ 2. Token found/not     │                        │
       │<───────────────────────│                        │
       │                        │                        │
       │ 3. API Request + Bearer Token                   │
       │─────────────────────────────────────────────────>
       │                        │                        │
       │ 4. 401 Unauthorized (if token expired)          │
       │<─────────────────────────────────────────────────
       │                        │                        │
       │ 5. Refresh token flow  │                        │
       │───────────────────────>│                        │
       │                        │                        │
       │ 6. New token stored    │                        │
       │<───────────────────────│                        │
       │                        │                        │
       │ 7. Retry request       │                        │
       │─────────────────────────────────────────────────>
       │                        │                        │
       │ 8. Success response    │                        │
       │<─────────────────────────────────────────────────
       ▼                        ▼                        ▼
```

---

## Wizard Flow Sequence Diagrams

### Step 1: Upload Media

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ UploadStep  │     │  ViewModel  │     │  APIClient  │     │ Python API  │
│    View     │     │             │     │   (Actor)   │     │             │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ 1. PhotosPicker   │                   │                   │
       │   selected image  │                   │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │                   │ 2. Upload image   │                   │
       │                   │──────────────────>│                   │
       │                   │                   │                   │
       │                   │                   │ 3. POST           │
       │                   │                   │ /upload-media     │
       │                   │                   │──────────────────>│
       │                   │                   │                   │
       │                   │                   │ 4. MediaUpload    │
       │                   │                   │    Response       │
       │                   │                   │<──────────────────│
       │                   │                   │                   │
       │                   │ 5. imageUrl,      │                   │
       │                   │    imageId        │                   │
       │                   │<──────────────────│                   │
       │                   │                   │                   │
       │ 6. Show preview   │                   │                   │
       │   Enable "Next"   │                   │                   │
       │<──────────────────│                   │                   │
       ▼                   ▼                   ▼                   ▼
```

### Step 2: Analyze Image

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ AnalyzeStep │     │  ViewModel  │     │  APIClient  │     │ Python API  │
│    View     │     │             │     │   (Actor)   │     │ + OpenAI    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ 1. View appears   │                   │                   │
       │   (auto-start)    │                   │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │ 2. Show Lottie    │ 3. Analyze image  │                   │
       │    animation      │──────────────────>│                   │
       │<──────────────────│                   │                   │
       │                   │                   │ 4. POST           │
       │                   │                   │ /analyze-image    │
       │                   │                   │──────────────────>│
       │                   │                   │                   │
       │                   │                   │      ⏳            │
       │                   │                   │   GPT-4o Vision   │
       │                   │                   │      ⏳            │
       │                   │                   │                   │
       │                   │                   │ 5. ImageAnalysis  │
       │                   │                   │  {title, content, │
       │                   │                   │   tags}           │
       │                   │                   │<──────────────────│
       │                   │                   │                   │
       │                   │ 6. Update state   │                   │
       │                   │<──────────────────│                   │
       │                   │                   │                   │
       │ 7. Hide animation │                   │                   │
       │   Show ✓ success  │                   │                   │
       │   Auto-advance    │                   │                   │
       │<──────────────────│                   │                   │
       ▼                   ▼                   ▼                   ▼
```

### Steps 3-7: Full Wizard Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         WIZARD STATE MACHINE                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   ┌─────────┐      ┌───────────┐      ┌─────────┐      ┌───────────┐   │
│   │ UPLOAD  │─────>│ ANALYZING │─────>│ REVIEW  │─────>│ TRANSLATE │   │
│   │ Step 1  │      │  Step 2   │      │ Step 3  │      │  Step 4   │   │
│   └─────────┘      └───────────┘      └─────────┘      └───────────┘   │
│        ▲                                   │                   │        │
│        │                                   │                   ▼        │
│   ┌────┴────┐                              │          ┌─────────────┐   │
│   │  BACK   │<─────────────────────────────┤          │ TRANSLATION │   │
│   │         │                              │          │   REVIEW    │   │
│   └─────────┘                              │          │   Step 5    │   │
│                                            │          └──────┬──────┘   │
│                                            │                 │          │
│   ┌─────────┐      ┌───────────┐      ┌───┴─────┐           │          │
│   │FINALIZE │<─────│   AUDIO   │<─────│  SAVE   │<──────────┘          │
│   │ Step 7  │      │  Step 6   │      │Translate│                      │
│   └─────────┘      └───────────┘      └─────────┘                      │
│        │                                                                │
│        ▼                                                                │
│   ┌─────────┐                                                           │
│   │COMPLETE │  🎉 Confetti Animation                                    │
│   └─────────┘                                                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Audio Generation with Live Activity (iOS)

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ AudioStep   │     │  ViewModel  │     │LiveActivity │     │ Python API  │
│    View     │     │             │     │  Manager    │     │ + OpenAI TTS│
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       │ 1. Tap "Generate" │                   │                   │
       │   for [en,es,hi]  │                   │                   │
       │──────────────────>│                   │                   │
       │                   │                   │                   │
       │                   │ 2. Start Live     │                   │
       │                   │    Activity       │                   │
       │                   │──────────────────>│                   │
       │                   │                   │                   │
       │                   │                   │ 3. Show Dynamic   │
       │                   │                   │    Island         │
       │                   │                   │                   │
       │                   │ 4. Loop: for each language            │
       │                   │─────────────────────────────────────────────┐
       │                   │                   │                   │     │
       │                   │                   │                   │     │
       │ 5. Update UI      │ 6. POST /generate-audio               │     │
       │<──────────────────│──────────────────────────────────────>│     │
       │                   │                   │                   │     │
       │                   │                   │      ⏳            │     │
       │                   │ 7. Update Live    │   TTS Generation  │     │
       │                   │    Activity       │      ⏳            │     │
       │                   │   (30%, 60%, ...)│                   │     │
       │                   │──────────────────>│                   │     │
       │                   │                   │                   │     │
       │                   │ 8. Audio URL      │                   │     │
       │                   │<──────────────────────────────────────│     │
       │                   │                   │                   │     │
       │<──────────────────────────────────────────────────────────┘     │
       │                   │                   │                   │
       │ 9. Show ✓ all     │ 10. End Live     │                   │
       │    languages done │     Activity      │                   │
       │<──────────────────│──────────────────>│                   │
       ▼                   ▼                   ▼                   ▼
```

---

## Testing Strategy

### Snapshot Testing (Replacing Playwright)

Use **SnapshotTesting** by Point-Free for UI regression testing:

```swift
import SnapshotTesting
import XCTest
@testable import CMS_Manager

final class StoryWizardSnapshotTests: XCTestCase {

    // 📸 Test upload step in all states
    func testUploadStepView_idle() {
        let view = UploadStepView(viewModel: .preview)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone15Pro)))
    }

    func testUploadStepView_withImage() {
        let viewModel = StoryWizardViewModel.preview
        viewModel.selectedImage = UIImage(named: "test-artwork")
        let view = UploadStepView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone15Pro)))
    }

    func testUploadStepView_uploading() {
        let viewModel = StoryWizardViewModel.preview
        viewModel.uploadState = .uploading
        let view = UploadStepView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone15Pro)))
    }

    // 🌙 Dark mode variants
    func testUploadStepView_darkMode() {
        let view = UploadStepView(viewModel: .preview)
            .preferredColorScheme(.dark)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone15Pro)))
    }

    // 📱 Device variants
    func testUploadStepView_iPad() {
        let view = UploadStepView(viewModel: .preview)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPadPro12_9)))
    }
}
```

### Test Matrix

| Test Type | Tool | Coverage Target |
|-----------|------|-----------------|
| Unit Tests | XCTest + Swift Testing | 90% for Use Cases |
| Snapshot Tests | SnapshotTesting | All UI states (idle, loading, error, success) |
| API Mocking | URLProtocol stubs | All endpoints |
| Integration | XCTest async | Happy paths |
| Accessibility | AccessibilitySnapshot | All interactive elements |

### Snapshot Test Directory Structure

```
Tests/
├── SnapshotTests/
│   ├── __Snapshots__/           # Auto-generated reference images
│   │   ├── UploadStepViewTests/
│   │   ├── AnalyzingStepViewTests/
│   │   ├── ReviewStepViewTests/
│   │   └── ...
│   ├── UploadStepViewTests.swift
│   ├── AnalyzingStepViewTests.swift
│   ├── ReviewStepViewTests.swift
│   ├── TranslationStepViewTests.swift
│   ├── AudioStepViewTests.swift
│   ├── FinalizeStepViewTests.swift
│   └── AccessibilityTests.swift
└── UnitTests/
    ├── UseCases/
    │   ├── UploadMediaUseCaseTests.swift
    │   ├── AnalyzeImageUseCaseTests.swift
    │   └── ...
    ├── API/
    │   ├── APIClientTests.swift
    │   └── EndpointTests.swift
    └── Models/
        ├── StoryTests.swift
        └── TranslationTests.swift
```

---

## Implementation Checklist

### Phase 1: Foundation

- [ ] **Create Swift Package structure**
  - [ ] Initialize `Packages/ArtfulArchivesCore/Package.swift`
  - [ ] Add all SPM dependencies (Lottie, Kingfisher, KeychainAccess, etc.)
  - [ ] Create folder structure: Domain, Data, Shared

- [ ] **Implement Domain Models**
  - [ ] `Story.swift` - Main story model with Codable conformance
  - [ ] `Translation.swift` - Per-language translation model
  - [ ] `AudioAsset.swift` - Audio URL and metadata
  - [ ] `ImageAnalysis.swift` - GPT-4o Vision response
  - [ ] `LanguageCode.swift` - Enum with en/es/hi
  - [ ] `WorkflowStage.swift` - State machine enum

- [ ] **Implement APIClient Actor**
  - [ ] Thread-safe request execution
  - [ ] Bearer token injection from Keychain
  - [ ] 401 handling with token refresh
  - [ ] Request/response logging
  - [ ] Multipart file upload support

- [ ] **Implement Endpoints**
  - [ ] `POST /api/v1/upload-media`
  - [ ] `POST /api/v1/analyze-image`
  - [ ] `POST /api/v1/translate`
  - [ ] `POST /api/v1/generate-audio`
  - [ ] `POST /api/v1/create-story-complete`
  - [ ] `GET/PUT/DELETE /api/v1/stories/{id}`
  - [ ] `POST /api/v1/stories/{id}/translations`

- [ ] **Implement KeychainManager**
  - [ ] Save/retrieve API token
  - [ ] Secure storage with `kSecAttrAccessibleAfterFirstUnlock`

### Phase 2: Wizard Flow

- [ ] **Create StoryWizardViewModel**
  - [ ] `@Observable` class with step state machine
  - [ ] Published properties for each step's data
  - [ ] Navigation logic (next/back/skip)
  - [ ] Error handling and retry

- [ ] **Implement Wizard Steps**
  - [ ] `UploadStepView.swift`
    - [ ] PhotosPicker integration
    - [ ] Drag-and-drop (macOS)
    - [ ] Image preview with shimmer loading
  - [ ] `AnalyzingStepView.swift`
    - [ ] Lottie loading animation
    - [ ] Auto-start on appear
    - [ ] Success checkmark transition
  - [ ] `ReviewStepView.swift`
    - [ ] Editable title, content, slug
    - [ ] Markdown preview
    - [ ] Tag editor
  - [ ] `TranslationStepView.swift`
    - [ ] Language picker (en/es/hi)
    - [ ] Progress per language
    - [ ] Parallel translation support
  - [ ] `TranslationReviewStepView.swift`
    - [ ] Side-by-side comparison
    - [ ] Edit capabilities
    - [ ] Save translations
  - [ ] `AudioStepView.swift`
    - [ ] Voice selector (nova, alloy, etc.)
    - [ ] Speed slider (0.25-4.0)
    - [ ] Waveform visualization
    - [ ] Progress per language
  - [ ] `FinalizeStepView.swift`
    - [ ] Summary view
    - [ ] Confetti celebration
    - [ ] "Create Another" / "View Story" actions

### Phase 3: Stories Management

- [ ] **StoriesListView**
  - [ ] Fetch stories from API
  - [ ] Search and filter
  - [ ] Pull-to-refresh
  - [ ] Swipe-to-delete

- [ ] **StoryDetailView**
  - [ ] Full story display
  - [ ] Audio playback controls
  - [ ] Translation tabs
  - [ ] Edit mode

### Phase 4: Platform Extensions

- [ ] **Live Activity (iOS 18+)**
  - [ ] `AudioGenerationAttributes`
  - [ ] Dynamic Island compact/expanded views
  - [ ] Lock screen widget
  - [ ] Progress updates

- [ ] **watchOS Companion**
  - [ ] WatchConnectivity setup
  - [ ] Recent stories list
  - [ ] Audio status complications
  - [ ] Haptic notifications

- [ ] **macOS Enhancements**
  - [ ] Menu bar quick actions
  - [ ] Keyboard shortcuts
  - [ ] Native drag-and-drop

### Phase 5: Polish & Testing

- [ ] **Animations**
  - [ ] SparkleModifier
  - [ ] ShimmerModifier
  - [ ] PulseModifier
  - [ ] SuccessCheckmark path animation

- [ ] **Toast System**
  - [ ] ToastManager with @Observable
  - [ ] Toast types: success, error, warning, info
  - [ ] Auto-dismiss with haptics

- [ ] **Testing**
  - [ ] Snapshot tests for all UI states
  - [ ] Unit tests for use cases
  - [ ] API mocking with URLProtocol
  - [ ] Accessibility audit

---

## Critical Files Reference

### VPS Backend Files

| Purpose | Path |
|---------|------|
| API Endpoints | `/root/api-gateway/backend-python/backend.py` |
| Story Handler | `/root/api-gateway/backend-python/story_handler.py` |
| Pydantic Models | `/root/api-gateway/backend-python/story_models.py` |
| Upload Wizard | `/root/website/src/components/admin/wizard/UploadStep.tsx` |
| Audio Options | `/root/website/src/components/admin/wizard/AudioStep.tsx` |
| Translation Flow | `/root/website/src/components/admin/wizard/TranslationStep.tsx` |
| Features List | `/root/Features.md` |
| TODO | `/root/TODO.md` |
| Roadmap | `/root/ROADMAP.md` |

### Local CMS-Swift Files

| Purpose | Path |
|---------|------|
| App Entry | `/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/CMS_ManagerApp.swift` |
| Main View | `/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/ContentView.swift` |
| SwiftData Model | `/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/Item.swift` |
| Art Model (Example) | `/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/ArtPiece.swift` |
| Watch App | `/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Watch Watch App/` |
| README Spec | `/Users/admin/Developer/CMS-Swift/README.md` |

---

## Summary

This architecture provides a complete blueprint for implementing the Artful Archives Studio Apple ecosystem apps. The plan leverages:

1. **Modern Swift 6.0** with strict concurrency and actors
2. **SwiftUI** with `@Observable` macro (no Combine)
3. **Curated SPM dependencies** for animation, testing, and security
4. **Snapshot testing** to replace Playwright for UI regression
5. **Clean architecture** with Domain/Data/Presentation layers
6. **Live Activities** for real-time audio generation progress

The implementation is structured in 5 phases, each building on the previous, with clear deliverables and testing requirements.
