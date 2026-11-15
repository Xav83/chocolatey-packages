# PSScriptAnalyzer settings for this repository (used by .github/workflows/lint.yml).
# Run locally with:  Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
@{
    Severity     = @('Error', 'Warning')

    ExcludeRules = @(
        # AU requires global functions (au_GetLatest, au_SearchReplace...) and global variables
        # ($au_Force, $au_Root...), and the shared helper is dot-sourced as global functions.
        'PSAvoidGlobalFunctions'
        'PSAvoidGlobalVars'

        # Write-Host is used on purpose: it is the only output AU shows from au_GetLatest.
        'PSAvoidUsingWriteHost'

        # Update scripts set script-level variables ($repository, $editions...) that are read
        # inside the au_* functions, which this rule cannot follow.
        'PSUseDeclaredVarsMoreThanAssignments'

        # Set-ReleaseChecksum only fills a hashtable; -WhatIf/-Confirm make no sense for it.
        'PSUseShouldProcessForStateChangingFunctions'
    )
}
