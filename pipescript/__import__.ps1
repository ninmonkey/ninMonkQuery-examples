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

function repo.WriteFileSummary {
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