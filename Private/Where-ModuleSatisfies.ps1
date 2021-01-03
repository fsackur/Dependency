using namespace Microsoft.PowerShell.Commands
using module Classes/DependencyModule.psm1

function Where-ModuleSatisfies
{
    <#
        .Synopsis
        Filters modules that meet the requirements made by a ModuleSpecification.
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
        if ($Module | Test-ModuleSatisfies $Spec)
        {
            return $Module
        }
    }
}
