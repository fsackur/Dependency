using namespace Microsoft.PowerShell.Commands


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
        [string]$Module,

        [Parameter(Mandatory, Position=1)]
        [ModuleSpecification]$Spec
    )

    process
    {
        return $Module -eq $Spec.Name
    }
}
