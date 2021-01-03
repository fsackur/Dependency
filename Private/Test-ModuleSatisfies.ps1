using namespace Microsoft.PowerShell.Commands
using module Classes/DependencyModule.psm1

function Test-ModuleSatisfies
{
    <#
        .Synopsis
        Tests whether a module meets the requirements made by a ModuleSpecification.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [DependencyModule]$Module,

        [Parameter(Mandatory, Position=1)]
        [ModuleSpecification]$Spec
    )

    process
    {
        if ($Module.Name -ne $Spec.Name)
        {
            return $false
        }

        if ($Spec.RequiredVersion -and $Module.Version -ne $Spec.RequiredVersion)
        {
            return $false
        }

        if ($Spec.Version -and $Module.Version -lt $Spec.Version)
        {
            return $false
        }

        if ($Spec.MaximumVersion -and $Module.Version -gt $Spec.MaximumVersion)
        {
            return $false
        }

        return $true
    }
}
