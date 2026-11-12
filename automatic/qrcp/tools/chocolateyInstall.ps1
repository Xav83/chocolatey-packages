$ErrorActionPreference = 'Stop'

$url32       = 'https://github.com/claudiodangelis/qrcp/releases/download/v0.11.7/qrcp_0.11.7_windows_386.tar.gz'
$url64       = 'https://github.com/claudiodangelis/qrcp/releases/download/v0.11.7/qrcp_0.11.7_windows_amd64.tar.gz'
$checksum32  = '0caf376057357220c10cda6d4840dbab39a1bf983dd520a4375eee621165e9ed'
$checksum64  = '072082e1bace619f3fedba2b3189d3f6420d32a2dbb87d5831c9b883b95f47f7'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs

# unzip tar
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyUnzip -FileFullPath "$toolsDir\*.tar" -Destination $toolsDir
Remove-Item $toolsDir\*.tar -ErrorAction SilentlyContinue -Force
