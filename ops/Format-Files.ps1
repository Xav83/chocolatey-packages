<#
.SYNOPSIS
    Applies (or checks) the formatting rules of .editorconfig on the repository's text files.

.DESCRIPTION
    - PowerShell files (.ps1, .psm1, .psd1): UTF-8 with BOM, CRLF
    - .cmd and .bat files: UTF-8 without BOM, CRLF
    - every other text file: UTF-8 without BOM, LF
    - no trailing whitespace (except in Markdown, where two spaces mean a line break)
    - exactly one newline at the end of the file

    Upstream legal texts shipped in packages (automatic/*/tools/*.txt) are skipped, and so are
    binary files. Used by the Git pre-commit hook (.githooks/pre-commit, -Fix) and by CI (-Check).

.EXAMPLE
    .\ops\Format-Files.ps1 -Check          # report the files that do not follow the rules
.EXAMPLE
    .\ops\Format-Files.ps1 -Fix            # fix all tracked files
#>
[CmdletBinding()]
param(
    # Rewrite the files that do not follow the rules, and print their paths.
    [switch] $Fix,

    # Only report the files that do not follow the rules; exit code 1 if there is any.
    [switch] $Check,

    # Files to process, relative to the repository root. Default: every file tracked by Git.
    [string[]] $Path,

    # File containing the paths to process, one per line (used by the Git hook).
    [string] $ListFile
)

$ErrorActionPreference = 'Stop'
if ($Fix -eq $Check) { throw 'Use exactly one of -Fix or -Check.' }

$root = (& git rev-parse --show-toplevel).Trim()
Set-Location $root

if ($ListFile) { $Path = Get-Content -LiteralPath $ListFile -Encoding UTF8 | Where-Object { $_ } }
if (!$Path)    { $Path = & git ls-files }

$skip     = '^automatic/.*/tools/.*\.txt$'
$utf8     = New-Object System.Text.UTF8Encoding $false
$bom      = [byte[]] (0xEF, 0xBB, 0xBF)
$problems = @()

foreach ($file in $Path) {
    $file = $file -replace '\\', '/'
    if ($file -match $skip -or !(Test-Path -LiteralPath $file -PathType Leaf)) { continue }

    $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $file))
    if ($bytes.Length -eq 0) { continue }
    if ([Array]::IndexOf($bytes[0..([Math]::Min($bytes.Length, 8000) - 1)], [byte] 0) -ge 0) { continue }  # binary

    $extension  = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
    $powershell = $extension -in '.ps1', '.psm1', '.psd1'
    $crlf       = $powershell -or ($extension -in '.cmd', '.bat')

    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $offset = if ($hasBom) { 3 } else { 0 }
    $text   = $utf8.GetString($bytes, $offset, $bytes.Length - $offset)

    $lines = $text -replace "`r`n", "`n" -replace "`r", "`n" -split "`n"
    if ($extension -ne '.md') { $lines = $lines | ForEach-Object { $_ -replace '[ \t]+$', '' } }
    $body = (($lines -join "`n") -replace "`n+$", '') + "`n"
    if ($crlf) { $body = $body -replace "`n", "`r`n" }

    $expected = $utf8.GetBytes($body)
    if ($powershell) { $expected = [byte[]] ($bom + $expected) }

    $same = $expected.Length -eq $bytes.Length
    if ($same) { for ($i = 0; $i -lt $bytes.Length; $i++) { if ($bytes[$i] -ne $expected[$i]) { $same = $false; break } } }
    if ($same) { continue }

    $problems += $file
    if ($Fix) {
        [System.IO.File]::WriteAllBytes((Join-Path $root $file), $expected)
        Write-Output $file
    } elseif ($env:GITHUB_ACTIONS) {
        Write-Output "::error file=$file,line=1,title=Formatting::Does not follow .editorconfig (encoding, line endings, trailing whitespace or final newline). Run .\ops\Format-Files.ps1 -Fix"
    } else {
        Write-Output "Not formatted: $file"
    }
}

if ($Check) {
    Write-Output "$($problems.Count) file(s) not formatted."
    if ($problems) { exit 1 }
}
