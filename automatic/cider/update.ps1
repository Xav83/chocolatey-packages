import-module chocolatey-au

$releases = 'https://github.com/ciderapp/Cider/releases'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    # Package frozen: Cider 1 is archived (final release v1.6.3) and its installer has been removed
    # from the GitHub release (download returns 404). Cider 2 is closed-source and sold on
    # itch.io / Microsoft Store, so it cannot be packaged automatically.
    return 'ignore'

    $releases_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $release_tag_url = "https://github.com" + ($releases_page.Links.Href -match "/tag/" | Select-Object -First 1)

    $expanded_assets_url = $release_tag_url -replace "/tag/","/expanded_assets/"
    $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

    $re = "Cider-Setup-.+"
    $url = $assets_page.Links.Href -match $re | Select-Object -First 1

    $version = ($url -split '/' | Select-Object -Last 1 -Skip 1) -replace 'v',''
    $url32 = 'https://github.com' + $url

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
