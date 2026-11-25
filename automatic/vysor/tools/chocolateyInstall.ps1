$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/koush/vysor.io/releases/download/v6.0.23/Vysor-6.0.23.Setup.exe'
$checksum64  = '1565aebf7c4e5fd9905aedd28f42b0824fe23a3f531f0c591479757de6acaa94'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = ''
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
