# Given a module specification, I want to know which modules match that spec.

using namespace Microsoft.PowerShell.Commands

#requires -Modules @{ModuleName = 'Pester'; ModuleVersion = '5.1.1'}


BeforeAll {
    Import-Module $PSScriptRoot/../Dependency.psd1 -Force
}


Describe "Test-ModuleSatisfies" {

    $ModuleName = if ($Module.Name) {$Module.Name, $Module.Version -join " "} else {$Module}
    $Name = "{0} {1}" -f $(if ($Expected) {"passes"} else {"fails"}), $ModuleName

    It $Name {
        $Module | Test-ModuleSatisfies $Spec | Should -Be $Expected
    }

} -ForEach @(
    @{
        Module = @{Name = "foo"}
        Spec = "foo"
        Expected = $true
    },
    @{
        Module = @{Name = "bar"}
        Spec = "foo"
        Expected = $false
    },

    @{
        Module = @{Name = "foo"; Version = "0.1.2"}
        Spec = @{ModuleName = "foo"; RequiredVersion = "1.2.3"}
        Expected = $false
    },
    @{
        Module = @{Name = "foo"; Version = "1.2.3"}
        Spec = @{ModuleName = "foo"; RequiredVersion = "1.2.3"}
        Expected = $true
    },
    @{
        Module = @{Name = "foo"; Version = "2.3.4"}
        Spec = @{ModuleName = "foo"; RequiredVersion = "1.2.3"}
        Expected = $false
    },
    @{
        Module = @{Name = "bar"; Version = "1.2.3"}
        Spec = @{ModuleName = "foo"; RequiredVersion = "1.2.3"}
        Expected = $false
    },

    @{
        Module = @{Name = "foo"; Version = "0.1.2"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $false
    },
    @{
        Module = @{Name = "foo"; Version = "1.2.3"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $true
    },
    @{
        Module = @{Name = "foo"; Version = "1.8.8"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $true
    },
    @{
        Module = @{Name = "foo"; Version = "1.9.9"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $true
    },
    @{
        Module = @{Name = "foo"; Version = "2.3.4"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $false
    },
    @{
        Module = @{Name = "bar"; Version = "1.2.3"}
        Spec = @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"}
        Expected = $false
    }
)
