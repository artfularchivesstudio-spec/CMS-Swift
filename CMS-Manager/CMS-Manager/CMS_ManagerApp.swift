//
//  CMS_ManagerApp.swift
//  CMS-Manager
//
//  🎭 The CMS Manager App - Grand Stage of Digital Storytelling
//
//  "Where dreams take form and stories find their wings,
//   this grand theater welcomes all who seek to craft
//   tales that echo through the halls of time."
//
//  - The Spellbinding Museum Director of the Grand Exhibition
//

import SwiftUI
import SwiftData

// MARK: - 🎭 CMS Manager App

/// 🎭 The main app entry point - where the magic begins
@main
struct CMS_ManagerApp: App {

    // MARK: - 🏺 App State

    /// 🏭 The singleton dependency container
    @State private var dependencies = Dependencies

    // MARK: - 🎭 Body

    var body: some Scene {
        WindowGroup {
            RootView()
                .withDependencies(dependencies)
                .modelContainer(dependencies.modelContainer)
                // 🎨 Global theme configuration
                .tint(.brandPrimary)
                .task {
                    // 🔑 Initialize API key before app loads
                    await initializeAPIKeyIfNeeded()
                }
                .onAppear {
                    setupAppearance()
                }
        }
    }

    // MARK: - 🔑 API Key Initialization

    /// 🔑 Initialize API key in keychain on first launch
    private func initializeAPIKeyIfNeeded() async {
        let keychain = dependencies.keychainManager

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

    // MARK: - 🎨 Appearance Setup

    /// 🎨 Configure the global appearance
    private func setupAppearance() {
        print("🎨 ✨ APPEARANCE CONFIGURATION AWAKENS!")

        // 🌙 Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        print("🎉 ✨ APPEARANCE MASTERPIECE COMPLETE!")
    }
}

// MARK: - 🏛️ Root View

/// 🏛️ The root view with tab navigation
private struct RootView: View {

    // MARK: - 🏺 Environment

    /// 🏋️ Selected tab
    @State private var selectedTab: Tab = .stories

    // MARK: - 🎭 Body

    var body: some View {
        TabView(selection: $selectedTab) {
            // 📚 Stories Tab
            StoriesListView()
                .tabItem {
                    Label("Stories", systemImage: Tab.stories.icon)
                }
                .tag(Tab.stories)

            // 🎨 Wizard Tab (Story Creator)
            PlaceholderView(title: "Story Wizard", icon: "wand.and.stars")
                .tabItem {
                    Label("Create", systemImage: Tab.wizard.icon)
                }
                .tag(Tab.wizard)

            // ⚙️ Settings Tab
            PlaceholderView(title: "Settings", icon: "gearshape")
                .tabItem {
                    Label("Settings", systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .tint(.brandPrimary)
    }
}

// MARK: - 📑 Tab Definition

/// 📑 The tabs in our app's navigation
enum Tab: String, CaseIterable {
    case stories
    case wizard
    case settings

    /// 🎨 SF Symbol icon for each tab
    var icon: String {
        switch self {
        case .stories: "book.closed"
        case .wizard: "wand.and.stars"
        case .settings: "gearshape"
        }
    }

    /// 📝 Name for accessibility
    var name: String {
        switch self {
        case .stories: "Stories"
        case .wizard: "Create Story"
        case .settings: "Settings"
        }
    }
}

// MARK: - 🌙 Placeholder View

/// 🌙 A simple placeholder view for tabs not yet implemented
private struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)

                Text(title)
                    .headlineLarge()

                Text("Coming soon...")
                    .bodyMedium(Color.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationTitle(title)
        }
    }
}

// MARK: - 🎨 Design System
// ✨ The complete design system is now organized in the Styles folder:
// - AppColors.swift: Comprehensive color palette with light/dark mode support
// - AppTypography.swift: Typography scale and text styles
// - AppSpacing.swift: Spacing system and layout constants
// - AppShadows.swift: Elevation and shadow system
// - AppButtonStyles.swift: Button components and styles
// - AppCardStyles.swift: Card container styles
