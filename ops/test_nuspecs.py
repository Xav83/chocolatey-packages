"""Validates the package nuspecs (automatic/*/*.nuspec) before AppVeyor and Chocolatey do.

Checks, for every package:
- the nuspec is well-formed XML and has a <metadata> element;
- the fields required by the Chocolatey community repository are present and not empty;
- <id> matches the package folder name;
- <version> is a valid version without leading zeros (the community repository rejects them);
- <packageSourceUrl> points to this package's folder in this repository;
- <dependency> elements have an id, and the <file src> folders exist.

Usage:  python ops/test_nuspecs.py      (exit code 1 if a problem is found)
In GitHub Actions, problems are reported as annotations on the nuspec files.
"""

import glob
import os
import re
import sys
import xml.etree.ElementTree as ET

REQUIRED = [
    "id",
    "version",
    "title",
    "authors",
    "description",
    "projectUrl",
    "packageSourceUrl",
    "tags",
]
REPOSITORY = "https://github.com/Xav83/chocolatey-packages/tree/develop/automatic/"
VERSION = re.compile(
    r"^(0|[1-9]\d*)(\.(0|[1-9]\d*)){0,3}(-[0-9A-Za-z][0-9A-Za-z.-]*)?$"
)

problems = 0


def report(path, message):
    global problems
    problems += 1
    if os.environ.get("GITHUB_ACTIONS"):
        print(f"::error file={path},line=1,title=Invalid nuspec::{message}")
    else:
        print(f"{path}: {message}")


def local(tag):
    return tag.rsplit("}", 1)[-1]  # strip the XML namespace


for path in sorted(glob.glob("automatic/*/*.nuspec")):
    folder = os.path.basename(os.path.dirname(path))
    if folder.startswith("_"):
        continue  # automatic/_output: template examples

    try:
        root = ET.parse(path).getroot()
    except ET.ParseError as error:
        report(path, f"not well-formed XML: {error}")
        continue

    metadata = next((e for e in root if local(e.tag) == "metadata"), None)
    if metadata is None:
        report(path, "no <metadata> element")
        continue
    fields = {local(e.tag): (e.text or "").strip() for e in metadata}

    for name in REQUIRED:
        if not fields.get(name):
            report(path, f"<{name}> is missing or empty")

    if fields.get("id") and fields["id"] != folder:
        report(
            path, f"<id>{fields['id']}</id> does not match the folder name '{folder}'"
        )

    if fields.get("version") and not VERSION.match(fields["version"]):
        report(
            path,
            f"<version>{fields['version']}</version> is not a valid version "
            "(numbers without leading zeros, optionally followed by -prerelease)",
        )

    if (
        fields.get("packageSourceUrl")
        and fields["packageSourceUrl"].rstrip("/") != REPOSITORY + folder
    ):
        report(path, f"<packageSourceUrl> should be {REPOSITORY + folder}")

    if fields.get("description") and len(fields["description"]) < 30:
        report(
            path,
            "<description> is too short (the community repository wants at least 30 characters)",
        )

    for element in root.iter():
        if local(element.tag) == "dependency" and not element.get("id", "").strip():
            report(path, "<dependency> without an id")
        if local(element.tag) == "file":
            src = element.get("src", "").replace("\\", "/").split("*")[0].rstrip("/")
            if src and not os.path.exists(os.path.join(os.path.dirname(path), src)):
                report(path, f"<file src=\"{element.get('src')}\"> does not exist")

print(
    f'{len(glob.glob("automatic/*/*.nuspec"))} nuspecs checked, {problems} problem(s) found.'
)
sys.exit(1 if problems else 0)
