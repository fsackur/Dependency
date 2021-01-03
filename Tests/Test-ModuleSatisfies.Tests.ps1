# Given a module specification, I want to know which modules match that spec.

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

$TestCases = . ($PSCommandPath -replace 'Tests.ps1', 'TestCases.ps1')

BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "Test-ModuleSatisfies" {

    $ModuleName = if ($Module.Name) {$Module.Name, $Module.Version -join " "} else {$Module}
    $Name = "{0} {1}" -f $(if ($Expected) {"passes"} else {"fails"}), $ModuleName

    It $Name {
        $Module | Test-ModuleSatisfies $Spec | Should -Be $Expected
    }

} -ForEach $TestCases
