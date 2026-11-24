$ErrorActionPreference = 'Stop'

$packageName = 'tvrename'
$url32       = 'https://github.com/TV-Rename/tvrename/releases/download/v5.3.0/TVRename-v5.3.0-Installer.exe'
$checksum32  = '93f587e7e67969064bce81853911951ab061d279aefd38a32a3c88c091272a0c'

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
