$ErrorActionPreference = 'Stop'

$url64       = 'https://download.kde.org/stable/crow-translate/4.1.0/crow-translate-4.1.0-windows-cl-msvc2022-x86_64.exe'
$checksum64  = '554b47f444f8ce23d51c7a46c63d2e80ef3851547290d4ae4dc19efcd9deef88'

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
