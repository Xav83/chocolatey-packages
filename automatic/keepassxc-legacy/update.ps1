import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'keepassxreboot/keepassxc'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Installer for older Windows versions (7, 8.1): 'KeePassXC-<v>-Win64-LegacyWindows.msi'
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^KeePassXC-[\d.]+-Win64-LegacyWindows\.msi$'
    if (!$release) { return 'ignore' }

    # KeePassXC 2.8.0 dropped the legacy installer. Warn when a newer regular release exists, so it
    # is visible that the package stays on the last version that had a legacy build.
    $regular = Get-GitHubReleaseAsset -Repository $repository -MaxReleases 3 -AssetPattern '^KeePassXC-[\d.]+-Win64\.msi$'
    if ($regular -and ([version]$regular.Version -gt [version]$release.Version)) {
        Write-Host "WARNING: KeePassXC $($regular.Version) has no LegacyWindows installer: the package stays on $($release.Version)."
    }

    return @{ URL64 = $release.Url; Version = $release.Version }
}

update -ChecksumFor 64
