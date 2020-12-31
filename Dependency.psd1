@{
    Description          = 'Get a tree view of PS Module dependencies. Searches artifact repos and github.'
    ModuleVersion        = '0.0.1'
    HelpInfoURI          = 'https://pages.github.com/fsackur/Dependency'

    GUID                 = 'b9f05d3d-3bd0-4e6c-93e1-d47a48e44926'

    RequiredModules      = @()

    Author               = 'Freddie Sackur'
    CompanyName          = 'DustyFox'
    Copyright            = '(c) 2020 Freddie Sackur. All rights reserved.'

    RootModule           = 'Dependency.psm1'

    FunctionsToExport    = @(
        '*'
    )

    PrivateData          = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/Dependency/main/LICENSE'
            ProjectUri = 'https://github.com/fsackur/Dependency'
            Tags       = @(
                'Dependency'
            )
        }
    }
}
