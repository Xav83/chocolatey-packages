$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$url32       = 'https://github.com/PhantomBot/PhantomBot/releases/download/v3.24.3.0/PhantomBot-3.24.3.0-win.zip'
$checksum32  = 'c8d21457460ab3c39db5867ae6533fa0ab7ae3a4bfc2aea1f6c091673fcdae45'

$pp = Get-PackageParameters

$install_dir = if ($pp.InstallDir) { $pp.InstallDir } else { Split-Path $MyInvocation.MyCommand.Definition }

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'ZIP'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = $install_dir
  validExitCodes = @(0)
}
Install-ChocolateyZipPackage @packageArgs
