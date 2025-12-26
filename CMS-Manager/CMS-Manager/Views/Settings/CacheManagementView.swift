//
//  CacheManagementView.swift
//  CMS-Manager
//
//  💎 The Cache Management View - Master Control for Offline Treasures
//
//  "Where the curator tends to the digital vault,
//   monitoring space, managing stories, and ensuring
//   the offline experience remains pristine and performant."
//
//  - The Spellbinding Museum Director of Cache Administration
//

import SwiftUI

// MARK: - 💎 Cache Management View

/// 💎 View for managing cached stories and images
struct CacheManagementView: View {

    // MARK: - 🏺 Environment

    /// 🏭 App dependencies
    @Environment(\.dependencies) private var dependencies

    // MARK: - 🌟 State

    /// 📊 Cache statistics
    @State private var cacheStats: CacheStats?

    /// ⏳ Loading state
    @State private var isLoading = true

    /// 🗑️ Is clearing cache in progress?
    @State private var isClearingCache = false

    /// 🧹 Is removing stale entries?
    @State private var isRemovingStale = false

    /// ✅ Show clear cache confirmation
    @State private var showClearCacheAlert = false

    /// ✅ Auto-cache stories when viewing them
    @AppStorage("autoCacheStories") private var autoCacheStories = true

    /// 📅 Auto-remove cache older than (days)
    @AppStorage("cacheMaxAgeDays") private var cacheMaxAgeDays = 30

    // MARK: - 🎭 Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // 📊 Statistics Card
                        statisticsCard

                        // ⚙️ Settings Card
                        settingsCard

                        // 🛠️ Actions Card
                        actionsCard

