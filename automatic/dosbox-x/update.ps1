import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'joncampbell123/dosbox-x'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Regular release tags look like 'dosbox-x-v2026.07.02'. Other tags (e.g. the OSFREE
    # releases, 'dosbox-x-v2026.10.01-osfree') are skipped.
    $tag_pattern = '^dosbox-x-v\d+(\.\d+)+$'

    # The package ships the XP-compatible installer 'dosbox-x-winXP-<v>-setup.exe' only.
    $release = Get-GitHubReleaseAsset -Repository $repository -TagPattern $tag_pattern -AssetPattern '^dosbox-x-winXP-[\d.]+-setup\.exe$'
    if (!$release) { return 'ignore' }
    # Chocolatey normalizes versions: '2025.05.03' is looked up as '2025.5.3', so a package pushed
    # with leading zeros can't be found (that made the verifier reject 2025.x). Drop them.
    $version = ($release.Tag -replace '^dosbox-x-v', '') -replace '(^|\.)0+(?=\d)', '$1'

    # Warn when a newer regular release exists without an XP build: the package would otherwise
    # silently stop being updated.
    $windows = Get-GitHubReleaseAsset -Repository $repository -TagPattern $tag_pattern -AssetPattern '^dosbox-x-windows-[\d.]+-setup\.exe$'
    if ($windows) {
        $windows_version = ($windows.Tag -replace '^dosbox-x-v', '') -replace '(^|\.)0+(?=\d)', '$1'
        if ([version]$windows_version -gt [version]$version) {
            Write-Host "WARNING: DOSBox-X $windows_version has no winXP installer: the package stays on $version (last release with an XP build)."
        }
    }

    return @{ URL64 = $release.Url; Version = $version }
}

update -ChecksumFor 64
