#!/usr/bin/env python3
import re
import sys
import argparse
from pathlib import Path
from datetime import datetime

IGNORE_DIRS = {".venv", "node_modules", ".smoke_venv", ".git", ".gradle", "build", ".agents"}
FOOTER_REGEX = re.compile(r"\*Last Updated: ([\d\-]+)\* \| \*Last Reviewed: ([\d\-]+)\*")

def check_file(file_path: Path, max_review_days: int, max_update_days: int, max_gap_days: int) -> bool:
    with file_path.open('r', encoding='utf-8') as f:
        content = f.read()

    match = FOOTER_REGEX.search(content)
    if not match:
        print(f"ERROR: {file_path} is missing the required timestamp footer.")
        return False

    updated_str, reviewed_str = match.groups()
    try:
        updated_date = datetime.strptime(updated_str, "%Y-%m-%d")
        reviewed_date = datetime.strptime(reviewed_str, "%Y-%m-%d")
    except ValueError:
        print(f"ERROR: {file_path} has invalid date formats. Must be YYYY-MM-DD.")
        return False

    now = datetime.now()
    review_age = (now - reviewed_date).days
    update_age = (now - updated_date).days
    gap = (reviewed_date - updated_date).days

    if gap < 0:
        print(f"ERROR: {file_path} was reviewed before it was updated? Gap: {gap} days.")
        return False

    is_valid = True
    if review_age > max_review_days:
        print(f"WARNING: {file_path} review is too old ({review_age} days > {max_review_days}).")
        is_valid = False
    if update_age > max_update_days:
        print(f"WARNING: {file_path} update is too old ({update_age} days > {max_update_days}).")
        is_valid = False
    if gap > max_gap_days:
        print(f"WARNING: {file_path} gap between update and review is too large ({gap} days > {max_gap_days}).")
        is_valid = False

    return is_valid

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-review-days", type=int, default=180)
    parser.add_argument("--max-update-days", type=int, default=365)
    parser.add_argument("--max-gap-days", type=int, default=365)
    args = parser.parse_args()

    root_dir = Path(".")
    all_valid = True
    for md_file in root_dir.rglob("*.md"):
        if any(part in IGNORE_DIRS for part in md_file.parts):
            continue
        if not check_file(md_file, args.max_review_days, args.max_update_days, args.max_gap_days):
            all_valid = False

    if not all_valid:
        print("\nSome documents failed the review policy checks. Please review and update them.")
        sys.exit(1)
    
    print("All documents passed the review policy checks.")

if __name__ == "__main__":
    main()
