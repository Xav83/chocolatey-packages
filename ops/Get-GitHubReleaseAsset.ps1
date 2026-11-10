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

        Returns a hashtable @{ Version; Url; Tag } for the first match, or $null.

    .EXAMPLE
        $release = Get-GitHubReleaseAsset -Repository 'setvisible/ArrowDL' -AssetPattern '^ArrowDL_x64_Setup\.exe$'
        if (!$release) { return 'ignore' }
        @{ URL64 = $release.Url; Version = $release.Version }
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
                return @{ Version = ($tag -replace '^v', ''); Url = $url; Tag = $tag }
            }
        }
    }

    Write-Warning "No release of $Repository with a tag matching '$TagPattern' and an asset matching '$AssetPattern' among the $MaxReleases latest releases."
    return $null
}
