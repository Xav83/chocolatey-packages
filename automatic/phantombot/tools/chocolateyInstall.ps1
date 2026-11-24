$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$url32       = 'https://github.com/PhantomBot/PhantomBot/releases/download/v3.24.4.0/PhantomBot-3.24.4.0-win.zip'
$checksum32  = '51180c1cc2f00c0b9ea58f71106b12dca3660ff3235411f014d872f76d5b2c62'

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
