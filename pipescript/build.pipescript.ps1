Import-Module Pipescript
# Import-Module ImportExcel
# Import-Module ExcelAnt

. (Gi (Join-Path $PSScriptRoot '__import__.ps1'))

pushd 'C:\Users\cppmo_000\SkyDrive\Documents\2022\Power-BI\My_Github\ninMonkQuery-examples\forumQuestions'

hr -fg blue

# $exportPipescriptSplat = @{
#     Verbose = $true
#     Path = '.\'
#     Filter = '*readme.md*'
#     OutputPath = '.\'
#     OutputFileName = 'readme.md.pipescript.ps1'
#     OutputFormat = 'ps1'
# }

Export-Pipescript -verbose
# Export-Pipescript -verbose -Path '.\' # -Filter '*readme.md*' -OutputPath '.\' -OutputFileName 'readme.md.pipescript.ps1' -OutputFormat 'ps1'

hr -fg orange

gc *readme.md*

popd
