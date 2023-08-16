"""
Script: HTTP URL Finder
Version: 1.0
Author: Jack Atherton
Synopsis: This script searches for HTTP URLs in a text file and prints the matching lines.

Description:
This script reads a text file specified by the user and searches for lines containing HTTP URLs.
It performs a pattern matching to identify URLs starting with http://, https://, ftp://, and other schemes,
and it prints the line numbers and the entire lines where matches are found.
"""

import re

def contains_http_url(line):
    # Regular expression pattern to match various URL schemes
    url_pattern = r"(http://|https://|ftp://|sftp://|ssh://|smtp://|pop3://|imap://|telnet://|rdp://|vnc://|nfs://|ldap://)\S+"
    match = re.search(url_pattern, line)
    if match:
        return match.group()  # Return the exact matched URL
    return None

def find_http_urls_in_file(file_path):
    try:
        with open(file_path, 'r') as file:
            for line_number, line in enumerate(file, start=1):
                matched_url = contains_http_url(line)
                if matched_url:
                    highlighted_line = line.replace(matched_url, f"\033[32m{matched_url}\033[0m")
                    print(f"Line {line_number}: {highlighted_line.strip()}")
            if not any(contains_http_url(line) for line in file):
                print("\033[31mNo matches found.\033[0m")  # Print "No matches found" in red
    except FileNotFoundError:
        print(f"File not found: {file_path}")

if __name__ == "__main__":
    file_path = input('Please enter the filename to search: ')
    find_http_urls_in_file(file_path)
