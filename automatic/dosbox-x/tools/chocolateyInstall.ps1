$ErrorActionPreference = 'Stop'

$url32       = 'https://github.com/joncampbell123/dosbox-x/releases/download/dosbox-x-v0.83.21/dosbox-x-win32-0.83.21-setup.exe'
$url64       = 'https://github.com/joncampbell123/dosbox-x/releases/download/dosbox-x-v0.83.21/dosbox-x-win64-0.83.21-setup.exe'
$checksum32  = '840c13ef110567ea93a008a914c628b86632cbe30584b43b9b62aaab2b22a65e'
$checksum64  = '34d57443902d0863e48bdd4637236e5851787c36dd1a8edfd0b18b7e080fce6c'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'EXE'
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
