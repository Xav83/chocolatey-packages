$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'MSI'
  url64bit       = ''

  checksum64     = ''
  checksumType64 = ''

  silentArgs     = "/qn"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
