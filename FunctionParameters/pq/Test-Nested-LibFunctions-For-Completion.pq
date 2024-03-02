    let
        /*
        About: Test to compare whether autocomplete or tooltips show up in vscode
            verses power BI.

            Version 1: With all docs metadata removed

        - Interestingly they ended up supporting the inverse of each other.
        - Although VsCode has native completers, and github-copilot,
            meaning it can actually suggest code from other files, even if it couldn't resolve it

        - settings may affect completions. Here's a couple to try


            "powerquery.diagnostics.typeStrategy": "Extended",
            "powerquery.general.mode": "SDK", // [ Power Query* | SDK ],
            "[powerquery]": {
                "github.copilot.editor.enableAutoCompletions": true,
                // "*suggest*": ...
            },
        */
        lib = [
            Csv = (source as list, optional options as nullable record) as text => Text.Combine(source, ","),
            invoke = ...
        ],

        /*
           VSCode: No
           PBI   : Works
        */
        summary = [
            innerTest = lib[Csv]( {"a".."z"} )
        ],
        /*
           VSCode: No
           PBI   : Works
        */
        baseDepthTest = lib[Csv]( {"a".."z"} ),

        ToCsv = lib[Csv],

        /*
           VSCode: Works
           PBI   : No
        */
        aliasTest = ToCsv( {"a".."b"} )
    in
        aliasTest