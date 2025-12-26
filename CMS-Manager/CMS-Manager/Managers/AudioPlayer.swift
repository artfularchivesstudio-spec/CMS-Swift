//
//  AudioPlayer.swift
//  CMS-Manager
//
//  🎵 The Audio Player - Symphony of Spoken Words
//
//  "Where text transforms into melody, and stories
//   find their voice through the ether of sound.
//   This conductor leads the orchestra of spoken tales."
//
//  - The Spellbinding Museum Director of Audio Arts
//

import Foundation
import AVFoundation
import SwiftUI

// MARK: - 🎭 Audio Player Protocol

/// 🎭 The interface for audio playback operations
@MainActor
protocol AudioPlayerProtocol: AnyObject {
    var isPlaying: Bool { get }
    var currentProgress: Double { get }
    var duration: Double { get }
    var currentTime: Double { get }
    var currentURL: String? { get }
    var playbackRate: Float { get }
    var volume: Float { get }

    func play(url: String) async throws
    func pause()
    func resume()
    func stop()
    func seek(to: Double)
    func skipBackward()
    func skipForward()
    func setRate(_ rate: Float)
    func setVolume(_ volume: Float)
}

// MARK: - 🎵 Audio Player Manager

/// 🎵 The keeper of spoken stories - manages audio playback across the app
@MainActor
@Observable
final class AudioPlayer: NSObject, AudioPlayerProtocol {

    // MARK: - 🌟 Playback State

    /// 🎭 Are we currently playing audio?
    private(set) var isPlaying = false

    /// ⏱️ Current playback progress (0.0 to 1.0)
    private(set) var currentProgress: Double = 0

    /// ⏰ Total duration of the current audio
    private(set) var duration: Double = 0

    /// ⏰ Current playback position in seconds
    private(set) var currentTime: Double = 0

    /// 🎵 The current audio URL being played
    private(set) var currentURL: String?

    /// 🐌 Current playback rate (0.5x to 2.0x)
    private(set) var playbackRate: Float = 1.0

    /// 🔊 Current volume level (0.0 to 1.0)
    private(set) var volume: Float = 1.0

    /// 🧙‍♂️ The underlying AVAudioPlayer
    private var player: AVAudioPlayer?

    /// ⏰ Timer for tracking progress
    private var progressTimer: Timer?

    /// 🔊 Audio session
    private let audioSession = AVAudioSession.sharedInstance()

    // MARK: - 🎭 Initialization

    /// 🌟 Create a new audio player
    override init() {
        super.init()
        setupAudioSession()
    }

