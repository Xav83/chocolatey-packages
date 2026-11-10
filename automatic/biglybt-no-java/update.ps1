import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'BiglySoftware/BiglyBT'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Since 4.x the Windows installer without bundled Java is 'GitHub_BiglyBT_Windows_NoJRE.exe'
    # (older releases used 'GitHub_BiglyBT_Installer64.exe').
    $release = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^GitHub_BiglyBT_(Windows_NoJRE|Installer64)\.exe$'
    if (!$release) { return 'ignore' }

    return @{ URL64 = $release.Url; Version = $release.Version }
}

update -ChecksumFor 64
