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
            "0.1.2", "1.2.3", "2.3.4", "3.4.5" |
                ForEach-Object {[version]$_} |
                Sort-Object -Descending |
                ForEach-Object {
                    $MockFoo = Import-Clixml $PSScriptRoot/PSArtifactModule.TestData.clixml
                    $MockFoo.Version = $_
                    $MockFoo
                }
        }
    }


    Context "Basics" {
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

    } -Foreach (
        @{Spec = [ModuleSpecification]"foo"}
    )


    Context "Finding by spec" {

        BeforeEach {
            $Result = Find-PSArtifactModule $Spec -Repository $MockRepository
        }

        It "Finds matching modules" {
            $Result.Count | Should -Be $ExpectedCount
        }

        It "Finds only matching modules" {
            $Result | Where-Object {$_.Name -ne $Spec.Name} | Should -BeNullOrEmpty
        }

    } -Foreach (
        @{Spec = [ModuleSpecification]"foo"; ExpectedCount = 4},
        @{Spec = [ModuleSpecification]@{ModuleName = "foo"; ModuleVersion = "1.2.3"}; ExpectedCount = 3},
        @{Spec = [ModuleSpecification]@{ModuleName = "foo"; RequiredVersion = "1.2.3"}; ExpectedCount = 1},
        @{Spec = [ModuleSpecification]@{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "2.5"}; ExpectedCount = 2}
    )
}
