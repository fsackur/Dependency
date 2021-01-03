# Given a module specification, I want to know which modules match that spec.

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

$TestCases = . ($PSCommandPath -replace 'Tests.ps1', 'TestCases.ps1')

BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "Test-ModuleSatisfies" {

    It $Name {
        $Module | Test-ModuleSatisfies $Spec | Should -Be $Expected
    }

} -ForEach $TestCases


Describe "Where-ModuleSatisfies" {

    It $Name {
        $IfExpectedToPass = $Expected
        $Module | Where-ModuleSatisfies $Spec | Should -Not:$IfExpectedToPass -BeNull
    }

} -ForEach $TestCases
