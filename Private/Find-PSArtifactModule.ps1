using namespace Microsoft.PowerShell.Commands
using module Classes/DependencyModule.psm1

function Find-PSArtifactModule
{
    <#
        .Synopsis
        Finds a module from an artifact repo, such as the PSGallery, that satisfies a specification.
    #>

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
        if ($Script:RepositoryCache[$Spec.Name])
        {
            return $Script:RepositoryCache[$Spec.Name]
        }

        $FoundModules = Find-Module $Spec.Name -Repository $Repository -AllVersions

        return $Script:RepositoryCache[$Spec.Name] = $FoundModules
    }
}
