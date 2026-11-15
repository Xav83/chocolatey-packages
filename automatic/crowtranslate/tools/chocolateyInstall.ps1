$ErrorActionPreference = 'Stop'

$url64       = ''
$checksum64  = ''

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

# Command-line shim 'crow'. The executable is 'crow.exe' up to 2.x and 'crow-translate.exe'
# (in a bin\ subfolder) since the move to KDE in 4.x.
$installDir = Join-Path $env:ProgramFiles 'Crow Translate'
$exe = Get-ChildItem -Path $installDir -Recurse -Include 'crow-translate.exe', 'crow.exe' -ErrorAction SilentlyContinue |
  Select-Object -First 1
if ($exe) {
  Install-BinFile -Name 'crow' -Path $exe.FullName
} else {
  Write-Warning "Crow Translate executable not found in '$installDir': the 'crow' command was not created."
}
