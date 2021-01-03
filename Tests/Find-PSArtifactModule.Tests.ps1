# Given a module spec, gets all matching version from the psrepository

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}

BeforeAll {
    $ModuleUnderTest = Import-Module $PSScriptRoot/../Dependency.psd1 -Force -PassThru
}


Describe "Find-PSArtifactModule" {

    BeforeAll {
        $MockRepository = "MockGallery"

        $MockSplat = @{
            CommandName     = "Find-Module"
            ParameterFilter = {$Name -eq $Spec.Name; $Repository -eq $MockRepository}
            ModuleName      = $ModuleUnderTest
        }

        Mock @MockSplat {
            $MockFoo = Import-Clixml $PSScriptRoot/PSArtifactModule.TestData.clixml
            return $MockFoo
        }
    }

    BeforeEach {
        $Spec = [ModuleSpecification]"foo"
        $Result = Find-PSArtifactModule $Spec -Repository $MockRepository
    }

    It "Finds foo" {
        $Result | Should -Not -BeNullOrEmpty
    }

    It "Finds only foo" {
        $Result | Where-Object {$_.Name -ne $Spec.Name} | Should -BeNullOrEmpty
    }

    It "Lets you choose the repository" {
        & $ModuleUnderTest {Remove-Variable RepositoryCache -Scope Script -ErrorAction SilentlyContinue}

        Find-PSArtifactModule $Spec -Repository $MockRepository

        Assert-MockCalled @MockSplat
    }

    It "Caches" {
        & $ModuleUnderTest {Remove-Variable RepositoryCache -Scope Script -ErrorAction SilentlyContinue}

        Find-PSArtifactModule $Spec -Repository $MockRepository
        Find-PSArtifactModule $Spec -Repository $MockRepository

        Assert-MockCalled @MockSplat -Times 1 -Exactly
    }
}
