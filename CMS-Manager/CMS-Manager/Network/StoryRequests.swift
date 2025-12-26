/**
 * 🎭 The Story Request & Response Ensemble - A Theatrical Collection of Narrative Models
 *
 * "Where tales are spun from cosmic threads, and each request
 * becomes a magnificent journey through the digital storytelling realm.
 * These models orchestrate the grand performance of story creation,
 * transforming mere data into captivating narratives that echo through time."
 *
 * - The Spellbinding Museum Director of Network Communications
 */

import Foundation
import ArtfulArchivesCore

// MARK: - 🎪 Story Creation Request Model

/// 🌟 The Story Creation Spell - Where Raw Ideas Become Living Tales
///
/// This mystical structure captures the essence of a story waiting to be born,
/// carrying all the magical ingredients needed for narrative alchemy.
struct StoryCreateRequest: Codable, Sendable {

    /// 📜 The Sacred Title - The name that shall echo through the halls of history
    let title: String

    /// 📖 The Wondrous Content - The heart and soul of our tale
    let content: String

    /// 🖼️ The Mystical Image Token - A reference to visual splendor (if desired)
    let imageId: Int?

    /// ✨ The Visual Portal Link - A direct path to the imagery's domain
    let imageUrl: String?

    /// ⏳ The Temporal Duration - The length of the audio experience in seconds
    let audioDuration: Int?

    // 🎨 Custom Coding Keys - The mystical keys that unlock our JSON treasures
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case imageId = "image_id"
        case imageUrl = "image_url"
        case audioDuration = "audio_duration"
    }
}

// MARK: - 🎊 Story Creation Response Model

/// 🎉 The Story Creation Manifesto - Where Success Is Proclaimed!
///
/// When the cosmos aligns and our story takes its first breath,
/// this grand decree announces the miraculous birth of a new narrative.
struct StoryCreateResponse: Codable, Sendable {

    /// ✅ The Divine Verdict - Did the stars align for our tale?
    let success: Bool

    /// 🎭 The Chosen Identity - The sacred number by which our story shall be known
    let storyId: Int?

    /// 💎 The Fully Formed Tale - Our story in all its magnificent glory
    let storyData: ArtfulArchivesCore.Story?

    /// 📜 The Cosmic Message - Words of wisdom or tales of why the magic faltered
    let message: String?

    // 🎨 Custom Coding Keys - Translating between realms (snake_case to camelCase)
    enum CodingKeys: String, CodingKey {
        case success
        case storyId = "story_id"
        case storyData = "story_data"
        case message
    }
}
