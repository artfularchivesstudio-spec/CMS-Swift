#!/bin/bash

# 🎨 Artful Archives Studio - Download Remaining Art Images
# Downloads images with proper rate limiting and retry logic

ASSETS_DIR="/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/local-assets"
METADATA_FILE="${ASSETS_DIR}/art_metadata.json"

cd "$ASSETS_DIR" || exit 1

echo "🎨 Starting download of remaining art images..."
echo "📋 Reading metadata from: $METADATA_FILE"

# Check if jq is available, otherwise use python
if command -v jq &> /dev/null; then
    USE_JQ=true
else
    USE_JQ=false
fi

# Function to download with retries
download_image() {
    local url="$1"
    local filename="$2"
    local title="$3"
    local max_retries=3
    local retry_delay=2
    
    for attempt in $(seq 1 $max_retries); do
        echo "  📥 Attempt $attempt/$max_retries: $title"
        
        # Use curl with User-Agent and proper headers
        if curl -L -s -f \
            --max-time 30 \
            --retry 2 \
            --retry-delay 1 \
            -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
            -o "$filename" \
            "$url" 2>/dev/null; then
            
            # Verify file was downloaded and has content
            if [ -s "$filename" ]; then
                echo "  ✅ Downloaded: $filename ($(du -h "$filename" | cut -f1))"
                return 0
            else
                echo "  ⚠️  File is empty, retrying..."
                rm -f "$filename"
            fi
        else
            echo "  ⚠️  Download failed, retrying in ${retry_delay}s..."
        fi
        
        if [ $attempt -lt $max_retries ]; then
            sleep $retry_delay
            retry_delay=$((retry_delay * 2))  # Exponential backoff
        fi
    done
    
    echo "  ❌ Failed to download: $title after $max_retries attempts"
    return 1
}

# Parse JSON and download missing images
if [ "$USE_JQ" = true ]; then
    # Using jq
    total=$(jq 'length' "$METADATA_FILE")
    downloaded=0
    skipped=0
    failed=0
    
    jq -c '.[]' "$METADATA_FILE" | while read -r artwork; do
        id=$(echo "$artwork" | jq -r '.id')
        title=$(echo "$artwork" | jq -r '.title')
        filename=$(echo "$artwork" | jq -r '.filename')
        image_url=$(echo "$artwork" | jq -r '.imageURL')
        
        # Check if file already exists
        if [ -f "$filename" ] && [ -s "$filename" ]; then
            echo "⏭️  Skipping ($((id+1))/$total): $title (already exists)"
            ((skipped++))
        else
            echo "📥 Downloading ($((id+1))/$total): $title by $(echo "$artwork" | jq -r '.artist')"
            if download_image "$image_url" "$filename" "$title"; then
                ((downloaded++))
            else
                ((failed++))
            fi
            # Rate limiting - be respectful to Wikimedia
            sleep 1
        fi
    done
else
    # Using Python as fallback
    python3 << 'PYTHON_SCRIPT'
import json
import urllib.request
import os
import time

assets_dir = "/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/local-assets"
metadata_file = os.path.join(assets_dir, "art_metadata.json")

os.chdir(assets_dir)

# Create opener with User-Agent
opener = urllib.request.build_opener()
opener.addheaders = [('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36')]
urllib.request.install_opener(opener)

with open(metadata_file, 'r', encoding='utf-8') as f:
    artworks = json.load(f)

total = len(artworks)
downloaded = 0
skipped = 0
failed = 0

for idx, artwork in enumerate(artworks):
    filename = artwork['filename']
    title = artwork['title']
    image_url = artwork['imageURL']
    
    # Check if file already exists
    if os.path.exists(filename) and os.path.getsize(filename) > 0:
        print(f"⏭️  Skipping ({idx+1}/{total}): {title} (already exists)")
        skipped += 1
        continue
    
    print(f"📥 Downloading ({idx+1}/{total}): {title} by {artwork['artist']}")
    
    max_retries = 3
    retry_delay = 2
    success = False
    
    for attempt in range(1, max_retries + 1):
        print(f"  📥 Attempt {attempt}/{max_retries}: {title}")
        try:
            urllib.request.urlretrieve(image_url, filename)
            if os.path.getsize(filename) > 0:
                file_size = os.path.getsize(filename) / (1024 * 1024)  # MB
                print(f"  ✅ Downloaded: {filename} ({file_size:.2f} MB)")
                downloaded += 1
                success = True
                break
            else:
                print(f"  ⚠️  File is empty, retrying...")
                os.remove(filename)
        except Exception as e:
            print(f"  ⚠️  Download failed: {e}, retrying in {retry_delay}s...")
            if attempt < max_retries:
                time.sleep(retry_delay)
                retry_delay *= 2  # Exponential backoff
    
    if not success:
        print(f"  ❌ Failed to download: {title} after {max_retries} attempts")
        failed += 1
    
    # Rate limiting - be respectful
    time.sleep(1)

print(f"\n🎉 Download summary:")
print(f"   ✅ Downloaded: {downloaded}")
print(f"   ⏭️  Skipped: {skipped}")
print(f"   ❌ Failed: {failed}")
print(f"   📊 Total: {total}")

PYTHON_SCRIPT
fi

echo ""
echo "🎉 Download process complete!"
echo "📁 Check the local-assets folder for downloaded images"


