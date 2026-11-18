$ErrorActionPreference = 'Stop'

$packageName = 'tvrename'
$url32       = 'https://github.com/TV-Rename/tvrename/releases/download/v5.2.8/TVRename-v5.2.8-Installer.exe'
$checksum32  = 'a170be52ec27e84310c57bc472b8679c932de529c76f9928221a3ea3945d2e08'

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
