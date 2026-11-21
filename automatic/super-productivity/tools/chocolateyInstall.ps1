$ErrorActionPreference = 'Stop'

$url64       = 'https://github.com/super-productivity/super-productivity/releases/download/v20.1.0/Super-Productivity-Setup-x64.exe'
$checksum64  = '0996fb9696c5180c6e48be422ebdd19431de5e8778a2a0e0888ec922eeec5bbd'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
