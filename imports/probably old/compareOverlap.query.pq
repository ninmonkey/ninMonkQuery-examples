// "hi world"

/*let
    nums =
        List.Transform(
            {0..12},
            each Text.From(_)
        ),
    squares =
        List.Transform(
            {0..12},
            each Text.From(_ * _)
        ),
    Summary = [
        maybeHi = Value.ToText(23),
        nums = Text.Combine(nums, ", "),
        squares = Text.Combine(squares, ", "),
        zed = "hi world"
    ],
    Extension.LoadFunction =
        (name as text) =>
            let
                binary = Extension.Contents(name),
                asText = Text.FromBinary(binary)
            in
                Expression.Evaluate(asText, #shared),
    //Table.ChangeType = Extension.LoadFunction("Table.ChangeType.pqm");
    //Table.GenerateByPage = Extension.LoadFunction("Table.GenerateByPage.pqm");
    //Table.ToNavigationTable = Extension.LoadFunction("Table.ToNavigationTable.pqm");
    // Diagnostics module contains multiple functions. We can take the ones we need.
    // Value.ToText = Diagnostics[Value.ToText],
    // Diagnostics = Extension.LoadFunction("Diagnostics.pq"),
    // FuncTool = Extension.LoadFunction("func_tools.pq"),
    // Diagnostics.LogValue = Diagnostics[LogValue],
    // Diagnostics.LogFailure = Diagnostics[LogFailure]
in
    Summary*/
let

    a = 2,
    b = 4,
    StartEndRecords = Table.ToRecords(StartEndTable),
    //flatten1 = flattenSpans(StartEndRecords, {}),
    flatten1  = 1,
    

    Debug.ListSection1 = () =>
            Text.Combine(
                List.FirstN(
                List.Sort( List.Transform(
                    Record.FieldNames(#sections[Section1]), each Text.From(_)) ), 20), ", " ),
    Debug.ListAllSections = () =>
            Text.Combine(
                List.FirstN(
                List.Sort( List.Transform(
                    Record.FieldNames(#sections), each Text.From(_)) ), 5), "#(cr,lf)" ),

    Debug.ListAllFunctions = (optional options as nullable record) =>
            Text.Combine(
                List.FirstN(
                List.Sort( List.Transform(
                    Record.FieldNames(#shared), each Text.From(_)) ),  3), ", " ),


    /* raw data */
    StartEndTable =
        let
            t0 = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlXSUTIyUIrViVYyNACyDU3BbGMQ2xjIjgUA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Start = _t, End = _t]),
            t1 = Table.TransformColumnTypes(t0,{{"Start", Int64.Type}, {"End", Int64.Type}})
        in t1,

    /* below are mostly imports */
     Extension.LoadFunction =
        (name as text) =>
            let
                binary = Extension.Contents(name),
                asText = Text.FromBinary(binary)
            in
                Expression.Evaluate(asText, #shared),
    FuncTool = Extension.LoadFunction("func_tools.pq"),
    flattenSpans = FuncTool[flattenSpans],
    mergeSpans = FuncTool[mergeSpans],
    findMaxSpanOrNull = FuncTool[findMaxSpanOrNull],


    Summary = [
        a = a, b = b, c = StartEndTable,
        flatten1 = flatten1,
        //ListAllShared = Debug.ListAllFunctions(),
        ListAllFunctions = Debug.ListAllFunctions(),
        ListAllSections = Debug.ListAllSections(),
        ListSection1 = Debug.ListSection1(),
        fin = 1

    ]
in
    Summary