$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/joncampbell123/dosbox-x/releases/download/dosbox-x-v2026.10.01/dosbox-x-winXP-2026.10.01-setup.exe'
$checksum64  = '06e189e5d7058d9d9fc780ce56848dad0d2b42bfceca1e7d92a6d46953731c27'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT /SP- /SUPPRESSMSGBOXES'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
