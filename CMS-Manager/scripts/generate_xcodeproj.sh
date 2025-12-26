#!/usr/bin/env bash

# 🎭 The Xcode Project Generation Spell
#
# "Where YAML configurations transform into magical Xcode projects,
# this script weaves together the threads of Swift, packages, and dreams
# into a tapestry of buildable wonder."
#
# - The Spellbinding Museum Director of Project Generation
#

set -euo pipefail  # 🛡️ Exit on error, undefined vars, and pipe failures
IFS=$'\n\t'        # 🎯 Safer loop handling

#
# 🎨 Colors and Emojis for the Console Theater
#
readonly COLOR_RESET='\033[0m'
readonly COLOR_BOLD='\033[1m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_PURPLE='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'

# 🎭 Emoji decorators
readonly EMOJI_MAGIC="✨"
readonly EMOJI_SPARKLE="🌟"
readonly EMOJI_SUCCESS="🎉"
readonly EMOJI_ERROR="💥"
readonly EMOJI_WARNING="⚠️"
readonly EMOJI_INFO="ℹ️"
readonly EMOJI_BUILD="🏗️"
readonly EMOJI_PACKAGE="📦"
readonly EMOJI_SWIFT="🔷"

#
# 🎯 Script Configuration
#
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly PROJECT_NAME="CMS-Manager"
readonly PROJECT_FILE="${PROJECT_ROOT}/project.yml"
readonly XCODE_PROJECT="${PROJECT_ROOT}/${PROJECT_NAME}.xcodeproj"

# 🎭 XcodeGen version requirement
readonly XCODEGEN_MIN_VERSION="2.40.0"

#
# 🎨 Utility Functions
#

# 🎭 Print with style
print_style() {
    local style="$1"
    shift
    local message="$*"

    case "${style}" in
        bold)    echo -e "${COLOR_BOLD}${message}${COLOR_RESET}" ;;
        red)     echo -e "${COLOR_RED}${message}${COLOR_RESET}" ;;
        green)   echo -e "${COLOR_GREEN}${message}${COLOR_RESET}" ;;
        yellow)  echo -e "${COLOR_YELLOW}${message}${COLOR_RESET}" ;;
        blue)    echo -e "${COLOR_BLUE}${message}${COLOR_RESET}" ;;
        purple)  echo -e "${COLOR_PURPLE}${message}${COLOR_RESET}" ;;
        cyan)    echo -e "${COLOR_CYAN}${message}${COLOR_RESET}" ;;
        *)       echo "${message}" ;;
    esac
}

# 🌟 Info message
info() {
    print_style cyan "${EMOJI_INFO} $*"
}

# 🎉 Success message
success() {
    print_style green "${EMOJI_SUCCESS} $*"
}

# ⚠️ Warning message
warning() {
    print_style yellow "${EMOJI_WARNING} $*"
}

# 💥 Error message
error() {
    print_style red "${EMOJI_ERROR} $*"
}

# 🎭 Header message
header() {
    echo ""
    print_style purple "${EMOJI_MAGIC} $*"
    print_style purple "$(printf '=%.0s' {1..80})"
    echo ""
}

#
# 🔍 Validation Functions
#

# 🎯 Check if XcodeGen is installed
check_xcodegen() {
    info "Checking for XcodeGen installation..."

    if command -v xcodegen &> /dev/null; then
        local version
        version=$(xcodegen version 2>/dev/null || echo "unknown")
        success "XcodeGen found: ${version}"
        return 0
    else
        warning "XcodeGen not found!"
        return 1
    fi
}

# 📦 Install XcodeGen via Homebrew
install_xcodegen() {
    header "🏗️ Installing XcodeGen via Homebrew"

    if ! command -v brew &> /dev/null; then
        error "Homebrew not found! Please install Homebrew first:"
        echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    info "Installing XcodeGen..."
    if brew install xcodegen; then
        success "XcodeGen installed successfully!"
        return 0
    else
        error "Failed to install XcodeGen!"
        exit 1
    fi
}

# 📄 Check if project.yml exists
check_project_file() {
    info "Checking for project.yml..."

    if [[ -f "${PROJECT_FILE}" ]]; then
        success "project.yml found at: ${PROJECT_FILE}"
        return 0
    else
        error "project.yml not found at: ${PROJECT_FILE}"
        error "Please create a project.yml file first!"
        exit 1
    fi
}

# 🔗 Check ArtfulArchivesCore package
check_artful_archives_core() {
    info "Checking ArtfulArchivesCore package..."

    local core_path="${PROJECT_ROOT}/../ArtfulArchivesCore"

    if [[ -d "${core_path}" ]]; then
        success "ArtfulArchivesCore found at: ${core_path}"
    else
        warning "ArtfulArchivesCore not found at: ${core_path}"
        warning "The project may not build without this package."
    fi
}

