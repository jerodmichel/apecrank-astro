import xml.etree.ElementTree as ET
import os

# Load your feed
tree = ET.parse('/home/stereo/Downloads/Takeout/Blogger/Blogs/Åpecranꓘ_ The Tenebric Symplecticum/feed.atom')
root = tree.getroot()

# The Blogger namespace
ns = {'atom': 'http://www.w3.org/2005/Atom'}

for entry in root.findall('atom:entry', ns):
    # Get the title
    title = entry.find('atom:title', ns).text
    # Get the content
    content = entry.find('atom:content', ns).text
    # Create a filename from the title
    filename = f"{title.lower().replace(' ', '-')}.md"
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(f"---\ntitle: \"{title}\"\n---\n\n{content}")
        print(f"Extracted: {filename}")
