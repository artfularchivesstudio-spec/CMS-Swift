#!/bin/bash

# 🧪 Gallery System Verification Script
#
# Tests the snapshot gallery system to ensure everything is ready
# for Agent Alpha's snapshot test execution.

set -e

echo "🧪 ✨ GALLERY SYSTEM VERIFICATION"
echo "========================================"
echo ""

PROJECT_ROOT="/Users/admin/Developer/CMS-Swift"
CMS_DIR="$PROJECT_ROOT/CMS-Manager"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

# Test function
test_file() {
    local file=$1
    local description=$2

    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $description"
        echo "   📁 $file"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $description"
        echo "   📁 $file (NOT FOUND)"
        ((FAILED++))
    fi
    echo ""
}

# Test executable
test_executable() {
    local file=$1
    local description=$2

    if [ -x "$file" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $description"
        echo "   📁 $file"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $description"
        echo "   📁 $file (NOT EXECUTABLE)"
        ((FAILED++))
    fi
    echo ""
}

# Test command
test_command() {
    local cmd=$1
    local description=$2

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -1)
        echo -e "${GREEN}✅ PASS${NC}: $description"
        echo "   🔧 $version"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $description"
        echo "   🔧 $cmd (NOT FOUND)"
        ((FAILED++))
    fi
    echo ""
}

echo "📋 Testing Gallery Files..."
echo "----------------------------"
test_file "$CMS_DIR/snapshot-gallery.html" "Gallery Template"
test_file "$CMS_DIR/snapshot-gallery-preview.html" "Preview Demo"
test_file "$CMS_DIR/SNAPSHOT_GALLERY_README.md" "Documentation"
test_file "$CMS_DIR/AGENT_CHARLIE_DELIVERY.md" "Delivery Report"

echo "📋 Testing Scripts..."
echo "----------------------------"
test_executable "$CMS_DIR/scripts/build-snapshot-gallery.sh" "Gallery Builder Script"

echo "📋 Testing System Dependencies..."
echo "----------------------------"
test_command "python3" "Python 3"
test_command "bash" "Bash Shell"
test_command "find" "Find Utility"

echo "📋 Testing File Sizes..."
echo "----------------------------"

# Check template size
TEMPLATE_SIZE=$(stat -f%z "$CMS_DIR/snapshot-gallery.html" 2>/dev/null || stat -c%s "$CMS_DIR/snapshot-gallery.html")
if [ "$TEMPLATE_SIZE" -gt 10000 ]; then
    echo -e "${GREEN}✅ PASS${NC}: Gallery template has substantial content"
    echo "   📊 Size: $TEMPLATE_SIZE bytes"
    ((PASSED++))
else
    echo -e "${RED}❌ FAIL${NC}: Gallery template seems too small"
    echo "   📊 Size: $TEMPLATE_SIZE bytes"
    ((FAILED++))
fi
echo ""

# Check script size
SCRIPT_SIZE=$(stat -f%z "$CMS_DIR/scripts/build-snapshot-gallery.sh" 2>/dev/null || stat -c%s "$CMS_DIR/scripts/build-snapshot-gallery.sh")
if [ "$SCRIPT_SIZE" -gt 5000 ]; then
    echo -e "${GREEN}✅ PASS${NC}: Builder script has substantial content"
    echo "   📊 Size: $SCRIPT_SIZE bytes"
    ((PASSED++))
else
    echo -e "${RED}❌ FAIL${NC}: Builder script seems too small"
    echo "   📊 Size: $SCRIPT_SIZE bytes"
    ((FAILED++))
fi
echo ""

echo "📋 Testing HTML Validity..."
echo "----------------------------"

# Basic HTML validation
if grep -q "<!DOCTYPE html>" "$CMS_DIR/snapshot-gallery.html"; then
    echo -e "${GREEN}✅ PASS${NC}: Gallery has valid DOCTYPE"
    ((PASSED++))
else
    echo -e "${RED}❌ FAIL${NC}: Gallery missing DOCTYPE"
    ((FAILED++))
fi
echo ""

if grep -q "const SNAPSHOTS" "$CMS_DIR/snapshot-gallery.html"; then
    echo -e "${GREEN}✅ PASS${NC}: Gallery has snapshot data structure"
    ((PASSED++))
else
    echo -e "${RED}❌ FAIL${NC}: Gallery missing snapshot data structure"
    ((FAILED++))
fi
echo ""

echo "📋 Testing Preview Gallery..."
echo "----------------------------"

if grep -q "Preview Mode" "$CMS_DIR/snapshot-gallery-preview.html"; then
    echo -e "${GREEN}✅ PASS${NC}: Preview has preview notice"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️  WARN${NC}: Preview missing preview notice"
    ((FAILED++))
fi
echo ""

echo "📋 Testing Script Functionality..."
echo "----------------------------"

# Test script can detect missing snapshots
if "$CMS_DIR/scripts/build-snapshot-gallery.sh" 2>&1 | grep -q "Snapshot directory not found"; then
    echo -e "${GREEN}✅ PASS${NC}: Builder script correctly detects missing snapshots"
    ((PASSED++))
else
    echo -e "${RED}❌ FAIL${NC}: Builder script error detection failed"
    ((FAILED++))
fi
echo ""

echo "========================================"
echo "📊 TEST RESULTS"
echo "========================================"
echo ""
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo ""

TOTAL=$((PASSED + FAILED))
PERCENTAGE=$((PASSED * 100 / TOTAL))

echo "🎯 Success Rate: $PERCENTAGE% ($PASSED/$TOTAL)"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ✨ ALL TESTS PASSED! Gallery system is ready!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Wait for Agent Alpha to run snapshot tests"
    echo "2. Run: ./scripts/build-snapshot-gallery.sh"
    echo "3. Open: snapshot-gallery-report.html"
    echo ""
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please review the issues above.${NC}"
    echo ""
    exit 1
fi
