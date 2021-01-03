using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

Describe "DependencyModule class" {

    BeforeAll {
        Get-Content $PSScriptRoot/../Classes/DependencyModule.psm1 -Raw | Invoke-Expression
    }

    Context "Basic type conversion" {

        It "Converts a string" {
            $Result = [DependencyModule]"foo"
            $Result.Name | Should -Be "foo"
            $Result.Version | Should -BeNullOrEmpty
            $Result.RequiredModules | Should -BeNullOrEmpty
        }
    }

    Context "Type conversion" {

        It "Converts a <Name>" {
            $Result = [DependencyModule]$Module

            $Result.Name | Should -Be $Module.Name
            $Result.Version | Should -Be $Module.Version
            $Result.RequiredModules | Should -Not -BeNullOrEmpty
        }

    } -Foreach (
        @{Name = "hashtable";        Module = @{Name = "foo"; Version = "1.2.3"; RequiredModules = @(@{ModuleName = "bar"; ModuleVersion = "1.2.3"})}},
        # Should really mock, but probably safe to assume any build machine has PowerShellGet
        @{Name = "PSModule";         Module = Get-Module PowerShellGet -ListAvailable | Select-Object -First 1},
        @{Name = "PSRepositoryItem"; Module = Import-Clixml $PSScriptRoot/PSArtifactModule.TestData.clixml}
    )

    Context "Tree structure" {

        $foo = [DependencyModule]@{
            Name = "foo"
            Version = "1.2.3"
            RequiredModules = @{ModuleName = "bar"; ModuleVersion = "1.2.3"}
        }
        $bar = [DependencyModule]@{
            Name = "bar"
            Version = "1.2.3"
            RequiredModules = @{ModuleName = "baz"; ModuleVersion = "1.2.3"}
        }
        $baz = [DependencyModule]@{
            Name = "baz"
            Version = "1.2.3"
            RequiredModules = $null
        }
        $foo.Imports.Add($bar)
        $bar.ImportedBy = $foo
        $bar.Imports.Add($baz)
        $baz.ImportedBy = $bar

        $baz.GetDepth() | Should -Be 2
    }
}
