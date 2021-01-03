using namespace Microsoft.PowerShell.Commands
using namespace System.Collections
using namespace System.Collections.Generic

class DependencyModule
{
    DependencyModule ([string]$Name)
    {
        $this.Name = $Name
    }

    DependencyModule ([string]$Name, [version]$Version, [IList[ModuleSpecification]]$RequiredModules)
    {
        $this.Name = $Name
        $this.Version = $Version
        $this.RequiredModules = [List[ModuleSpecification]]::new($RequiredModules)
    }

    DependencyModule ([IDictionary]$Properties)
    {
        # Type converter from hashtables
        $this.PSObject.Properties | ForEach-Object {
            $_.Value = $Properties[$_.Name]
        }
    }

    DependencyModule ([psobject]$InputObject)
    {
        # Type converter from psobject
        $this.PSObject.Properties | ForEach-Object {
            $_.Value = $InputObject.$($_.Name)
        }

        if ($InputObject.PSTypeNames -contains 'Microsoft.PowerShell.Commands.PSRepositoryItemInfo')
        {
            $this.RequiredModules = [List[ModuleSpecification]]::new($InputObject.Dependencies.Count)
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

    [ValidateNotNullOrEmpty()][string]$Name
    [version]$Version
    [IList[ModuleSpecification]]$RequiredModules
}
