using namespace Microsoft.PowerShell.Commands
using namespace System.Collections
using namespace System.Collections.Generic

class DependencyModule
{
    #region Constructors and type converters
    DependencyModule ([string]$Name)
    {
        $this.InitializeFrom([pscustomobject]$PSBoundParameters)
    }

    DependencyModule ([string]$Name, [version]$Version, [IList[ModuleSpecification]]$RequiredModules)
    {
        $this.InitializeFrom([pscustomobject]$PSBoundParameters)
    }

    # Type converter from hashtable
    DependencyModule ([IDictionary]$Properties)
    {
        $this.InitializeFrom([pscustomobject]$Properties)
    }

    # Type converter from PSModuleInfo
    DependencyModule ([psmoduleinfo]$PSModule)
    {
        $this.InitializeFrom(($PSModule | Select-Object * -ExcludeProperty RequiredModules))

        if ($PSModule.RequiredModules)
        {
            $Psd1 = Get-Content $PSModule.Path -Raw | Invoke-Expression
            $Psd1.RequiredModules | ForEach-Object {
                $this.RequiredModules.Add($_)
            }
        }
    }

    # Type converter from PSCustomObject, including output from Find-Module
    DependencyModule ([psobject]$InputObject)
    {
        $this.InitializeFrom($InputObject)

        if ($InputObject.PSTypeNames -match '\bPSRepositoryItemInfo$')
        {
            $InputObject.Dependencies | ForEach-Object {
                $Spec = @{}
                $Spec.ModuleName = $_.Name
                if ($_.MinimumVersion)  {$Spec.ModuleVersion = $_.MinimumVersion}
                if ($_.RequiredVersion) {$Spec.RequiredVersion = $_.RequiredVersion}
                if ($_.MaximumVersion)  {$Spec.MaximumVersion = $_.MaximumVersion}

                $this.RequiredModules.Add($Spec)
            }
        }
    }

    # Helper
    [void] InitializeFrom([psobject]$InputObject)
    {
        $this.PSObject.Properties |
            Where-Object {$_.Name -ne 'RequiredModules'} |
            ForEach-Object {
                $_.Value = $InputObject.$($_.Name)
            }

        $this.RequiredModules = [List[ModuleSpecification]]::new()
        if ($InputObject.RequiredModules)
        {
            $InputObject.RequiredModules | ForEach-Object {$this.RequiredModules.Add($_)}
        }

        $this.Imports = [List[DependencyModule]]::new()
    }
    #endregion Constructors and type converters

    # Properties
    [ValidateNotNullOrEmpty()][string]$Name
    [version]$Version
    [IList[ModuleSpecification]]$RequiredModules
}
