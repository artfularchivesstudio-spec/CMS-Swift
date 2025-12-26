# 📸 Snapshot Testing Infrastructure

## Overview

This directory contains the snapshot testing infrastructure for the CMS-Manager app, powered by [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing).

## Directory Structure

```
Snapshots/
├── README.md (this file)
└── WizardSteps/
    ├── AnalyzingStepSnapshotTests.swift
    ├── ReviewStepSnapshotTests.swift
    └── UploadStepSnapshotTests.swift
```

## Helper Utilities

Located in `../Helpers/`:

- **DeviceConfigurations.swift**: Device profiles for testing across iPhone and iPad sizes
- **SnapshotTestHelpers.swift**: Mock data factories and view wrapping utilities
- **XCTestCase+Snapshots.swift**: Convenient extension methods for snapshot assertions

## Running Snapshot Tests

### Normal Test Mode (Comparison)

```bash
xcodebuild test \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### Recording Mode (Generate New Snapshots)

```bash
SNAPSHOT_RECORDING=true xcodebuild test \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Device Matrix

Tests are run across multiple device configurations:

- **iPhone Essentials**: iPhone SE (3rd gen), iPhone 13 Pro, iPhone 15 Pro Max
- **All iPhones**: SE, 13 Pro, 15 Pro, 15 Pro Max
- **iPads**: iPad Pro 11", iPad Pro 12.9"

## Helper Methods

### `assertAllDevices`
Captures snapshots across multiple devices in one call.

```swift
assertAllDevices(
    matching: view,
    devices: DeviceConfiguration.iPhoneEssentials,
    colorScheme: .light
)
```

### `assertBothColorSchemes`
Tests both light and dark modes.

```swift
assertBothColorSchemes(
    matching: view,
    devices: [.iPhone13Pro]
)
```

### `assertDarkMode` / `assertIPads`
Convenience methods for specific testing scenarios.

## Example Test

```swift
@MainActor
func testUploadStepEmpty() {
    let viewModel = MockViewModelFactory.createWizardAtUpload()
    let view = UploadStepView(viewModel: viewModel)

    assertAllDevices(
        matching: view,
        devices: DeviceConfiguration.iPhoneEssentials,
        colorScheme: .light,
        record: isRecordingSnapshots
    )
}
```

## Snapshot Storage

Snapshots are stored in `__Snapshots__/<TestClassName>/` directories adjacent to test files.

## CI/CD Integration

Set `SNAPSHOT_RECORDING=false` (or omit) in CI to ensure snapshots are compared, not recorded.

## Best Practices

1. **Test Multiple States**: Empty, populated, loading, error states
2. **Test Color Schemes**: Both light and dark modes
3. **Test Device Sizes**: At least iPhone SE, standard iPhone, and iPad
4. **Keep Tests Fast**: Use `.fast` strategy during development, `.exact` for CI
5. **Meaningful Names**: Use descriptive test names that indicate what's being tested

## Adding New Snapshot Tests

1. Create a new test file in the appropriate subdirectory
2. Import required modules:
   ```swift
   import XCTest
   import SwiftUI
   import SnapshotTesting
   @testable import CMS_Manager
   ```
3. Use `MockViewModelFactory` to create test view models
4. Use `assertAllDevices` or other helper methods
5. Run with `SNAPSHOT_RECORDING=true` once to generate reference images
6. Commit both test code and snapshot images

## Troubleshooting

### Tests Failing Due to Small Pixel Differences

Use relaxed precision:

```swift
assertDevice(
    matching: view,
    device: .iPhone13Pro,
    strategy: .relaxed
)
```

### Snapshots Not Generating

- Ensure `SNAPSHOT_RECORDING=true` environment variable is set
- Check that the test is actually running (not skipped)
- Verify snapshot directory permissions

### Different Results on CI vs Local

- Use consistent simulator OS versions
- Ensure system fonts render identically
- Consider using `.relaxed` strategy for views with system-rendered text
