/**
 * 🎭 The Workflow Stage - The Seven Pillars of Content Creation
 *
 * "Every masterpiece passes through these sacred gates,
 * from creation's spark to the final curtain call."
 *
 * - The Spellbinding Museum Director of Content Workflows
 */

import Foundation

// 🎭 The Workflow Stage - Where stories are in their journey
public enum WorkflowStage: String, Codable, CaseIterable, Equatable, Sendable {

    // MARK: - 🌟 Stages

    /// ✨ The birth of a new story
    case created

    /// 📝 English text has been reviewed and approved
    case englishTextApproved = "english_text_approved"

    /// 🔊 English audio has been generated and approved
    case englishAudioApproved = "english_audio_approved"

    /// 🎬 The complete English version is approved
    case englishVersionApproved = "english_version_approved"

    /// 🌐 All translations are complete and approved
    case multilingualTextApproved = "multilingual_text_approved"

    /// 🔊 All audio translations are complete and approved
    case multilingualAudioApproved = "multilingual_audio_approved"

    /// 👁️ Final review before publishing
    case pendingFinalReview = "pending_final_review"

    /// 🎉 The story is ready for the world
    case approved

    // MARK: - 🎨 Computed Properties

    /// 📜 Human-readable display name
    public var displayName: String {
        switch self {
        case .created:
            return "Created"
        case .englishTextApproved:
            return "English Text Approved"
        case .englishAudioApproved:
            return "English Audio Approved"
        case .englishVersionApproved:
            return "English Version Approved"
        case .multilingualTextApproved:
            return "Multilingual Text Approved"
        case .multilingualAudioApproved:
            return "Multilingual Audio Approved"
        case .pendingFinalReview:
            return "Pending Final Review"
        case .approved:
            return "Approved"
        }
    }

    /// 📖 A brief description of what this stage means
    public var description: String {
        switch self {
        case .created:
            return "The story has been created and is waiting for content review."
        case .englishTextApproved:
            return "The English text has been reviewed and approved."
        case .englishAudioApproved:
            return "The English audio has been generated and approved."
        case .englishVersionApproved:
            return "The complete English version (text + audio) is approved."
        case .multilingualTextApproved:
            return "All translations have been completed and approved."
        case .multilingualAudioApproved:
            return "All translated audio has been generated and approved."
        case .pendingFinalReview:
            return "The story is awaiting final review before publishing."
        case .approved:
            return "The story has been fully approved and is ready to publish."
        }
    }

    /// 🎭 SF Symbol icon for this stage
    public var icon: String {
        switch self {
        case .created:
            return "sparkles"
        case .englishTextApproved:
            return "checkmark.text.page"
        case .englishAudioApproved:
            return "waveform.badge.checkmark"
        case .englishVersionApproved:
            return "checkmark.seal"
        case .multilingualTextApproved:
            return "globe.badge.checkmark"
        case .multilingualAudioApproved:
            return "speaker.wave.3.badge.checkmark"
        case .pendingFinalReview:
            return "eye.circle"
        case .approved:
            return "checkmark.circle.fill"
        }
    }

    /// 🎨 Color associated with this stage
    public var color: StageColor {
        switch self {
        case .created:
            return .blue
        case .englishTextApproved:
            return .teal
        case .englishAudioApproved:
            return .purple
        case .englishVersionApproved:
            return .indigo
        case .multilingualTextApproved:
            return .orange
        case .multilingualAudioApproved:
            return .pink
        case .pendingFinalReview:
            return .yellow
        case .approved:
            return .green
        }
    }

    /// 📊 The position in the workflow (0-7)
    public var position: Int {
        switch self {
        case .created:
            return 0
        case .englishTextApproved:
            return 1
        case .englishAudioApproved:
            return 2
        case .englishVersionApproved:
            return 3
        case .multilingualTextApproved:
            return 4
        case .multilingualAudioApproved:
            return 5
        case .pendingFinalReview:
            return 6
        case .approved:
            return 7
        }
    }

    /// 🎯 The next stage in the workflow
    public var nextStage: WorkflowStage? {
        switch self {
        case .created:
            return .englishTextApproved
        case .englishTextApproved:
            return .englishAudioApproved
        case .englishAudioApproved:
            return .englishVersionApproved
        case .englishVersionApproved:
            return .multilingualTextApproved
        case .multilingualTextApproved:
            return .multilingualAudioApproved
        case .multilingualAudioApproved:
            return .pendingFinalReview
        case .pendingFinalReview:
            return .approved
        case .approved:
            return nil // Final stage
        }
    }

    /// 🌙 The previous stage in the workflow
    public var previousStage: WorkflowStage? {
        switch self {
        case .created:
            return nil // First stage
        case .englishTextApproved:
            return .created
        case .englishAudioApproved:
            return .englishTextApproved
        case .englishVersionApproved:
            return .englishAudioApproved
        case .multilingualTextApproved:
            return .englishVersionApproved
        case .multilingualAudioApproved:
            return .multilingualTextApproved
        case .pendingFinalReview:
            return .multilingualAudioApproved
        case .approved:
            return .pendingFinalReview
        }
    }

