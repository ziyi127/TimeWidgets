
import os

file_path = r'C:\Users\ziyi127\Desktop\TimeWidgets\static_site\index.html'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Simple formatting: add newline after > if it's not followed by < (text content) or just add newline after every >
# To be safe and readable, let's just add newlines after closing tags commonly used for structure
formatted_content = content.replace('><', '>\n<')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(formatted_content)

print(f"Formatted {file_path}")
