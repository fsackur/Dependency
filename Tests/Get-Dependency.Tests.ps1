using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

BeforeAll {
    $ModuleUnderTest = Import-Module $PSScriptRoot/../Dependency.psd1 -Force -PassThru
}

Describe "Get-Dependency" {

    Context "API" {

        It "accepts a PSModule" {
            # Should really mock, but probably safe to assume any build machine has PowerShellGet
            $Module = Get-Module PowerShellGet -ListAvailable | Select-Object -First 1

            $Module | Get-Dependency | Should -Not -BeNullOrEmpty
        }

        It "accepts a module name" {
            "PowerShellGet" | Get-Dependency | Should -Not -BeNullOrEmpty
        }

        It "accepts a module path" {
            $PSScriptRoot | Split-Path | Get-Dependency | Should -Not -BeNullOrEmpty
        }

        It "throws on an invalid name" {
            {"lkjhasflkahsf" | Get-Dependency | Should -Throw}
        }

        It "throws on an invalid path" {
            {$PSScriptRoot | Get-Dependency | Should -Throw}
        }

        It "throws on ambiguous input" {
            # Should really mock, but we know we have Pester and we assume PowerShellGet
            {"P*e*" | Get-Dependency | Should -Throw}
        }
    }
}
