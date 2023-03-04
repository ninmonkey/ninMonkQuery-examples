
& {
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
    | CountIt
    $query
    | Where-Object extension -Match $Regex.IncludeExtension #
    | Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
    | CountIt
    | Out-Null

    # $Query | CountIt
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
    | Select GroupMonth Kind, Name, RelativeWorkspace, * -ea ignore
    | Export-Excel -ExcelPackage $Pkg -TableName 'files2_table' -worksheet 'files2' -TableStyle Light2 -AutoSize -Title 'file2 listing'
    | Out-null

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

}
'- [ ] (1) - pivot, show counts by month, and kinds per month'
'- [ ] (2) - show breadlines, mini bars of counts per week'
'- [ ] (3) - or graphs of numbers over a timelapse'
