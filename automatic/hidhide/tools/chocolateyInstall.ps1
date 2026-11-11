$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/nefarius/HidHide/releases/download/v1.5.230.0/HidHide_1.5.230_x64.exe'
$checksum64  = 'f4bbbcb82e6258641b887c74bc81c4c5f66e4aa811808dfc304347687b7605f6'

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
