function md.Path.escapeSpace {
    <#
    .DESCRIPTION
        escapes spaces in filepaths, making relative urls clickable
    .EXAMPLE
       PS>  'c:\foo bar\fast cat.png'
       c:\foo%20bar\fast%20cat.png
    #>
    process {
        $_ -replace ' ', '%20'
    }
}

function repo.WriteFileSummary-v1 {
    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match '\.(pbix|pq|xlsx|png|md|dax)'#
    | Where-Object Extension -NotMatch '\.ps\.(md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object BaseName | ForEach-Object name
    | ForEach-Object {
        '[{0}]({1})' -f @(
            $_
            $_ | md.Path.escapeSpace
        )
    }
}
function repo.WriteFileSummary {
    <#
    .SYNOPSIS
        generates markdown urls to files, using relative filepaths, and escaping spaces for github preview
    #>
    param(
        [string]$RootPath,

        # optionally overwrite the regex selector
        [string]$IncludeExtensionRegex
    )
    $origPath = Get-Location
    Push-Location $RootPath

    repo.WriteNavigation


    $Regex = @{
        CwdPrefix        = [regex]::Escape(( Get-Item . | ForEach-Object FullName )) + '\\'
        IncludeExtension = '\.(pbix|pq|xlsx|png|md|dax)'
        ExcludeExtension = '\.ps\.(md|pbix|pq|dax)'
    }
    if($IncludeExtensionRegex) {
        $Regex.IncludeExtension = '\.({0})$' -f @( $IncludeExtensionRegex )
    }

    # Get-ChildItem . -Recurse -File
    # | Where-Object extension -Match $Regex.IncludeExtension #
    # | Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
    # | Sort-Object BaseName
    # | ForEach-Object {
    #     '[{0}]({1})' -f @(
    #         $_.BaseName
    #         $_.FullName -replace $prefix, '' | md.Path.escapeSpace
    #     )
    # } | join.UL


    & {
        Get-ChildItem . -Recurse -File
        | Where-Object extension -Match $Regex.IncludeExtension #
        | Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
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
                SizeKb            = '{0:n} kb' -f @( $_.Length / 1kb )

            }
        }
        | Sort-Object RelativeWorkspace
        | Sort LastModifiedDt -Descending
        | ForEach-Object {
            '<small>{4}</small> <b>{0}</b> [{1}]({2}) {3}' -f @(
                $_.BaseName
                $_.RelativeWorkspace
                $_.RelativeWorkspace | md.Path.escapeSpace
                $_.SizeKb
                $_.GroupMonth
                # $_.FullName -replace $prefix, '' | md.Path.escapeSpace
            )
        } | join.UL
        # | CountIt

    }






    Pop-Location
    Set-Location $origPath
}
function repo.WriteFileSummary-v2 {
    <#
    .SYNOPSIS
        generates markdown urls to files, using relative filepaths, and escaping spaces for github preview
    #>
    param(
        [string]$RootPath
    )
    $origPath = Get-Location
    Push-Location $RootPath

    repo.WriteNavigation


    $prefix = [regex]::Escape(( Get-Item . | ForEach-Object FullName )) + '\\'
    $Regex = @{

        IncludeExtension = '\.(pbix|pq|xlsx|png|md|dax)'
        ExcludeExtension = '\.ps\.(md|pbix|pq|dax)'
    }

    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match $Regex.IncludeExtension #
    | Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
    | Sort-Object BaseName
    | ForEach-Object {
        '[{0}]({1})' -f @(
            $_.BaseName
            $_.FullName -replace $prefix, '' | md.Path.escapeSpace
        )
    } | join.UL

    Pop-Location
    Set-Location $origPath
}


function md.Write.Url {
    param(
        # rquired label, and url
        [Parameter(Mandatory, Position = 0)]
        [string]$Text,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $Url
    )
    process {
        $EscapedLabel = $Text -replace '\(', '\(' -replace '\)', '\)' -replace '\[', '\[' -replace '\]', '\]'

        @(
            '[{0}]' -f @( $EscapedLabel )
            '({0})' -f @(
                $Url | md.Path.EscapeSpace
            )
        )

    }
}

function repo.WriteNavigation {
    @'
[Root](https://github.com/ninmonkey/ninMonkQuery-examples) | [Up ⭡](./../readme.md)
'@
}





<#


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