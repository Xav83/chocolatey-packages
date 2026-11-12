## Operations

### Ketarin/ChocolateyPackageUpdater Ops

* Use ketarinupdate.cmd or another file to set up a scheduled task for daily, hourly, or whatever schedule you best feel will work appropriately.

### AutomaticUpdater

Nothing to do here, jobs run automatically by AppVeyor on commit and on a schedule that you've set up in AppVeyor.

### Shared helpers for AU update scripts

* `Get-GitHubReleaseAsset.ps1` - finds the newest GitHub release with a real version tag (skipping placeholders such as `v4.x.x`, nightlies and release candidates) that ships an asset matching a pattern. Usage from `automatic/<package>/update.ps1`:

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

`Set-ReleaseChecksum` copies the SHA256 digest GitHub shows for the asset into `$Latest`, so AU skips downloading the installer just to compute its checksum ("Automatic checksum skipped" in the log). Assets without a digest are downloaded and checksummed by AU as before.
