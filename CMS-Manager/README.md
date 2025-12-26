# 🎭 CMS-Manager

[![CI](https://github.com/YOUR_USERNAME/CMS-Manager/workflows/CI/badge.svg)](https://github.com/YOUR_USERNAME/CMS-Manager/actions/workflows/ci.yml)
[![Deploy](https://github.com/YOUR_USERNAME/CMS-Manager/workflows/Deploy/badge.svg)](https://github.com/YOUR_USERNAME/CMS-Manager/actions/workflows/deploy.yml)
[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-Private-red.svg)](LICENSE)

> "Where digital artistry meets museum curation - a spellbinding collection management system crafted with Swift and SwiftUI, bringing the mystical world of art into the palms of your hands."

## ✨ Features

- **🎨 Art Collection Management**: Curate and organize your artistic treasures
- **📱 Native iOS Experience**: Built with SwiftUI for iOS 18+
- **🔮 Modern Swift**: Leveraging Swift 6.0's latest features and concurrency
- **📸 Snapshot Testing**: Visual regression testing for UI consistency
- **🏗️ Modular Architecture**: Clean separation with ArtfulArchivesCore package
- **🌐 Network Integration**: Seamless communication with backend services
- **💾 Local Asset Management**: Offline-first approach with local asset caching

## 🚀 Getting Started

### Prerequisites

- **Xcode**: 15.2 or later
- **Swift**: 6.0 or later
- **iOS**: 18.0+ (Deployment Target)
- **macOS**: Sonoma 14.0+ (for development)
- **XcodeGen**: For project generation

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/CMS-Manager.git
   cd CMS-Manager
   ```

2. **Generate the Xcode project**
   ```bash
   ./scripts/generate_xcodeproj.sh
   ```

3. **Open in Xcode**
   ```bash
   open CMS-Manager.xcodeproj
   ```

4. **Build and Run**
   - Select the `CMS_Manager` scheme
   - Choose iPhone 15 Pro simulator (or your preferred device)
   - Press `⌘R` to build and run

## 🏗️ Project Structure

```
CMS-Manager/
├── .github/
│   └── workflows/          # CI/CD pipelines
│       ├── ci.yml          # Continuous Integration
│       └── deploy.yml      # Deployment pipeline
├── CMS-Manager/            # Main iOS app
│   ├── Features/           # Feature modules
│   ├── Views/              # SwiftUI views
│   ├── Managers/           # Service managers
│   ├── Network/            # Networking layer
│   └── local-assets/       # Local asset storage
├── CMS-ManagerTests/       # Unit tests
│   ├── Mocks/              # Test mocks
│   └── Snapshots/          # Snapshot reference images
├── Packages/               # Local Swift packages
│   └── ArtfulArchivesCore/ # Core functionality package
├── scripts/                # Build and automation scripts
│   ├── build.sh            # Build script
│   ├── run_tests.sh        # Test runner
│   ├── update_snapshots.sh # Snapshot updater
│   └── generate_xcodeproj.sh # Project generator
├── project.yml             # XcodeGen configuration
└── .swiftlint.yml          # SwiftLint configuration
```

## 🧪 Testing

### Run All Tests

```bash
./scripts/run_tests.sh
```

### Run Tests with Options

```bash
# Run on specific device
./scripts/run_tests.sh --device "iPhone 15 Pro Max"

# Clean build before testing
./scripts/run_tests.sh --clean

# Record snapshot tests
./scripts/run_tests.sh --record

# Verbose output
./scripts/run_tests.sh --verbose
```

### Update Snapshot Tests

```bash
./scripts/update_snapshots.sh
```

## 🏗️ Building

### Build for Simulator (Debug)

```bash
./scripts/build.sh
```

### Build for Release

```bash
./scripts/build.sh --release
```

### Build with Options

```bash
# Clean build
./scripts/build.sh --clean

# Build for device
./scripts/build.sh --device

# Create archive
./scripts/build.sh --archive

# Verbose output
./scripts/build.sh --verbose
```

## 🔄 CI/CD Pipeline

The project uses GitHub Actions for automated testing and deployment:

### Continuous Integration (CI)

Runs on every push and pull request:
- ✅ Builds the project
- 🧪 Runs unit tests and snapshot tests
- 📊 Generates code coverage reports
- 🧹 Performs SwiftLint checks
- 📦 Archives test results and artifacts

**Workflow**: [`.github/workflows/ci.yml`](.github/workflows/ci.yml)

### Deployment

Triggered on version tags (e.g., `v1.0.0`):
- 🏗️ Builds release archive
- 📋 Generates release notes
- 🎉 Creates GitHub release
- 📦 Uploads build artifacts

**Workflow**: [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)

### Manual Workflow Dispatch

Both workflows support manual triggering through GitHub Actions UI with custom parameters.

## 📝 Code Style

The project follows strict Swift coding standards enforced by SwiftLint:

```bash
# Run SwiftLint
swiftlint lint

# Auto-fix issues
swiftlint --fix
```

### Style Guidelines

- **Comments**: Use mystical emoji-enhanced comments for better readability
- **Function Length**: Keep functions under 50 lines (warning at 50, error at 100)
- **Line Length**: Maximum 120 characters (warning), 150 (error)
- **Naming**: Clear, descriptive names following Swift conventions
- **Optionals**: Avoid force unwrapping - handle optionals gracefully

## 🎨 Architecture

### Core Components

- **AppDependencies**: Dependency injection container
- **Feature Modules**: Self-contained feature implementations
- **Managers**: Service layer for business logic
- **Network**: API communication layer
- **ArtfulArchivesCore**: Shared core functionality package

### Design Patterns

- **MVVM**: Model-View-ViewModel architecture
- **Dependency Injection**: Protocol-based dependency management
- **Repository Pattern**: Data access abstraction
- **Coordinator Pattern**: Navigation management

## 🔐 Configuration

### Environment Variables

The app supports environment-specific configurations:

- **Debug**: Development settings with verbose logging
- **Release**: Production settings with optimizations

### Entitlements

- App Groups: `group.com.artfularchives.cms`
- Network Client: Enabled
- Photo Library Access: Required for artwork uploads
- Camera Access: Required for artwork capture

## 📦 Dependencies

### Swift Package Manager

- **ArtfulArchivesCore**: Local package for core functionality
- **SnapshotTesting**: Visual regression testing (by Point-Free)
- **Kingfisher**: Image downloading and caching (via ArtfulArchivesCore)
- **MarkdownUI**: Markdown rendering (via ArtfulArchivesCore)

## 🚢 Deployment

### Version Tagging

Create a new release by tagging a commit:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This triggers the deployment workflow which:
1. Builds the release archive
2. Generates release notes from commits
3. Creates a GitHub release (as draft)
4. Uploads build artifacts

### TestFlight (Future)

The deployment workflow includes a placeholder for TestFlight uploads. To enable:

1. Configure App Store Connect API credentials
2. Set up code signing certificates
3. Uncomment the TestFlight job in `deploy.yml`
4. Add required GitHub Secrets

## 🛠️ Development

### Regenerate Xcode Project

After modifying `project.yml`:

```bash
./scripts/generate_xcodeproj.sh
```

**Important**: Never manually edit the `.xcodeproj` file. Always modify `project.yml` instead.

### Adding Dependencies

Edit `project.yml` to add new Swift packages:

```yaml
packages:
  NewPackage:
    url: https://github.com/example/package
    from: 1.0.0
```

Then regenerate the project.

## 🐛 Troubleshooting

### Build Failures

1. Clean build folder: `./scripts/build.sh --clean`
2. Regenerate project: `./scripts/generate_xcodeproj.sh`
3. Delete derived data: `rm -rf .build`

### Test Failures

1. Update snapshots: `./scripts/update_snapshots.sh`
2. Check simulator device: `./scripts/run_tests.sh --device "iPhone 15 Pro"`
3. Run with verbose output: `./scripts/run_tests.sh --verbose`

### CI/CD Issues

- Check GitHub Actions logs
- Verify Xcode version matches local development
- Ensure all required secrets are configured

## 📄 License

This project is proprietary and private. All rights reserved.

## 🎭 Acknowledgments

Built with mystical automation and theatrical flair by the Spellbinding Development Team.

---

**✨ May your code compile swiftly and your tests pass gloriously! ✨**
