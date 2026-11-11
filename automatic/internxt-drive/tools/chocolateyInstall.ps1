$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/internxt/drive-desktop/releases/download/v2.7.2/Internxt-Setup-2.7.2.exe'
$checksum64  = '881d577ea07b637a2e43c8f4c5956ba9553cc6099ad584b4c10eae2b3262666e'

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
