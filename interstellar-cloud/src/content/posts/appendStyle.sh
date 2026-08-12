#!/bin/bash
cd ~/tested-transit/interstellar-cloud/src/content/posts

for f in *notes-from-china*.md; do
  # Remove last 8 lines (the old style block)
  head -n -8 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  
  # Append the new one
  cat >> "$f" << 'EOF'

<style>
  @media (max-width: 480px) {
    div[id^="Section"] {
      width: 110% !important;
      transform: scale(0.85) !important;
      transform-origin: top left !important;
    }
  }
</style>
EOF
done

echo "Done!"
