//
//  AnimationConstants.swift
//  CMS-Manager
//
//  🎭 The Animation Constants - A Treasure Trove of Mystical Timing Values
//
//  "In the grand theater of motion, every animation has its perfect tempo—
//   from the snappy bounce of a button to the graceful glide of a modal.
//   These constants are the conductor's baton, orchestrating visual harmony!"
//
//  - The Spellbinding Museum Director of Temporal Artistry
//

import SwiftUI

/// 🎨 Animation Constants - Centralized timing and easing values for consistent animations
///
/// Use these constants throughout the wizard to maintain a cohesive animation language.
/// Think of it as your animation style guide! ✨
enum AnimationConstants {

    // MARK: - ⏱️ Duration Constants

    /// 🏃‍♀️ Ultra-fast animations (0.15s) - Perfect for micro-interactions like button presses
    static let ultraFast: Double = 0.15

    /// ⚡ Fast animations (0.25s) - Great for quick state changes
    static let fast: Double = 0.25

    /// 🎯 Normal animations (0.35s) - The sweet spot for most transitions
    static let normal: Double = 0.35

    /// 🌊 Medium animations (0.5s) - For more substantial changes
    static let medium: Double = 0.5

    /// 🐌 Slow animations (0.75s) - For dramatic entrances
    static let slow: Double = 0.75

    /// 🎭 Celebration animations (1.0s) - For success states
    static let celebration: Double = 1.0

    // MARK: - 🌊 Spring Damping Values

    /// 🎪 Bouncy spring (0.5) - For playful, energetic animations
    static let bouncyDamping: CGFloat = 0.5

    /// 🎨 Smooth spring (0.7) - The default, feels natural
    static let smoothDamping: CGFloat = 0.7

    /// 🏛️ Gentle spring (0.8) - For refined, elegant motion
    static let gentleDamping: CGFloat = 0.8

    /// 💎 Crisp spring (0.9) - Almost no bounce, very precise
    static let crispDamping: CGFloat = 0.9

    // MARK: - 🎬 Pre-configured Animations

    /// ✨ Standard spring animation - The workhorse of the wizard
    static var standardSpring: Animation {
        .spring(response: normal, dampingFraction: smoothDamping)
    }

    /// 🎪 Bouncy spring animation - For delightful interactions
    static var bouncySpring: Animation {
        .spring(response: fast, dampingFraction: bouncyDamping)
    }

    /// 🌊 Smooth spring animation - For elegant transitions
    static var smoothSpring: Animation {
        .spring(response: medium, dampingFraction: gentleDamping)
    }

    /// 🎉 Celebration spring - For success states
    static var celebrationSpring: Animation {
        .spring(response: celebration, dampingFraction: bouncyDamping)
    }

    /// ⚡ Quick ease-out - For snappy responses
    static var quickEaseOut: Animation {
        .easeOut(duration: fast)
    }

    /// 🎯 Standard ease-in-out - Balanced and smooth
    static var standardEaseInOut: Animation {
        .easeInOut(duration: normal)
    }

    // MARK: - 🎪 Stagger Timing

    /// 📊 Stagger delay for sequential animations (0.05s per item)
    static let staggerDelay: Double = 0.05

    /// 🎭 Longer stagger for dramatic effect (0.1s per item)
    static let dramaticStaggerDelay: Double = 0.1

    // MARK: - 🔄 Rotation & Transform

    /// 🌀 Full rotation (360 degrees)
    static let fullRotation: Double = 360

    /// 🎯 Half rotation (180 degrees)
    static let halfRotation: Double = 180

    /// ✨ Subtle scale up (1.05)
    static let subtleScaleUp: CGFloat = 1.05

    /// 🎪 Bounce scale up (1.15)
    static let bounceScaleUp: CGFloat = 1.15

    /// 🎉 Celebration scale up (1.3)
    static let celebrationScaleUp: CGFloat = 1.3

    // MARK: - 🌊 Opacity Transitions

    /// 👻 Fade in/out opacity delta
    static let fadeOpacity: Double = 0.0

    /// ✨ Full opacity
    static let fullOpacity: Double = 1.0

    /// 🌙 Dimmed opacity
    static let dimmedOpacity: Double = 0.6

    // MARK: - 📏 Offset Values

    /// 🚀 Standard slide distance (40pt)
    static let standardSlide: CGFloat = 40

    /// 🎭 Dramatic slide distance (100pt)
    static let dramaticSlide: CGFloat = 100

    /// ✨ Subtle slide distance (20pt)
    static let subtleSlide: CGFloat = 20
}

// MARK: - 🎨 Animation Helper Extensions

extension View {

    /// ✨ Apply a standard wizard transition with slide and fade
    /// - Parameter edge: The edge to slide from
    /// - Returns: Modified view with transition applied
    func wizardTransition(from edge: Edge = .trailing) -> some View {
        self.transition(
            .asymmetric(
                insertion: .move(edge: edge).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        )
    }

    /// 🎪 Apply a bouncy scale transition - perfect for success states!
    func bouncyScale() -> some View {
        self.scaleEffect(1.0)
            .animation(AnimationConstants.bouncySpring, value: UUID())
    }

    /// 🌊 Apply a smooth fade transition
    func smoothFade(isVisible: Bool) -> some View {
        self.opacity(isVisible ? AnimationConstants.fullOpacity : AnimationConstants.fadeOpacity)
            .animation(AnimationConstants.smoothSpring, value: isVisible)
    }
}
