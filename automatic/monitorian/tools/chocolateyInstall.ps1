$ErrorActionPreference = 'Stop'

$url64       = ''
$checksum64  = ''

# The release asset is a ZIP that contains the MSI installer:
# extract it to a temporary folder, then run the MSI silently.
$unzipLocation = Join-Path $env:TEMP "$env:ChocolateyPackageName\$env:ChocolateyPackageVersion"

$zipArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64Bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  unzipLocation  = $unzipLocation
}
Install-ChocolateyZipPackage @zipArgs

$msi = Get-ChildItem -Path $unzipLocation -Filter '*.msi' -Recurse | Select-Object -First 1
if (!$msi) { throw "No MSI installer found in the extracted archive ($unzipLocation)." }

$logFile = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.MsiInstall.log"

$installArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'MSI'
  file           = $msi.FullName
  silentArgs     = "/qn /norestart /l*v `"$logFile`""
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @installArgs

Remove-Item -Path $unzipLocation -Recurse -Force -ErrorAction SilentlyContinue
