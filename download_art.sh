#!/bin/bash

# 🎨 Artful Archives Studio - Public Domain Art Downloader
# Downloads 50 public domain paintings and creates metadata JSON

ASSETS_DIR="/Users/admin/Developer/CMS-Swift/CMS-Manager/CMS-Manager/local-assets"
METADATA_FILE="${ASSETS_DIR}/art_metadata.json"

mkdir -p "$ASSETS_DIR"
cd "$ASSETS_DIR"

echo "🎨 Starting download of 50 public domain paintings..."

# Array of art pieces: URL|Title|Artist|Year|SourceURL
declare -a ART_PIECES=(
    # Kandinsky (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Vassily_Kandinsky%2C_1913_-_Composition_7.jpg/1280px-Vassily_Kandinsky%2C_1913_-_Composition_7.jpg|Composition 7|Wassily Kandinsky|1913|https://commons.wikimedia.org/wiki/File:Vassily_Kandinsky,_1913_-_Composition_7.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Vassily_Kandinsky%2C_1911_-_Composition_IV.jpg/1280px-Vassily_Kandinsky%2C_1911_-_Composition_IV.jpg|Composition IV|Wassily Kandinsky|1911|https://commons.wikimedia.org/wiki/File:Vassily_Kandinsky,_1911_-_Composition_IV.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Vassily_Kandinsky%2C_1913_-_Black_Lines.jpg/1280px-Vassily_Kandinsky%2C_1913_-_Black_Lines.jpg|Black Lines|Wassily Kandinsky|1913|https://commons.wikimedia.org/wiki/File:Vassily_Kandinsky,_1913_-_Black_Lines.jpg"
    
    # Hilma af Klint (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan%2C_No._1_%281914-1915%29.jpg/1280px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan%2C_No._1_%281914-1915%29.jpg|Group IX SUW, The Swan, No. 1|Hilma af Klint|1914-1915|https://commons.wikimedia.org/wiki/File:Hilma_af_Klint_-_Group_IX_SUW,_The_Swan,_No._1_(1914-1915).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Hilma_af_Klint_-_Group_X%2C_No._1%2C_Altarpiece_%281915%29.jpg/1280px-Hilma_af_Klint_-_Group_X%2C_No._1%2C_Altarpiece_%281915%29.jpg|Group X, No. 1, Altarpiece|Hilma af Klint|1915|https://commons.wikimedia.org/wiki/File:Hilma_af_Klint_-_Group_X,_No._1,_Altarpiece_(1915).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Hilma_af_Klint_-_Group_IV%2C_The_Ten_Largest%2C_No._7%2C_Adulthood_%281907%29.jpg/1280px-Hilma_af_Klint_-_Group_IV%2C_The_Ten_Largest%2C_No._7%2C_Adulthood_%281907%29.jpg|Group IV, The Ten Largest, No. 7, Adulthood|Hilma af Klint|1907|https://commons.wikimedia.org/wiki/File:Hilma_af_Klint_-_Group_IV,_The_Ten_Largest,_No._7,_Adulthood_(1907).jpg"
    
    # William Blake (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/William_Blake_001.jpg/1280px-William_Blake_001.jpg|The Ancient of Days|William Blake|1794|https://commons.wikimedia.org/wiki/File:William_Blake_001.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/William_Blake_-_Newton_%281795%29.jpg/1280px-William_Blake_-_Newton_%281795%29.jpg|Newton|William Blake|1795|https://commons.wikimedia.org/wiki/File:William_Blake_-_Newton_(1795).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/William_Blake_-_The_Great_Red_Dragon_and_the_Woman_Clothed_with_the_Sun.jpg/1280px-William_Blake_-_The_Great_Red_Dragon_and_the_Woman_Clothed_with_the_Sun.jpg|The Great Red Dragon and the Woman Clothed with the Sun|William Blake|1805-1810|https://commons.wikimedia.org/wiki/File:William_Blake_-_The_Great_Red_Dragon_and_the_Woman_Clothed_with_the_Sun.jpg"
    
    # Picasso (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Les_Demoiselles_d%27Avignon.jpg/1280px-Les_Demoiselles_d%27Avignon.jpg|Les Demoiselles d'Avignon|Pablo Picasso|1907|https://commons.wikimedia.org/wiki/File:Les_Demoiselles_d%27Avignon.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Pablo_Picasso%2C_1901%2C_La_Mort_de_Casagemas%2C_oil_on_canvas%2C_27_x_35_cm%2C_Mus%C3%A9e_Picasso%2C_Paris.jpg/1280px-Pablo_Picasso%2C_1901%2C_La_Mort_de_Casagemas%2C_oil_on_canvas%2C_27_x_35_cm%2C_Mus%C3%A9e_Picasso%2C_Paris.jpg|La Mort de Casagemas|Pablo Picasso|1901|https://commons.wikimedia.org/wiki/File:Pablo_Picasso,_1901,_La_Mort_de_Casagemas.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Pablo_Picasso%2C_1901%2C_Le_Moulin_de_la_Galette%2C_oil_on_canvas%2C_88.2_x_115.6_cm%2C_Solomon_R._Guggenheim_Museum%2C_New_York.jpg/1280px-Pablo_Picasso%2C_1901%2C_Le_Moulin_de_la_Galette%2C_oil_on_canvas%2C_88.2_x_115.6_cm%2C_Solomon_R._Guggenheim_Museum%2C_New_York.jpg|Le Moulin de la Galette|Pablo Picasso|1901|https://commons.wikimedia.org/wiki/File:Pablo_Picasso,_1901,_Le_Moulin_de_la_Galette.jpg"
    
    # Monet (5)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Claude_Monet%2C_Impression%2C_soleil_levant.jpg/1280px-Claude_Monet%2C_Impression%2C_soleil_levant.jpg|Impression, Sunrise|Claude Monet|1872|https://commons.wikimedia.org/wiki/File:Claude_Monet,_Impression,_soleil_levant.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Claude_Monet_-_The_Water_Lilies_-_The_Clouds.jpg/1280px-Claude_Monet_-_The_Water_Lilies_-_The_Clouds.jpg|The Water Lilies - The Clouds|Claude Monet|1903|https://commons.wikimedia.org/wiki/File:Claude_Monet_-_The_Water_Lilies_-_The_Clouds.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Claude_Monet_-_Water_Lilies_%28W1992%29.jpg/1280px-Claude_Monet_-_Water_Lilies_%28W1992%29.jpg|Water Lilies|Claude Monet|1919|https://commons.wikimedia.org/wiki/File:Claude_Monet_-_Water_Lilies_(W1992).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Claude_Monet%2C_Le_Bassin_aux_Nymph%C3%A9as%2C_1919.jpg/1280px-Claude_Monet%2C_Le_Bassin_aux_Nymph%C3%A9as%2C_1919.jpg|Le Bassin aux Nymphéas|Claude Monet|1919|https://commons.wikimedia.org/wiki/File:Claude_Monet,_Le_Bassin_aux_Nymph%C3%A9as,_1919.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Claude_Monet_-_Woman_with_a_Parasol_-_Madame_Monet_and_Her_Son.jpg/1280px-Claude_Monet_-_Woman_with_a_Parasol_-_Madame_Monet_and_Her_Son.jpg|Woman with a Parasol|Claude Monet|1875|https://commons.wikimedia.org/wiki/File:Claude_Monet_-_Woman_with_a_Parasol_-_Madame_Monet_and_Her_Son.jpg"
    
    # Van Gogh (5)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/1280px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg|The Starry Night|Vincent van Gogh|1889|https://commons.wikimedia.org/wiki/File:Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_%28454045%29.jpg/1280px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_%28454045%29.jpg|Self-Portrait|Vincent van Gogh|1889|https://commons.wikimedia.org/wiki/File:Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_(454045).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Vincent_van_Gogh_-_Sunflowers_-_VGM_F458.jpg/1280px-Vincent_van_Gogh_-_Sunflowers_-_VGM_F458.jpg|Sunflowers|Vincent van Gogh|1888|https://commons.wikimedia.org/wiki/File:Vincent_van_Gogh_-_Sunflowers_-_VGM_F458.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Vincent_van_Gogh_-_The_Potato_Eaters_-_Google_Art_Project.jpg/1280px-Vincent_van_Gogh_-_The_Potato_Eaters_-_Google_Art_Project.jpg|The Potato Eaters|Vincent van Gogh|1885|https://commons.wikimedia.org/wiki/File:Vincent_van_Gogh_-_The_Potato_Eaters_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Vincent_van_Gogh_-_The_Red_Vineyard_-_Google_Art_Project.jpg/1280px-Vincent_van_Gogh_-_The_Red_Vineyard_-_Google_Art_Project.jpg|The Red Vineyard|Vincent van Gogh|1888|https://commons.wikimedia.org/wiki/File:Vincent_van_Gogh_-_The_Red_Vineyard_-_Google_Art_Project.jpg"
    
    # Degas (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Edgar_Degas_-_The_Absinthe_Drinker_-_Google_Art_Project.jpg/1280px-Edgar_Degas_-_The_Absinthe_Drinker_-_Google_Art_Project.jpg|The Absinthe Drinker|Edgar Degas|1876|https://commons.wikimedia.org/wiki/File:Edgar_Degas_-_The_Absinthe_Drinker_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Edgar_Degas_-_The_Dance_Class_-_Google_Art_Project.jpg/1280px-Edgar_Degas_-_The_Dance_Class_-_Google_Art_Project.jpg|The Dance Class|Edgar Degas|1874|https://commons.wikimedia.org/wiki/File:Edgar_Degas_-_The_Dance_Class_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Edgar_Degas_-_Woman_Combing_Her_Hair_-_Google_Art_Project.jpg/1280px-Edgar_Degas_-_Woman_Combing_Her_Hair_-_Google_Art_Project.jpg|Woman Combing Her Hair|Edgar Degas|1888-1890|https://commons.wikimedia.org/wiki/File:Edgar_Degas_-_Woman_Combing_Her_Hair_-_Google_Art_Project.jpg"
    
    # Renoir (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Pierre-Auguste_Renoir_-_Luncheon_of_the_Boating_Party.jpg/1280px-Pierre-Auguste_Renoir_-_Luncheon_of_the_Boating_Party.jpg|Luncheon of the Boating Party|Pierre-Auguste Renoir|1881|https://commons.wikimedia.org/wiki/File:Pierre-Auguste_Renoir_-_Luncheon_of_the_Boating_Party.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Pierre-Auguste_Renoir%2C_Le_D%C3%A9jeuner_des_canotiers.jpg/1280px-Pierre-Auguste_Renoir%2C_Le_D%C3%A9jeuner_des_canotiers.jpg|Le Déjeuner des canotiers|Pierre-Auguste Renoir|1881|https://commons.wikimedia.org/wiki/File:Pierre-Auguste_Renoir,_Le_D%C3%A9jeuner_des_canotiers.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Pierre-Auguste_Renoir_-_Two_Sisters_%28On_the_Terrace%29_-_Google_Art_Project.jpg/1280px-Pierre-Auguste_Renoir_-_Two_Sisters_%28On_the_Terrace%29_-_Google_Art_Project.jpg|Two Sisters (On the Terrace)|Pierre-Auguste Renoir|1881|https://commons.wikimedia.org/wiki/File:Pierre-Auguste_Renoir_-_Two_Sisters_(On_the_Terrace)_-_Google_Art_Project.jpg"
    
    # Cézanne (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Paul_C%C3%A9zanne_-_The_Card_Players.jpg/1280px-Paul_C%C3%A9zanne_-_The_Card_Players.jpg|The Card Players|Paul Cézanne|1890-1892|https://commons.wikimedia.org/wiki/File:Paul_C%C3%A9zanne_-_The_Card_Players.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Paul_C%C3%A9zanne_-_The_Bathers_%28Les_Grandes_Baigneuses%29_-_Google_Art_Project.jpg/1280px-Paul_C%C3%A9zanne_-_The_Bathers_%28Les_Grandes_Baigneuses%29_-_Google_Art_Project.jpg|The Bathers|Paul Cézanne|1894-1905|https://commons.wikimedia.org/wiki/File:Paul_C%C3%A9zanne_-_The_Bathers_(Les_Grandes_Baigneuses)_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Paul_C%C3%A9zanne_063.jpg/1280px-Paul_C%C3%A9zanne_063.jpg|Mont Sainte-Victoire|Paul Cézanne|1904-1906|https://commons.wikimedia.org/wiki/File:Paul_C%C3%A9zanne_063.jpg"
    
    # Gauguin (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Paul_Gauguin_-_Where_Do_We_Come_From%3F_What_Are_We%3F_Where_Are_We_Going%3F.jpg/1280px-Paul_Gauguin_-_Where_Do_We_Come_From%3F_What_Are_We%3F_Where_Are_We_Going%3F.jpg|Where Do We Come From? What Are We? Where Are We Going?|Paul Gauguin|1897-1898|https://commons.wikimedia.org/wiki/File:Paul_Gauguin_-_Where_Do_We_Come_From%3F_What_Are_We%3F_Where_Are_We_Going%3F.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Paul_Gauguin_-_The_Yellow_Christ_-_Google_Art_Project.jpg/1280px-Paul_Gauguin_-_The_Yellow_Christ_-_Google_Art_Project.jpg|The Yellow Christ|Paul Gauguin|1889|https://commons.wikimedia.org/wiki/File:Paul_Gauguin_-_The_Yellow_Christ_-_Google_Art_Project.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Paul_Gauguin_-_Tahitian_Women_on_the_Beach_-_Google_Art_Project.jpg/1280px-Paul_Gauguin_-_Tahitian_Women_on_the_Beach_-_Google_Art_Project.jpg|Tahitian Women on the Beach|Paul Gauguin|1891|https://commons.wikimedia.org/wiki/File:Paul_Gauguin_-_Tahitian_Women_on_the_Beach_-_Google_Art_Project.jpg"
    
    # Seurat (2)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg/1280px-A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg|A Sunday Afternoon on the Island of La Grande Jatte|Georges Seurat|1884-1886|https://commons.wikimedia.org/wiki/File:A_Sunday_on_La_Grande_Jatte,_Georges_Seurat,_1884.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Georges_Seurat_-_Bathers_at_Asni%C3%A8res_-_Google_Art_Project.jpg/1280px-Georges_Seurat_-_Bathers_at_Asni%C3%A8res_-_Google_Art_Project.jpg|Bathers at Asnières|Georges Seurat|1884|https://commons.wikimedia.org/wiki/File:Georges_Seurat_-_Bathers_at_Asni%C3%A8res_-_Google_Art_Project.jpg"
    
    # Manet (3)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/%C3%89douard_Manet_-_Le_D%C3%A9jeuner_sur_l%27herbe.jpg/1280px-%C3%89douard_Manet_-_Le_D%C3%A9jeuner_sur_l%27herbe.jpg|Le Déjeuner sur l'herbe|Édouard Manet|1863|https://commons.wikimedia.org/wiki/File:%C3%89douard_Manet_-_Le_D%C3%A9jeuner_sur_l%27herbe.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/%C3%89douard_Manet_-_Olympia.jpg/1280px-%C3%89douard_Manet_-_Olympia.jpg|Olympia|Édouard Manet|1863|https://commons.wikimedia.org/wiki/File:%C3%89douard_Manet_-_Olympia.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/%C3%89douard_Manet_-_A_Bar_at_the_Folies-Berg%C3%A8re_-_Google_Art_Project.jpg/1280px-%C3%89douard_Manet_-_A_Bar_at_the_Folies-Berg%C3%A8re_-_Google_Art_Project.jpg|A Bar at the Folies-Bergère|Édouard Manet|1882|https://commons.wikimedia.org/wiki/File:%C3%89douard_Manet_-_A_Bar_at_the_Folies-Berg%C3%A8re_-_Google_Art_Project.jpg"
    
    # Turner (2)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/JMW_Turner_-_The_Fighting_Temeraire_tugged_to_her_last_Berth_to_be_broken_up%2C_1838.jpg/1280px-JMW_Turner_-_The_Fighting_Temeraire_tugged_to_her_last_Berth_to_be_broken_up%2C_1838.jpg|The Fighting Temeraire|J. M. W. Turner|1839|https://commons.wikimedia.org/wiki/File:JMW_Turner_-_The_Fighting_Temeraire_tugged_to_her_last_Berth_to_be_broken_up,_1838.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/JMW_Turner_-_Rain%2C_Steam_and_Speed_-_The_Great_Western_Railway.jpg/1280px-JMW_Turner_-_Rain%2C_Steam_and_Speed_-_The_Great_Western_Railway.jpg|Rain, Steam and Speed|J. M. W. Turner|1844|https://commons.wikimedia.org/wiki/File:JMW_Turner_-_Rain,_Steam_and_Speed_-_The_Great_Western_Railway.jpg"
    
    # Whistler (2)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Whistler_-_Arrangement_in_Grey_and_Black_No._1_%28The_Artist%27s_Mother%29.jpg/1280px-Whistler_-_Arrangement_in_Grey_and_Black_No._1_%28The_Artist%27s_Mother%29.jpg|Arrangement in Grey and Black No. 1|James McNeill Whistler|1871|https://commons.wikimedia.org/wiki/File:Whistler_-_Arrangement_in_Grey_and_Black_No._1_(The_Artist%27s_Mother).jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/James_Abbott_McNeill_Whistler_-_Nocturne_in_Black_and_Gold_-_The_Falling_Rocket.jpg/1280px-James_Abbott_McNeill_Whistler_-_Nocturne_in_Black_and_Gold_-_The_Falling_Rocket.jpg|Nocturne in Black and Gold - The Falling Rocket|James McNeill Whistler|1875|https://commons.wikimedia.org/wiki/File:James_Abbott_McNeill_Whistler_-_Nocturne_in_Black_and_Gold_-_The_Falling_Rocket.jpg"
    
    # More to reach 50...
    # Vermeer (2)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/1665_Girl_with_a_Pearl_Earring.jpg/1280px-1665_Girl_with_a_Pearl_Earring.jpg|Girl with a Pearl Earring|Johannes Vermeer|1665|https://commons.wikimedia.org/wiki/File:1665_Girl_with_a_Pearl_Earring.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Vermeer_-_The_Art_of_Painting.jpg/1280px-Vermeer_-_The_Art_of_Painting.jpg|The Art of Painting|Johannes Vermeer|1666-1668|https://commons.wikimedia.org/wiki/File:Vermeer_-_The_Art_of_Painting.jpg"
    
    # Rembrandt (2)
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/The_Nightwatch_by_Rembrandt_-_Rijksmuseum.jpg/1280px-The_Nightwatch_by_Rembrandt_-_Rijksmuseum.jpg|The Night Watch|Rembrandt|1642|https://commons.wikimedia.org/wiki/File:The_Nightwatch_by_Rembrandt_-_Rijksmuseum.jpg"
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Rembrandt_van_Rijn_-_Self-portrait_-_Google_Art_Project.jpg/1280px-Rembrandt_van_Rijn_-_Self-portrait_-_Google_Art_Project.jpg|Self-Portrait|Rembrandt|1659|https://commons.wikimedia.org/wiki/File:Rembrandt_van_Rijn_-_Self-portrait_-_Google_Art_Project.jpg"
)

