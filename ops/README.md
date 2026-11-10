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
    return @{ URL64 = $release.Url; Version = $release.Version }
}
```
