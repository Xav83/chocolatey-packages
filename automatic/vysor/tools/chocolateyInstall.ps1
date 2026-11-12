$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/koush/vysor.io/releases/download/v6.0.2/Vysor-6.0.2.Setup.exe'
$checksum64  = '9408b0669cc869750b7bc55475fba79c20cd4b8a7691f34593550952ffeef234'

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
