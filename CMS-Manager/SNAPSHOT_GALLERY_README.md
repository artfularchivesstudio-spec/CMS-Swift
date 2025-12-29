# 📸 Snapshot Test Gallery - Visual Testing Museum

## Overview

The Snapshot Gallery is a beautiful, standalone HTML page that showcases all snapshot test results from the CMS Manager app. It provides an interactive, filterable, and searchable interface for reviewing visual regression test results across multiple devices and color schemes.

## Features

### 🎨 Beautiful Design
- **Apple-quality aesthetics** - Clean, minimalist design inspired by Apple and Airbnb
- **Dark mode support** - Toggle between light and dark themes
- **Responsive layout** - Works perfectly on desktop, tablet, and mobile
- **Smooth animations** - Delightful micro-interactions and transitions

### 🔍 Powerful Filtering
- **Category filters** - View snapshots by Components, Workflows, or Views
- **Real-time search** - Search by test name, device, or tags
- **Smart categorization** - Automatically organized by test suite

### 🖼️ Interactive Gallery
- **Grid layout** - Responsive grid showing all snapshots
- **Image zoom** - Click any snapshot to view full-screen
- **Device labels** - See which device each snapshot was captured on
- **Color scheme badges** - Instantly identify light vs dark mode tests

### 📊 Stats Dashboard
- **Total snapshots** - Count of all captured images
- **Device coverage** - Number of unique devices tested
- **Category breakdown** - Distribution across test categories

## Quick Start

### 1. Run Snapshot Tests

First, execute the snapshot tests to generate images:

```bash
# Run all tests (recommended)
xcodebuild test \
  -scheme CMS-Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -enableCodeCoverage YES

# Or run specific snapshot test target
xcodebuild test \
  -scheme CMS-Manager \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:CMS-ManagerTests/StoriesListViewSnapshotTests
```

### 2. Build the Gallery

Run the gallery builder script to collect all snapshots and generate the HTML:

```bash
cd /Users/admin/Developer/CMS-Swift/CMS-Manager
./scripts/build-snapshot-gallery.sh
```

The script will:
- ✅ Find all snapshot images in `__Snapshots__/`
- ✅ Extract metadata (device, color scheme, test name)
- ✅ Organize snapshots by category
- ✅ Generate a beautiful HTML gallery
- ✅ Output to `snapshot-gallery-report.html`

### 3. View the Gallery

Open the generated gallery in your browser:

```bash
open /Users/admin/Developer/CMS-Swift/CMS-Manager/snapshot-gallery-report.html
```

Or simply double-click the `snapshot-gallery-report.html` file.

## Gallery Structure

The gallery organizes snapshots into categories:

### 📚 Stories List
- Empty state
- Loading state
- List view with stories
- Grid view mode
- Search results
- Filter states
- Error states

### 📖 Story Detail
- Complete stories
- Different workflow stages
- Audio states
- Edit mode
- Multiple images
- Multiple languages
- Device-specific layouts

### 🎭 Wizard Steps
- **Upload Step** (📤) - Image upload interface
- **Analysis Step** (🔍) - AI analysis in progress
- **Review Step** (✅) - Text review and editing
- **Translation Review** (🌐) - Multi-language review
- **Audio Step** (🎵) - Audio generation controls
- **Finalize Step** (🎊) - Final review before publishing

## Usage Tips

### Filtering
- **All** - Shows all snapshots across categories
- **Components** - Individual UI component snapshots
- **Workflows** - Multi-step workflow screens
- **Views** - Complete screen/view snapshots

### Searching
Type in the search box to filter by:
- Test name (e.g., "testEmptyState")
- Device (e.g., "iPhone 13 Pro")
- Color scheme (e.g., "dark")
- Category name (e.g., "Stories List")
- Tags

### Viewing Images
- **Click** any snapshot card to view full-screen
- **Arrow keys** or on-screen buttons to navigate
- **ESC** or click outside to close
- **Keyboard shortcuts**:
  - `←` Previous image
  - `→` Next image
  - `Esc` Close modal

### Theme Toggle
Click the moon/sun icon in the header to switch between light and dark modes. Your preference is saved locally.

## File Structure

```
CMS-Manager/
├── snapshot-gallery.html              # Template (base HTML/CSS/JS)
├── snapshot-gallery-report.html       # Generated gallery with data
├── scripts/
│   └── build-snapshot-gallery.sh      # Gallery builder script
└── CMS-ManagerTests/
    └── __Snapshots__/                 # Generated snapshot images
        ├── StoriesListViewSnapshotTests/
        ├── StoryDetailViewSnapshotTests/
        └── Snapshots/
            └── WizardSteps/
```

## Advanced Usage

### Customizing Categories

Edit the script to add custom category detection:

```bash
# In build-snapshot-gallery.sh, add new case:
case "$category" in
    *YourNewTest*)
        category_name="Your Category"
        category_icon="🚀"
        ;;
esac
```

### CI/CD Integration

Integrate into your CI pipeline:

```yaml
# .github/workflows/snapshot-tests.yml
- name: Run Snapshot Tests
  run: |
    xcodebuild test -scheme CMS-Manager ...

- name: Build Gallery
  run: ./scripts/build-snapshot-gallery.sh

- name: Upload Gallery Artifact
  uses: actions/upload-artifact@v3
  with:
    name: snapshot-gallery
    path: snapshot-gallery-report.html
```

### Sharing Results

The gallery is a **single HTML file** that can be:
- Emailed to stakeholders
- Hosted on any web server
- Opened locally without a server
- Shared via cloud storage (Dropbox, Google Drive, etc.)
- Committed to git (though large images may require Git LFS)

## Troubleshooting

### No snapshots found
**Problem**: Script reports 0 snapshots
**Solution**: Run snapshot tests first to generate images

### Images not loading
**Problem**: Broken image icons in gallery
**Solution**: Ensure you're opening the HTML from the correct directory, or use absolute paths

### Empty gallery
**Problem**: Gallery shows "Awaiting Snapshot Generation"
**Solution**: The template hasn't been populated yet - run `build-snapshot-gallery.sh`

### Build script fails
**Problem**: Script exits with error
**Solution**: Check that Python 3 is installed and accessible via `python3`

## Technical Details

### Dependencies
- **bash** - Shell script execution
- **python3** - JSON processing and data organization
- **find** - File system traversal
- **jq** (optional) - Alternative JSON processing

### Browser Compatibility
- ✅ Chrome/Edge (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

### Performance
- Lazy image loading for fast initial render
- Efficient filtering with vanilla JavaScript
- No external dependencies (fully self-contained)
- Works offline once opened

## Workflow Integration

### Typical Testing Workflow

1. **Develop** new feature or UI change
2. **Run** snapshot tests: `xcodebuild test ...`
3. **Build** gallery: `./scripts/build-snapshot-gallery.sh`
4. **Review** visual changes in gallery
5. **Update** snapshots if changes are intentional
6. **Commit** updated snapshots to git

### Recording New Snapshots

When UI changes are intentional:

1. Set `recordMode = true` in test file
2. Run tests to re-record
3. Build gallery to verify new snapshots
4. Set `recordMode = false`
5. Commit updated snapshots

## Contributing

To improve the gallery:

1. **Template**: Edit `snapshot-gallery.html` for UI changes
2. **Builder**: Edit `build-snapshot-gallery.sh` for logic changes
3. **Test**: Run with sample data to verify
4. **Document**: Update this README with changes

## Credits

Built with care by **Agent Charlie - The HTML Snapshot Gallery Builder**

Part of the CMS Manager visual testing suite.

---

**Made with ❤️ for visual quality and developer experience**
