$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/koush/vysor.io/releases/download/v6.0.22/Vysor-6.0.22.Setup.exe'
$checksum64  = 'bc502362a93b564ce428488c2a3002e078aabb7a050b73c86a9b7dacd8ba73e6'

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
