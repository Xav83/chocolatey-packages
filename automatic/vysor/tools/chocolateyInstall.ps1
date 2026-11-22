$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/koush/vysor.io/releases/download/v6.0.18/Vysor-6.0.18.Setup.exe'
$checksum64  = '683915cae78acdc6d14e2085d3e51868d6bf3bcac869b45818c721e02cb0aef0'

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
