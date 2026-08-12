#!/bin/bash
cd ~/tested-transit/interstellar-cloud/src/content/posts

for f in *notes-from-china*.md; do
  cat >> "$f" << 'EOF'

<style>
  @media (max-width: 480px) {
    div[id^="Section"] {
      width: 110% !important;
      transform: scale(1.0) !important;
      transform-origin: top left !important;
    }
  }
</style>
EOF
done

echo "Done! Added style blocks to all notes-from-china posts."
