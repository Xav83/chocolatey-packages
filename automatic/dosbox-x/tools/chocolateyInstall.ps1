$ErrorActionPreference = 'Stop'
$url32       = 'https://github.com/joncampbell123/dosbox-x/releases/download/dosbox-x-v0.83.18/dosbox-x-win32-0.83.18-setup.exe'
$url64       = 'https://github.com/joncampbell123/dosbox-x/releases/download/dosbox-x-v0.83.18/dosbox-x-win64-0.83.18-setup.exe'
$checksum32  = 'A20D8B635C96DC8B6C6EA6A8C1F9695E4C2C430BDE9BD8F1645C054EF25A4C56'
$checksum64  = 'DA1AD84F2DA016387547AF883AEF29284AC2C6903E91BFE61D32FA26A632DBAE'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'EXE'
  url            = $url32
  url64bit       = $url64
  checksum       = $checksum32
  checksumType   = 'sha256'
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
