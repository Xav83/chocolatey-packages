$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/super-productivity/super-productivity/releases/download/v20.0.0/Super-Productivity-Setup-x64.exe'
$checksum64  = '246b5e0ab1b2aa495353e2bcbeadb763747ecec90ae007f6273d24a5f0346350'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
