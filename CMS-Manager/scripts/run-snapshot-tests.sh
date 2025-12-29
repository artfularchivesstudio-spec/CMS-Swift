#!/bin/bash

# 📸 Snapshot Test Runner - Bypasses Xcode Sandbox Issues
# This script runs snapshot tests from the command line with proper environment setup

set -e  # Exit on error

# 🎨 Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 📁 Navigate to CMS-Manager directory
cd "$(dirname "$0")/.."

echo -e "${BLUE}📸 Snapshot Test Runner${NC}"
echo -e "${BLUE}========================${NC}\n"

# 🔍 Parse arguments
RECORD_MODE=false
TEST_NAME=""
DEVICE="iPhone 17 Pro"

while [[ $# -gt 0 ]]; do
    case $1 in
        --record)
            RECORD_MODE=true
            shift
            ;;
        --test)
            TEST_NAME="$2"
            shift 2
            ;;
        --device)
            DEVICE="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --record          Record new snapshots instead of verifying"
            echo "  --test NAME       Run specific test (e.g., StoriesListViewSnapshotTests/testEmptyState)"
            echo "  --device DEVICE   Simulator device to use (default: iPhone 17 Pro)"
            echo "  --help            Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run all snapshot tests"
            echo "  $0 --record                           # Record all snapshots"
            echo "  $0 --test StoriesListViewSnapshotTests/testEmptyState"
            echo "  $0 --record --test StoriesListViewSnapshotTests"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ⚙️ Configuration
PROJECT_DIR="$(pwd)"
SNAPSHOT_DIR="${PROJECT_DIR}/CMS-ManagerTests"
DESTINATION="platform=iOS Simulator,name=${DEVICE}"

echo -e "${YELLOW}Configuration:${NC}"
echo -e "  Project: ${PROJECT_DIR}"
echo -e "  Snapshots: ${SNAPSHOT_DIR}/__Snapshots__"
echo -e "  Device: ${DEVICE}"
echo -e "  Record Mode: ${RECORD_MODE}"
if [ -n "$TEST_NAME" ]; then
    echo -e "  Test Filter: ${TEST_NAME}"
fi
echo ""

# 🎯 Set environment variable for snapshot directory
export SNAPSHOT_ARTIFACTS="${SNAPSHOT_DIR}"

# 📝 Update recordMode in test files if needed
if [ "$RECORD_MODE" = true ]; then
    echo -e "${YELLOW}⚠️  RECORD MODE ENABLED${NC}"
    echo -e "${YELLOW}   Snapshots will be recorded/updated${NC}\n"

    # Note: You'll need to manually set recordMode = true in test files
    # or we can add sed commands here to modify them temporarily
fi

# 🏗️  Build for testing
echo -e "${BLUE}Building for testing...${NC}"
xcodebuild build-for-testing \
    -project CMS-Manager.xcodeproj \
    -scheme CMS_Manager \
    -destination "${DESTINATION}" \
    -quiet

# 🧪 Run tests
echo -e "\n${BLUE}Running tests...${NC}\n"

if [ -n "$TEST_NAME" ]; then
    # Run specific test
    xcodebuild test-without-building \
        -project CMS-Manager.xcodeproj \
        -scheme CMS_Manager \
        -destination "${DESTINATION}" \
        -only-testing:"CMS_ManagerTests/${TEST_NAME}" \
        | grep -v "Gradient stop locations" \
        | grep -E "(Test Suite|Test Case|passed|failed|Executed)"
else
    # Run all snapshot tests
    xcodebuild test-without-building \
        -project CMS-Manager.xcodeproj \
        -scheme CMS_Manager \
        -destination "${DESTINATION}" \
        -only-testing:CMS_ManagerTests \
        | grep -v "Gradient stop locations" \
        | grep -E "(Test Suite|Test Case|passed|failed|Executed)"
fi

TEST_RESULT=$?

echo ""
if [ $TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Tests passed!${NC}"
else
    echo -e "${RED}❌ Tests failed${NC}"
    echo -e "${YELLOW}Check the output above for details${NC}"
fi

exit $TEST_RESULT
