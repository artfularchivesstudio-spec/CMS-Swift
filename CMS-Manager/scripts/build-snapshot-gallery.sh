#!/bin/bash

# 🎨 The Snapshot Gallery Builder - Digital Museum Curator
#
# "Like a meticulous curator arranging artifacts for display,
# this script gathers all snapshot test results and weaves them
# into a beautiful, interactive gallery for visual inspection."
#
# - The Spellbinding Museum Director of Visual Testing

set -e

# 🎨 Configuration
PROJECT_ROOT="/Users/admin/Developer/CMS-Swift"
SNAPSHOT_DIR="$PROJECT_ROOT/CMS-Manager/CMS-ManagerTests/__Snapshots__"
GALLERY_TEMPLATE="$PROJECT_ROOT/CMS-Manager/snapshot-gallery.html"
GALLERY_OUTPUT="$PROJECT_ROOT/CMS-Manager/snapshot-gallery-report.html"
TEMP_JSON="/tmp/snapshots.json"

echo "🎭 ✨ SNAPSHOT GALLERY BUILDER AWAKENS!"
echo "================================================"
echo ""

# 🔍 Check if snapshots directory exists
if [ ! -d "$SNAPSHOT_DIR" ]; then
    echo "⚠️  Snapshot directory not found: $SNAPSHOT_DIR"
    echo "💡 Run snapshot tests first to generate images!"
    echo ""
    echo "Example: xcodebuild test -scheme CMS-Manager -destination 'platform=iOS Simulator,name=iPhone 17 Pro'"
    exit 1
fi

# 📊 Count snapshots
SNAPSHOT_COUNT=$(find "$SNAPSHOT_DIR" -name "*.png" -type f | wc -l | xargs)

if [ "$SNAPSHOT_COUNT" -eq 0 ]; then
    echo "⚠️  No snapshot images found in $SNAPSHOT_DIR"
    echo "💡 Run snapshot tests to generate images first!"
    exit 1
fi

echo "📸 Found $SNAPSHOT_COUNT snapshot images!"
echo ""

# 🧹 Create temporary JSON file to store snapshot data
echo "🔮 Analyzing snapshot metadata..."
echo "[" > "$TEMP_JSON"

FIRST=true

# 🎨 Parse snapshot directory structure and build JSON
# Expected structure: __Snapshots__/TestClassName/testMethodName.{device}.{colorScheme}.png
find "$SNAPSHOT_DIR" -name "*.png" -type f | while read -r snapshot_path; do
    # Extract components from path
    filename=$(basename "$snapshot_path")
    dirname=$(basename "$(dirname "$snapshot_path")")

    # Parse filename: testName.device.colorScheme.png
    # Example: testEmptyState.iPhone-13-Pro.light.1.png
    base_name="${filename%.png}"

    # Try to extract device and color scheme
    # This is a heuristic parser - adjust based on actual naming convention
    if [[ $base_name =~ (.+)\.(iPhone.*|iPad.*)\.(light|dark)\.?[0-9]* ]]; then
        test_name="${BASH_REMATCH[1]}"
        device="${BASH_REMATCH[2]}"
        color_scheme="${BASH_REMATCH[3]}"
    else
        # Fallback parsing
        test_name="${base_name%%.*}"
        device="Unknown Device"
        color_scheme="light"
    fi

    # Clean up device name (replace hyphens with spaces)
    device_clean=$(echo "$device" | sed 's/-/ /g')

    # Determine category from test class name
    category="$dirname"

    # Assign category icons
    case "$category" in
        *StoriesListView*)
            category_name="Stories List"
            category_icon="📚"
            ;;
        *StoryDetailView*)
            category_name="Story Detail"
            category_icon="📖"
            ;;
        *UploadStep*)
            category_name="Upload Step"
            category_icon="📤"
            ;;
        *AnalyzingStep*)
            category_name="Analysis Step"
            category_icon="🔍"
            ;;
        *ReviewStep*)
            category_name="Review Step"
            category_icon="✅"
            ;;
        *TranslationReviewStep*)
            category_name="Translation Review"
            category_icon="🌐"
            ;;
        *AudioStep*)
            category_name="Audio Step"
            category_icon="🎵"
            ;;
        *FinalizeStep*)
            category_name="Finalize Step"
            category_icon="🎊"
            ;;
        *)
            category_name="$category"
            category_icon="📸"
            ;;
    esac

    # Create human-readable title
    title=$(echo "$test_name" | sed 's/test//g' | sed 's/\([A-Z]\)/ \1/g' | sed 's/^ //')

    # Generate relative path for HTML
    rel_path=$(python3 -c "import os.path; print(os.path.relpath('$snapshot_path', '$PROJECT_ROOT/CMS-Manager'))")

    # Add comma before JSON object (except for first one)
    if [ "$FIRST" = false ]; then
        echo "," >> "$TEMP_JSON"
    fi
    FIRST=false

    # Write JSON object
    cat >> "$TEMP_JSON" <<EOF
    {
        "category": "$category_name",
        "categoryIcon": "$category_icon",
        "title": "$title",
        "device": "$device_clean",
        "colorScheme": "$color_scheme",
        "path": "$rel_path",
        "testName": "$test_name",
        "tags": ["$color_scheme", "$(echo $device_clean | tr ' ' '-')"]
    }
