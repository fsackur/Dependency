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

    process
    {
        $SpecSplat = @{
            Name            = $Spec.Name
            MinimumVersion  = $Spec.Version
            RequiredVersion = $Spec.RequiredVersion
            MaximumVersion  = $Spec.MaximumVersion
        }

        PowerShellGet\Find-Module @SpecSplat -Repository $Repository
    }
}
