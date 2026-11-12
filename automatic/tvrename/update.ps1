import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'TV-Rename/tvrename'
function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    # Installer: 'TVRename-v<v>-Installer.exe' (5.x), previously 'TVRename-<v>.exe'.
    # Pre-release / beta tags are skipped.
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^TVRename-v?[\d.]+(-Installer)?\.exe$'
    if (!$release) { return 'ignore' }

    return @{ URL32 = $release.Url; Version = $release.Version }
}

update -ChecksumFor 32