    /// 🔧 Configure the shared audio session
    private func setupAudioSession() {
        do {
            // 🎧 Configure for playback
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [])
            try audioSession.setActive(true)
            print("🎉 ✨ AUDIO SESSION MASTERPIECE COMPLETE!")
        } catch {
            print("💥 😭 AUDIO SESSION SETUP FAILED! \(error.localizedDescription)")
        }
    }

    // MARK: - 🎵 Playback Controls

    /// ▶️ Play audio from a URL
    /// - Parameter url: The audio URL (can be http or data URL)
    func play(url: String) async throws {
        print("🎵 ✨ AUDIO PLAYBACK AWAKENS! URL: \(url.prefix(50))...")

        // 🛑 Stop any current playback
        stop()

        // 📦 Load the audio data
        let audioData: Data

        if url.hasPrefix("data:") {
            // 🎭 Base64 encoded data URL
            audioData = try decodeBase64AudioURL(url)
        } else {
            // 🌐 Remote URL
            audioData = try await fetchAudioData(from: url)
        }

        // 🎵 Create the player
        do {
            player = try AVAudioPlayer(data: audioData)
            player?.delegate = self
            player?.enableRate = true
            player?.rate = playbackRate
            player?.volume = volume
            player?.prepareToPlay()

            // 📊 Update state
            duration = player?.duration ?? 0
            currentURL = url
            currentTime = 0
            currentProgress = 0

            // ▶️ Start playback
            player?.play()
            isPlaying = true

            // ⏰ Start progress tracking
            startProgressTimer()

            print("🎉 ✨ AUDIO PLAYING! Duration: \(duration) seconds at \(playbackRate)x speed, volume: \(Int(volume * 100))%")
        } catch {
            print("💥 😭 AUDIO PLAYER CREATION FAILED! \(error.localizedDescription)")
            throw AudioError.playbackFailed(error)
        }
    }

    /// ⏸️ Pause playback
    func pause() {
        print("⏸️ Pausing the symphony...")
        player?.pause()
        isPlaying = false
        stopProgressTimer()
    }

    /// ▶️ Resume playback
    func resume() {
        print("▶️ Resuming the melody...")
        player?.play()
        isPlaying = true
        startProgressTimer()
    }

    /// ⏹️ Stop playback completely
    func stop() {
        print("⏹️ Bringing the music to an end")
        player?.stop()
        player = nil
        isPlaying = false
        currentProgress = 0
        currentTime = 0
        duration = 0
        currentURL = nil
        stopProgressTimer()
    }

    /// ⏩ Seek to a specific position
    /// - Parameter time: The time in seconds to seek to
    func seek(to time: Double) {
        print("⏩ Seeking to \(time) seconds")
        player?.currentTime = time
        currentTime = time
        updateProgress()
    }

    // MARK: - 🧙‍♂️ Private Helpers

    /// 🔓 Decode a base64 data URL
    private func decodeBase64AudioURL(_ urlString: String) throws -> Data {
        // Extract base64 portion
        guard let base64Range = urlString.range(of: "base64,", options: .backwards) else {
            throw AudioError.invalidURL
        }

        let base64String = String(urlString[base64Range.upperBound...])

        guard let data = Data(base64Encoded: base64String) else {
            throw AudioError.decodingFailed
        }

        print("🎉 ✨ BASE64 AUDIO MASTERPIECE COMPLETE! \(data.count) bytes")
        return data
    }

    /// 📡 Fetch audio data from a remote URL
    private func fetchAudioData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw AudioError.invalidURL
        }

        print("🌐 📡 Fetching audio from remote realm...")

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AudioError.downloadFailed
        }

        print("🎉 ✨ AUDIO DOWNLOAD MASTERPIECE COMPLETE! \(data.count) bytes")
        return data
    }

    /// ⏰ Start the progress tracking timer
    private func startProgressTimer() {
        stopProgressTimer()

        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateProgress()
            }
        }
    }

    /// ⏰ Stop the progress tracking timer
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    /// 📊 Update the current playback progress
    private func updateProgress() {
        guard let player = player, duration > 0 else { return }

        currentTime = player.currentTime
        currentProgress = currentTime / duration
    }

    /// 🔄 Toggle play/pause
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }

    /// ⏪ Skip backward
    func skipBackward(seconds: Double = 15) {
        let newTime = max(0, currentTime - seconds)
        seek(to: newTime)
    }

    /// ⏪ Skip backward (protocol requirement)
    func skipBackward() {
        skipBackward(seconds: 15)
    }

    /// ⏩ Skip forward (protocol requirement)
    func skipForward() {
        skipForward(seconds: 15)
    }

    /// ⏩ Skip forward by specified amount
    func skipForward(seconds: Double) {
        let newTime = min(duration, currentTime + seconds)
        seek(to: newTime)
    }

    /// 🐌 Set playback speed
    func setRate(_ rate: Float) {
        playbackRate = rate
        player?.rate = rate
        print("🐌 Playback speed: \(rate)x")
    }

    /// 🔊 Set volume level
    /// - Parameter volume: Volume level from 0.0 (silent) to 1.0 (max)
    func setVolume(_ volume: Float) {
        self.volume = max(0.0, min(1.0, volume))
        player?.volume = self.volume
        print("🔊 Volume level: \(Int(self.volume * 100))%")
    }
}

// MARK: - 🎭 AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {

    /// 🎵 Audio finished playing
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            print("🎉 ✨ AUDIO PLAYBACK COMPLETE! Standing ovation!")
            stop()
        }
    }

    /// 💥 Audio playback error
    nonisolated func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        Task { @MainActor in
            print("💥 😭 AUDIO DECODING ERROR! \(error?.localizedDescription ?? "Unknown error")")
            stop()
        }
    }
}

