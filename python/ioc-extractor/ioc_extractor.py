#!/usr/bin/env python3

#load python regex to find patterns in text
import re
#give access to system-specific parameters and functions
import sys

PATTERNS = {
    "URLs":    r"https?://[^\s\"'<>]+",
    "Emails":  r"\b[\w.+-]+@[\w-]+(?:\.[\w-]+)+\b",
    "IPs":     r"\b(?:\d{1,3}\.){3}\d{1,3}\b",
    "Domains": r"\b(?:[a-z0-9-]+\.)+[a-z]{2,}\b",
    "SHA256":  r"\b[a-f0-9]{64}\b",
    "SHA1":    r"\b[a-f0-9]{40}\b",
    "MD5":     r"\b[a-f0-9]{32}\b",
}

#If defanged, refang it so it can be matched. If not defanged, do nothing.
def refang(text):
    return text.replace("[.]", ".").replace("hxxp", "http").replace("[@]", "@")

#Now the report can be matched against the regex patterns. If a match is found, it will be defanged again.
def defang(ioc):
    return ioc.replace("http", "hxxp").replace(".", "[.]").replace("@", "[@]")

#Find every IOC in the text, removing duplicates.
def extract(text):
    text = refang(text)
    results = {}
    for name, pattern in PATTERNS.items():
        matches = re.findall(pattern, text, re.IGNORECASE)
        results[name] = sorted({m.rstrip(".,;)") for m in matches})
    return results

#Main function to run the script. It takes a file as an argument, reads its content, and extracts IOCs from it. The results are printed to the console.
def main():
    if len(sys.argv) != 2:
        print("Usage: python ioc_extractor.py <file>")
        sys.exit(1)

    with open(sys.argv[1], encoding="utf-8", errors="ignore") as f:
        text = f.read()

    for name, iocs in extract(text).items():
        if iocs:
            print(f"\n{name} ({len(iocs)})")
            for ioc in iocs:
                print(f"  {defang(ioc)}")

#Run the main function if the script is executed directly.
if __name__ == "__main__":
    main()