import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'grame-cncm/faust'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # The newest release does not always ship the Windows installer (yet): use the newest one that does.
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^Faust-[\d.]+-win64\.exe$'
    if (!$release) { return 'ignore' }

    return @{ URL64 = $release.Url; Version = $release.Version }
}

update -ChecksumFor 64
