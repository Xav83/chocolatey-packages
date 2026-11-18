"""Checks the consistency between each package's update.ps1 and the files it updates.

For every package (automatic/*/update.ps1):
- every pattern of au_SearchReplace matches at least one line of its target file. Otherwise
  AU silently leaves that value (URL, checksum...) unchanged when it updates the package.

Usage:  python ops/test_package_scripts.py      (exit code 1 if a problem is found)
In GitHub Actions, problems are reported as annotations on the update.ps1 files.
"""

import glob
import os
import re
import sys

problems = 0


def report(path, line, message):
    global problems
    problems += 1
    if os.environ.get("GITHUB_ACTIONS"):
        print(f"::error file={path},line={line},title=au_SearchReplace::{message}")
    else:
        print(f"{path}:{line}: {message}")


def powershell_string(literal):
    """Value of a PowerShell string literal, or None if it contains variables."""
    quote, body = literal[0], literal[1:-1]
    if quote == "'":
        return body.replace("''", "'")
    if re.search(r"(?<!`)\$[({A-Za-z_]", body):
        return None  # expandable string with a variable: value only known at run time
    return re.sub(r"`(.)", r"\1", body)  # `$ -> $, `" -> "...


STRING = r"(\"(?:[^\"`]|`.)*\"|'(?:[^']|'')*')"

for update in sorted(glob.glob("automatic/*/update.ps1")):
    package = os.path.dirname(update)
    text = open(update, encoding="utf-8-sig").read()

    block = re.search(r"function\s+global:au_SearchReplace\s*\{(.*?)\n\}", text, re.S)
    if not block:
        continue
    start_line = text[: block.start(1)].count("\n") + 1

    target = None
    for offset, line in enumerate(block.group(1).split("\n")):
        number = start_line + offset
        key = re.match(rf"\s*{STRING}\s*=\s*@\{{", line)
        if key:
            name = powershell_string(key.group(1))
            path = os.path.join(package, *name.split("\\")) if name else None
            target = None
            if path is None:
                continue  # file name computed at run time
            if not os.path.isfile(path):
                report(update, number, f"target file '{name}' does not exist")
                continue
            target = (name, open(path, encoding="utf-8-sig").read().splitlines())
            continue

        entry = re.match(rf"\s*{STRING}\s*=", line)
        if entry and target:
            pattern = powershell_string(entry.group(1))
            if pattern is None:
                continue
            # AU applies -replace line by line, and PowerShell's -replace ignores case.
            regex = re.compile(pattern, re.IGNORECASE)
            if not any(regex.search(text_line) for text_line in target[1]):
                report(
                    update,
                    number,
                    f"pattern {entry.group(1)} matches no line of '{target[0]}'",
                )

count = len(glob.glob("automatic/*/update.ps1"))
print(f"{count} update scripts checked, {problems} problem(s) found.")
sys.exit(1 if problems else 0)
