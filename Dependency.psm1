
try
{
    # Having pain with using module statement
    Push-Location $PSScriptRoot
    Get-ChildItem Private\*.ps1 | ForEach-Object {. $_.FullName}
    Get-ChildItem Public\*.ps1  | ForEach-Object {. $_.FullName}
}
finally
{
    Pop-Location
}
