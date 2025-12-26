#!/bin/bash
# 🧪 The Test Conductor - Orchestrating the Grand Testing Symphony
#
# "This mystical script channels the power of xcodebuild to invoke
# the sacred testing rituals, ensuring your code performs flawlessly
# in the grand theater of quality assurance."
#
# - The Spellbinding Testing Virtuoso

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

# 🌟 The Grand Announcement - Let the Testing Begin!
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║  🧪 The CMS Manager Testing Symphony Awakens!  🧪  ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ✨ Parse command line arguments with mystical wisdom
DEVICE="iPhone 15 Pro"
OS_VERSION="latest"
CLEAN_BUILD=false
COVERAGE=true
VERBOSE=false
SNAPSHOT_RECORD=false

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
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        --no-coverage)
            COVERAGE=false
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -r|--record)
            SNAPSHOT_RECORD=true
            shift
            ;;
        -h|--help)
            echo "🎭 Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -d, --device <name>    Specify simulator device (default: iPhone 15 Pro)"
            echo "  -o, --os <version>     Specify iOS version (default: latest)"
            echo "  -c, --clean            Clean build before testing"
            echo "  --no-coverage          Disable code coverage"
            echo "  -v, --verbose          Enable verbose output"
            echo "  -r, --record           Record snapshot tests (update snapshots)"
            echo "  -h, --help             Show this mystical help message"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# 🌐 Determine destination based on OS version
if [ "$OS_VERSION" = "latest" ]; then
    DESTINATION="platform=iOS Simulator,name=$DEVICE"
else
    DESTINATION="platform=iOS Simulator,name=$DEVICE,OS=$OS_VERSION"
fi

echo -e "${CYAN}📱 Device Configuration:${NC} $DEVICE"
echo -e "${CYAN}📍 Destination:${NC} $DESTINATION"
echo ""

# 🧹 The Cleansing Ritual - If requested by the seeker
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}🧹 Performing the sacred cleansing ritual...${NC}"
    rm -rf "$DERIVED_DATA"
    xcodebuild clean \
        -project "$PROJECT_FILE" \
        -scheme "$SCHEME" > /dev/null 2>&1
    echo -e "${GREEN}✨ Cleansing complete!${NC}"
    echo ""
fi

# 🏗️ The Construction Phase - Building the testing foundations
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
    echo -e "${RED}💥 Build failed! The construction ritual was interrupted.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"
echo ""

# 🎪 The Main Performance - Running the Tests
echo -e "${PURPLE}🎪 The testing performance begins!${NC}"
echo ""

TEST_ARGS=(
    -project "$PROJECT_FILE"
    -scheme "$SCHEME"
    -sdk iphonesimulator
    -destination "$DESTINATION"
    -derivedDataPath "$DERIVED_DATA"
    -resultBundlePath "$DERIVED_DATA/TestResults.xcresult"
    test-without-building
)

# 📊 Add coverage if enabled
if [ "$COVERAGE" = true ]; then
    TEST_ARGS+=(-enableCodeCoverage YES)
fi

# 📸 Set snapshot recording mode
if [ "$SNAPSHOT_RECORD" = true ]; then
    echo -e "${YELLOW}📸 Snapshot recording mode enabled - snapshots will be updated${NC}"
    export SNAPSHOT_TEST_RECORD_MODE=1
else
    export SNAPSHOT_TEST_RECORD_MODE=0
fi

# 🎭 Execute the tests with theatrical flair
if [ "$VERBOSE" = true ]; then
    xcodebuild "${TEST_ARGS[@]}" | tee "$DERIVED_DATA/test-output.log"
    TEST_RESULT=${PIPESTATUS[0]}
else
    xcodebuild "${TEST_ARGS[@]}" 2>&1 | tee "$DERIVED_DATA/test-output.log" | grep -E "^Test|^Testing|PASSED|FAILED|error:"
    TEST_RESULT=${PIPESTATUS[0]}
fi

echo ""

# 🎉 The Grand Finale - Announcing the results
if [ $TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     🎉 ✨ ALL TESTS PASSED! MASTERPIECE! ✨ 🎉     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"

    # 📊 Show coverage summary if enabled
    if [ "$COVERAGE" = true ]; then
        echo ""
        echo -e "${CYAN}📊 Code Coverage Report:${NC}"
        echo -e "   View detailed coverage in: ${BLUE}$DERIVED_DATA/TestResults.xcresult${NC}"
    fi

    echo ""
    echo -e "${CYAN}📦 Test artifacts location:${NC} $DERIVED_DATA"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   💥 😭 TESTS FAILED - TEMPORARY INTERMISSION 😭 💥  ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}🔍 Check the logs for details:${NC}"
    echo -e "   ${BLUE}$DERIVED_DATA/test-output.log${NC}"
    echo -e "   ${BLUE}$DERIVED_DATA/TestResults.xcresult${NC}"
    echo ""
    echo -e "${CYAN}🎭 But the show must go on... Fix the issues and try again!${NC}"
    exit 1
fi
