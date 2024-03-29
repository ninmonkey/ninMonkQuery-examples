. ( Get-Item -ea 'stop' (Join-Path $PSScriptRoot '__import__.ps1'))
<#
example of additional formatting


- [Multiple Nested Conditions with `Switch()`](#multiple-nested-conditions-with-switch) <span style='font-size:0.55em;'>2023-01-24</span>
- [Finding Distinct Pairs](#finding-distinct-pairs) <span style='font-size:0.55em;'>2023-01-02</span>

## Multiple Nested Conditions with `Switch()`

- [view Report.pbix](./discord%20%E2%96%B8%20Switch%20with%20Multiple%20Columns.2023-01.pbix)
- [view Queries.dax](./dax/discord%20%E2%96%B8%20Switch%20with%20Multiple%20Columns.2023-01.dax)

![screenshot of report](./img/discord%20%E2%96%B8%20Switch%20with%20Multiple%20Columns.2023-01.pbix.png)

## Finding Distinct Pairs 23

- [view Report.pbix](./multiple%20methods%20of%20getting%20Distinct%20Codes%20per%20year%20%E2%94%902022-12.pbix)
- [view Report.pq](./pq/multiple_distinct_examples.md)

![screenshot of report](./img/multiple%20methods%20of%20getting%20Distinct%20Codes%20per%20year%20%E2%94%902022-12.png)
#>

# & {
$Regex ??= @{}
$Regex.CwdPrefix = [regex]::Escape(( Get-Item . | ForEach-Object FullName )) + '\\'

$Regex.IncludeExtension = '\.(pbix|pq|xlsx|png|md|dax)'
$Regex.ExcludeExtension = '\.ps\.(md|pbix|pq|dax)'
$Fstr = @{
    YearMonthDay = 'yyyy-MM-dd'
    YearMonth    = 'yyyy-MM'
}


(Get-Date).ToString($fStr.YearMonthDay)
$query = Get-ChildItem . -Recurse -File
| ForEach-Object {
    [pscustomobject]@{
        GroupMonth        = $_.LastWriteTime.ToString($fStr.YearMonth)
        Kind              = fileCategory $_.Name
        Name              = $_.Name
        RelativeWorkspace = $_.FullName -replace $Regex.CwdPrefix, ''
        BaseName          = $_.BaseName
        FullName          = $_.FullName
        Extension         = $_.Extension
        GroupDate         = $_.LastWriteTime.ToString($fStr.YearMonthDay)
        GroupParentPath   = $_.Directory
        LastModifiedDt    = $_.LastWriteTime -as 'datetime'
    }
}
| Sort-Object LastModifiedDt -Descending
| CountOf

$null = 0
$query
| Where-Object extension -Match $Regex.IncludeExtension #
| Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
| CountOf | Out-Null

# $Query | CountOf
# | to-xl

Close-ExcelPackage $Pkg -ea ignore
$PathXL = 'g:\temp\xl\monquery.xlsx'
Remove-Item $PathXl -ea ignore
$Pkg = Open-ExcelPackage -Path $PathXl -Create
$Query
| Export-Excel -ExcelPackage $Pkg -TableName 'files_table' -worksheet 'files' -TableStyle Light2 -AutoSize -Title 'file listing'
| Out-Null

$query
| Sort-Object GroupMonth -Descending
| Select-Object -prop GroupMonth, Kind, Name, RelativeWorkspace, * -ea ignore
| Export-Excel -ExcelPackage $Pkg -TableName 'files2_table' -worksheet 'files2' -TableStyle Light2 -AutoSize -Title 'file2 listing'
| Out-Null

# $chart_splat = @{
#     ChartType = 'ColumnClustered'
#     Title = 'files by month'
#     XRange = 'files_table[GroupMonth]'
#     YRange = 'files_table[Count]'
#     Name = 'files_by_month'
#     Worksheet = 'files'
#     Position = 1, 1
# }

New-ExcelChartDefinition @chart_splat -XRange 'Kind' -YRange 'FullName' -Title 'count kind'
| Export-Excel -ExcelPackage $Pkg -Worksheet 'files2' -Name 'files_by_kind'
# -pack
# New-ExcelChartDefinition @chart_splat -XRange 'Kind' -yrange 'FullName' -Title 'count kind' # -pack
# | Add-ExcelChart -ExcelPackage $Pkg
# New-ExcelChartDefinition# -Name 'files_by_month' -ChartType ColumnClustered -Title 'files by month' -XRange 'files_table[GroupMonth]' -YRange 'files_table[Count]' -Worksheet 'files' -Position 1, 1 | Add-ExcelChart -ExcelPackage $Pkg

Close-ExcelPackage $Pkg -Show

$query | Sort-Object GroupMonth | Format-Table

$query
| Sort-Object GroupMonth -Descending
| Format-Table -group GroupMonth Kind, Name, RelativeWorkspace -AutoSize

# }
'- [ ] (1) - pivot, show counts by month, and kinds per month'
'- [ ] (2) - show breadlines, mini bars of counts per week'
'- [ ] (3) - or graphs of numbers over a timelapse'
