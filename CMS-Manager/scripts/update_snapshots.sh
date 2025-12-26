#!/bin/bash
# 📸 The Snapshot Enchanter - Capturing UI Perfection
#
# "This mystical script wields the power to crystallize your UI's appearance,
# creating eternal reference images that serve as guardians of visual consistency.
# When invoked, it records the current state of your views, preserving them
# for all future comparison rituals."
#
# - The Spellbinding Snapshot Maestro

set -e  # Exit on error
set -o pipefail  # Catch errors in pipes

# 🎨 Color definitions for theatrical output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 🔮 Configuration Constants
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SCHEME="CMS_Manager"
PROJECT_FILE="$PROJECT_DIR/CMS-Manager.xcodeproj"
DERIVED_DATA="$PROJECT_DIR/.build"
SNAPSHOTS_DIR="$PROJECT_DIR/CMS-ManagerTests/__Snapshots__"

# 🌟 The Grand Announcement - The Snapshot Ritual Begins!
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║  📸 The Snapshot Crystallization Ritual Begins! 📸  ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ⚠️ Warning banner - This is a significant action
echo -e "${YELLOW}⚠️  WARNING: This will update ALL snapshot test references!${NC}"
echo -e "${YELLOW}   Only proceed if you've verified the UI changes are correct.${NC}"
echo ""

# ✨ Parse command line arguments
DEVICE="iPhone 15 Pro"
OS_VERSION="latest"
AUTO_YES=false
VERBOSE=false
SPECIFIC_TEST=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -o|--os)
            OS_VERSION="$2"
            shift 2
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -t|--test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        -h|--help)
            echo "📸 Snapshot Update Script - The Visual Guardian"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -d, --device <name>    Specify simulator device (default: iPhone 15 Pro)"
            echo "  -o, --os <version>     Specify iOS version (default: latest)"
            echo "  -y, --yes              Skip confirmation prompt"
            echo "  -v, --verbose          Enable verbose output"
            echo "  -t, --test <name>      Update specific test only"
            echo "  -h, --help             Show this mystical help message"
            echo ""
            echo "Examples:"
            echo "  $0                           # Update all snapshots (with confirmation)"
            echo "  $0 -y                        # Update all snapshots (no confirmation)"
            echo "  $0 -t UploadStepSnapshotTests  # Update specific test"
            echo "  $0 -d 'iPhone 15 Pro Max'    # Use different device"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# 🌐 Determine destination
if [ "$OS_VERSION" = "latest" ]; then
    DESTINATION="platform=iOS Simulator,name=$DEVICE"
else
    DESTINATION="platform=iOS Simulator,name=$DEVICE,OS=$OS_VERSION"
fi

echo -e "${CYAN}📱 Device Configuration:${NC} $DEVICE"
echo -e "${CYAN}📍 Destination:${NC} $DESTINATION"

if [ -n "$SPECIFIC_TEST" ]; then
    echo -e "${CYAN}🎯 Target Test:${NC} $SPECIFIC_TEST"
fi
echo ""

# 🔍 Show current snapshot status
if [ -d "$SNAPSHOTS_DIR" ]; then
    SNAPSHOT_COUNT=$(find "$SNAPSHOTS_DIR" -name "*.png" | wc -l | tr -d ' ')
    echo -e "${BLUE}📊 Current snapshots found:${NC} $SNAPSHOT_COUNT images"
    echo -e "${BLUE}📁 Snapshots location:${NC} $SNAPSHOTS_DIR"
    echo ""
fi

# 🤔 Confirmation prompt (unless auto-yes is set)
if [ "$AUTO_YES" = false ]; then
    echo -e "${YELLOW}❓ Do you want to proceed with updating snapshots?${NC}"
    echo -e "   This will replace existing reference images."
    echo -n "   Type 'yes' to continue: "
    read -r CONFIRMATION

    if [ "$CONFIRMATION" != "yes" ]; then
        echo -e "${RED}❌ Snapshot update cancelled by the seeker.${NC}"
        exit 0
    fi
    echo ""
fi

# 🏗️ Build for testing first
echo -e "${BLUE}🏗️  Building for testing...${NC}"

