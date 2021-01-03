
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
        @{
            Module = $_[0]
            Spec = $_[1]
            Expected = $_[2]
        }
    }
