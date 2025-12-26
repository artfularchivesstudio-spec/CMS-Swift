//
//  LoadingAnimation.swift
//  CMS-Manager
//
//  🎭 The Loading Animation - Mystical Patience
//
//  "While data dances through the digital ether,
//   this gentle spinner whispers: patience, dear seeker,
//   magic is brewing just beyond the veil."
//
//  - The Spellbinding Museum Director of Graceful Waiting
//

import SwiftUI
import Lottie

// MARK: - 🌀 Loading Animation

/// 🌀 A reusable loading spinner animation
/// Perfect for async operations, data fetching, and mystical transformations
struct LoadingAnimation: View {

    // MARK: - 🎨 Animation Type

    enum AnimationType: String {
        case spinner = "loading-spinner"
        case cloudUpload = "cloud-upload"
        case sparkles = "sparkles-magic"
        case soundWave = "sound-wave"
        case globe = "globe-translation"
    }

    // MARK: - 🎨 Properties

    /// 🎭 Type of loading animation
    var type: AnimationType = .spinner

    /// 📐 Size of the animation
    var size: CGFloat = 100

    /// ⚡ Animation speed (1.0 = normal)
    var speed: CGFloat = 1.0

    /// 📝 Loading message
    var message: String?

    /// 🎨 Message color
    var messageColor: Color = .secondary

    // MARK: - 🎭 Body

    var body: some View {
        VStack(spacing: 16) {
            // 🌀 Loading animation
            LottieView(
                animation: type.rawValue,
                loopMode: .loop,
                animationSpeed: speed
            )
            .frame(width: size, height: size)

            // 📝 Optional loading message
            if let message = message {
                Text(message)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(messageColor)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - 🎨 Convenience Modifiers

extension LoadingAnimation {
    /// 🎭 Set the animation type
    func type(_ type: AnimationType) -> Self {
        var view = self
        view.type = type
        return view
    }

    /// 📐 Set the size
    func size(_ size: CGFloat) -> Self {
        var view = self
        view.size = size
        return view
    }

    /// ⚡ Set the speed
    func speed(_ speed: CGFloat) -> Self {
        var view = self
        view.speed = speed
        return view
    }

    /// 📝 Set the message
    func message(_ message: String, color: Color = .secondary) -> Self {
        var view = self
        view.message = message
        view.messageColor = color
        return view
    }
}

// MARK: - 🎨 Convenience Constructors

extension LoadingAnimation {
    /// ☁️ Cloud upload animation
    static func cloudUpload(message: String? = "Uploading...") -> LoadingAnimation {
        LoadingAnimation(type: .cloudUpload, message: message)
    }

    /// ✨ Sparkles magic animation
    static func sparkles(message: String? = "Analyzing...") -> LoadingAnimation {
        LoadingAnimation(type: .sparkles, message: message)
    }

    /// 🔊 Sound wave animation
    static func soundWave(message: String? = "Generating audio...") -> LoadingAnimation {
        LoadingAnimation(type: .soundWave, message: message)
    }

    /// 🌍 Globe translation animation
    static func globe(message: String? = "Translating...") -> LoadingAnimation {
        LoadingAnimation(type: .globe, message: message)
    }

    /// 🌀 Generic spinner
    static func spinner(message: String? = "Loading...") -> LoadingAnimation {
        LoadingAnimation(type: .spinner, message: message)
    }
}

// MARK: - 🎨 Preview

#Preview("Loading Animations") {
    ScrollView {
        VStack(spacing: 40) {
            Text("🌀 Loading Animations")
                .font(.title)
                .fontWeight(.bold)

            // Cloud upload
            LoadingAnimation.cloudUpload()
                .size(120)

            // Sparkles
            LoadingAnimation.sparkles()
                .size(120)

            // Sound wave
            LoadingAnimation.soundWave()
                .size(120)

            // Globe
            LoadingAnimation.globe()
                .size(120)

            // Generic spinner
            LoadingAnimation.spinner()
                .size(80)

            // Custom message
            LoadingAnimation.spinner(message: "Performing mystical rituals...")
                .size(100)
        }
        .padding()
    }
}
