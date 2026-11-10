import-module chocolatey-au
. "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

$repository = 'comictagger/comictagger'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Tags look like '1.5.5' or '1.6.0-beta.6' (alpha and beta releases are packaged too).
    # Windows asset: 'ComicTagger-<v>-Windows-AMD64.zip' (since 1.6.0-beta.6),
    # previously 'ComicTagger-<v>-win-AMD64.exe.zip'.
    $release = Get-GitHubReleaseAsset -Repository $repository `
        -TagPattern '^v?\d+(\.\d+)+(-(alpha|beta)\.\d+)?$' `
        -AssetPattern '^ComicTagger-.+-(Windows-AMD64|win-AMD64\.exe)\.zip$'
    if (!$release) { return 'ignore' }

    # Chocolatey pre-release format: '1.6.0-beta.6' -> '1.6.0-beta6'
    $version = $release.Version -replace '-(alpha|beta)\.(\d+)$', '-$1$2'

    return @{ URL64 = $release.Url; Version = $version }
}

update -ChecksumFor 64
