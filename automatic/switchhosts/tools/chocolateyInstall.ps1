$ErrorActionPreference = 'Stop'

$url32       = 'https://github.com/oldj/SwitchHosts/releases/download/v5.0.3/SwitchHosts-5.0.3-windows-x86-setup.exe'
$checksum32  = 'a734a578437d8bded5892835edece83644b2b3e89a3775eedfc38debf385437d'
$url64       = 'https://github.com/oldj/SwitchHosts/releases/download/v5.0.3/SwitchHosts-5.0.3-windows-x64-setup.exe'
$checksum64  = '0f0af3e5f4bae316eede8ff1299f15e7cca8da81be33e3aac7153a278d434ed1'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
