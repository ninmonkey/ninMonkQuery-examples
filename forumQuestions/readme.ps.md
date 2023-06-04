# Questions from the internet

Last updated: ```.<{ Get-date | % tostring u }>.``` 


## Questions from the Internet

~~~PipeScript{
    import-module ninmonkey.console -Scope Global *>$null
    
    function md.Path.escapeSpace { process { $_ -replace ' ', '%20' } }

    function Path.Shorten { # relative cwd
        param() #  $RelativeTo 
        process { 
            $_  | Ninmonkey.Console\ConvertTo-RelativePath
                | %{ $_ -replace '\\', '/' }
        }
    }
    
    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match '\.(png|pbix|pq|xlsx|png|md|dax)'#
    | Where-Object Extension -NotMatch '\.ps\.(md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object LastWriteTime | ForEach-Object FullName
    | ForEach-Object {
        '[{0}]({1})' -f @(            
            $_ | Path.Shorten

            $_ | Path.Shorten
               | md.Path.escapeSpace
        )
    } | Join.UL
}
~~~

