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

    [ValidateNotNullOrEmpty()][string]$Name
    [version]$Version
    [IList[ModuleSpecification]]$RequiredModules
}