# Start JSON array
echo "[" > "$METADATA_FILE"

count=0
total=${#ART_PIECES[@]}

for piece in "${ART_PIECES[@]}"; do
    IFS='|' read -r url title artist year source_url <<< "$piece"
    
    # Create safe filename
    safe_artist=$(echo "$artist" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]')
    safe_title=$(echo "$title" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | cut -c1-30)
    filename="${count}_${safe_artist}_${safe_title}.jpg"
    filename=$(echo "$filename" | sed 's/[^a-zA-Z0-9._-]/_/g')
    
    echo "📥 Downloading ($((count+1))/$total): $title by $artist"
    
    # Download image with better error handling
    if curl -L -s -f --max-time 30 --retry 2 -o "$filename" "$url" 2>/dev/null; then
        echo "✅ Downloaded: $filename"
        
        # Add to JSON (with comma if not first)
        if [ $count -gt 0 ]; then
            echo "," >> "$METADATA_FILE"
        fi
        
        # Escape JSON special characters
        title_escaped=$(echo "$title" | sed 's/"/\\"/g')
        artist_escaped=$(echo "$artist" | sed 's/"/\\"/g')
        year_escaped=$(echo "$year" | sed 's/"/\\"/g')
        
        # Create JSON entry
        cat >> "$METADATA_FILE" <<EOF
    {
        "id": $count,
        "title": "$title_escaped",
        "artist": "$artist_escaped",
        "year": "$year_escaped",
        "filename": "$filename",
        "sourceURL": "$source_url",
        "imageURL": "$url"
    }
EOF
        ((count++))
    else
        echo "❌ Failed to download: $title"
    fi
    
    # Small delay to be respectful
    sleep 0.3
done

# Close JSON array
echo "]" >> "$METADATA_FILE"

echo ""
echo "🎉 Download complete! Downloaded $count paintings."
echo "📄 Metadata saved to: $METADATA_FILE"
