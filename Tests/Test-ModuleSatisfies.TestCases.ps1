
# Module                                 Spec                                                                        Expected
# ------                                 ----                                                                        --------
(@{Name = "foo"},                        "foo",                                                                      $true),
(@{Name = "bar"},                        "foo",                                                                      $false),
(@{Name = "foo"; Version = "0.1.2"},     @{ModuleName = "foo"; RequiredVersion = "1.2.3"},                           $false),
(@{Name = "foo"; Version = "1.2.3"},     @{ModuleName = "foo"; RequiredVersion = "1.2.3"},                           $true),
(@{Name = "foo"; Version = "2.3.4"},     @{ModuleName = "foo"; RequiredVersion = "1.2.3"},                           $false),
(@{Name = "bar"; Version = "1.2.3"},     @{ModuleName = "foo"; RequiredVersion = "1.2.3"},                           $false),
(@{Name = "foo"; Version = "0.1.2"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $false),
(@{Name = "foo"; Version = "1.2.3"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $true),
(@{Name = "foo"; Version = "1.8.8"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $true),
(@{Name = "foo"; Version = "1.9.9"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $true),
(@{Name = "foo"; Version = "2.3.4"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $false),
(@{Name = "bar"; Version = "1.2.3"},     @{ModuleName = "foo"; ModuleVersion = "1.2.3"; MaximumVersion = "1.9.9"},   $false) |

    ForEach-Object {

        $Module, $Spec, $Expected = $_

        $ModuleName = if ($Module.Name) {$Module.Name, $Module.Version -join " "} else {$Module}
        $ModuleName = $ModuleName.Trim()
        $Name = "{0} {1}" -f $(if ($Expected) {"passes"} else {"fails"}), $ModuleName

        @{
            Name     = $Name
            Module   = $Module
            Spec     = $Spec
            Expected = $Expected
        }
    }
