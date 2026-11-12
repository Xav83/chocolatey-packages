import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'conan-io/conan'

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
    # 64-bit installer: 'conan-<v>-windows-x86_64-installer.exe'
    $release64 = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^conan-[\d.]+-windows-x86_64-installer\.exe$'
    if (!$release64) { return 'ignore' }

    # 32-bit installer from the same release: 'conan-<v>-windows-i686-installer.exe'
    $release32 = Get-GitHubReleaseAsset -Repository $repository -MaxReleases 1 `
        -TagPattern ('^' + [regex]::Escape($release64.Tag) + '$') `
        -AssetPattern '^conan-[\d.]+-windows-i686-installer\.exe$'

    $Latest = @{ URL64 = $release64.Url; Version = $release64.Version }
    Set-ReleaseChecksum -Latest $Latest -Release $release64 -Arch 64
    if ($release32) {
        $Latest.URL32 = $release32.Url
        Set-ReleaseChecksum -Latest $Latest -Release $release32 -Arch 32
    } else {
        Write-Host "WARNING: Conan $($release64.Version) has no 32-bit (i686) installer: the package will be 64-bit only."
    }
    return $Latest
}

update
