import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'oldj/SwitchHosts'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    # SwitchHosts 5 installers: 'SwitchHosts-<v>-windows-x64-setup.exe' / '...-windows-x86-setup.exe'
    # (also shown as 'SwitchHosts_<v>_x64-setup.exe'). The arm64 build must never be picked.
    $release64 = Get-GitHubReleaseAsset -Repository $repository -AssetPattern '^SwitchHosts[-_][\d.]+[-_](windows-)?x64-setup\.exe$'
    if (!$release64) { return 'ignore' }

    $release32 = Get-GitHubReleaseAsset -Repository $repository -MaxReleases 1 `
        -TagPattern ('^' + [regex]::Escape($release64.Tag) + '$') `
        -AssetPattern '^SwitchHosts[-_][\d.]+[-_](windows-)?x86-setup\.exe$'
    if (!$release32) { return 'ignore' }

    return @{ URL32 = $release32.Url; URL64 = $release64.Url; Version = $release64.Version }
}

update
