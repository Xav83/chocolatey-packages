import-module chocolatey-au

$releases = 'https://github.com/athensresearch/athens/releases'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Athens is no longer maintained: the repository was archived by its authors and there will be no new
    # release (https://github.com/athensresearch/athens). The package stays frozen at its last version.
    return 'ignore'

    $releases_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $release_tag_url = "https://github.com" + ($releases_page.Links.Href -match "/tag/" | Select-Object -First 1)

    $expanded_assets_url = $release_tag_url -replace "/tag/","/expanded_assets/"
    $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

    $re  = "Athens-Setup-.+.exe"

    $url = $assets_page.Links.Href -match $re | Select-Object -First 1

    $version = ($url -split '/' | Select-Object -Last 1 -Skip 1) -replace 'v',''
    if ($version.Contains("beta")) { 
        $version = $version -replace 'beta.','beta'
    }

    $url64 = 'https://github.com' + $url

    $Latest = @{ URL64 = $url64; Version = $version }
    return $Latest
}

update -ChecksumFor 64
