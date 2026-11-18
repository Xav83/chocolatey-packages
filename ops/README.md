# Operations

Scripts used by the packages, by CI and by the Git pre-commit hook.

| Script | Used by | What it does |
| --- | --- | --- |
| `Get-GitHubReleaseAsset.ps1` | `automatic/*/update.ps1` | Shared helper to find the latest GitHub release of a package (see below). |
| `Format-Files.ps1` | pre-commit hook, `lint.yml` | Applies (`-Fix`) or checks (`-Check`) the `.editorconfig` rules: encoding, line endings, trailing whitespace, final newline. |
| `test_nuspecs.py` | pre-commit hook, `lint.yml` | Validates the nuspecs (required fields, id = folder name, normalized version, `packageSourceUrl`, dependencies, files) and checks that the package table of `README.md` lists every package. |
| `test_package_scripts.py` | pre-commit hook, `lint.yml` | Checks that every `au_SearchReplace` pattern of `update.ps1` matches its target file. |

## Shared helper for AU update scripts

`Get-GitHubReleaseAsset.ps1` finds the newest GitHub release with a real version tag (skipping placeholders such as `v4.x.x`, nightlies and release candidates) that ships an asset matching a pattern. Usage from `automatic/<package>/update.ps1`:

```powershell
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

function global:au_GetLatest {
    $release = Get-GitHubReleaseAsset -Repository 'owner/name' -AssetPattern '^App-Setup-x64\.exe$'
    if (!$release) { return 'ignore' }
    $Latest = @{ URL64 = $release.Url; Version = $release.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64   # use GitHub's SHA256 digest when available
    return $Latest
}
```

`Set-ReleaseChecksum` copies the SHA256 digest GitHub shows for the asset into `$Latest`, so AU can verify the download against it. Assets without a digest are downloaded and checksummed by AU as before.
