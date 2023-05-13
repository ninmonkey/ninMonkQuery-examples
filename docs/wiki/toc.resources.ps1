$App = @{ AppRoot = Get-Item $PSScriptRoot }
$App += @{
    Export = Join-Path $App.AppRoot
}
