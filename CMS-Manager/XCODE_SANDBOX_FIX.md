# 🔧 Manual Xcode Sandbox Fix

## The Problem
Xcode's test sandbox prevents SnapshotTesting from writing reference images to the source directory.

## ✅ Solution: Disable Test Sandbox (5 Steps)

### Step 1: Edit the Test Scheme

1. In Xcode, click **CMS_Manager** scheme (next to Run/Stop buttons)
2. Select **"Edit Scheme..."**
3. Click **"Test"** in left sidebar

### Step 2: Add Environment Variable

1. Select the **"Arguments"** tab at the top
2. In the **"Environment Variables"** section, click **+**
3. Add:
   - **Name**: `SNAPSHOT_ARTIFACTS`
   - **Value**: `$(SOURCE_ROOT)/CMS-ManagerTests`
4. Make sure the checkbox is **checked** ✅

### Step 3: Disable Code Coverage (Important!)

1. Still in Edit Scheme > Test
2. Go to the **"Options"** tab
3. **Uncheck** "Gather coverage for"
4. **Uncheck** "Debug executable" (if checked)

### Step 4: Disable Sandbox Protection

1. Go to the **"Info"** tab
2. Under **"Expand variables based on:"** select **"CMS_Manager"**
3. Close the scheme editor

### Step 5: Set Test Target Build Settings

1. In Xcode project navigator, select **CMS-Manager project** (blue icon at top)
2. Select **CMS_ManagerTests** target
3. Go to **"Build Settings"** tab
4. Search for: `ENABLE_TESTING_SEARCH_PATHS`
5. Set to **NO**
6. Search for: `ENABLE_TESTABILITY`
7. Set to **YES**

### Step 6: Clean and Rebuild

```bash
# In Xcode menu
Product > Clean Build Folder (⇧⌘K)

# Then build for testing
Product > Build for Testing (⇧⌘U)
```

### Step 7: Run Tests

Now you can run snapshot tests directly in Xcode! (⌘U)

---

## Alternative: Use xcodebuild with Custom Destination

If the above doesn't work, use this command:

```bash
cd CMS-Manager

# Build
xcodebuild build-for-testing \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run tests WITHOUT building (avoids sandbox)
xcodebuild test-without-building \
  -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -enableCodeCoverage NO
```

---

## Still Not Working?

### Nuclear Option: Symlink

Create a symlink from the build directory to your source:

```bash
cd CMS-Manager

# Find the build location
BUILD_DIR=$(xcodebuild -project CMS-Manager.xcodeproj \
  -scheme CMS_Manager \
  -showBuildSettings | grep "BUILD_DIR" | head -1 | awk '{print $3}')

# Create symlink
ln -sf "$(pwd)/CMS-ManagerTests/__Snapshots__" \
  "$BUILD_DIR/Debug-iphonesimulator/CMS-Manager.app/PlugIns/CMS_ManagerTests.xctest/__Snapshots__"
```

---

## Why Is This So Hard?

Apple's App Sandbox (enabled for all iOS app tests) prevents writing outside the container. This is a **security feature**, not a bug. Snapshot testing needs to write to your source directory, which conflicts with this design.

**Recommended**: Just set `recordMode = false` and verify snapshots in CI/CD instead! 😅

---

## Verification

After applying the fix, you should see:

```bash
# Run a single test
⌘U on a test function

# Expected output in console:
📸 Using SNAPSHOT_ARTIFACTS path: /path/to/CMS-ManagerTests
✅ Test passed
```

No more "volume is read only" errors!

---

**Last Resort**: If nothing works, snapshot tests can only run in CI/CD (GitHub Actions), which is configured and working fine.
