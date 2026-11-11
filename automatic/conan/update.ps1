import-module chocolatey-au

$releases = 'https://github.com/conan-io/conan/releases'

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
    $releases_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $release_tag_url = "https://github.com" + ($releases_page.Links.Href -match "/tag/" | Select-Object -First 1)

    $expanded_assets_url = $release_tag_url -replace "/tag/","/expanded_assets/"
    $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

    $re  = "conan-.+-windows-x86_64-installer.exe"
    $url = $assets_page.Links.Href -match $re | Select-Object -First 1

    $version = $url -split '/' | Select-Object -Last 1 -Skip 1
    $url32 = 'https://github.com' + $url
    $url64 = 'https://github.com' + $url

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
