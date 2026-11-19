$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/BiglySoftware/BiglyBT/releases/download/v4.2.0.0/GitHub_BiglyBT_Windows_NoJRE.exe'
$checksum64  = '7a27ed366e7270d5877739efc558b3dca8e0772739d838da973539e4c576c10e'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '-q'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
