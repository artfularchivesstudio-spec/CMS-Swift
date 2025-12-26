# ⚡ Animation Quick Reference

> Copy-paste ready code snippets for delightful interactions!

---

## 🎊 Celebrations

### Confetti Explosion
```swift
@State private var showConfetti = false

// Add to view
.confetti(isActive: $showConfetti)

// Trigger
showConfetti = true
```

### Success Checkmark
```swift
@State private var showSuccess = false

// Add to view
SuccessCheckmark(isVisible: $showSuccess)

// Or as modifier
.successCheckmark(isVisible: $showSuccess)
```

### Sparkle Burst
```swift
@State private var showSparkles = false

// Add to view
.sparkle(isActive: $showSparkles)

// Trigger
showSparkles = true
```

---

## 🎨 Button Styles

### Bouncy (Standard)
```swift
Button("Action") { }
    .buttonStyle(.bouncy)
```

### Bouncy with Custom Haptic
```swift
Button("Important") { }
    .buttonStyle(.bouncy(scale: 0.97, haptic: .heavy))
```

### Pulsing CTA
```swift
Button("Get Started") { }
    .buttonStyle(.pulse)
    // OR
    .attentionPulse(color: .blue)
```

### Celebration Button
```swift
Button("Complete") { }
    .buttonStyle(.celebration)
```

### Gradient Shift
```swift
Button("Premium") { }
    .buttonStyle(.gradientShift(colors: [.pink, .purple]))
```

---

## 💥 Validation & Errors

### Shake on Error
```swift
@State private var isInvalid = false

TextField("Email", text: $email)
    .shake(trigger: $isInvalid)

// Trigger
isInvalid = true
```

### Shake on Multiple Attempts
```swift
@State private var attempts = 0

TextField("Code", text: $code)
    .shakeOnCount($attempts)

// Trigger
attempts += 1
```

---

## 💓 Pulse Effects

### Attention Pulse
```swift
Button("Important!") { }
    .attentionPulse(color: .red)
```

### Subtle Pulse
```swift
Button("Secondary") { }
    .subtlePulse(color: .gray)
```

### Badge Pulse (Notifications)
```swift
Image(systemName: "envelope")
    .badgePulse(count: messageCount)
```

### Progress Pulse (Loading)
```swift
ProgressView()
    .progressPulse(isActive: isLoading)
```

---

## 🎵 Haptic Feedback

### Success
```swift
HapticManager.success()  // ✅
```

### Error
```swift
HapticManager.error()  // ❌
```

### Warning
```swift
HapticManager.warning()  // ⚠️
```

### Impacts
```swift
HapticManager.light()     // 💫 Subtle
HapticManager.medium()    // 🎯 Standard
HapticManager.heavy()     // 💥 Strong
```

### Selection
```swift
HapticManager.selection()  // 🎪 Picker/Toggle
```

---

## 🎭 Complete Celebration Sequence

### Story Published
```swift
@State private var showConfetti = false
@State private var showCheckmark = false
@State private var showSparkles = false

// In view body
.confetti(isActive: $showConfetti)

// Success animation view
VStack {
    SuccessCheckmark(isVisible: $showCheckmark, size: 100)
    Text("Success!")
    StoryDetails()
        .sparkle(isActive: $showSparkles)
}

// Trigger function
private func celebrate() {
    HapticManager.success()
    showConfetti = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        showCheckmark = true
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        showSparkles = true
    }
}
```

---

## 🎪 Interactive Card

### Bounce on Tap
```swift
@State private var scale: CGFloat = 1.0

CardView()
    .scaleEffect(scale)
    .onTapGesture {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            scale = 1.05
        }
        HapticManager.light()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }
```

---

## 📝 Form Field with Feedback

### Complete Example
```swift
@State private var email = ""
@State private var isValid = false
@State private var isInvalid = false

VStack {
    TextField("Email", text: $email)
        .shake(trigger: $isInvalid)
        .onChange(of: email) { _, newValue in
            isValid = newValue.contains("@")
        }

    if isValid {
        HStack {
            SuccessCheckmark(
                isVisible: .constant(true),
                style: .minimal,
                size: 20,
                color: .green
            )
            Text("Valid email")
                .foregroundStyle(.green)
        }
    }
}

// Validate
func validate() {
    if !email.contains("@") {
        isInvalid = true
        HapticManager.error()
    }
}
```