#
# 🏗️ Build Functions
#

# 🎭 Generate the Xcode project
generate_project() {
    header "🏗️ Generating Xcode Project"

    info "Project file: ${PROJECT_FILE}"
    info "Output: ${XCODE_PROJECT}"

    # 🧹 Clean existing project if requested
    if [[ "${CLEAN}" == "true" ]]; then
        info "Cleaning existing project..."
        rm -rf "${XCODE_PROJECT}"
        success "Existing project removed"
    fi

    # ✨ Generate the project
    info "Running XcodeGen..."
    cd "${PROJECT_ROOT}"

    if xcodegen generate \
        --spec project.yml \
        --quiet \
        2>&1; then
        success "Project generated successfully!"
    else
        error "Project generation failed!"
        exit 1
    fi
}

# 📦 Resolve package dependencies
resolve_packages() {
    header "📦 Resolving Package Dependencies"

    if [[ ! -d "${XCODE_PROJECT}" ]]; then
        error "Xcode project not found! Generate it first."
        exit 1
    fi

    info "Resolving SPM packages..."

    if xcodebuild -resolvePackageDependencies \
        -project "${XCODE_PROJECT}" \
        -scheme CMS_Manager \
        -quiet 2>&1; then
        success "Package dependencies resolved!"
    else
        warning "Failed to resolve some packages. This may be okay if packages are already cached."
    fi
}

# 🎯 Validate the generated project
validate_project() {
    header "🎯 Validating Generated Project"

    if [[ ! -d "${XCODE_PROJECT}" ]]; then
        error "Xcode project was not created!"
        exit 1
    fi

    # 📊 Check for key targets
    info "Checking for expected targets..."

    local expected_targets=(
        "CMS_Manager"
        "CMS_ManagerTests"
        "CMS_ManagerUITests"
    )

    local missing_targets=()

    for target in "${expected_targets[@]}"; do
        # 🎭 Check if target exists in project.pbxproj
        # Search for target reference in the project file (various formats)
        if grep -q "${target}" "${XCODE_PROJECT}/project.pbxproj" 2>/dev/null; then
            success "✓ Target found: ${target}"
        else
            warning "✗ Target missing: ${target}"
            missing_targets+=("${target}")
        fi
    done

    if [[ ${#missing_targets[@]} -gt 0 ]]; then
        warning "Some targets are missing: ${missing_targets[*]}"
    else
        success "All expected targets present!"
    fi
}

#
# 🎨 Main Function
#
main() {
    header "🎭 CMS-Manager Xcode Project Generator"
    echo ""
    info "Project: ${PROJECT_NAME}"
    info "Root:    ${PROJECT_ROOT}"
    echo ""

    # 🔧 Parse arguments
    CLEAN="false"
    SKIP_PACKAGES="false"
    OPEN_XCODE="false"

    while [[ $# -gt 0 ]]; do
        case $1 in
            --clean|-c)
                CLEAN="true"
                shift
                ;;
            --skip-packages|-s)
                SKIP_PACKAGES="true"
                shift
                ;;
            --open|-o)
                OPEN_XCODE="true"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --clean, -c         Clean existing project before generating"
                echo "  --skip-packages, -s Skip resolving package dependencies"
                echo "  --open, -o          Open Xcode after successful generation"
                echo "  --help, -h          Show this help message"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # 🔍 Validate prerequisites
    check_project_file
    check_artful_archives_core

    if ! check_xcodegen; then
        install_xcodegen
    fi

    # 🏗️ Generate project
    generate_project

    # 📦 Resolve packages (unless skipped)
    if [[ "${SKIP_PACKAGES}" == "false" ]]; then
        resolve_packages
    else
        info "Skipping package resolution"
    fi

    # 🎯 Validate
    validate_project

    # 🎉 Success!
    header "🎉 Project Generation Complete!"
    echo ""
    success "Your Xcode project is ready at:"
    echo "    ${XCODE_PROJECT}"
    echo ""
    info "Next steps:"
    echo "  1. Open the project: open ${XCODE_PROJECT}"
    echo "  2. Select a scheme (CMS_Manager or CMS_Watch)"
    echo "  3. Build and run! (⌘R)"
    echo ""

    # 🚀 Open Xcode if requested
    if [[ "${OPEN_XCODE}" == "true" ]]; then
        info "Opening Xcode..."
        open "${XCODE_PROJECT}"
    fi
}

# 🎭 Run the show!
main "$@"
