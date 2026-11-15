import-module chocolatey-au

$releases = 'https://github.com/chylex/Discord-History-Tracker/releases'

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
    $release_tag_url = "https://github.com" + ($releases_page.Links.Href -match "/tag/" | Select-Object -First 1)

    $expanded_assets_url = $release_tag_url -replace "/tag/","/expanded_assets/"
    $assets_page = Invoke-WebRequest -Uri $expanded_assets_url -UseBasicParsing

    $re  = "win-x64.zip"

    $url = $assets_page.Links.Href -match $re | Select-Object -First 1

    $version = ($url -split '/' | Select-Object -Last 1 -Skip 1) -replace 'v',''
    $charCount = ($version.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    if ($charCount -eq 1)
    {
        $version = $version + ".0"
    }
    $url64 = 'https://github.com' + $url

    $Latest = @{ URL64 = $url64; Version = $version }
    return $Latest
}

update -ChecksumFor 64
