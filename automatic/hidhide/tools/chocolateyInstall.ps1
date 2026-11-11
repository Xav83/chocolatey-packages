$ErrorActionPreference = 'Stop'

$url64       = ''
$checksum64  = ''

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  # The installer is an EXE wrapper around an MSI: /exenoui hides the wrapper's own UI.
  silentArgs     = '/exenoui /qn /norestart'
  validExitCodes = @(0, 3010, 1641)   # 3010 / 1641: success, reboot required (driver install)
}
Install-ChocolateyPackage @packageArgs
