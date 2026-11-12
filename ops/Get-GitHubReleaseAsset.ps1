# Shared helper for AU update scripts (automatic/<package>/update.ps1).
# Dot-source it from an update script:
#   . "$PSScriptRoot\..\..\ops\Get-GitHubReleaseAsset.ps1"

function global:Get-GitHubReleaseAsset {
    <#
    .SYNOPSIS
        Finds the newest GitHub release that has a real version tag and an asset matching a pattern.

    .DESCRIPTION
        Reads the releases page of a GitHub repository (newest first) and checks up to
        MaxReleases releases. Releases whose tag does not match TagPattern (placeholders
        such as 'v4.x.x', nightlies, release candidates...) are skipped, and so are
        releases that do not ship an asset matching AssetPattern (yet).

        Returns a hashtable @{ Version; Url; Tag; Checksum; ChecksumType } for the first match,
        or $null. Checksum is the SHA256 digest GitHub shows for the asset (assets uploaded since
        mid-2025 have one); it is empty when GitHub has no digest, in which case AU computes the
        checksum by downloading the file, as usual. Pass the result to Set-ReleaseChecksum to use it.

    .EXAMPLE
        $release = Get-GitHubReleaseAsset -Repository 'setvisible/ArrowDL' -AssetPattern '^ArrowDL_x64_Setup\.exe$'
        if (!$release) { return 'ignore' }
        $Latest = @{ URL64 = $release.Url; Version = $release.Version }
        Set-ReleaseChecksum -Latest $Latest -Release $release -Arch 64
        return $Latest
    #>
    param(
        # Repository as 'owner/name'.
        [Parameter(Mandatory = $true)] [string] $Repository,

        # Regex matched against the asset file name (not the full URL).
        [Parameter(Mandatory = $true)] [string] $AssetPattern,

        # Regex a tag must match to be considered a release. Default: plain versions such as 'v1.2.3' or '1.2'.
        [string] $TagPattern = '^v?\d+(\.\d+)+$',

        # Maximum number of releases to inspect, newest first.
        [int] $MaxReleases = 10
    )

    $releases_url = "https://github.com/$Repository/releases"
    $releases_page = Invoke-WebRequest -Uri $releases_url -UseBasicParsing

    $tag_prefix = "/$Repository/releases/tag/"
    $tags = @()
    foreach ($href in $releases_page.Links.Href) {
        if (!$href -or !$href.StartsWith($tag_prefix, [StringComparison]::OrdinalIgnoreCase)) { continue }
        $tag = [Uri]::UnescapeDataString($href.Substring($tag_prefix.Length))
        if (($tag -match $TagPattern) -and ($tags -notcontains $tag)) { $tags += $tag }
    }

    foreach ($tag in ($tags | Select-Object -First $MaxReleases)) {
        $assets_url = "https://github.com/$Repository/releases/expanded_assets/$([Uri]::EscapeDataString($tag))"
        $assets_page = Invoke-WebRequest -Uri $assets_url -UseBasicParsing

        foreach ($href in $assets_page.Links.Href) {
            if (!$href -or ($href -notmatch '/releases/download/')) { continue }
            $file_name = $href -split '/' | Select-Object -Last 1
            if ($file_name -match $AssetPattern) {
                $url = if ($href.StartsWith('http')) { $href } else { 'https://github.com' + $href }
                $checksum = Get-GitHubAssetDigest -Html $assets_page.Content -Href $href
                return @{
                    Version      = ($tag -replace '^v', '')
                    Url          = $url
                    Tag          = $tag
                    Checksum     = $checksum
                    ChecksumType = $(if ($checksum) { 'sha256' } else { '' })
                }
            }
        }
    }

    Write-Host "WARNING: No release of $Repository with a tag matching '$TagPattern' and an asset matching '$AssetPattern' among the $MaxReleases latest releases."
    return $null
}

function global:Get-GitHubAssetDigest {
    <#
    .SYNOPSIS
        Returns the SHA256 digest GitHub shows next to an asset on a release's asset list, or ''.
    .DESCRIPTION
        Looks for 'sha256:<64 hex digits>' in the list item (<li>) that contains the asset's link.
    #>
    param([string] $Html, [string] $Href)

    if (!$Html -or !$Href) { return '' }
    $index = $Html.IndexOf($Href)
    if ($index -lt 0) { return '' }

    $start = $Html.LastIndexOf('<li', $index)
    $end = $Html.IndexOf('</li>', $index)
    if ($start -lt 0) { $start = 0 }
    if ($end -lt 0) { $end = $Html.Length }

    $item = $Html.Substring($start, $end - $start)
    if ($item -match 'sha256:([0-9a-fA-F]{64})') { return $Matches[1].ToLower() }
    return ''
}

function global:Set-ReleaseChecksum {
    <#
    .SYNOPSIS
        Copies the GitHub digest of a release asset into AU's $Latest, for the given architecture.
    .DESCRIPTION
        When the digest is known, AU can use it instead of downloading the file to compute the
        checksum. When it is not, $Latest is left unchanged and AU computes the checksum itself.
    .EXAMPLE
        Set-ReleaseChecksum -Latest $Latest -Release $release64 -Arch 64
    #>
    param(
        [Parameter(Mandatory = $true)] [hashtable] $Latest,
        $Release,
        [ValidateSet('32', '64')] [string] $Arch = '64'
    )

    if ($Release -and $Release.Checksum) {
        $Latest["Checksum$Arch"]     = $Release.Checksum
        $Latest["ChecksumType$Arch"] = $Release.ChecksumType
    }
}
