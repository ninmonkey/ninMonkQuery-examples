Import-Module Pipescript
# Import-Module ImportExcel
# Import-Module ExcelAnt
. (Get-Item (Join-Path $PSScriptRoot '__import__.ps1'))

& {
    Push-Location 'C:\Users\cppmo_000\SkyDrive\Documents\2022\Power-BI\My_Github\ninMonkQuery-examples\forumQuestions'
    Hr -fg blue
    Export-Pipescript -Verbose
    Hr -fg orange
    Get-Content *readme.md*
    Pop-Location
}

& {
    Push-Location 'C:\Users\cppmo_000\SkyDrive\Documents\2022\Power-BI\My_Github\ninMonkQuery-examples'
    Hr -fg blue
    Export-Pipescript
    Hr -fg orange
    Get-Content toc.md
    Pop-Location
}


# $exportPipescriptSplat = @{
#     Verbose = $true
#     Path = '.\'
#     Filter = '*readme.md*'
#     OutputPath = '.\'
#     OutputFileName = 'readme.md.pipescript.ps1'
#     OutputFormat = 'ps1'
# }

# Export-Pipescript -Verbose -InputPath './' -filter 'toc.md'
# Export-Pipescript -verbose -Path '.\' # -Filter '*readme.md*' -OutputPath '.\' -OutputFileName 'readme.md.pipescript.ps1' -OutputFormat 'ps1'


