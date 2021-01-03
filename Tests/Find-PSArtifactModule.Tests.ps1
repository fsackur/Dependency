# Given a module spec, gets all matching version from the psrepository

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "Find-PSArtifactModule" {

    BeforeAll {
        Mock Find-Module -ParameterFilter {$Name -eq $Spec.Name} -ModuleName Dependency {
            $MockFoo = Import-Clixml $PSScriptRoot/PSArtifactModule.TestData.clixml
            return $MockFoo
        }
    }

    BeforeEach {
        $Spec = [ModuleSpecification]"foo"
        $Result = Find-PSArtifactModule $Spec
    }

    It "Finds foo" {
        $Result | Should -Not -BeNullOrEmpty
    }

    It "Finds only foo" {
        $Result | Where-Object {$_.Name -ne $Spec.Name} | Should -BeNullOrEmpty
    }
}
