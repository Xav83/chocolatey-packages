import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

# Each Sophia Script release ships one zip per Windows edition. The package version is the release tag
# (= the Windows 11 script version), and the install script picks the zip matching the user's Windows:
#   Windows 10       'Sophia.Script.for.Windows.10.v<version>.zip'      (its own version, e.g. 7.1.0)
#   Windows 11       'Sophia.Script.for.Windows.11.v<version>.zip'
#   Windows 11 Arm   'Sophia.Script.for.Windows.11.Arm.v<version>.zip'
$repository = 'farag2/Sophia-Script-for-Windows'

$editions = [ordered]@{
    'Win10'    = '^Sophia\.Script\.for\.Windows\.10\.v[\d.]+\.zip$'
    'Win11'    = '^Sophia\.Script\.for\.Windows\.11\.v[\d.]+\.zip$'
    'Win11Arm' = '^Sophia\.Script\.for\.Windows\.11\.Arm\.v[\d.]+\.zip$'
}

function global:au_SearchReplace {
    $replacements = @{}
    foreach ($edition in $editions.Keys) {
        $replacements["(^[$]url$edition\s*=\s*)('.*')"]      = "`$1'$($Latest["URL$edition"])'"
        $replacements["(^[$]checksum$edition\s*=\s*)('.*')"] = "`$1'$($Latest["Checksum$edition"])'"
    }
    @{ 'tools\chocolateyInstall.ps1' = $replacements }
}

function global:au_BeforeUpdate {
    # Use GitHub's SHA256 digests; download and hash only the zips that have none.
    foreach ($edition in $editions.Keys) {
        if (!$Latest["Checksum$edition"]) {
            $Latest["Checksum$edition"] = Get-RemoteChecksum $Latest["URL$edition"]
        }
    }
}

function global:au_GetLatest {
    # The Windows 11 zip decides the release (and the package version)...
    $win11 = Get-GitHubReleaseAsset -Repository $repository -AssetPattern $editions['Win11']
    if (!$win11) { return 'ignore' }

    $Latest = @{ Version = $win11.Version; URLWin11 = $win11.Url; ChecksumWin11 = $win11.Checksum }

    # ...and the other editions must come from the same release.
    $same_tag = '^' + [regex]::Escape($win11.Tag) + '$'
    foreach ($edition in @('Win10', 'Win11Arm')) {
        $release = Get-GitHubReleaseAsset -Repository $repository -MaxReleases 1 -TagPattern $same_tag -AssetPattern $editions[$edition]
        if (!$release) {
            Write-Host "WARNING: Sophia Script $($win11.Version) has no $edition zip: not updating."
            return 'ignore'
        }
        $Latest["URL$edition"]      = $release.Url
        $Latest["Checksum$edition"] = $release.Checksum
    }
    return $Latest
}

update -ChecksumFor none