// MARK: - 🌩️ Audio Error

/// 🌩️ The dramatic tales of audio failures
enum AudioError: LocalizedError {
    case invalidURL
    case decodingFailed
    case downloadFailed
    case playbackFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid audio URL format"
        case .decodingFailed:
            return "Failed to decode audio data"
        case .downloadFailed:
            return "Failed to download audio file"
        case .playbackFailed(let error):
            return "Playback error: \(error.localizedDescription)"
        }
    }

    var icon: String {
        switch self {
        case .invalidURL: "link.badge.xmark"
        case .decodingFailed: "doc.badge.gearshape"
        case .downloadFailed: "icloud.slash"
        case .playbackFailed: "speaker.slash"
        }
    }
}

// MARK: - ⏱️ Duration Formatter

/// ⏱️ A helpful formatter for audio timestamps
struct AudioDurationFormatter {

    /// 📏 Format seconds into MM:SS or HH:MM:SS
    static func format(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        let hours = mins / 60
        let remainingMins = mins % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, remainingMins, secs)
        } else {
            return String(format: "%d:%02d", mins, secs)
        }
    }
}

// MARK: - 🎵 Audio Player View

/// 🎵 A SwiftUI view for audio playback controls
struct AudioPlayerView: View {

    // MARK: - 🏺 Properties

    /// 🎵 The audio player
    @Environment(\.audioPlayer) private var player

    /// 🔗 The audio URL to play
    let audioURL: String

    /// 🌙 Is the view currently loading?
    @State private var isLoading = false

    /// 🌩️ Any error that occurred
    @State private var error: AudioError?

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 12) {
            // 📊 Progress bar
            ProgressView(value: player.currentProgress)
                .tint(.blue)

            HStack {
                // ⏰ Current time
                Text(AudioDurationFormatter.format(player.currentTime))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)

                Spacer()

                // ⏰ Duration
                Text(AudioDurationFormatter.format(player.duration))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            // 🎮 Controls
            HStack(spacing: 20) {
                // ⏪ Skip back
                Button {
                    player.seek(to: max(0, player.currentTime - 15))
                } label: {
                    Image(systemName: "backward.15")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)

                Spacer()

                // ▶️ Play/Pause
                Button {
                    if player.isPlaying {
                        player.pause()
                    } else if player.currentURL == audioURL {
                        player.resume()
                    } else {
                        Task {
                            await playAudio()
                        }
                    }
                } label: {
                    Image(systemName: player.isPlaying && player.currentURL == audioURL ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .disabled(isLoading)

                Spacer()

                // ⏩ Skip forward
                Button {
                    player.skipForward()
                } label: {
                    Image(systemName: "forward.15")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - 🧙‍♂️ Helpers

    /// 🎵 Play the audio
    private func playAudio() async {
        isLoading = true
        error = nil

        do {
            try await player.play(url: audioURL)
        } catch let audioError as AudioError {
            self.error = audioError
        } catch {
            self.error = .playbackFailed(error)
        }

        isLoading = false
    }
}

// MARK: - 🌐 Environment Key

/// 🌐 Environment key for injecting the audio player
private struct AudioPlayerEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: AudioPlayerProtocol = StubAudioPlayer()
}

/// 🎭 Stub implementation for default environment value
/// 💥 Will fatalError if used - always inject at app root!
@MainActor
private final class StubAudioPlayer: AudioPlayerProtocol {
    var isPlaying: Bool { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var currentProgress: Double { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var duration: Double { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var currentTime: Double { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var currentURL: String? { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var playbackRate: Float { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    var volume: Float { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }

    func play(url: String) async throws { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func pause() { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func resume() { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func stop() { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func seek(to: Double) { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func skipBackward() { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func skipForward() { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func setRate(_ rate: Float) { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
    func setVolume(_ volume: Float) { fatalError("🌩️ AudioPlayer not injected! Use .environment(\\.audioPlayer) at app root.") }
}

extension EnvironmentValues {
    /// 🎵 The shared audio player
    var audioPlayer: AudioPlayerProtocol {
        get { self[AudioPlayerEnvironmentKey.self] }
        set { self[AudioPlayerEnvironmentKey.self] = newValue }
    }
}