    /// 🎭 Whether this is a final stage (no next stage)
    public var isFinal: Bool {
        nextStage == nil
    }

    /// ✨ Whether this is the first stage
    public var isInitial: Bool {
        previousStage == nil
    }

    /// 📊 Progress percentage through the workflow
    public var progressPercentage: Double {
        Double(position) / Double(Self.allCases.count - 1)
    }

    /// 🎯 Suggested action for this stage
    public var suggestedAction: String {
        switch self {
        case .created:
            return "Review and edit the English text"
        case .englishTextApproved:
            return "Generate English audio"
        case .englishAudioApproved:
            return "Review the complete English version"
        case .englishVersionApproved:
            return "Create translations"
        case .multilingualTextApproved:
            return "Generate translated audio"
        case .multilingualAudioApproved:
            return "Perform final review"
        case .pendingFinalReview:
            return "Approve for publishing"
        case .approved:
            return "Publish the story"
        }
    }

    // MARK: - 🎨 Stage Groupings

    /// 📝 All English-related stages
    public static var englishStages: [WorkflowStage] {
        [.englishTextApproved, .englishAudioApproved, .englishVersionApproved]
    }

    /// 🌐 All multilingual stages
    public static var multilingualStages: [WorkflowStage] {
        [.multilingualTextApproved, .multilingualAudioApproved]
    }

    /// 🎯 Early stages (before multilingual work)
    public static var earlyStages: [WorkflowStage] {
        [.created, .englishTextApproved, .englishAudioApproved, .englishVersionApproved]
    }

    /// 🎯 Late stages (multilingual and final)
    public static var lateStages: [WorkflowStage] {
        [.multilingualTextApproved, .multilingualAudioApproved, .pendingFinalReview, .approved]
    }

    /// ✅ All approval stages
    public static var approvalStages: [WorkflowStage] {
        [
            .englishTextApproved,
            .englishAudioApproved,
            .englishVersionApproved,
            .multilingualTextApproved,
            .multilingualAudioApproved,
            .approved
        ]
    }
}

// MARK: - 🎨 Stage Color

/// 🎨 Visual themes for workflow stages
public enum StageColor: String, CaseIterable, Sendable {
    case blue
    case teal
    case purple
    case indigo
    case orange
    case pink
    case yellow
    case green

    public var hexValue: String {
        switch self {
        case .blue: return "#007AFF"
        case .teal: return "#5AC8FA"
        case .purple: return "#AF52DE"
        case .indigo: return "#5856D6"
        case .orange: return "#FF9500"
        case .pink: return "#FF2D55"
        case .yellow: return "#FFCC00"
        case .green: return "#34C759"
        }
    }

    public var colorName: String {
        rawValue.capitalized
    }
}

// MARK: - 📊 Stage Transition

/// 📊 Represents a transition between workflow stages
public struct StageTransition: Equatable, Sendable {
    public let from: WorkflowStage
    public let to: WorkflowStage
    public let timestamp: Date
    public let actor: String?

    public init(from: WorkflowStage, to: WorkflowStage, timestamp: Date = Date(), actor: String? = nil) {
        self.from = from
        self.to = to
        self.timestamp = timestamp
        self.actor = actor
    }

    /// 🎭 Whether this is a forward progression
    public var isProgression: Bool {
        to.position > from.position
    }

    /// 🌙 Whether this is moving backward
    public var isRegression: Bool {
        to.position < from.position
    }

    /// 📊 How many stages this jumps
    public var stageDifference: Int {
        abs(to.position - from.position)
    }
}

// MARK: - 📋 Stage History

/// 📋 Track the history of a story through workflow stages
public struct StageHistory: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let transitions: [StageTransition]
    public let currentStage: WorkflowStage

    public init(transitions: [StageTransition], currentStage: WorkflowStage) {
        self.transitions = transitions
        self.currentStage = currentStage
    }

    /// 📊 How many times this story has moved stages
    public var transitionCount: Int {
        transitions.count
    }

    /// 🎭 The first stage this story was in
    public var initialStage: WorkflowStage {
        transitions.first?.from ?? currentStage
    }

    /// 📅 When this story entered its current stage
    public var currentStageEnteredAt: Date {
        transitions.last?.timestamp ?? Date()
    }

    /// ⏱️ How long this story has been in the current stage
    public var timeInCurrentStage: TimeInterval {
        Date().timeIntervalSince(currentStageEnteredAt)
    }

    /// 📊 Total time in workflow
    public var totalTimeInWorkflow: TimeInterval {
        guard let firstTransition = transitions.first else {
            return 0
        }
        return Date().timeIntervalSince(firstTransition.timestamp)
    }
}
