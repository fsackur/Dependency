using namespace Microsoft.PowerShell.Commands
using module Classes/DependencyModule.psm1

function Get-Dependency
{
    <#
        .Synopsis
        Builds a dependency tree for a module.
    #>

    [OutputType([DependencyModule])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$Module
    )

    process
    {
        if ($Module -is [psmoduleinfo])
        {
            $PSModule = $Module
        }
        else
        {
            $Resolved = Get-Module $Module -ListAvailable
            if (-not $Resolved)
            {
                throw [ArgumentException]::new("Could not find module '$Module'", "Module")
            }
            if ($Resolved.Count -gt 1)
            {
                throw [ArgumentException]::new("Found multiple modules matching '$Module'", "Module")
            }

            $PSModule = $Resolved
        }

        [DependencyModule]$Module = $PSModule

        $Module
    }
}
