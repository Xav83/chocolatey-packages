import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'claudiodangelis/qrcp'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Tags are '0.11.3' or, since 0.11.6, 'v0.11.6': the helper strips the 'v' from the version.
    $release64 = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^qrcp_[\d.]+_windows_amd64\.tar\.gz$'
    if (!$release64) { return 'ignore' }

    # 32-bit archive from the same release
    $release32 = Get-GitHubReleaseAsset -Repository $repository -MaxReleases 1 `
        -TagPattern ('^' + [regex]::Escape($release64.Tag) + '$') `
        -AssetPattern '^qrcp_[\d.]+_windows_386\.tar\.gz$'
    if (!$release32) { return 'ignore' }

    $Latest = @{ URL32 = $release32.Url; URL64 = $release64.Url; Version = $release64.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release32 -Arch 32
    Set-ReleaseChecksum -Latest $Latest -Release $release64 -Arch 64
    return $Latest
}

update
