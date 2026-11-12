$ErrorActionPreference = 'Stop'

$packageName = 'tvrename'
$url32       = 'https://github.com/TV-Rename/tvrename/releases/download/v5.2.7/TVRename-v5.2.7-Installer.exe'
$checksum32  = '19145648b548a64fcf871313e81f62aa27c040a281c611df7085ec0521fe7dad'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
