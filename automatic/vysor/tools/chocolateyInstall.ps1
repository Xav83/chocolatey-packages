$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/koush/vysor.io/releases/download/v6.0.5/Vysor-6.0.5.Setup.exe'
$checksum64  = 'e8a4867b599566524c7658818edf4cf71e99dda90a6e2bfce99b51797fed6509'

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
