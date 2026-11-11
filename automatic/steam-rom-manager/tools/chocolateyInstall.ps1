$ErrorActionPreference = 'Stop'

$url32       = 'https://github.com/SteamGridDB/steam-rom-manager/releases/download/v2.6.3/Steam-ROM-Manager-Setup-2.6.3.exe'
$checksum32  = '5a99520d436e1f9f358e9c6330249915907d22fd408250219ede7763a67d55e1'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'EXE'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
