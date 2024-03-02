    let
        /*
        About: Test to compare whether autocomplete or tooltips show up in vscode
            verses power BI.

            Version 2: Including docs metadata

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
            // comment before
            Csv.Impl = (source as list, optional options as nullable record) as text =>
                // comment inline
                Text.Combine(source, ","),
            Csv.Type = type function (source as list, optional options as nullable record) as text meta [
                Documentation.Name = "Csv",
                Documentation.Description = "Converts a list to a csv string",
                Documentation.LongDescription = "Converts a list to a csv string",
                Documentation.Examples = {
                    [
                        Description = "Converts a list to a csv string",
                        Code = "Csv({1, 2, 3})",
                        Result = "1,2,3"
                    ]}
            ],
            Csv = Value.ReplaceType(Csv.Impl, Csv.Type),

            invoke = ...
        ],

        /*
           VSCode: No
            +docs: No
           PBI   : Works
            +docs: No
        */
        summary = [
            innerTest = lib[Csv]( {"a".."z"} )
        ],
        /*
           VSCode: No
            +docs: No
           PBI   : Works
            +docs: No
        */
        baseDepthTest = lib[Csv]( {"a".."z"} ),

        ToCsv = lib[Csv],

        /*
           VSCode: No
            +docs: No
           PBI   : No
            +docs: No
        */
        aliasTest = ToCsv( {"a".."b"} )
    in
        aliasTest