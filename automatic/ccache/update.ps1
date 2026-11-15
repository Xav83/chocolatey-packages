import-module chocolatey-au

$releases = 'https://github.com/ccache/ccache/releases'

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
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re  = "github.com.+ccache-.+-windows-.+.zip$"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 2 -expand href

    $version = $url[0] -split '/' -replace 'v','' | Select-Object -Last 1 -Skip 1
    $charCount = ($version.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    if ($charCount -eq 1)
    {
        $version = $version + ".0"
    }
    $url32 = $url[0]
    $url64 = $url[1]

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
