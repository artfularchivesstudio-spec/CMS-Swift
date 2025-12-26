# 🎭 GitHub Actions Setup Guide

> "A mystical guide to configuring GitHub Actions for the CMS-Manager project, ensuring your repository is ready for automated workflows."

## 📋 Prerequisites

Before setting up GitHub Actions, ensure you have:

- [ ] GitHub repository created
- [ ] Repository access (admin/write permissions)
- [ ] Local development environment configured
- [ ] Project building successfully locally

## 🚀 Quick Start

### 1. Push Workflow Files

The workflow files are already in `.github/workflows/`. Push them to your repository:

```bash
git add .github/
git commit -m "ci: Add GitHub Actions workflows"
git push origin main
```

### 2. Verify Workflows

1. Go to your repository on GitHub
2. Click on the **Actions** tab
3. You should see these workflows:
   - ✅ CI
   - 🚀 Deploy
   - 📋 PR Checks
   - 🌙 Nightly Build

### 3. Enable Workflows

If workflows are disabled:

1. Go to Settings > Actions > General
2. Under "Actions permissions", select:
   - ✅ **Allow all actions and reusable workflows**
3. Under "Workflow permissions", select:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

## ⚙️ Configuration Steps

### Step 1: Configure Repository Settings

#### 1.1 Branch Protection Rules

Protect your `main` branch:

1. Go to **Settings > Branches**
2. Click **Add rule**
3. Branch name pattern: `main`
4. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require conversation resolution before merging
   - ✅ Do not allow bypassing the above settings

5. Add required status checks:
   - `test`
   - `build`
   - `lint`
   - `quick-test` (from PR Checks)

6. Click **Create** or **Save changes**

#### 1.2 Actions Settings

Configure Actions behavior:

1. Go to **Settings > Actions > General**

2. **Actions permissions:**
   - ✅ Allow all actions and reusable workflows

3. **Workflow permissions:**
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests

4. **Fork pull request workflows:**
   - ✅ Run workflows from fork pull requests
   - Require approval for first-time contributors

#### 1.3 Code Owners

The CODEOWNERS file is already created. Update it:

```bash
# Edit .github/CODEOWNERS
# Replace @YOUR_USERNAME with your GitHub username
```

Example:
```
* @johndoe
/.github/ @johndoe @janedoe
```

### Step 2: Update README Badges

Update the badges in `README.md` with your repository information:

```markdown
[![CI](https://github.com/YOUR_USERNAME/CMS-Manager/workflows/CI/badge.svg)](https://github.com/YOUR_USERNAME/CMS-Manager/actions/workflows/ci.yml)
[![Deploy](https://github.com/YOUR_USERNAME/CMS-Manager/workflows/Deploy/badge.svg)](https://github.com/YOUR_USERNAME/CMS-Manager/actions/workflows/deploy.yml)
```

Replace `YOUR_USERNAME` with your GitHub username or organization name.

### Step 3: Configure Notifications (Optional)

#### Email Notifications

1. Go to your GitHub profile settings
2. Navigate to **Notifications**
3. Configure email preferences for Actions

#### Slack Notifications (Optional)

To add Slack notifications:

1. Create a Slack webhook URL
2. Add as repository secret: `SLACK_WEBHOOK`
3. Uncomment notification steps in workflow files

### Step 4: Test the Setup

#### Test CI Workflow

1. Create a test branch:
   ```bash
   git checkout -b test/ci-setup
   ```

2. Make a small change:
   ```bash
   echo "# Test CI" >> TEST.md
   git add TEST.md
   git commit -m "test: Verify CI workflow"
   ```

3. Push the branch:
   ```bash
   git push origin test/ci-setup
   ```

4. Create a Pull Request on GitHub

5. Verify that workflows run automatically

6. Check that all jobs complete successfully

#### Test Manual Workflow

1. Go to **Actions** tab
2. Select **CI** workflow
3. Click **Run workflow**
4. Select branch and any inputs
5. Click **Run workflow**
6. Monitor the execution

### Step 5: Configure Secrets (Future)

When ready for App Store distribution, add these secrets:

1. Go to **Settings > Secrets and variables > Actions**
2. Click **New repository secret**
3. Add each required secret:

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID | App Store Connect > Users and Access > Keys |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | Same page as API Key |
| `CERTIFICATE_P12` | Code signing cert (base64) | Export from Keychain, then `base64 -i cert.p12` |
| `CERTIFICATE_PASSWORD` | Certificate password | Password used when exporting |
| `PROVISIONING_PROFILE` | Provisioning profile (base64) | Download from Apple, then `base64 -i profile.mobileprovision` |

## 🎨 Customization

### Adjust Workflow Triggers

#### CI Workflow

Edit `.github/workflows/ci.yml`:

