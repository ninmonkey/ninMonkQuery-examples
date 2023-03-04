# Questions from the internet

Last updated: ```.<{ Get-date | % tostring u }>.``` 


## Questions from the Internet

~~~PipeScript{

    function md.Path.escapeSpace { process { $_ -replace ' ', '%20' } }

    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match '\.(pbix|pq|xlsx|png|md|dax)'#
    | Where-Object Extension -NotMatch '\.ps\.(md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object BaseName | ForEach-Object name
    | ForEach-Object {
        '[{0}]({1})' -f @(
            $_
            $_ | md.Path.escapeSpace
        )
    } | Join.UL
}
~~~

