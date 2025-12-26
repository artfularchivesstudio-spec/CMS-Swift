# Scripts Directory

This directory contains automation scripts for building, testing, and maintaining the CMS Manager project.

## Available Scripts

### 🧪 run_tests.sh

The main testing script that builds and runs all unit tests and snapshot tests.

**Usage:**
```bash
./scripts/run_tests.sh [options]
```

**Options:**
- `-d, --device <name>` - Specify simulator device (default: iPhone 15 Pro)
- `-o, --os <version>` - Specify iOS version (default: latest)
- `-c, --clean` - Clean build before testing
- `--no-coverage` - Disable code coverage
- `-v, --verbose` - Enable verbose output
- `-r, --record` - Record snapshot tests (update snapshots)
- `-h, --help` - Show help message

**Examples:**
```bash
# Run all tests with default settings
./scripts/run_tests.sh

# Run tests on a specific device
./scripts/run_tests.sh -d "iPhone 15 Pro Max"

# Run tests with clean build and verbose output
./scripts/run_tests.sh -c -v

# Run tests without code coverage
./scripts/run_tests.sh --no-coverage
```

**What it does:**
1. Builds the project for testing
2. Runs all unit tests and snapshot tests
3. Generates code coverage reports
4. Saves test results to `.build/TestResults.xcresult`
5. Creates test logs in `.build/test-output.log`

---

### 📸 update_snapshots.sh

Updates snapshot test reference images when UI changes are intentional.

**Usage:**
```bash
./scripts/update_snapshots.sh [options]
```

**Options:**
- `-d, --device <name>` - Specify simulator device (default: iPhone 15 Pro)
- `-o, --os <version>` - Specify iOS version (default: latest)
- `-y, --yes` - Skip confirmation prompt
- `-v, --verbose` - Enable verbose output
- `-t, --test <name>` - Update specific test only
- `-h, --help` - Show help message

**Examples:**
```bash
# Update all snapshots (with confirmation)
./scripts/update_snapshots.sh

# Update all snapshots without confirmation
./scripts/update_snapshots.sh -y

# Update only specific snapshot test
./scripts/update_snapshots.sh -t UploadStepSnapshotTests

# Update snapshots on different device
./scripts/update_snapshots.sh -d "iPhone 15 Pro Max"
```

**What it does:**
1. Shows current snapshot count and asks for confirmation
2. Builds the project for testing
3. Runs snapshot tests in recording mode
4. Updates all reference images in `CMS-ManagerTests/__Snapshots__/`
5. Reports which snapshots were updated

**Important Notes:**
- Only run this when UI changes are intentional and verified
- Always review the updated snapshots before committing
- Use `git diff CMS-ManagerTests/__Snapshots__/` to review changes
- Commit updated snapshots along with the code changes that caused them

---

### 🏗️ generate_xcodeproj.sh

Generates the Xcode project file from project.yml configuration.

**Usage:**
```bash
./scripts/generate_xcodeproj.sh
```

---

## Continuous Integration

The project uses GitHub Actions for automated testing on every pull request and push to main.

**Workflow File:** `.github/workflows/ci.yml`

**What it does:**
1. Runs on pull requests to `main` and `develop` branches
2. Runs on pushes to `main` branch
3. Uses macOS-14 runner with Xcode 15.2
4. Caches Swift Package Manager dependencies
5. Builds and runs all tests
6. Uploads test results as artifacts
7. Uploads failed snapshots if tests fail
8. Posts test summary as PR comment

**Artifacts:**
- `test-results` - Complete test results bundle (.xcresult)
- `failed-snapshots` - Failed snapshot comparison images (only on failure)

---

## Test Results

After running tests, you can find results in:

**Test Results Bundle:**
```
CMS-Manager/.build/TestResults.xcresult
```

Open in Xcode:
```bash
open CMS-Manager/.build/TestResults.xcresult
```

**Test Logs:**
```
CMS-Manager/.build/test-output.log
```

**Code Coverage:**
View coverage data in the TestResults.xcresult bundle or use Xcode's coverage viewer.

---

## Snapshot Testing

Snapshot tests verify UI appearance by comparing rendered views against reference images.

**Snapshot Location:**
```
CMS-ManagerTests/__Snapshots__/
```

**Workflow:**

1. **Initial Setup:** Run tests to create initial snapshots
   ```bash
   ./scripts/run_tests.sh -r
   ```

2. **Regular Testing:** Run tests to compare against snapshots
   ```bash
   ./scripts/run_tests.sh
   ```

3. **Update After Changes:** Update snapshots when UI changes intentionally
   ```bash
   ./scripts/update_snapshots.sh
   git diff CMS-ManagerTests/__Snapshots__/
   git add CMS-ManagerTests/__Snapshots__/
   git commit -m "Update snapshots for new UI design"
   ```

4. **CI Validation:** GitHub Actions runs snapshot tests in comparison mode
   - Fails if snapshots don't match
   - Uploads failure diffs as artifacts for review

---

## Troubleshooting

### Tests Fail Locally But Pass on CI (or vice versa)

This usually indicates device/simulator differences:
- Check iOS version matches between local and CI
- Check device type (iPhone 15 Pro vs others)
- Ensure clean build: `./scripts/run_tests.sh -c`

### Snapshot Tests Fail After Xcode Update

Xcode updates can change rendering slightly:
1. Verify changes are only rendering differences
2. Update snapshots: `./scripts/update_snapshots.sh`
3. Review and commit updated snapshots

### Build Failures

Clean and rebuild:
```bash
./scripts/run_tests.sh -c
```

Or manually:
```bash
rm -rf CMS-Manager/.build
xcodebuild clean -project CMS-Manager/CMS-Manager.xcodeproj -scheme CMS_Manager
```

### Permission Denied

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

---

## Best Practices

1. **Always run tests before committing:**
   ```bash
   ./scripts/run_tests.sh
   ```

2. **Update snapshots deliberately:**
   - Only when UI changes are intentional
   - Review all changes before committing
   - Document why snapshots changed in commit message

3. **Use verbose mode for debugging:**
   ```bash
   ./scripts/run_tests.sh -v
   ```

4. **Clean build when things seem weird:**
   ```bash
   ./scripts/run_tests.sh -c
   ```

5. **Check coverage regularly:**
   - Open `.build/TestResults.xcresult` in Xcode
   - Aim for high coverage on critical paths
   - Add tests for uncovered code

---

## Environment Variables

The scripts support these environment variables:

- `SNAPSHOT_TEST_RECORD_MODE` - Set to `1` to record snapshots, `0` to compare (set automatically by scripts)
- `XCODE_PATH` - Custom Xcode path (optional)

---

## CI Configuration

To modify CI behavior, edit `.github/workflows/ci.yml`:

**Change iOS version:**
```yaml
-destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.5'
```

**Change timeout:**
```yaml
timeout-minutes: 45
```

**Add additional test steps:**
Add new steps in the `jobs.test.steps` section.

---

For questions or issues, consult the project documentation or open an issue on GitHub.