```yaml
on:
  push:
    branches:
      - main
      - develop  # Add additional branches
  pull_request:
    branches:
      - main
      - develop
```

#### Nightly Build Schedule

Edit `.github/workflows/nightly.yml`:

```yaml
on:
  schedule:
    # Run at 2 AM UTC instead of midnight
    - cron: '0 2 * * *'
```

Cron schedule examples:
- `0 0 * * *` - Daily at midnight UTC
- `0 */6 * * *` - Every 6 hours
- `0 0 * * 1` - Weekly on Monday
- `0 0 1 * *` - Monthly on the 1st

### Add Custom Devices

Edit the device matrix in workflows:

```yaml
strategy:
  matrix:
    device:
      - 'iPhone 15 Pro'
      - 'iPhone 15 Pro Max'
      - 'iPhone SE (3rd generation)'
      - 'iPad Air (5th generation)'
```

### Configure Code Coverage Thresholds

Add coverage enforcement to CI workflow:

```yaml
- name: Check Coverage Threshold
  run: |
    COVERAGE=$(xcrun xccov view --report .build/TestResults.xcresult | grep -E "CMS-Manager\.app" | awk '{print $4}' | sed 's/%//' | head -1)
    THRESHOLD=70

    if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
      echo "❌ Coverage $COVERAGE% is below threshold $THRESHOLD%"
      exit 1
    else
      echo "✅ Coverage $COVERAGE% meets threshold $THRESHOLD%"
    fi
```

## 🔍 Verification Checklist

After setup, verify:

- [ ] All workflows appear in Actions tab
- [ ] Workflows are enabled (not disabled)
- [ ] Branch protection rules are configured
- [ ] CODEOWNERS file has correct usernames
- [ ] README badges work (may need first workflow run)
- [ ] Test PR triggers workflows correctly
- [ ] Manual workflow dispatch works
- [ ] Workflow permissions are correct
- [ ] Artifacts are uploaded successfully
- [ ] Notifications are configured (if desired)

## 🐛 Troubleshooting

### Workflows Not Appearing

**Problem:** Workflows don't show in Actions tab

**Solutions:**
1. Ensure workflow files are in `.github/workflows/`
2. Check YAML syntax: `yamllint .github/workflows/*.yml`
3. Verify workflows are committed to default branch
4. Check repository Actions settings are enabled

### Permission Errors

**Problem:** Workflow fails with permission errors

**Solutions:**
1. Check **Settings > Actions > General > Workflow permissions**
2. Ensure "Read and write permissions" is selected
3. For PR comments, enable "Allow GitHub Actions to create and approve pull requests"

### Workflow Not Triggering

**Problem:** Push doesn't trigger workflow

**Solutions:**
1. Verify branch name matches workflow trigger
2. Check if paths filter is too restrictive
3. Ensure workflow is not disabled
4. Check if commits are made by GitHub Actions (may not trigger workflows)

### Status Check Not Required

**Problem:** PR can be merged without CI passing

**Solutions:**
1. Go to **Settings > Branches**
2. Edit branch protection rule
3. Add status checks under "Require status checks to pass"
4. Status checks must run at least once to appear in list

### Cache Issues

**Problem:** Builds are slow despite caching

**Solutions:**
1. Verify cache key is correct
2. Check cache hit/miss in workflow logs
3. Clear cache: **Actions > Caches > Delete**
4. Ensure cache path exists and is correct

## 📚 Additional Resources

### GitHub Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Using Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

### Xcode on GitHub Actions

- [Available Xcode Versions](https://github.com/actions/runner-images/blob/main/images/macos/macos-14-Readme.md)
- [macOS Runner Images](https://github.com/actions/runner-images)

### CI/CD Best Practices

- [Caching Dependencies](https://docs.github.com/en/actions/guides/caching-dependencies-to-speed-up-workflows)
- [Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

## 🎯 Next Steps

After completing setup:

1. **Run Initial Tests**
   - Create a test PR
   - Verify all workflows pass
   - Review artifacts

2. **Configure Monitoring**
   - Set up email notifications
   - Add Slack integration (optional)
   - Monitor workflow run times

3. **Optimize Performance**
   - Review cache effectiveness
   - Adjust timeouts if needed
   - Parallelize independent jobs

4. **Plan for Distribution**
   - Set up App Store Connect API
   - Configure code signing
   - Enable TestFlight workflow

5. **Document Custom Changes**
   - Update this guide with customizations
   - Share with team members
   - Create runbook for common issues

## 🎭 Support

For issues or questions:

1. Check [CI/CD Documentation](CI-CD.md)
2. Review [GitHub Actions logs](#debugging)
3. Search [GitHub Actions community](https://github.community/c/code-to-cloud/github-actions/)
4. Create issue in repository

---

**✨ May your CI/CD setup be smooth and your pipelines ever green! ✨**
