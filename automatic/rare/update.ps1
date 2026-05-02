import-module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"       = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $latestRelease = Get-LatestRelease;

    $TARGET_ASSET_REGEX = 'Rare-.*-x86_64.msi'

    $targetAsset = $latestRelease.assets | Where-Object { $_.name -match $TARGET_ASSET_REGEX }
    if (-not $targetAsset) {
        Write-Host 'Unable to find the taget asset'
        return 'ignore'
    }

    $url64 = $targetAsset.browser_download_url

    $version = $latestRelease.tag_name
    # NOTE: Clean-up rc tags
    # Not sure if this is needed, the last rc was in 2022.
    # Keeping this here for equivalence sake.
    $version = $Version -creplace 'rc.', 'rc'

    # EXAMPLE: $targetAsset.digest == "sha256:2151b604e..."
    $checksumType64, $checksum64 = $targetAsset.digest -split ':', 2

    return @{
        URL64 = $url64
        Checksum64 = $checksum64
        ChecksumType64 = $checksumType64

        Version = $version
    }
}

function Get-LatestRelease {
    $REPO_OWNER = 'RareDevs'
    $REPO_NAME = 'Rare'

    $REQUEST_HEADERS = @{
        'Accept' = 'application/vnd.github+json'
        'X-GitHub-Api-Version' = '2026-03-10'
    }

    $repoReleases = Invoke-WebRequest `
        # NOTE: More convoluted usage of releases API
        # There is a dedicated api for pulling the latest release.
        # We don't use it as does not report pre-releases (which the old script did).
        -Uri "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases" `
        -Headers $REQUEST_HEADERS `
        # NOTE: Match GitHub API-docs example usage
        # The cURL based examples use the -L flag allowing redirects (iwr does this by default).
        # The maximum amount of redirects by default in cURL is 50 (iwr's default is 10).
        # This flag here allows us to match that 50 redirect number.
        -MaximumRedirection 50 `
        -UseBasicParsing `
        | ConvertFrom-Json
    if (-not $repoReleases) {
        Write-Host 'Unable to request latest releases'
        return 'ignore'
    }

    return $repoReleases[0]
}

update -ChecksumFor none
