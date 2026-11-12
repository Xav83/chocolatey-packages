$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/Suwayomi/Suwayomi-JUI/releases/download/v1.3.3/Suwayomi-JUI-windows-x64-1.3.3.msi'
$checksum64  = 'de82ba03280c3c1132ad07690ff04db620c8a8a18e53b75e80fe26aeba4b261c'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'MSI'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/q'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
