import-module chocolatey-au

# OpenProject publishes no Windows build: this package ships the source archive of each release
# (as requested in https://github.com/chocolatey-community/chocolatey-package-requests/issues/1015).
$repository = 'opf/openproject'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    $releases_page = Invoke-WebRequest -Uri "https://github.com/$repository/releases" -UseBasicParsing

    $tag_prefix = "/$repository/releases/tag/"
    $tag = $releases_page.Links.Href |
        Where-Object { $_ -and $_.StartsWith($tag_prefix) } |
        ForEach-Object { $_.Substring($tag_prefix.Length) } |
        Where-Object { $_ -match '^v\d+(\.\d+)+$' } |
        Select-Object -First 1

    if (!$tag) {
        Write-Host "WARNING: No release of $repository with a plain version tag found."
        return 'ignore'
    }

    $Latest = @{
        URL64   = "https://github.com/$repository/archive/refs/tags/$tag.zip"
        Version = $tag -replace '^v', ''
    }
    return $Latest
}

update -ChecksumFor 64
