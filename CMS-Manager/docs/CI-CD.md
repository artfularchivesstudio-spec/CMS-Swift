# 🎭 CI/CD Pipeline Documentation

> "Where automation meets artistry - a comprehensive guide to the mystical workflows that ensure quality and consistency in our CMS-Manager project."

## 📋 Table of Contents

- [Overview](#overview)
- [Workflows](#workflows)
- [Configuration](#configuration)
- [Secrets & Environment Variables](#secrets--environment-variables)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🌟 Overview

The CMS-Manager project uses GitHub Actions for continuous integration and deployment. Our CI/CD pipeline ensures code quality, runs comprehensive tests, and automates the build and release process.

### Pipeline Goals

- ✅ Automated testing on every push and PR
- 🔍 Code quality enforcement via SwiftLint
- 📊 Code coverage tracking
- 🏗️ Automated builds for multiple configurations
- 🚀 Streamlined release process
- 📱 Multi-device testing support

## 🎪 Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**
- Push to `main` branch
- All pull requests
- Manual workflow dispatch

**Jobs:**

#### 🧪 Test Job
- Builds the project for testing
- Runs unit tests and UI tests
- Generates code coverage reports
- Uploads test results as artifacts

**Duration:** ~15-20 minutes

#### 🏗️ Build Job
- Builds Release configuration
- Creates iOS Simulator build
- Archives build artifacts

**Duration:** ~10-15 minutes

#### 🧹 Lint Job
- Runs SwiftLint analysis
- Reports code style issues
- Non-blocking (continues on error)

**Duration:** ~2-5 minutes

#### 📊 Summary Job
- Aggregates all job results
- Generates pipeline summary
- Posts to GitHub Actions summary

**Configuration:**
```yaml
env:
  DEVELOPER_DIR: /Applications/Xcode_15.2.app/Contents/Developer
  SCHEME: CMS_Manager
  IOS_SIMULATOR_DEVICE: iPhone 15 Pro
  XCODE_VERSION: '15.2'
```

### 2. Deploy Workflow (`.github/workflows/deploy.yml`)

**Triggers:**
- Git tags matching `v*.*.*` (e.g., `v1.0.0`)
- Manual workflow dispatch

**Jobs:**

#### 🏗️ Build Archive Job
- Generates Xcode project from `project.yml`
- Builds Release archive
- Extracts version information
- Generates release notes from commits
- Creates GitHub Release (as draft)
- Uploads build artifacts

**Duration:** ~20-30 minutes

**Release Process:**
1. Tag a commit: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. Workflow runs automatically
4. Draft release created on GitHub
5. Review and publish release manually

#### 🚀 TestFlight Job (Future)
- Placeholder for App Store distribution
- Requires code signing configuration
- Currently commented out

### 3. PR Checks Workflow (`.github/workflows/pr-checks.yml`)

**Triggers:**
- Pull request opened, synchronized, or reopened
- Pull request ready for review

**Jobs:**

#### 📋 Validate PR Job
- Checks PR title follows semantic versioning
- Validates PR size (warns if >1000 lines)
- Ensures proper PR metadata

#### 🔍 Code Quality Job
- Runs SwiftLint with strict mode
- Performs security scans (hardcoded secrets, force unwraps)
- Generates quality report

#### 🧪 Quick Test Job
- Runs unit tests only (faster than full CI)
- Skips UI tests for speed
- Provides quick feedback on PRs

#### 📝 PR Comment Job
- Posts automated comment on PR
- Shows check results in table format
- Updates existing comment on re-runs

**Duration:** ~10-15 minutes

### 4. Nightly Build Workflow (`.github/workflows/nightly.yml`)

**Triggers:**
- Scheduled daily at midnight UTC (`cron: '0 0 * * *'`)
- Manual workflow dispatch

**Jobs:**

#### 🌙 Comprehensive Tests Job
- Matrix strategy across multiple devices:
  - iPhone 15 Pro
  - iPhone 15 Pro Max
  - iPad Pro (12.9-inch)
- Runs all tests (unit + UI)
- Generates coverage for each device
- Archives results for 14 days

#### ⚡ Performance Tests Job
- Runs performance benchmarks
- Tracks performance metrics over time
- Identifies performance regressions

#### 📊 Build Size Analysis Job
- Analyzes release build size
- Tracks binary size growth
- Reports framework and asset sizes
- Generates size comparison report

#### 📧 Nightly Summary Job
- Aggregates all nightly results
- Generates comprehensive summary
- (Optional) Sends notifications

**Duration:** ~45-60 minutes

## ⚙️ Configuration

### Xcode Version

All workflows use Xcode 15.2:

```yaml
env:
  DEVELOPER_DIR: /Applications/Xcode_15.2.app/Contents/Developer
  XCODE_VERSION: '15.2'
```

To update Xcode version:
1. Update `DEVELOPER_DIR` in all workflow files
2. Update `XCODE_VERSION` environment variable
3. Test locally before committing

### Swift Package Manager Caching

SPM dependencies are cached for faster builds:

```yaml
- name: 📦 Cache SPM Dependencies
  uses: actions/cache@v4
  with:
    path: |
      .build
      ~/Library/Developer/Xcode/DerivedData
      Packages/ArtfulArchivesCore/.build
    key: ${{ runner.os }}-spm-${{ hashFiles('**/Package.resolved', '**/project.yml') }}
```

Cache is invalidated when:
- `Package.resolved` changes
- `project.yml` changes
- Runner OS changes

### Build Settings

#### Code Signing (Simulator)
```bash
CODE_SIGN_IDENTITY=""
CODE_SIGNING_REQUIRED=NO
```

#### Architecture
```bash
ONLY_ACTIVE_ARCH=NO  # Build for all architectures
```

#### Configurations
- **Debug**: Used for testing
- **Release**: Used for builds and archives

## 🔐 Secrets & Environment Variables

### GitHub Secrets

Currently required secrets: **None** (simulator builds only)

### Future Secrets (for TestFlight/App Store)

When ready for distribution, add these secrets:

| Secret Name | Description | Required For |
|------------|-------------|--------------|
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID | TestFlight upload |
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect Issuer ID | TestFlight upload |
| `CERTIFICATE_P12` | Code signing certificate (base64) | Device builds |
| `CERTIFICATE_PASSWORD` | Certificate password | Device builds |
| `PROVISIONING_PROFILE` | Provisioning profile (base64) | Device builds |
| `SLACK_WEBHOOK` | Slack webhook for notifications | Notifications |

### Setting Secrets

1. Go to repository Settings > Secrets and variables > Actions
2. Click "New repository secret"
3. Add secret name and value
4. Reference in workflow: `${{ secrets.SECRET_NAME }}`

## 🎨 Customization

### Adding New Devices

To test on additional devices, update the matrix in `nightly.yml`:

```yaml
strategy:
  matrix:
    device:
      - 'iPhone 15 Pro'
      - 'iPhone 15 Pro Max'
      - 'iPad Pro (12.9-inch) (6th generation)'
      - 'iPhone SE (3rd generation)'  # Add new device
```

### Adjusting Test Timeout

Update timeout in workflow:

```yaml
jobs:
  test:
    timeout-minutes: 30  # Adjust as needed
```

### Changing Nightly Schedule

Update cron schedule in `nightly.yml`:

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Midnight UTC
    # Examples:
    # - cron: '0 2 * * *'  # 2 AM UTC
    # - cron: '0 0 * * 1'  # Midnight Monday
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Build Failures

**Problem:** Xcode project generation fails

**Solution:**
```bash
# Ensure XcodeGen is installed locally
brew install xcodegen

# Validate project.yml syntax
xcodegen generate --spec project.yml
```

#### 2. Test Failures

**Problem:** Tests pass locally but fail in CI

**Possible Causes:**
- Different Xcode version
- Missing simulator runtime
- Snapshot test differences
- Race conditions

**Solution:**
```bash
# Match Xcode version locally
sudo xcode-select -s /Applications/Xcode_15.2.app/Contents/Developer

# Run tests with same configuration as CI
./scripts/run_tests.sh --device "iPhone 15 Pro"
```

#### 3. SwiftLint Failures

**Problem:** SwiftLint fails in CI but not locally

**Solution:**
```bash
# Ensure same SwiftLint version
brew upgrade swiftlint

# Run with strict mode (same as CI)
swiftlint lint --strict
```

#### 4. Cache Issues

**Problem:** Builds are slow despite caching

**Solution:**
- Clear cache in GitHub Actions settings
- Verify cache key in workflow file
- Check cache size limits (10GB per repo)

#### 5. Workflow Not Triggering

**Problem:** Push doesn't trigger CI

**Checks:**
- Verify branch name matches trigger
- Check if workflow file has syntax errors
- Ensure workflow is enabled in Actions settings

### Debugging Workflows

#### Enable Debug Logging

Add secrets to enable verbose logging:
- `ACTIONS_RUNNER_DEBUG`: `true`
- `ACTIONS_STEP_DEBUG`: `true`

#### View Logs

1. Go to Actions tab
2. Click on workflow run
3. Expand job and steps
4. Download logs for local analysis

#### Test Workflow Locally

Use [act](https://github.com/nektos/act) to run workflows locally:

```bash
# Install act
brew install act

# Run CI workflow
act push

# Run specific job
act -j test
```

## 🎯 Best Practices

### 1. Commit Messages

Follow conventional commits for better release notes:

```
feat: Add new artwork filter feature
fix: Resolve crash on artwork detail view
docs: Update CI/CD documentation
test: Add snapshot tests for gallery view
ci: Update Xcode to 15.2
```

### 2. Pull Requests

- Keep PRs focused and reasonably sized (<1000 lines)
- Ensure all CI checks pass before requesting review
- Update tests when changing functionality
- Add screenshots for UI changes

### 3. Version Tagging

Follow semantic versioning:

- `v1.0.0` - Major release (breaking changes)
- `v1.1.0` - Minor release (new features)
- `v1.0.1` - Patch release (bug fixes)

### 4. Code Coverage

Maintain coverage above 70%:

```bash
# View coverage locally
./scripts/run_tests.sh
open .build/TestResults.xcresult
```

### 5. Performance

Monitor build performance:
- Keep test suite under 20 minutes
- Use caching effectively
- Run UI tests in nightly builds only
- Parallelize independent jobs

### 6. Security

- Never commit secrets or API keys
- Use GitHub Secrets for sensitive data
- Review security scan results
- Keep dependencies updated

## 📊 Monitoring & Metrics

### Workflow Status

Check workflow status:
- GitHub Actions tab
- README badges
- Email notifications (configure in settings)

### Key Metrics

Track these metrics:
- **Test Success Rate**: Should be >95%
- **Build Time**: Target <20 minutes for CI
- **Code Coverage**: Target >70%
- **SwiftLint Issues**: Target 0 errors

### Artifacts

Artifacts are retained:
- **Test Results**: 30 days
- **Build Artifacts**: 7 days
- **Nightly Reports**: 14 days
- **Release Builds**: 90 days

## 🚀 Future Enhancements

### Planned Improvements

- [ ] Automatic version bumping
- [ ] TestFlight distribution
- [ ] App Store submission automation
- [ ] Slack/Discord notifications
- [ ] Performance regression detection
- [ ] Automated changelog generation
- [ ] Screenshot automation for App Store
- [ ] Localization validation
- [ ] Accessibility testing
- [ ] UI automation tests

### Contributing

To improve CI/CD:

1. Test changes locally first
2. Create PR with clear description
3. Update this documentation
4. Monitor first runs carefully

---

**✨ May your builds always pass and your deployments run smoothly! ✨**
