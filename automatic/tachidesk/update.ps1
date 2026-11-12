import-module chocolatey-au

$releases = 'https://github.com/Suwayomi/Tachidesk-JUI/releases'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Package frozen: replaced by the 'tachidesk-jui' package (same app) since October 2022.
    return 'ignore'

    $releases_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $release_tag_url = "https://github.com" + ($releases_page.Links.Href -match "/tag/" | Select-Object -First 1)

    $expanded_assets_url = $release_tag_url -replace "/tag/","/expanded_assets/"
    $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

    $re  = "Tachidesk-JUI-windows-x64-.+.msi"

    $url = $assets_page.Links.Href -match $re | Select-Object -First 1

    $version = ($url -split '/' | Select-Object -Last 1 -Skip 1) -replace 'v',''
    $url64 = 'https://github.com' + $url

    $Latest = @{ URL64 = $url64; Version = $version }
    return $Latest
}

update -ChecksumFor 64
