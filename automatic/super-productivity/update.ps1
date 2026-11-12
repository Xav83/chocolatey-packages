import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'super-productivity/super-productivity'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # x64 installer: 'Super-Productivity-Setup-x64.exe'. New releases are sometimes published before
    # the Windows installer is attached: the helper then falls back to the newest release that has it.
    # Tags: 'v20.0.0' or release candidates such as 'v17.0.0-rc.1'.
    $release = Get-GitHubReleaseAsset -Repository $repository `
        -TagPattern '^v?\d+(\.\d+)+(-rc\.?\d+)?$' `
        -AssetPattern '^Super-Productivity-Setup-x64\.exe$'
    if (!$release) { return 'ignore' }

    # Chocolatey pre-release format: '17.0.0-rc.1' -> '17.0.0-rc1'
    $version = $release.Version -replace '-rc\.(\d+)$', '-rc$1'

    $Latest = @{ URL64 = $release.Url; Version = $version }
    Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64
    return $Latest
}

update -ChecksumFor 64
