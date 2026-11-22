$ErrorActionPreference = 'Stop'

$url32       = 'https://github.com/claudiodangelis/qrcp/releases/download/v0.12.0/qrcp_0.12.0_windows_386.tar.gz'
$url64       = 'https://github.com/claudiodangelis/qrcp/releases/download/v0.12.0/qrcp_0.12.0_windows_amd64.tar.gz'
$checksum32  = '5bd702ecfd4c80e871ebfbebbe588afa323aa7aa01760bb0e540c356b8be77f4'
$checksum64  = 'e1ebb8c4c6aaa654fa549a796f515a6c2c0a773bf4449e62a3825f0f62ae8eb0'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs

# unzip tar
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyUnzip -FileFullPath "$toolsDir\*.tar" -Destination $toolsDir
Remove-Item $toolsDir\*.tar -ErrorAction SilentlyContinue -Force
