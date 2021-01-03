using namespace Microsoft.PowerShell.Commands
using module Classes/DependencyModule.psm1

function Find-PSArtifactModule
{
    <#
        .Synopsis
        Finds a module from an artifact repo, such as the PSGallery, that satisfies a specification.
    #>

    [OutputType([DependencyModule])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string[]]$Repository = "PSGallery",

        [Parameter(Mandatory, Position=0)]
        [ModuleSpecification]$Spec
    )

    begin
    {
        if (-not $Script:RepositoryCache)
        {
            $Script:RepositoryCache = @{}
        }
    }

    process
    {
        if (-not $Script:RepositoryCache.ContainsKey($Spec.Name))
        {
            [DependencyModule[]]$FoundModules = Find-Module $Spec.Name -Repository $Repository -AllVersions
            $Script:RepositoryCache[$Spec.Name] = $FoundModules
        }

        $Script:RepositoryCache[$Spec.Name] | Where-ModuleSatisfies $Spec
    }
}
