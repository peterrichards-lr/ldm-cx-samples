#!/usr/bin/env python3
import re
from pathlib import Path
from datetime import datetime

IGNORE_DIRS = {".venv", "node_modules", ".smoke_venv", ".git", ".gradle", "build", ".agents"}

FOOTER_TEMPLATE = """
<!-- markdownlint-disable MD049 -->
---
*Last Updated: {date}* | *Last Reviewed: {date}*
"""

FOOTER_REGEX = re.compile(r"\*Last Updated: ([\d\-]+)\* \| \*Last Reviewed: ([\d\-]+)\*")

def process_file(file_path: Path):
    with file_path.open('r', encoding='utf-8') as f:
        content = f.read()

    if FOOTER_REGEX.search(content):
        return  # Footer already exists

    print(f"Appending timestamps to {file_path}")
    today = datetime.now().strftime("%Y-%m-%d")
    footer = FOOTER_TEMPLATE.format(date=today)
    
    with file_path.open('a', encoding='utf-8') as f:
        if not content.endswith("\n"):
            f.write("\n")
        f.write(footer)

def main():
    root_dir = Path(".")
    for md_file in root_dir.rglob("*.md"):
        # Check if it's in an ignored directory
        if any(part in IGNORE_DIRS for part in md_file.parts):
            continue
        process_file(md_file)

if __name__ == "__main__":
    main()
