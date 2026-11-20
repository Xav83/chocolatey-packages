$ErrorActionPreference = 'Stop'

$packageName = 'tvrename'
$url32       = 'https://github.com/TV-Rename/tvrename/releases/download/v5.2.9/TVRename-v5.2.9-Installer.exe'
$checksum32  = 'b06341c5425055a1cb74b5b4348908e1c1c11d77d241431ee96d1efefbb1d2d1'

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
