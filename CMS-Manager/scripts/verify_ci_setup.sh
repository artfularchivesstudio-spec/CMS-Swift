#!/bin/bash
# 🔍 The CI/CD Setup Verifier
#
# "This mystical script peers into the digital realm to verify that
# all CI/CD components are properly configured and ready for action."
#
# - The Spellbinding Setup Auditor

set -e

# 🎨 Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 🔮 Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

PASSED=0
FAILED=0
WARNINGS=0

# 🌟 Header
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║    🔍 CI/CD Setup Verification Starting... 🔍     ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ✨ Helper functions
check_file() {
    local file="$1"
    local description="$2"

    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ $description${NC}"
        echo -e "   ${YELLOW}Missing: $file${NC}"
        ((FAILED++))
        return 1
    fi
}

check_directory() {
    local dir="$1"
    local description="$2"

    if [ -d "$PROJECT_DIR/$dir" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ $description${NC}"
        echo -e "   ${YELLOW}Missing directory: $dir${NC}"
        ((FAILED++))
        return 1
    fi
}

check_executable() {
    local file="$1"
    local description="$2"

    if [ -x "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}⚠️  $description${NC}"
        echo -e "   ${YELLOW}Not executable: $file${NC}"
        echo -e "   ${CYAN}Run: chmod +x $file${NC}"
        ((WARNINGS++))
        return 1
    fi
}

check_yaml_syntax() {
    local file="$1"
    local description="$2"

    # Check if file exists first
    if [ ! -f "$PROJECT_DIR/$file" ]; then
        echo -e "${RED}❌ $description - File missing${NC}"
        ((FAILED++))
        return 1
    fi

    # Basic YAML syntax check (Python)
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('$PROJECT_DIR/$file'))" 2>/dev/null; then
            echo -e "${GREEN}✅ $description${NC}"
            ((PASSED++))
            return 0
        else
            echo -e "${YELLOW}⚠️  $description - YAML syntax may have issues${NC}"
            ((WARNINGS++))
            return 1
        fi
    else
        echo -e "${CYAN}ℹ️  $description - Skipping validation (Python not available)${NC}"
        return 0
    fi
}

# 🎯 Check GitHub Actions Workflows
echo -e "${BLUE}📂 Checking GitHub Actions Workflows...${NC}"
check_directory ".github/workflows" "Workflows directory exists"
check_file ".github/workflows/ci.yml" "CI workflow exists"
check_file ".github/workflows/deploy.yml" "Deploy workflow exists"
check_file ".github/workflows/pr-checks.yml" "PR Checks workflow exists"
check_file ".github/workflows/nightly.yml" "Nightly workflow exists"
echo ""

# 🎯 Check YAML Syntax
echo -e "${BLUE}📝 Validating YAML Syntax...${NC}"
check_yaml_syntax ".github/workflows/ci.yml" "CI workflow YAML valid"
check_yaml_syntax ".github/workflows/deploy.yml" "Deploy workflow YAML valid"
check_yaml_syntax ".github/workflows/pr-checks.yml" "PR Checks workflow YAML valid"
check_yaml_syntax ".github/workflows/nightly.yml" "Nightly workflow YAML valid"
check_yaml_syntax ".swiftlint.yml" "SwiftLint config YAML valid"
echo ""

# 🎯 Check GitHub Configuration
echo -e "${BLUE}⚙️  Checking GitHub Configuration...${NC}"
check_file ".github/CODEOWNERS" "CODEOWNERS file exists"
check_file ".github/pull_request_template.md" "PR template exists"
check_file ".github/ISSUE_TEMPLATE/bug_report.md" "Bug report template exists"
check_file ".github/ISSUE_TEMPLATE/feature_request.md" "Feature request template exists"
echo ""

# 🎯 Check Build Scripts
echo -e "${BLUE}🛠️  Checking Build Scripts...${NC}"
check_file "scripts/build.sh" "Build script exists"
check_file "scripts/run_tests.sh" "Test script exists"
check_file "scripts/generate_xcodeproj.sh" "Project generator exists"
check_file "scripts/update_snapshots.sh" "Snapshot updater exists"
echo ""

echo -e "${BLUE}🔐 Checking Script Permissions...${NC}"
check_executable "scripts/build.sh" "Build script is executable"
check_executable "scripts/run_tests.sh" "Test script is executable"
check_executable "scripts/generate_xcodeproj.sh" "Project generator is executable"
check_executable "scripts/update_snapshots.sh" "Snapshot updater is executable"
echo ""

# 🎯 Check Configuration Files
echo -e "${BLUE}📋 Checking Configuration Files...${NC}"
check_file ".swiftlint.yml" "SwiftLint config exists"
check_file ".gitignore" "Git ignore file exists"
check_file "project.yml" "XcodeGen project config exists"
check_file "README.md" "README exists"
echo ""

# 🎯 Check Documentation
echo -e "${BLUE}📚 Checking Documentation...${NC}"
check_directory "docs" "Documentation directory exists"
check_file "docs/CI-CD.md" "CI/CD documentation exists"
check_file "docs/GITHUB-ACTIONS-SETUP.md" "Setup guide exists"
check_file "CI-CD-SETUP-SUMMARY.md" "Setup summary exists"
echo ""

# 🎯 Check for Required Tools
echo -e "${BLUE}🔧 Checking Required Tools...${NC}"

if command -v xcodegen &> /dev/null; then
    XCODEGEN_VERSION=$(xcodegen --version)
    echo -e "${GREEN}✅ XcodeGen installed ($XCODEGEN_VERSION)${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️  XcodeGen not installed${NC}"
    echo -e "   ${CYAN}Install: brew install xcodegen${NC}"
    ((WARNINGS++))
fi

if command -v swiftlint &> /dev/null; then
    SWIFTLINT_VERSION=$(swiftlint version)
    echo -e "${GREEN}✅ SwiftLint installed ($SWIFTLINT_VERSION)${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️  SwiftLint not installed${NC}"
    echo -e "   ${CYAN}Install: brew install swiftlint${NC}"
    ((WARNINGS++))
fi

if command -v xcpretty &> /dev/null; then
    echo -e "${GREEN}✅ xcpretty installed${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️  xcpretty not installed (optional)${NC}"
    echo -e "   ${CYAN}Install: gem install xcpretty${NC}"
    ((WARNINGS++))
fi

echo ""

# 🎯 Check for Placeholders
echo -e "${BLUE}🔍 Checking for Placeholders...${NC}"

if grep -q "YOUR_USERNAME" "$PROJECT_DIR/README.md" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  README.md contains placeholder 'YOUR_USERNAME'${NC}"
    echo -e "   ${CYAN}Update with your GitHub username${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✅ No placeholders in README.md${NC}"
    ((PASSED++))
fi

if grep -q "YOUR_USERNAME" "$PROJECT_DIR/.github/CODEOWNERS" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  CODEOWNERS contains placeholder 'YOUR_USERNAME'${NC}"
    echo -e "   ${CYAN}Update with your GitHub username${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✅ No placeholders in CODEOWNERS${NC}"
    ((PASSED++))
fi

echo ""

# 🎯 Check Git Status
echo -e "${BLUE}📦 Checking Git Status...${NC}"

if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Git repository initialized${NC}"
    ((PASSED++))

    # Check if .github is tracked
    if git ls-files --error-unmatch .github/workflows/ci.yml &>/dev/null; then
        echo -e "${GREEN}✅ CI/CD files are tracked by Git${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠️  CI/CD files not yet committed${NC}"
        echo -e "   ${CYAN}Add files: git add .github/ scripts/ docs/${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}❌ Not a Git repository${NC}"
    ((FAILED++))
fi

echo ""

# 🎯 Xcode Project Check
echo -e "${BLUE}🏗️  Checking Xcode Project...${NC}"

if [ -f "$PROJECT_DIR/CMS-Manager.xcodeproj/project.pbxproj" ]; then
    echo -e "${GREEN}✅ Xcode project exists${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️  Xcode project not found${NC}"
    echo -e "   ${CYAN}Generate: ./scripts/generate_xcodeproj.sh${NC}"
    ((WARNINGS++))
fi

echo ""

# 🎉 Summary
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║             🎭 Verification Summary 🎭             ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Passed:   $PASSED${NC}"
echo -e "${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
echo -e "${RED}❌ Failed:   $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 ✨ Perfect! CI/CD Setup Complete! ✨ 🎉       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. Commit files: ${BLUE}git add . && git commit -m 'ci: Add CI/CD pipeline'${NC}"
    echo -e "  2. Push to GitHub: ${BLUE}git push origin main${NC}"
    echo -e "  3. Configure GitHub Actions (see docs/GITHUB-ACTIONS-SETUP.md)"
    echo ""
    exit 0
elif [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║   ⚠️  Setup Complete with Warnings! ⚠️            ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Please address the warnings above before deploying.${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   💥 Setup Incomplete - Errors Found! 💥          ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Please fix the errors above and run verification again.${NC}"
    echo ""
    exit 1
fi
