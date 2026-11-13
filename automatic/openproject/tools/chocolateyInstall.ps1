$ErrorActionPreference = 'Stop'

$url64       = ''
$checksum64  = ''

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  unzipLocation  = $toolsDir
}
Install-ChocolateyZipPackage @packageArgs

Write-Host ''
Write-Host "The OpenProject source code has been extracted to: $toolsDir"
Write-Host 'Note: this package does not install a runnable OpenProject server.'
Write-Host 'OpenProject does not support Windows natively; to run it on Windows, use Docker'
Write-Host '(Docker Desktop with the WSL2 backend), see:'
Write-Host '  https://www.openproject.org/docs/installation-and-operations/installation/docker/'
