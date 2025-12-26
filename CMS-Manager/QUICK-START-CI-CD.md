# 🚀 CI/CD Quick Start Guide

> "Your 5-minute guide to getting the CI/CD pipeline running."

## ✅ Pre-Deployment Checklist

Before pushing to GitHub, complete these steps:

### 1. Update Placeholders (2 minutes)

```bash
# Update README.md badges
# Replace YOUR_USERNAME with your GitHub username
sed -i '' 's/YOUR_USERNAME/your-github-username/g' README.md

# Update CODEOWNERS
# Replace YOUR_USERNAME with your GitHub username
sed -i '' 's/YOUR_USERNAME/your-github-username/g' .github/CODEOWNERS
```

**Or manually edit:**
- `README.md` - Lines with badge URLs
- `.github/CODEOWNERS` - All lines with `@YOUR_USERNAME`

### 2. Verify Setup (1 minute)

```bash
./scripts/verify_ci_setup.sh
```

Should show: `✅ Passed: 34+` with 0-2 warnings.

### 3. Commit CI/CD Files (1 minute)

```bash
git add .github/ scripts/ docs/ .swiftlint.yml .gitignore README.md CI-CD-SETUP-SUMMARY.md
git commit -m "ci: Add comprehensive GitHub Actions CI/CD pipeline

- Add CI workflow for automated testing
- Add deploy workflow for releases
- Add PR checks for code quality
- Add nightly build for comprehensive testing
- Add build scripts and documentation
- Configure SwiftLint and git ignore"
```

### 4. Push to GitHub (1 minute)

```bash
git push origin main
```

## ⚙️ Configure GitHub (3-5 minutes)

### Enable Actions

1. Go to your repo on GitHub
2. Click **Actions** tab
3. If prompted, click **I understand my workflows, go ahead and enable them**

### Set Permissions

1. Go to **Settings > Actions > General**
2. Under **Workflow permissions**:
   - ✅ Select **Read and write permissions**
   - ✅ Check **Allow GitHub Actions to create and approve pull requests**
3. Click **Save**

### Enable Branch Protection (Optional but Recommended)

1. Go to **Settings > Branches**
2. Click **Add rule**
3. Branch name pattern: `main`
4. Enable:
   - ✅ **Require a pull request before merging**
   - ✅ **Require status checks to pass before merging**
5. After first workflow run, add required checks:
   - `test`
   - `build`
   - `lint`
6. Click **Create**

## 🧪 Test the Pipeline (5 minutes)

### Option A: Test with a Pull Request

```bash
# Create test branch
git checkout -b test/ci-pipeline

# Make a small change
echo "# CI/CD Pipeline Active" >> TEST.md

# Commit and push
git add TEST.md
git commit -m "test: Verify CI/CD pipeline"
git push origin test/ci-pipeline
```

Then:
1. Go to GitHub
2. Create Pull Request
3. Watch workflows run automatically
4. Verify all checks pass

### Option B: Manual Trigger

1. Go to **Actions** tab
2. Select **CI** workflow
3. Click **Run workflow**
4. Select `main` branch
5. Click **Run workflow**
6. Monitor execution

## 📊 Workflow Overview

| Workflow | When It Runs | Duration |
|----------|--------------|----------|
| **CI** | Every push, PR | 20-30 min |
| **PR Checks** | Pull requests | 15-20 min |
| **Deploy** | Version tags (v1.0.0) | 30-45 min |
| **Nightly** | Daily at midnight UTC | 45-60 min |

## 🎯 Common Tasks

### Create a Release

```bash
# Tag the commit
git tag v1.0.0

# Push the tag
git push origin v1.0.0
```

Deploy workflow runs automatically and creates a GitHub Release (draft).

### Run Tests Locally

```bash
./scripts/run_tests.sh
```

### Build Locally

```bash
# Debug build
./scripts/build.sh

# Release build
./scripts/build.sh --release
```

### Update Snapshots

```bash
./scripts/update_snapshots.sh
```

## 🔧 Troubleshooting

### Workflows Not Running

**Check:**
- Actions are enabled (Settings > Actions)
- Workflow files are on main branch
- Workflow permissions are set correctly

### Tests Failing in CI but Not Locally

**Try:**
```bash
# Match CI environment
./scripts/run_tests.sh --device "iPhone 15 Pro" --clean
```

### SwiftLint Errors

**Fix:**
```bash
# Auto-fix issues
swiftlint --fix

# Check what will fail
swiftlint lint --strict
```

## 📚 Full Documentation

- **Complete Guide:** `docs/CI-CD.md`
- **Setup Guide:** `docs/GITHUB-ACTIONS-SETUP.md`
- **Summary:** `CI-CD-SETUP-SUMMARY.md`

## 🎉 Success Criteria

CI/CD is working when:
- ✅ Pushes trigger CI workflow
- ✅ PRs show status checks
- ✅ Tests run automatically
- ✅ Builds complete successfully
- ✅ Artifacts are uploaded

## 🆘 Need Help?

1. Run verification: `./scripts/verify_ci_setup.sh`
2. Check workflow logs in GitHub Actions
3. Review documentation in `docs/`
4. Check [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**✨ Ready? Run these commands and you're live in 10 minutes! ✨**

```bash
# 1. Update placeholders (edit manually or use sed)
vim README.md .github/CODEOWNERS

# 2. Verify
./scripts/verify_ci_setup.sh

# 3. Commit
git add .github/ scripts/ docs/ .swiftlint.yml .gitignore README.md
git commit -m "ci: Add CI/CD pipeline"

# 4. Push
git push origin main

# 5. Configure GitHub (web UI)
# 6. Create test PR
# 7. Celebrate! 🎉
```