BUILD_ARGS=(
    -project "$PROJECT_FILE"
    -scheme "$SCHEME"
    -sdk iphonesimulator
    -destination "$DESTINATION"
    -derivedDataPath "$DERIVED_DATA"
    build-for-testing
)

if [ "$VERBOSE" = false ]; then
    BUILD_ARGS+=(-quiet)
fi

if ! xcodebuild "${BUILD_ARGS[@]}"; then
    echo -e "${RED}💥 Build failed! Cannot proceed with snapshot update.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"
echo ""

# 📸 The Snapshot Recording Ritual
echo -e "${PURPLE}📸 Capturing the mystical UI snapshots...${NC}"
echo ""

# Set recording mode environment variable
export SNAPSHOT_TEST_RECORD_MODE=1

TEST_ARGS=(
    -project "$PROJECT_FILE"
    -scheme "$SCHEME"
    -sdk iphonesimulator
    -destination "$DESTINATION"
    -derivedDataPath "$DERIVED_DATA"
    -resultBundlePath "$DERIVED_DATA/SnapshotResults.xcresult"
    test-without-building
)

# Add specific test filter if provided
if [ -n "$SPECIFIC_TEST" ]; then
    TEST_ARGS+=(-only-testing:"CMS_ManagerTests/$SPECIFIC_TEST")
fi

# Run the tests in recording mode
if [ "$VERBOSE" = true ]; then
    xcodebuild "${TEST_ARGS[@]}" 2>&1 | tee "$DERIVED_DATA/snapshot-update.log"
    TEST_RESULT=${PIPESTATUS[0]}
else
    xcodebuild "${TEST_ARGS[@]}" 2>&1 | tee "$DERIVED_DATA/snapshot-update.log" | grep -E "^Test|Snapshot|PASSED|FAILED|error:"
    TEST_RESULT=${PIPESTATUS[0]}
fi

echo ""

# 📊 Analyze the results
if [ -d "$SNAPSHOTS_DIR" ]; then
    NEW_SNAPSHOT_COUNT=$(find "$SNAPSHOTS_DIR" -name "*.png" | wc -l | tr -d ' ')
    echo -e "${CYAN}📊 Updated snapshot count:${NC} $NEW_SNAPSHOT_COUNT images"

    # Show recently modified snapshots
    echo ""
    echo -e "${CYAN}📸 Recently updated snapshots (last 5):${NC}"
    find "$SNAPSHOTS_DIR" -name "*.png" -type f -exec stat -f "%Sm %N" -t "%Y-%m-%d %H:%M:%S" {} \; | sort -r | head -5 | while read -r line; do
        filename=$(basename "$(echo "$line" | awk '{print $NF}')")
        timestamp=$(echo "$line" | awk '{print $1, $2}')
        echo -e "   ${BLUE}•${NC} $filename ${YELLOW}($timestamp)${NC}"
    done
fi

echo ""

# 🎉 The Grand Finale
if [ $TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 ✨ SNAPSHOTS UPDATED SUCCESSFULLY! ✨ 🎉        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📋 Next steps:${NC}"
    echo -e "   1. Review the updated snapshots in: ${BLUE}$SNAPSHOTS_DIR${NC}"
    echo -e "   2. Run normal tests to verify: ${BLUE}./scripts/run_tests.sh${NC}"
    echo -e "   3. Commit the updated snapshots to version control"
    echo ""
    echo -e "${YELLOW}💡 Tip:${NC} Review changes with: ${BLUE}git diff $SNAPSHOTS_DIR${NC}"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  💥 SNAPSHOT UPDATE ENCOUNTERED ISSUES 💥          ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}🔍 Check the logs for details:${NC}"
    echo -e "   ${BLUE}$DERIVED_DATA/snapshot-update.log${NC}"
    echo ""
    echo -e "${CYAN}🎭 Common issues:${NC}"
    echo -e "   • UI rendering errors in snapshot tests"
    echo -e "   • Missing dependencies or assets"
    echo -e "   • Simulator boot failures"
    echo ""
    exit 1
fi
