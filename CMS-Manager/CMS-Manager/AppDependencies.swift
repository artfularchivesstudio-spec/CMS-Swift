//
//  AppDependencies.swift
//  CMS-Manager
//
//  🏭 The App Dependencies - Grand Central Station of Services
//
//  "Where all the mystical components converge,
//   this great conductor orchestrates the symphony
//   of services that power our digital museum."
//
//  - The Spellbinding Museum Director of Architecture
//

import SwiftUI
import SwiftData

// MARK: - 🏭 App Dependencies

/// 🎭 The dependency container - holds all services
/// Note: @Observable is nonisolated(unsafe) to work with @MainActor properties
@Observable
final class AppDependencies: @unchecked Sendable {
    // MARK: - 🌐 Network
    /// 🌐 The API client - messenger to the Python backend
    let apiClient: APIClientProtocol

    // MARK: - 🔐 Security
    /// 🔐 The keychain manager - guardian of secrets
    let keychainManager: KeychainManagerProtocol

    // MARK: - 💾 Persistence
    /// 📦 The SwiftData model container
    let modelContainer: ModelContainer

    /// 💎 The cache manager - guardian of offline stories (basic caching)
    // TODO: Implement CacheManager
    // let cacheManager: CacheManager

    /// 🖼️ The story cache manager - master curator of offline stories with images
    let storyCacheManager: StoryCacheManager

    // MARK: - 🎨 UI
    /// 🍞 The toast manager - herald of notifications
    @MainActor let toastManager: ToastManager

    // MARK: - 🎵 Audio
    /// 🎵 The audio player - conductor of sound
    @MainActor let audioPlayer: AudioPlayerProtocol

    // MARK: - 🎭 Haptics
    /// 🌟 The haptic manager - maestro of tactile feedback
    @MainActor let hapticManager: HapticManager

    // MARK: - 🎭 Initialization
    /// 🌟 Create the dependency container
    @MainActor
    init(
        apiClient: APIClientProtocol,
        keychainManager: KeychainManagerProtocol,
        modelContainer: ModelContainer,
        // cacheManager: CacheManager,
        storyCacheManager: StoryCacheManager,
        toastManager: ToastManager,
        audioPlayer: AudioPlayerProtocol,
        hapticManager: HapticManager
    ) {
        print("🏭 ✨ APP DEPENDENCIES AWAKENS!")
        self.apiClient = apiClient
        self.keychainManager = keychainManager
        self.modelContainer = modelContainer
        // self.cacheManager = cacheManager
        self.storyCacheManager = storyCacheManager
        self.toastManager = toastManager
        self.audioPlayer = audioPlayer
        self.hapticManager = hapticManager
        print("🎉 ✨ APP DEPENDENCIES MASTERPIECE COMPLETE!")
    }

    /// 🎨 Convenience init for standard production setup
    @MainActor
    static func createStandard() -> AppDependencies {
        print("🏭 ✨ Creating standard dependencies...")

        // 🔐 Step 1: Create security
        let keychain = KeychainManager()
        print("🔐 ✨ Keychain guardian summoned")

        // 🔑 Step 1.5: Initialize API key (one-time setup)
        Task {
            await initializeAPIKey(keychain: keychain)
        }

        // 🌐 Step 2: Create network client
        let api = APIClient(keychain: keychain)
        print("🌐 ✨ API messenger dispatched")

        // 💾 Step 3: Setup persistence
        let schema = Schema([Item.self, CachedStory.self, CachedImage.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: schema, configurations: [config])
        print("💎 ✨ SwiftData vault constructed")

        // 💎 Step 4: Create cache managers
        // let cache = CacheManager(modelContainer: container)
        // print("💎 ✨ Cache guardian summoned")

        let storyCache = StoryCacheManager(modelContainer: container)
        print("🖼️ ✨ Story cache manager summoned")

        // 🍞 Step 5: Create toast manager
        let toast = ToastManager()
        print("🍞 ✨ Toast herald ready")

        // 🎵 Step 6: Create audio player
        let audio = AudioPlayer()
        print("🎵 ✨ Audio conductor ready")

        // 🎭 Step 7: Create haptic manager
        let haptics = HapticManager()
        print("🌟 ✨ Haptic maestro ready")

        return AppDependencies(
            apiClient: api,
            keychainManager: keychain,
            modelContainer: container,
            // cacheManager: cache,
            storyCacheManager: storyCache,
            toastManager: toast,
            audioPlayer: audio,
            hapticManager: haptics
        )
    }

    /// 🔑 Initialize API key in keychain (one-time setup)
    /// - Parameter keychain: The keychain manager instance
    private static func initializeAPIKey(keychain: KeychainManagerProtocol) async {
        // 🔍 Check if API key already exists
        if let existingToken = try? await keychain.retrieve(for: .apiToken), !existingToken.isEmpty {
            print("🔐 ✨ API key already present in keychain")
            return
        }

        // 🔑 The sacred API key - hardcoded for simplicity
        let apiKey = "5c95a2d09ebd15f772c1695b8518fc54021b421dfa84d4953d9002f76b6a20fc"

        do {
            try await keychain.save(apiKey, for: .apiToken)
            print("🎉 ✨ API key successfully stored in keychain!")
        } catch {
            print("💥 😭 Failed to save API key: \(error.localizedDescription)")
        }
    }
}

// MARK: - 🌙 Singleton

/// 🌙 Storage for the shared dependencies - uses Unmanaged for thread-safe lazy initialization
private let _dependenciesStorage: Unmanaged<AppDependencies> = {
    // We need to synchronously create dependencies at module load time
    // Use a MainActor.run with an unsafe assumption that we're on main thread
    // This is safe because the app startup always happens on main thread
    MainActor.assumeIsolated {
        let deps = AppDependencies.createStandard()
        return Unmanaged.passRetained(deps)
    }
}()

/// 🌙 Access the global dependencies instance
/// nonisolated(unsafe) is safe because we always access on main thread
nonisolated(unsafe) var Dependencies: AppDependencies {
    _dependenciesStorage.takeUnretainedValue()
}

// MARK: - 🧪 Mock Dependencies

/// 🧪 Mock dependencies for SwiftUI previews
@MainActor
extension AppDependencies {
    /// 🎭 Create mock dependencies for previews
    static var mock: AppDependencies {
        let container = try! ModelContainer(
            for: Schema([Item.self, CachedStory.self, CachedImage.self]),
            configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
        )
        return AppDependencies(
            apiClient: MockAPIClient(),
            keychainManager: KeychainManager(),
            modelContainer: container,
            // cacheManager: CacheManager(modelContainer: container),
            storyCacheManager: StoryCacheManager(modelContainer: container),
            toastManager: ToastManager(),
            audioPlayer: AudioPlayer(),
            hapticManager: HapticManager()
        )
    }
}

// MARK: - 🎨 Environment Key

/// 🌐 Environment key for dependencies
/// nonisolated(unsafe) is safe here since Environment values are always accessed on main thread
private struct DependenciesEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: AppDependencies = Dependencies
}

extension EnvironmentValues {
    /// 🏭 The app dependencies container
    var dependencies: AppDependencies {
        get { self[DependenciesEnvironmentKey.self] }
        set { self[DependenciesEnvironmentKey.self] = newValue }
    }
}

// MARK: - 🎭 View Extension

extension View {
    /// 🏭 Inject dependencies into the view hierarchy
    /// Note: @MainActor is required because AppDependencies holds @MainActor-isolated properties
    @MainActor
    func withDependencies(_ dependencies: AppDependencies = Dependencies) -> some View {
        environment(\.dependencies, dependencies)
    }
}
