import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'RareDevs/Rare'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # MSI installer for x64. Releases also ship 'Rare-<v>-arm64.msi', which must never be picked.
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^Rare-[\d.]+(-(x64|amd64|x86_64))?\.msi$'
    if (!$release) { return 'ignore' }

    $Latest = @{ URL64 = $release.Url; Version = $release.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64
    return $Latest
}

update -ChecksumFor 64
