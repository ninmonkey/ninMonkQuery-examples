~~~pipescript{
    # build metadata yaml-header
    function Template.WriteHeader { 
        @{ 
        PipeScriptVersion = Get-Module pipescript | Join-String Version
        Pwsh = $PSVersionTable.PSVersion -join ''
        LastGenerated = Get-Date | % toString u
        } | ConvertTo-Yaml
        | Join-String -op  "---`n" -os "---"
    }

Template.WriteHeader
}~~~

## Answering Questions from the Internet

[Automatically Generated Index](readme.ps.md) of `pq`, `pbix` and `png` files, sorted by `lastWriteTime`

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
    | Sort-Object LastWriteTime -Desc | ForEach-Object FullName
    | ForEach-Object {
        '[{0}]({1})' -f @(            
            $_ | Path.Shorten

            $_ | Path.Shorten
               | md.Path.escapeSpace
        )
    } | Join.UL
}
~~~

## Images only

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
    | Where-Object extension -Match '\.(png|gif|jpe?g|mp4|svg)'#
    | Where-Object Extension -NotMatch '\.ps\.(svg|md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object LastWriteTime -Desc | ForEach-Object FullName
    | ForEach-Object {
        '[{0}]({1})' -f @(            
            $_ | Path.Shorten

            $_ | Path.Shorten
               | md.Path.escapeSpace
        )
    } | Join.UL
}
~~~

