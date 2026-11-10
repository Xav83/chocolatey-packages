import-module chocolatey-au

$releases = 'https://github.com/TDesktop-x64/tdesktop/releases'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    $releases_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    # Several recent releases, newest first: the newest one may not ship a Windows installer (yet).
    $tag_urls = $releases_page.Links.Href -match "/releases/tag/" | Select-Object -Unique -First 10

    $re = '64Gram-setup-x64[.-]v?[\d.]+\.exe$'

    foreach ($tag_url in $tag_urls) {
        $expanded_assets_url = "https://github.com" + ($tag_url -replace "/tag/", "/expanded_assets/")
        $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

        $url = $assets_page.Links.Href -match $re | Select-Object -First 1
        if (!$url) { continue }

        $version = ($tag_url -split '/' | Select-Object -Last 1) -replace '^v', ''
        return @{ URL64 = 'https://github.com' + $url; Version = $version }
    }

    Write-Warning "No 64Gram Windows installer found in the latest releases."
    return 'ignore'
}

update -ChecksumFor 64
