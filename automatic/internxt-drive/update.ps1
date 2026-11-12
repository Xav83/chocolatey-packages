import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'internxt/drive-desktop'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Windows installer: 'Internxt-Setup-<v>.exe' (older releases: 'Internxt-Drive-Setup-<v>.exe')
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^Internxt(-Drive)?-Setup-[\d.]+\.exe$'
    if (!$release) { return 'ignore' }

    $Latest = @{ URL64 = $release.Url; Version = $release.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64
    return $Latest
}

update -ChecksumFor 64
