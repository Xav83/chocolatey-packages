# Automatic packages

Every folder here is a Chocolatey package kept up to date by [Chocolatey AU](https://github.com/chocolatey-community/chocolatey-au) (`chocolatey-au`).

Each package has:

* `<package>.nuspec`: the package metadata;
* `tools/chocolateyInstall.ps1` (and sometimes `chocolateyUninstall.ps1`): the install script;
* `update.ps1`: the AU script that finds the latest version (`au_GetLatest`) and the values to update in the package files (`au_SearchReplace`).

AppVeyor runs `update_all.ps1` from the repository root on a schedule: it updates and pushes every package with a new version, then commits the result back to `develop`.

To update one package locally, run `.\update.ps1` from its folder (with `$au_Push = $false` to only build the `.nupkg`). To list the AU packages, run `Get-AUPackages` in this folder.