                        // 📝 Info Card
                        infoCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Cache Management")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await loadCacheStats()
            }
            .refreshable {
                await loadCacheStats()
            }
            .alert("Clear All Cache?", isPresented: $showClearCacheAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    Task {
                        await clearAllCache()
                    }
                }
            } message: {
                Text("This will delete all cached stories and images. You'll need to download them again for offline access.")
            }
        }
    }

    // MARK: - 📊 Statistics Card

    /// 📊 Display cache statistics
    private var statisticsCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentColor)

                Text("Cache Statistics")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))

            Divider()

            if let stats = cacheStats {
                VStack(spacing: 0) {
                    // Stories count
                    statisticRow(
                        icon: "book.closed.fill",
                        title: "Cached Stories",
                        value: "\(stats.totalCachedStories)",
                        detail: "\(stats.freshCachedStories) fresh, \(stats.staleCachedStories) stale"
                    )

                    Divider()
                        .padding(.leading, 56)

                    // Images count
                    statisticRow(
                        icon: "photo.fill",
                        title: "Cached Images",
                        value: "\(stats.totalCachedImages)",
                        detail: formatBytes(stats.totalImageSize)
                    )

                    Divider()
                        .padding(.leading, 56)

                    // Disk usage
                    statisticRow(
                        icon: "internaldrive.fill",
                        title: "Disk Usage",
                        value: formatBytes(stats.diskUsage),
                        detail: progressDescription(for: stats.diskUsage),
                        showProgress: true,
                        progress: diskUsagePercentage(stats.diskUsage)
                    )

                    if let oldestDate = stats.oldestCacheDate {
                        Divider()
                            .padding(.leading, 56)

                        statisticRow(
                            icon: "clock.fill",
                            title: "Oldest Cache",
                            value: oldestDate.formatted(.relative(presentation: .named)),
                            detail: oldestDate.formatted(date: .abbreviated, time: .omitted)
                        )
                    }
                }
                .padding(.vertical, 8)
            } else {
                Text("Loading cache statistics...")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 📊 A single statistic row
    private func statisticRow(
        icon: String,
        title: String,
        value: String,
        detail: String,
        showProgress: Bool = false,
        progress: Double = 0
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.accentColor)
                .frame(width: 32, height: 32)
                .background(Color.accentColor.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    Text(detail)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    if showProgress {
                        ProgressView(value: progress)
                            .scaleEffect(y: 0.5)
                            .frame(maxWidth: 80)
                    }
                }
            }

            Spacer()

            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - ⚙️ Settings Card

    /// ⚙️ Cache settings
    private var settingsCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "gear")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentColor)

                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))

            Divider()

            VStack(spacing: 0) {
                // Auto-cache toggle
                Toggle(isOn: $autoCacheStories) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.accentColor)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Auto-Cache Stories")
                                .font(.system(size: 14, weight: .medium))

                            Text("Automatically cache stories when viewing them")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                Divider()
                    .padding(.leading, 56)

                // Cache age setting
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.accentColor)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Keep Cache For")
                            .font(.system(size: 14, weight: .medium))

                        Text("Auto-remove cache older than this")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Picker("Days", selection: $cacheMaxAgeDays) {
                        Text("7 days").tag(7)
                        Text("14 days").tag(14)
                        Text("30 days").tag(30)
                        Text("60 days").tag(60)
                        Text("90 days").tag(90)
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 🛠️ Actions Card

    /// 🛠️ Cache management actions
    private var actionsCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentColor)

                Text("Actions")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))

            Divider()

            VStack(spacing: 0) {
                // Remove stale cache
                actionButton(
                    icon: "trash.circle.fill",
                    title: "Remove Stale Cache",
                    subtitle: "Delete cache older than \(cacheMaxAgeDays) days",
                    color: .orange,
                    isLoading: isRemovingStale
                ) {
                    await removeStaleCache()
                }

                Divider()
                    .padding(.leading, 56)

                // Clear all cache
                actionButton(
                    icon: "xmark.circle.fill",
                    title: "Clear All Cache",
                    subtitle: "Delete all cached stories and images",
                    color: .red,
                    isLoading: isClearingCache
                ) {
                    showClearCacheAlert = true
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 🛠️ An action button row
    private func actionButton(
        icon: String,
        title: String,
        subtitle: String,
        color: Color,
        isLoading: Bool,
        action: @escaping () async -> Void
    ) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .disabled(isLoading)
    }

    // MARK: - 📝 Info Card

    /// 📝 Information about cache
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.accentColor)

                Text("About Cache")
                    .font(.system(size: 16, weight: .semibold))
            }

            Text("Cached stories are stored locally on your device for offline access. This allows you to browse stories even without an internet connection.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Images are downloaded separately and stored in the app's cache directory. The cache is automatically managed to prevent excessive storage usage.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 🔄 Actions

    /// 📊 Load cache statistics
    private func loadCacheStats() async {
        isLoading = true

        do {
            let stats = try await dependencies.storyCacheManager.getCacheStats()
            cacheStats = stats
            print("📊 Cache stats loaded: \(stats.formattedDescription)")
        } catch {
            print("🌩️ Failed to load cache stats: \(error.localizedDescription)")
        }

        isLoading = false
    }

    /// 🗑️ Clear all cache
    private func clearAllCache() async {
        isClearingCache = true

        do {
            try await dependencies.storyCacheManager.clearCache()
            await dependencies.toastManager.show("Cache cleared successfully", type: .success)
            await loadCacheStats()

            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            await dependencies.toastManager.show("Failed to clear cache", type: .error)
            print("🌩️ Failed to clear cache: \(error.localizedDescription)")
        }

        isClearingCache = false
    }

    /// 🧹 Remove stale cache entries
    private func removeStaleCache() async {
        isRemovingStale = true

        do {
            try await dependencies.storyCacheManager.removeStaleCache(olderThanDays: cacheMaxAgeDays)
            await dependencies.toastManager.show("Stale cache removed", type: .success)
            await loadCacheStats()

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            await dependencies.toastManager.show("Failed to remove stale cache", type: .error)
            print("🌩️ Failed to remove stale cache: \(error.localizedDescription)")
        }

        isRemovingStale = false
    }

    // MARK: - 🛠️ Utilities

    /// 📊 Format bytes into human-readable string
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }

    /// 📊 Calculate disk usage percentage (500 MB max)
    private func diskUsagePercentage(_ bytes: Int64) -> Double {
        let maxSize: Int64 = 500 * 1024 * 1024 // 500 MB
        return min(Double(bytes) / Double(maxSize), 1.0)
    }

    /// 📝 Progress description for disk usage
    private func progressDescription(for bytes: Int64) -> String {
        let percentage = diskUsagePercentage(bytes) * 100
        return String(format: "%.1f%% of 500 MB", percentage)
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview {
    CacheManagementView()
        .withDependencies(.mock)
}
