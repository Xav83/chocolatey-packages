import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'setvisible/ArrowDL'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^ArrowDL_x64_Setup\.exe$'
    if (!$release) { return 'ignore' }

    $Latest = @{ URL64 = $release.Url; Version = $release.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64
    return $Latest
}

update  -ChecksumFor 64
