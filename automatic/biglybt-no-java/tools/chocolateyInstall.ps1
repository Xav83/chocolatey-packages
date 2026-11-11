$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/BiglySoftware/BiglyBT/releases/download/v4.1.0.0/GitHub_BiglyBT_Windows_NoJRE.exe'
$checksum64  = 'ab7e58c8cf3a94ed03e7a4c186b17ffbf6552db4909a7579796f4e3c4c23bfc9'

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
