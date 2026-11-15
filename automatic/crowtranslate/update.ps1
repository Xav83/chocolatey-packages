import-module chocolatey-au

# Crow Translate moved to KDE in 2025 (the GitHub repository is archived). Releases are published on
# KDE's GitLab, with the binaries on download.kde.org:
#   https://invent.kde.org/office/crow-translate/-/releases
$releases_api = 'https://invent.kde.org/api/v4/projects/office%2Fcrow-translate/releases?per_page=10'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    $releases = Invoke-RestMethod -Uri $releases_api -UseBasicParsing

    # Newest release with a plain version tag (v4.1.0) and a Windows installer on download.kde.org.
    # Older releases linked to CI job artifacts, which expire: those are skipped.
    foreach ($release in $releases) {
        if ($release.upcoming_release -or $release.tag_name -notmatch '^v?\d+(\.\d+)+$') { continue }

        $installer = $release.assets.links | Where-Object {
            $_.url -match '^https://download\.kde\.org/.+-windows-.+x86_64\.exe$'
        } | Select-Object -First 1

        if ($installer) {
            return @{ URL64 = $installer.url; Version = $release.tag_name -replace '^v', '' }
        }
    }

    Write-Host "WARNING: No release of Crow Translate with a Windows installer on download.kde.org among the latest releases."
    return 'ignore'
}

update -ChecksumFor 64
