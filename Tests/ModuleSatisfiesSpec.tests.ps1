# Given a module specification, I want to know which modules match that spec.

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}


BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "We know when modules satisfy specifications" {

    Context "Name-only spec" {

        BeforeAll {
            $Spec = [ModuleSpecification]"foo"
        }

        It "Passes foo" {
            "foo" | Test-ModuleSatisfies $Spec | Should -Be $true
        }

        It "Fails bar" {
            "bar" | Test-ModuleSatisfies $Spec | Should -Be $false
        }
    }

    Context "RequiredVersion spec" {

        BeforeAll {
            $Spec = [ModuleSpecification]@{ModuleName = "foo"; RequiredVersion = "1.2.3"}
        }

        It "Passes foo 1.2.3" {
            @{Name = "foo"; Version = "1.2.3"} | Test-ModuleSatisfies $Spec | Should -Be $true
        }

        It "Fails foo 2.3.4" {
            @{Name = "foo"; Version = "2.3.4"} | Test-ModuleSatisfies $Spec | Should -Be $false
        }

        It "Fails bar 1.2.3" {
            @{Name = "bar"; Version = "1.2.3"} | Test-ModuleSatisfies $Spec | Should -Be $false
        }
    }
}
