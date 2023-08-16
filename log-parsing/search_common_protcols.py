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
    return re.search(url_pattern, line)

def find_http_urls_in_file(file_path):
    try:
        found_match = False  # Flag to track if any matches are found
        with open(file_path, 'r') as file:
            for line_number, line in enumerate(file, start=1):
                if contains_http_url(line):
                    print(f"\033[32mLine {line_number}: {line.strip()}\033[0m")  # Print in green
                    found_match = True
            if not found_match:
                print("\033[31mNo matches found.\033[0m")  # Print "No matches found" in red
    except FileNotFoundError:
        print(f"File not found: {file_path}")

if __name__ == "__main__":
    file_path = input('Please enter the filename to search: ')
    find_http_urls_in_file(file_path)
