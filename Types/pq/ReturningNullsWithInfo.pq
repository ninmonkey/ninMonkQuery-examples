let

    Source = { 10, -13, 0.324, Number.PI, "sdf", null },

    results = List.Transform( Source, (item) => DoubleIt( item ) ),

    DoubleIt = (source as any) as nullable number =>
        try source * 2
        catch (e) =>
            null meta [ State = "Failed", ErrorRecord = e ],

    AsTable = Table.FromList(
        results, Splitter.SplitByNothing(),
        type table [ Value = nullable number ],
        null, ExtraValues.Error ),

    TestColumn = Table.AddColumn(
        AsTable, "TypeOf",
        each [Value] is number or [Value] is null,
        Logical.Type )
in
    TestColumn