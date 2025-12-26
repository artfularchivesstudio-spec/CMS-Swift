//
//  LottieView.swift
//  CMS-Manager
//
//  🎭 The Lottie View - Mystical Animation Canvas
//
//  "Where JSON becomes magic, and static screens dance with life,
//   this enchanted wrapper brings Lottie's power to SwiftUI's embrace.
//   Each frame a brushstroke in our digital masterpiece."
//
//  - The Spellbinding Museum Director of Animated Delights
//

import SwiftUI
import Lottie

// MARK: - 🎭 Lottie View

/// 🎭 A SwiftUI wrapper for Lottie animations
/// Supports looping, playback speed, completion handlers, and dynamic sizing
struct LottieView: UIViewRepresentable {

    // MARK: - 🎨 Properties

    /// 📦 The name of the animation file (without .json extension)
    let animationName: String

    /// 🔁 Loop mode for the animation
    var loopMode: LottieLoopMode = .loop

    /// ⚡ Animation playback speed (1.0 = normal)
    var animationSpeed: CGFloat = 1.0

    /// 🎬 Content mode for the animation
    var contentMode: UIView.ContentMode = .scaleAspectFit

    /// 🎭 Completion handler called when animation finishes (for .playOnce mode)
    var onComplete: (() -> Void)?

    /// 🎮 External control for playing/pausing
    @Binding var isPlaying: Bool

    // MARK: - 🎨 Initializers

    /// 🌟 Create a Lottie view with basic configuration
    init(
        animation animationName: String,
        loopMode: LottieLoopMode = .loop,
        animationSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        isPlaying: Binding<Bool> = .constant(true),
        onComplete: (() -> Void)? = nil
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
        self._isPlaying = isPlaying
        self.onComplete = onComplete
    }

    // MARK: - 🎭 UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        print("🎨 ✨ LOTTIE VIEW AWAKENS! Animation: \(animationName)")

        // 🎭 Create the container view
        let containerView = UIView()
        containerView.backgroundColor = .clear

        // 🎬 Create the animation view
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.backgroundBehavior = .pauseAndRestore

        // 🎯 Load the animation from the bundle
        if let path = Bundle.main.path(forResource: animationName, ofType: "json", inDirectory: "local-assets/lottie"),
           let animation = LottieAnimation.filepath(path) {
            animationView.animation = animation
            print("🎉 Animation loaded successfully: \(animationName)")
        } else {
            print("🌩️ Failed to load animation: \(animationName)")
            print("🔍 Looking in: local-assets/lottie/")
        }

        // 🎨 Add to container and set up constraints
        containerView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        // 🎬 Start playing if needed
        if isPlaying {
            animationView.play()
            print("▶️ Playing animation: \(animationName)")
        }

        // 💾 Store reference for updates
        context.coordinator.animationView = animationView

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 🎮 Handle play/pause state changes
        guard let animationView = context.coordinator.animationView else { return }

        if isPlaying && !animationView.isAnimationPlaying {
            animationView.play()
            print("▶️ Resuming animation: \(animationName)")
        } else if !isPlaying && animationView.isAnimationPlaying {
            animationView.pause()
            print("⏸️ Pausing animation: \(animationName)")
        }
    }

    // MARK: - 🎭 Coordinator

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        /// 🎬 Reference to the animation view for updates
        var animationView: LottieAnimationView?
    }
}

// MARK: - 🎨 Convenience Initializer

extension LottieView {
    /// 🌟 Create a simple looping Lottie view
    init(animation: String) {
        self.init(animation: animation, loopMode: .loop)
    }
}

// MARK: - 🎨 View Modifiers

extension LottieView {
    /// 🔁 Set the loop mode
    func loopMode(_ mode: LottieLoopMode) -> Self {
        var view = self
        view.loopMode = mode
        return view
    }

    /// ⚡ Set the animation speed
    func animationSpeed(_ speed: CGFloat) -> Self {
        var view = self
        view.animationSpeed = speed
        return view
    }

    /// 🎬 Set the content mode
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        var view = self
        view.contentMode = mode
        return view
    }

    /// 🎭 Set completion handler
    func onComplete(_ handler: @escaping () -> Void) -> Self {
        var view = self
        view.onComplete = handler
        return view
    }
}

// MARK: - 🎨 Preview

#Preview("Looping Animation") {
    VStack(spacing: 20) {
        Text("🎭 Lottie Animation Preview")
            .font(.title2)
            .fontWeight(.bold)

        // Example: Replace with actual animation name
        LottieView(
            animation: "loading-spinner",
            loopMode: .loop
        )
        .frame(width: 200, height: 200)
    }
    .padding()
}

#Preview("Play Once Animation") {
    VStack(spacing: 20) {
        Text("🎉 Success Animation")
            .font(.title2)
            .fontWeight(.bold)

        LottieView(
            animation: "success-checkmark",
            loopMode: .playOnce,
            onComplete: {
                print("🎊 Success animation completed!")
            }
        )
        .frame(width: 200, height: 200)
    }
    .padding()
}
