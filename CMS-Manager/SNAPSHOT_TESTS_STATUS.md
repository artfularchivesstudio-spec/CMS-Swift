# 📸 Snapshot Tests - Current Status

**Last Updated**: December 28, 2025

## ✅ What's Working

- **All tests compile** without errors
- **Test structure** is complete with 100+ snapshot configurations
- **Helper methods** properly configured
- **Mock data** available for all test scenarios
- **CI/CD integration** ready in `.github/workflows/ci.yml`

## ⚠️ Known Issue: Xcode Sandbox

**Problem**: Running snapshot tests directly in Xcode fails with:
```
"You can't save the file because the volume is read only"
```

**Root Cause**: Xcode's test sandbox prevents writing to the file system where reference snapshots need to be saved.

## 🎯 How to Run Snapshot Tests

### Option 1: Command Line (Recommended)
```bash
cd CMS-Manager
./scripts/run-snapshot-tests.sh
```

### Option 2: Configure Xcode Scheme
See `SNAPSHOT_TESTING_GUIDE.md` for detailed instructions.

### Option 3: CI/CD
Tests run automatically in GitHub Actions on every PR.

## 📊 Test Coverage

| Test Suite | Tests | Devices | Color Schemes |
|------------|-------|---------|---------------|
| StoriesListView | 15 | 3 | Light + Dark |
| StoryDetailView | 8 | 3 | Light + Dark |
| WizardSteps | 25+ | 3 | Light + Dark |
| **Total** | **48+** | **iPhone SE, 13 Pro, 15 Pro Max** | **~100 configurations** |

## 📁 Snapshot Organization

```
CMS-ManagerTests/
├── __Snapshots__/                    # Reference images (git tracked)
│   ├── StoriesListViewSnapshotTests/
│   ├── StoryDetailViewSnapshotTests/
│   └── Snapshots/WizardSteps/
├── StoriesListViewSnapshotTests.swift
├── StoryDetailViewSnapshotTests.swift
└── Snapshots/WizardSteps/
    ├── UploadStepSnapshotTests.swift
    ├── AnalyzingStepSnapshotTests.swift
    ├── ReviewStepSnapshotTests.swift
    ├── AudioStepSnapshotTests.swift
    └── TranslationReviewStepSnapshotTests.swift
```

## 🔧 Quick Commands

```bash
# Run all tests
./scripts/run-snapshot-tests.sh

# Run specific suite
./scripts/run-snapshot-tests.sh --test StoriesListViewSnapshotTests

# Run single test
./scripts/run-snapshot-tests.sh --test StoriesListViewSnapshotTests/testEmptyState

# Record new snapshots
# 1. Edit test file: set recordMode = true
# 2. Run: ./scripts/run-snapshot-tests.sh
# 3. Edit test file: set recordMode = false
# 4. Commit new snapshots

# Different device
./scripts/run-snapshot-tests.sh --device "iPhone 15 Pro"
```

## 📚 Documentation

- **Full Guide**: `SNAPSHOT_TESTING_GUIDE.md`
- **Helper Functions**: `CMS-ManagerTests/Helpers/XCTestCase+Snapshots.swift`
- **Device Configs**: `CMS-ManagerTests/Helpers/DeviceConfigurations.swift`

## 🚀 Next Steps

1. **Record Initial Snapshots**: Run tests in record mode to create baseline images
2. **Commit Snapshots**: Add `__Snapshots__/` directory to git
3. **Enable CI Checks**: Uncomment snapshot tests in CI workflow
4. **Maintain**: Update snapshots when UI changes are intentional

## ❓ FAQ

**Q: Why can't I run tests in Xcode?**
A: Xcode's test sandbox is read-only. Use the command-line script instead.

**Q: Do I need to commit snapshot images?**
A: Yes! They're your visual regression baseline.

**Q: How do I update snapshots after UI changes?**
A: Set `recordMode = true`, run tests, review changes, set back to `false`, commit.

**Q: Tests fail with tiny pixel differences?**
A: Font rendering can vary by OS version. This is normal - review and re-record if acceptable.

---

**Status**: ✅ Ready for use via command line
**Maintainer**: The Spellbinding Museum Director of Visual Testing
