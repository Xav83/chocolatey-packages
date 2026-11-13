$ErrorActionPreference = 'Stop'

$urlWin10         = ''
$checksumWin10    = ''
$urlWin11         = ''
$checksumWin11    = ''
$urlWin11Arm      = ''
$checksumWin11Arm = ''

# Sophia Script has one edition per Windows version: pick the one matching this machine.
$build = [Environment]::OSVersion.Version.Build
$isArm = ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') -or ($env:PROCESSOR_ARCHITEW6432 -eq 'ARM64')

if ($build -ge 22000) {
  if ($isArm) { $edition = 'Windows 11 Arm'; $url = $urlWin11Arm; $checksum = $checksumWin11Arm }
  else        { $edition = 'Windows 11';     $url = $urlWin11;    $checksum = $checksumWin11 }
} elseif ($build -ge 10240) {
  $edition = 'Windows 10'; $url = $urlWin10; $checksum = $checksumWin10
} else {
  throw "Sophia Script for Windows requires Windows 10 or Windows 11 (detected build $build)."
}
Write-Host "Installing Sophia Script for $edition (Windows build $build)."

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64bit       = $url
  checksum64     = $checksum
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs

# Sophia bundles helper tools (e.g. LGPO.exe): don't put them on the PATH.
Get-ChildItem -Path $packageArgs.unzipLocation -Filter '*.exe' -Recurse |
  ForEach-Object { New-Item -Path "$($_.FullName).ignore" -ItemType File -Force | Out-Null }

Write-Host 'Note: the LTSC and PowerShell 7 editions of Sophia Script are not installed by this package;'
Write-Host 'download them from https://github.com/farag2/Sophia-Script-for-Windows/releases if you need them.'