EOF
done

echo "]" >> "$TEMP_JSON"

echo "✨ Metadata extraction complete!"
echo ""

# 🎨 Group snapshots by category
echo "🎪 Organizing snapshots into categories..."

# Use Python to group and format the data properly
python3 - <<'PYTHON_SCRIPT'
import json
import sys
from collections import defaultdict

# Read the temp JSON
with open('/tmp/snapshots.json', 'r') as f:
    snapshots = json.load(f)

# Group by category
categories = defaultdict(lambda: {"snapshots": [], "icon": "📸"})

for snap in snapshots:
    cat_name = snap['category']
    categories[cat_name]['snapshots'].append({
        'title': snap['title'],
        'device': snap['device'],
        'colorScheme': snap['colorScheme'],
        'path': snap['path'],
        'testName': snap['testName'],
        'tags': snap.get('tags', [])
    })
    categories[cat_name]['icon'] = snap.get('categoryIcon', '📸')

# Convert to list format
result = []
for cat_name, cat_data in sorted(categories.items()):
    result.append({
        'category': cat_name,
        'icon': cat_data['icon'],
        'snapshots': cat_data['snapshots']
    })

# Output as JavaScript variable assignment
print("const SNAPSHOTS = " + json.dumps(result, indent=4) + ";")

PYTHON_SCRIPT

# Save the JavaScript data
SNAPSHOT_DATA=$(python3 - <<'PYTHON_SCRIPT'
import json
from collections import defaultdict

with open('/tmp/snapshots.json', 'r') as f:
    snapshots = json.load(f)

categories = defaultdict(lambda: {"snapshots": [], "icon": "📸"})

for snap in snapshots:
    cat_name = snap['category']
    categories[cat_name]['snapshots'].append({
        'title': snap['title'],
        'device': snap['device'],
        'colorScheme': snap['colorScheme'],
        'path': snap['path'],
        'testName': snap['testName'],
        'tags': snap.get('tags', [])
    })
    categories[cat_name]['icon'] = snap.get('categoryIcon', '📸')

result = []
for cat_name, cat_data in sorted(categories.items()):
    result.append({
        'category': cat_name,
        'icon': cat_data['icon'],
        'snapshots': cat_data['snapshots']
    })

print("const SNAPSHOTS = " + json.dumps(result, indent=4) + ";")
PYTHON_SCRIPT
)

echo "🌟 Categories organized successfully!"
echo ""

# 🎨 Inject snapshot data into HTML template
echo "🖼️  Building gallery HTML..."

# Read template
TEMPLATE_CONTENT=$(<"$GALLERY_TEMPLATE")

# Replace the placeholder SNAPSHOTS array with actual data
# Find the line "const SNAPSHOTS = [" and replace everything until the closing "];"
OUTPUT_CONTENT=$(echo "$TEMPLATE_CONTENT" | awk -v data="$SNAPSHOT_DATA" '
    /const SNAPSHOTS = \[/ {
        print data
        skip=1
        next
    }
    /^\s*\];/ && skip {
        skip=0
        next
    }
    !skip {
        print
    }
')

# Write output
echo "$OUTPUT_CONTENT" > "$GALLERY_OUTPUT"

echo "✅ Gallery built successfully!"
echo ""
echo "📊 Summary:"
echo "  - Total Snapshots: $SNAPSHOT_COUNT"
echo "  - Output File: $GALLERY_OUTPUT"
echo ""
echo "🌐 To view the gallery, open:"
echo "   file://$GALLERY_OUTPUT"
echo ""
echo "🎉 ✨ GALLERY MASTERPIECE COMPLETE!"

# 🚀 Optionally open in browser
if command -v open &> /dev/null; then
    echo ""
    read -p "📱 Open gallery in browser now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$GALLERY_OUTPUT"
        echo "🎊 Gallery opened in default browser!"
    fi
fi

# 🧹 Cleanup
rm -f "$TEMP_JSON"