---

## 🌟 Primary CTA Template

### The Perfect Primary Button
```swift
Button {
    performAction()
} label: {
    HStack {
        Image(systemName: "star.fill")
        Text("Get Started")
        Image(systemName: "arrow.right")
    }
    .font(.title3)
    .fontWeight(.semibold)
    .foregroundStyle(.white)
    .padding()
    .frame(maxWidth: .infinity)
    .background(
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
    .clipShape(RoundedRectangle(cornerRadius: 16))
}
.buttonStyle(.bouncy(scale: 0.97, haptic: .heavy))
.attentionPulse(color: .purple)
.disabled(!canProceed)
```

---

## 🔄 Loading State

### With Progress Pulse
```swift
@State private var isLoading = false

VStack {
    if isLoading {
        ProgressView("Loading...")
            .progressPulse(isActive: true)
    }
}
```

---

## 🎯 Cheat Sheet Matrix

| Want to... | Use This |
|-----------|----------|
| Make button bouncy | `.buttonStyle(.bouncy)` |
| Draw attention | `.attentionPulse(color:)` |
| Celebrate success | `.confetti(isActive:)` + `SuccessCheckmark` |
| Show completion | `SuccessCheckmark(isVisible:)` |
| Add sparkles | `.sparkle(isActive:)` |
| Shake on error | `.shake(trigger:)` |
| Pulse subtly | `.subtlePulse(color:)` |
| Show notification count | `.badgePulse(count:)` |
| Indicate loading | `.progressPulse(isActive:)` |
| Fancy gradient button | `.buttonStyle(.gradientShift(colors:))` |
| Success haptic | `HapticManager.success()` |
| Error haptic | `HapticManager.error()` |
| Light tap haptic | `HapticManager.light()` |

---

## 💡 Common Patterns

### Success Flow
```swift
1. Action starts
   HapticManager.medium()

2. Action succeeds
   HapticManager.success()
   showConfetti = true
   showCheckmark = true

3. Display success state
   Button with .bouncy style
```

### Error Flow
```swift
1. Validation fails
   HapticManager.error()
   isInvalid = true  // Triggers shake

2. Show error message
   Text("Error").foregroundStyle(.red)

3. User fixes input
   isInvalid = false
   HapticManager.light()
```

### CTA Flow
```swift
1. Show pulsing button
   .attentionPulse(color:)

2. User taps
   .buttonStyle(.bouncy(haptic: .heavy))

3. Action completes
   HapticManager.success()
   Celebration animations
```

---

## 🚀 Copy-Paste Templates

### Template: Publish Button
```swift
Button {
    publish()
} label: {
    HStack {
        if isLoading {
            ProgressView()
                .tint(.white)
            Text("Publishing...")
        } else {
            Image(systemName: "paperplane.fill")
            Text("Publish")
        }
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(
        LinearGradient(
            colors: canPublish ? [.green, .green.opacity(0.8)] : [.gray, .gray],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
    .foregroundStyle(.white)
    .clipShape(RoundedRectangle(cornerRadius: 14))
}
.buttonStyle(.bouncy(scale: 0.97, haptic: .heavy))
.attentionPulse(color: canPublish ? .green : .gray)
.disabled(!canPublish)
```

### Template: Success View
```swift
VStack(spacing: 20) {
    SuccessCheckmark(
        isVisible: $showCheckmark,
        size: 100,
        color: .green
    )

    Text("Success!")
        .font(.title)
        .fontWeight(.bold)

    Text("Your action completed successfully")
        .foregroundStyle(.secondary)
}
.confetti(isActive: $showConfetti)
.sparkle(isActive: $showSparkles)
```

### Template: Form Field
```swift
VStack(alignment: .leading) {
    TextField("Field", text: $value)
        .textFieldStyle(.roundedBorder)
        .shake(trigger: $isInvalid)

    if isInvalid {
        HStack {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
            Text(errorMessage)
                .font(.caption)
                .foregroundStyle(.red)
        }
    }
}
```

---

**✨ Happy animating! ✨**
