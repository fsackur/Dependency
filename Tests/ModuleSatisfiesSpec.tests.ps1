# Given a module specification, I want to know which modules match that spec.

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}


BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "We know when modules satisfy specifications" {

    Context "Name-only spec" {

        $Spec = [ModuleSpecification]"foo"

        It "Passes foo" {
            "foo" | Test-ModuleSatisfies $Spec | Should -Be $true
        }

        It "Fails bar" {
            "bar" | Test-ModuleSatisfies $Spec | Should -Be $false
        }
    }
}
