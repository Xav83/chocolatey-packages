$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/comictagger/comictagger/releases/download/1.6.0-beta.10/ComicTagger-1.6.0b10-Windows-AMD64.zip'
$checksum64  = '706f1cf99bd9e205562e448ae6da40253f934b4eb16c0e5025930f1935a01a1b'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
  validExitCodes = @(0)
}
Install-ChocolateyZipPackage @packageArgs
