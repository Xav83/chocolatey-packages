$ErrorActionPreference = 'Stop'

$packageName = 'cairoshell'
$url32       = 'https://github.com/cairoshell/cairoshell/releases/download/v0.4.174/CairoSetup_32bit.exe'
$url64       = 'https://github.com/cairoshell/cairoshell/releases/download/v0.4.174/CairoSetup_64bit.exe'
$checksum32  = '4c827ca05f4445ce292c5439efc77ecd3a5e612fd3278298f2ed4369ff513aa4'
$checksum64  = '7762030e2526f5d61af7b0e416e76630dc37baa4c88422592851a27219f86ac7'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/SD'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
