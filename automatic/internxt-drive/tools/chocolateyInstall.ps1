$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/internxt/drive-desktop/releases/download/v2.7.3/Internxt-Setup-2.7.3.exe'
$checksum64  = 'e167245c0e42c130e453879a4beb73600d8b5a3ca8697321ce78fe31f91861e9'

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
