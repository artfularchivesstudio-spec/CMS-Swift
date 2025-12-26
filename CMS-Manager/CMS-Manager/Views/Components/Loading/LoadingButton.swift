//
//  LoadingButton.swift
//  CMS-Manager
//
//  🔘 The Button Transformer - Interactive Loading States
//
//  "A button that gracefully transitions from action to anticipation,
//   showing spinners instead of text, disabled yet dignified,
//   communicating progress without breaking the visual rhythm."
//
//  - The Spellbinding Museum Director of Button Choreography
//

import SwiftUI

// MARK: - 🔘 Loading Button

/// 🔘 A button that shows a loading state during async operations
/// Replaces the label with a spinner while loading - elegant and informative! ✨
struct LoadingButton<Label: View>: View {

    // MARK: - 🎨 Properties

    /// 🎬 The async action to perform
    let action: () async -> Void

    /// 🏷️ The button label (shown when not loading)
    let label: () -> Label

    /// ⏳ Are we currently loading?
    @State private var isLoading = false

    // MARK: - 🎭 Initializer

    /// 🔘 Create a loading button
    /// - Parameters:
    ///   - action: Async action to perform
    ///   - label: Button label view builder
    init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    // MARK: - 🎭 Body

    var body: some View {
        Button {
            Task {
                await performAction()
            }
        } label: {
            ZStack {
                // 🏷️ Original label (hidden when loading)
                label()
                    .opacity(isLoading ? 0 : 1)

                // ⏳ Loading spinner (shown when loading)
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isLoading)
        }
        .disabled(isLoading)
        .accessibilityLabel(isLoading ? "Loading" : "")
        .accessibilityAddTraits(isLoading ? [.updatesFrequently] : [])
    }

    // MARK: - 🎬 Actions

    /// 🎬 Perform the action with loading state management
    private func performAction() async {
        guard !isLoading else { return }

        isLoading = true

        await action()

        // ⏱️ Small delay to prevent jarring instant disappearance
        try? await Task.sleep(for: .milliseconds(200))

        isLoading = false
    }
}

// MARK: - 🎨 Loading Button Style

/// 🎨 A button style with loading state support
/// For use with standard SwiftUI buttons - no custom view needed! 🎭
struct LoadingButtonStyle: ButtonStyle {

    /// ⏳ Is the button currently loading?
    @Binding var isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isLoading ? 0.6 : (configuration.isPressed ? 0.8 : 1.0))
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - 🎨 View Extension

extension View {
    /// 🔘 Apply loading button style
    /// - Parameter isLoading: Binding to loading state
    /// - Returns: Button with loading style applied
    func loadingButtonStyle(isLoading: Binding<Bool>) -> some View {
        buttonStyle(LoadingButtonStyle(isLoading: isLoading))
    }
}

// MARK: - 🔘 Async Button (Alternative Implementation)

/// 🔘 A SwiftUI button wrapper for async actions with built-in loading state
/// Clean API: AsyncButton("Save") { await saveData() }
struct AsyncButton<Label: View>: View {

    let role: ButtonRole?
    let action: () async -> Void
    @ViewBuilder let label: () -> Label

    @State private var isLoading = false

    /// 🔘 Create an async button
    /// - Parameters:
    ///   - role: Button role (destructive, cancel, etc.)
    ///   - action: Async action to perform
    ///   - label: Button label
    init(
        role: ButtonRole? = nil,
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(role: role) {
            Task {
                isLoading = true
                await action()
                try? await Task.sleep(for: .milliseconds(200))
                isLoading = false
            }
        } label: {
            ZStack {
                label()
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3), value: isLoading)
        }
        .disabled(isLoading)
    }
}

// MARK: - 🎨 String Label Convenience Initializers

extension AsyncButton where Label == Text {
    /// 🔘 Create an async button with string label
    /// - Parameters:
    ///   - title: Button title
    ///   - role: Button role (destructive, cancel, etc.)
    ///   - action: Async action to perform
    init(
        _ title: String,
        role: ButtonRole? = nil,
        action: @escaping () async -> Void
    ) {
        self.role = role
        self.action = action
        self.label = { Text(title) }
    }
}

// MARK: - 🧙‍♂️ Preview

#Preview("Loading Button") {
    VStack(spacing: 20) {
        // 🔘 LoadingButton example
        LoadingButton {
            try? await Task.sleep(for: .seconds(2))
        } label: {
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Save Changes")
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)

        // 🔘 AsyncButton example with text
        AsyncButton("Delete Story", role: .destructive) {
            try? await Task.sleep(for: .seconds(2))
        }
        .buttonStyle(.bordered)

        // 🔘 AsyncButton with custom label
        AsyncButton {
            try? await Task.sleep(for: .seconds(2))
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Refresh")
            }
        }
        .buttonStyle(.borderedProminent)

        // 🔘 Regular button with loading style
        @State var isManualLoading = false

        Button("Manual Loading") {
            isManualLoading = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                isManualLoading = false
            }
        }
        .buttonStyle(.borderedProminent)
        .loadingButtonStyle(isLoading: $isManualLoading)
    }
    .padding()
}
