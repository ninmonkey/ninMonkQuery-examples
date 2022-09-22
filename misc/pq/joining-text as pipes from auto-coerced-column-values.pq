let
    /*
    references about metadata and help related metadata
        https://bengribaudo.com/blog/2021/09/21/6179/describing-function-record-parameters
        https://bengribaudo.com/blog/2020/06/02/5259/power-query-m-primer-part18-type-system-iii-custom-types#function
        https://bengribaudo.com/blog/2021/09/21/6179/describing-function-record-parameters#Specifying%20the%20Shape
        https://bengribaudo.com/blog/2020/09/03/5408/power-query-m-primer-part19-type-system-iv-ascription-conformance-and-equalitys-strange-behaviors
        https://bengribaudo.com/blog/2020/02/05/4948/power-query-m-primer-part16-type-system-i-basics
    */
    json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjRS0lEyAWIgArOVYnWilYyBDAMIV0dJAYRj8sASJoYQMSBKgykG0qZAbGQMlUtMLYeJQ00oQlcLRbGxAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [ColA = _t, ColB = _t, Stuff = _t, Fin = _t, FinFin = _t]),
    Source = Table.TransformColumnTypes(json,{{"ColA", Int64.Type}, {"ColB", Int64.Type}, {"Stuff", Int64.Type}, {"Fin", type text}, {"FinFin", type text}}),
    hardcoded_values = {
        null, 0, "", " ", "#(cr,lf)", "", "#(0001f412)"
    },


    // column_names = Table.ColumnNames( Source ),
    Text.JoinSpecialValues = Value.ReplaceType( Text.JoinSpecialValues_impl, Text.JoinSpecialValues.Type ),
    Text.JoinSpecialValues.Type = type function (
            source as list,
            optional options as nullable [
                Separator = (type text meta [
                    Documentation.SampleValues = { "|", ", " },
                    // Documentation.AllowedValues = { "|", ", " },
                    Documentation.FieldCaption = "Separator to join on"
                ]),
                UseSpecialSymbols = (type logical meta [
                    Documentation.AllowedValues = {false, true},
                    Documentation.FieldCaption = "Set to false to not modify the original values" ])
            ]
            // optional options as nullable record
        ) as text meta [
            Documentation.Name = "Text.JoinSpecialValues",
            Documentation.LongDescription = Text.Combine({
                "Convert a list of values into text, then join them like a Csv.",
                "",
                "The <b>default</b> will replace <i>true</i><code>null</code> values with symbols.",
                "<br><br>",

                "<b>Testing Help Syntax</b>: Table",
                "<table>
                    <tr><td>true <code>null</code></td><td>␀</td></tr>
                    <tr><td>true <code>EmptyString</code></td><td>␠</td></tr>
                </table>",

                "<b>Testing Help Syntax</b>: Unordered List",
                "<ul>
                    <li>true <code>null</code> ⇒ '␀'</li></ul>
                    <li>true <code>EmptyString</code> ⇒ '␠'</li></ul>␠

                "

            }, "<br>" ),
            /* something like
                    [
                        Test1 = Text.JoinSpecialValues({"a", 34.5, "c"}),
                        Test2  = Text.JoinSpecialValues({"Col1", null, "", 23.54})
        ]
            */
            Documentation.Examples = {
                [Description = "Positive number as input", Code = "SomeFuction(1)", Result = "10"],
                [Description = "Insert taable.addcolumn here", Code = "SomeFuction(-2)", Result = "-20"]
            }
        ],
    Text.JoinSpecialValues_impl = (source as list, optional options as nullable record) as text =>
        let
            /*
            options[Separator] :
            */
                config = Record.Combine({defaults, options ?? []}),
                defaults = [
                    Separator = "|",
                    UseSpecialSymbols = true
                ],
                joined_string =  Text.Combine( text_list, config[Separator] ),
                values_list  = if not config[UseSpecialSymbols] then source else
                    List.ReplaceMatchingItems( source,
                        {
                            // replace true null, and true empty strings (vs whitespace)
                            { null, "␀"},
                            { "#(cr,lf)", "#(240d)␤" }, // is #(2424)" }
                            { "#(lf)", "␤" }, // is #(2424)" }
                            // add: whitespace but nothing else: { "<blank>", }
                            {"", "␠"}
                        } ) ,

                // text_list = List.Transform( values_list, each _)
                text_list = List.Transform( values_list, Text.From)
            in
                joined_string,

    tests = [
        Values = hardcoded_values,
        Defaults = Text.JoinSpecialValues( hardcoded_values ),
        Separator = Text.JoinSpecialValues( hardcoded_values, [ Separator = "￤"]),
        WithoutUseSpecialSymbols = Text.JoinSpecialValues( hardcoded_values, [ Separator = "￤", UseSpecialSymbols=false])
    ],    // # replacement list from: <https://www.compart.com/en/unicode/block/U+2400>
    #"join as pipes" = Table.AddColumn(
        Source, "MergeAll", (row) => Text.JoinSpecialValues( Record.FieldValues(row)), type text)


        // # or even each Record.FieldNames(_)

in
    #"join as pipes"