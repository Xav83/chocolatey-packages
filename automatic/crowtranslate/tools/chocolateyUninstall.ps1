$ErrorActionPreference = 'Stop'

# Remove the 'crow' command created at install.
Uninstall-BinFile -Name 'crow'

# Run the NSIS uninstaller silently. Chocolatey's automatic uninstaller cannot tell that this
# uninstaller is silent and asks for confirmation, which blocks unattended uninstalls.
[array] $keys = Get-UninstallRegistryKey -SoftwareName 'Crow Translate*'

if ($keys.Count -eq 1) {
  Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName `
    -FileType 'EXE' `
    -SilentArgs '/S' `
    -File ($keys[0].UninstallString -replace '"', '') `
    -ValidExitCodes @(0)
} elseif ($keys.Count -eq 0) {
  Write-Warning 'Crow Translate is not installed (no uninstall entry found): nothing to uninstall.'
} else {
  Write-Warning "$($keys.Count) Crow Translate installations found; uninstall them manually:"
  $keys | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
