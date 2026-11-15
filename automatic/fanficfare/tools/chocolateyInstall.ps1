$ErrorActionPreference = 'Stop'

$url64       = ''
$checksum64  = ''

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'ZIP'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  fileFullPath   = Join-Path (Split-Path $MyInvocation.MyCommand.Definition) "FanFicFarePlugin.zip"
  validExitCodes = @(0)
}

Get-ChocolateyWebFile @packageArgs

if (Get-Command "calibre-customize.exe" -ErrorAction SilentlyContinue) {
  $pinfo                        = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName               = "calibre-customize.exe"
  $pinfo.UseShellExecute        = $false
  $pinfo.CreateNoWindow         = $true
  $pinfo.RedirectStandardOutput = $true
  $pinfo.RedirectStandardError  = $true

  $pinfo.Arguments   = '--add-plugin={0}' -f $packageArgs.fileFullPath
  $process           = New-Object System.Diagnostics.Process
  $process.StartInfo = $pinfo

  $null = $process.Start()
  Write-Verbose($process.StandardOutput.ReadToEnd())
} else {
  Write-Error -Message 'calibre-customize.exe not found on path' -Category ResourceUnavailable
}
