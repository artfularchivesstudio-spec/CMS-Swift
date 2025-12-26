#!/bin/bash
# 🏗️ The Build Architect - Constructing Digital Masterpieces
#
# "This mystical script orchestrates the transformation of source code
# into executable artifacts, channeling the power of xcodebuild to
# manifest our vision into reality."
#
# - The Spellbinding Build Maestro

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

# 🌟 The Grand Announcement
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║   🏗️  The CMS Manager Build Ritual Begins!  🏗️   ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ✨ Parse command line arguments
CONFIGURATION="Debug"
SDK="iphonesimulator"
DEVICE="iPhone 15 Pro"
CLEAN_BUILD=false
ARCHIVE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--configuration)
            CONFIGURATION="$2"
            shift 2
            ;;
        --release)
            CONFIGURATION="Release"
            shift
            ;;
        --debug)
            CONFIGURATION="Debug"
            shift
            ;;
        -s|--sdk)
            SDK="$2"
            shift 2
            ;;
        --device)
            SDK="iphoneos"
            shift
            ;;
        --simulator)
            SDK="iphonesimulator"
            shift
            ;;
        -d|--destination)
            DEVICE="$2"
            shift 2
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        -a|--archive)
            ARCHIVE=true
            CONFIGURATION="Release"
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "🎭 Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -c, --configuration <config>  Build configuration (Debug|Release)"
            echo "  --release                      Build Release configuration"
            echo "  --debug                        Build Debug configuration (default)"
            echo "  -s, --sdk <sdk>                SDK to build for (iphonesimulator|iphoneos)"
            echo "  --device                       Build for physical device (iphoneos)"
            echo "  --simulator                    Build for simulator (default)"
            echo "  -d, --destination <device>     Simulator device name"
            echo "  --clean                        Clean before building"
            echo "  -a, --archive                  Create archive (forces Release config)"
            echo "  -v, --verbose                  Enable verbose output"
            echo "  -h, --help                     Show this mystical help message"
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
if [ "$SDK" = "iphonesimulator" ]; then
    DESTINATION="platform=iOS Simulator,name=$DEVICE"
else
    DESTINATION="generic/platform=iOS"
fi

echo -e "${CYAN}⚙️  Configuration:${NC} $CONFIGURATION"
echo -e "${CYAN}📱 SDK:${NC} $SDK"
echo -e "${CYAN}📍 Destination:${NC} $DESTINATION"
echo ""

# 🧹 The Cleansing Ritual
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}🧹 Performing the sacred cleansing ritual...${NC}"
    rm -rf "$DERIVED_DATA"
    xcodebuild clean \
        -project "$PROJECT_FILE" \
        -scheme "$SCHEME" > /dev/null 2>&1
    echo -e "${GREEN}✨ Cleansing complete!${NC}"
    echo ""
fi

# 🏗️ The Main Build Performance
if [ "$ARCHIVE" = true ]; then
    echo -e "${BLUE}🏗️  Creating archive...${NC}"

    ARCHIVE_PATH="$DERIVED_DATA/CMS-Manager.xcarchive"

    BUILD_ARGS=(
        -project "$PROJECT_FILE"
        -scheme "$SCHEME"
        -sdk "$SDK"
        -archivePath "$ARCHIVE_PATH"
        -configuration "$CONFIGURATION"
        archive
    )

    if [ "$SDK" = "iphonesimulator" ]; then
        BUILD_ARGS+=(CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO)
    fi

    if [ "$VERBOSE" = false ]; then
        BUILD_ARGS+=(-quiet)
    fi

    if ! xcodebuild "${BUILD_ARGS[@]}"; then
        echo -e "${RED}💥 Archive creation failed!${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Archive created successfully!${NC}"
    echo -e "${CYAN}📦 Archive location:${NC} $ARCHIVE_PATH"

else
    echo -e "${BLUE}🏗️  Building for $CONFIGURATION...${NC}"

    BUILD_ARGS=(
        -project "$PROJECT_FILE"
        -scheme "$SCHEME"
        -sdk "$SDK"
        -destination "$DESTINATION"
        -configuration "$CONFIGURATION"
        -derivedDataPath "$DERIVED_DATA"
        build
    )

    if [ "$SDK" = "iphonesimulator" ]; then
        BUILD_ARGS+=(CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO)
    fi

    if [ "$VERBOSE" = false ]; then
        BUILD_ARGS+=(-quiet)
    fi

    if ! xcodebuild "${BUILD_ARGS[@]}"; then
        echo -e "${RED}💥 Build failed!${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Build successful!${NC}"

    # 📱 Show the built product location
    if [ "$SDK" = "iphonesimulator" ]; then
        APP_PATH="$DERIVED_DATA/Build/Products/$CONFIGURATION-iphonesimulator/CMS-Manager.app"
    else
        APP_PATH="$DERIVED_DATA/Build/Products/$CONFIGURATION-iphoneos/CMS-Manager.app"
    fi

    if [ -d "$APP_PATH" ]; then
        echo -e "${CYAN}📦 Build product:${NC} $APP_PATH"

        # Get app size
        APP_SIZE=$(du -sh "$APP_PATH" | cut -f1)
        echo -e "${CYAN}📊 App size:${NC} $APP_SIZE"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      🎉 ✨ BUILD MASTERPIECE COMPLETE! ✨ 🎉       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"

exit 0
