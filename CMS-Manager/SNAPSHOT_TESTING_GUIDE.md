# 📸 Snapshot Testing Guide

## Overview

This project uses [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) for visual regression testing of SwiftUI views.

## Current Status

✅ **Tests Compile**: All snapshot tests compile successfully
✅ **Command Line Ready**: Run via `scripts/run-snapshot-tests.sh`
⚠️ **Xcode Sandbox Issue**: Direct Xcode execution blocked by sandbox (see solutions below)
✅ **CI/CD Ready**: GitHub Actions workflow configured for snapshot testing

---

## The Problem: "Volume is read only"

When running snapshot tests in Xcode, you see:
```
failed - You can't save the file "StoriesListViewSnapshotTests" because the volume is read only.
```

**Why**: Xcode's test sandbox creates a read-only test bundle. The SnapshotTesting library can't write reference images to this location.

**TL;DR**: Use the command-line script (Solution 1) - it's the easiest!

---

## ✅ Solution 1: Command Line Script (RECOMMENDED)

Run tests from the terminal using the provided script:

```bash
cd CMS-Manager

# Run all snapshot tests
./scripts/run-snapshot-tests.sh

# Run specific test
./scripts/run-snapshot-tests.sh --test StoriesListViewSnapshotTests/testEmptyState

# Record new snapshots (first set recordMode = true in test files)
./scripts/run-snapshot-tests.sh --record

# Run on different device
./scripts/run-snapshot-tests.sh --device "iPhone 15 Pro"

# Show help
./scripts/run-snapshot-tests.sh --help
```

**Advantages**:
- ✅ Works immediately, no configuration needed
- ✅ Bypasses Xcode sandbox completely
- ✅ Same environment as CI/CD
- ✅ Can be scripted/automated

---

## Solution 2: Xcode Scheme Configuration

### Step 1: Edit the Test Scheme

1. In Xcode, click the scheme dropdown (next to the run/stop buttons)
2. Select **"Edit Scheme..."**
3. Select **"Test"** in the left sidebar
4. Go to the **"Arguments"** tab
5. Under **"Environment Variables"**, click **+** and add:
   ```
   Name: SNAPSHOT_ARTIFACTS
   Value: $(SOURCE_ROOT)/CMS-ManagerTests
   ```

### Step 2: Disable Sandbox (Optional)

1. Still in **Edit Scheme > Test**
2. Go to **"Options"** tab
3. Uncheck **"Debug executable"** (or set to release mode)

### Step 3: Record Snapshots

1. Open any snapshot test file (e.g., `StoriesListViewSnapshotTests.swift`)
2. Change `recordMode = false` to `recordMode = true`
3. Run the tests (⌘U)
4. Snapshots will be saved to `CMS-ManagerTests/__Snapshots__/`
5. **IMPORTANT**: Change `recordMode` back to `false` before committing!

### Step 4: Verify Snapshots

1. Make sure `recordMode = false`
2. Run tests again
3. Tests will compare rendered views against saved snapshots

---

## Solution 2: Run from Command Line

### Recording Snapshots

```bash
cd CMS-Manager

# Set environment variable
export SNAPSHOT_ARTIFACTS="$(pwd)/CMS-ManagerTests"

# Build for testing
xcodebuild build-for-testing \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run tests in record mode
# First, manually edit test files to set recordMode = true
xcodebuild test-without-building \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

### Verifying Snapshots

```bash
# Make sure recordMode = false in all test files
xcodebuild test \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:CMS_ManagerTests
```

---

## Solution 3: CI/CD (GitHub Actions)

The GitHub Actions workflow (`.github/workflows/ci.yml`) is already configured:

```yaml
env:
  SNAPSHOT_ARTIFACTS: ${{ github.workspace }}/CMS-Manager/CMS-ManagerTests
  IS_CI: "true"
```

Tests will automatically:
- Compare against committed snapshots
- Fail if UI changes don't match
- Upload failed snapshot diffs as artifacts

---

## Snapshot Test Structure

```
CMS-ManagerTests/
├── __Snapshots__/               # Reference images (committed to git)
│   ├── StoriesListViewSnapshotTests/
│   │   ├── testEmptyState-iPhone13Pro-light.png
│   │   ├── testEmptyState-iPhone13Pro-dark.png
│   │   └── ...
│   └── StoryDetailViewSnapshotTests/
│       └── ...
├── Snapshots/                   # Test organization
│   └── WizardSteps/
├── StoriesListViewSnapshotTests.swift
├── StoryDetailViewSnapshotTests.swift
└── ...
```

---

## Available Snapshot Tests

### View-Level Tests
- `StoriesListViewSnapshotTests` - Stories list in various states
- `StoryDetailViewSnapshotTests` - Story detail screens
- `FinalizeStepSnapshotTests` - Finalize wizard step
- `TranslationStepSnapshotTests` - Translation wizard step
- `AudioGenerationStepSnapshotTests` - Audio generation step

### Wizard Step Tests (in `Snapshots/WizardSteps/`)
- `UploadStepSnapshotTests`
- `AnalyzingStepSnapshotTests`
- `ReviewStepSnapshotTests`
- `AudioStepSnapshotTests`
- `TranslationReviewStepSnapshotTests`

---

## Test Devices

Defined in `DeviceConfigurations.swift`:

```swift
.iPhoneEssentials  // SE, 13 Pro, 15 Pro Max
.iPads             // iPad Pro 11", 12.9"
.allDevices        // All of the above
```

---

## Helper Functions

### Testing Both Color Schemes
```swift
assertBothColorSchemes(
    matching: view,
    devices: [.iPhone13Pro],
    record: false
)
```

### Testing Multiple Devices
```swift
assertAllDevices(
    matching: view,
    devices: DeviceConfiguration.iPhoneEssentials,
    colorScheme: .light,
    record: false
)
```

### Testing Single Configuration
```swift
assertDevice(
    matching: view,
    device: .iPhone13Pro,
    colorScheme: .dark,
    record: false
)
```

---

## Best Practices

1. **Keep recordMode = false**: Only set to `true` when updating snapshots intentionally
2. **Review snapshot diffs**: Always review visual changes before committing new snapshots
3. **Commit snapshots**: Reference images should be committed to git
4. **Test on CI**: Let CI catch unintended visual regressions
5. **Use descriptive names**: Test names become snapshot filenames

---

## Troubleshooting

### "Volume is read only" error
- Follow Solution 1 or 2 above to configure SNAPSHOT_ARTIFACTS

### Snapshots not updating
- Make sure `recordMode = true`
- Check that SNAPSHOT_ARTIFACTS points to source directory, not build directory
- Delete old snapshots manually if needed

### Tests failing with minor pixel differences
- Font rendering can differ slightly between OS versions
- Consider using a tolerance parameter if needed
- Update snapshots if the difference is acceptable

### Gradient warnings
- SwiftUI gradient warnings are filtered in CI
- They don't affect snapshot quality
- Can be ignored locally

---

## Additional Resources

- [swift-snapshot-testing Documentation](https://github.com/pointfreeco/swift-snapshot-testing)
- [Point-Free Episode on Snapshot Testing](https://www.pointfree.co/collections/testing/snapshot-testing)

---

**Last Updated**: December 28, 2025
**Maintainer**: The Spellbinding Museum Director of Visual Testing ✨
