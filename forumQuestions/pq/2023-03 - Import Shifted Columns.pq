// Ships
let
    Source = #"Raw Data",
    // treats whitespace only values like a null
    Text.IsBlank = (source as any) as logical =>
        let
            str = Text.From(source),
            strip = Text.Clean( str )
        in
            str is null or strip = "",

    // converts a single row (type record) to a new row of type record
    processRow = (row as record) as record =>
        let
            values = Record.FieldValues(row),
            non_empty = List.Select( values, (item) => not Text.IsBlank(item) ),
            good_values = Record.FromList(non_empty, {"SY", "SHIP GENERAL", "1"})
        in good_values,

    table2 = Table.TransformRows(
        Source,
        each processRow(_)
    ),
    Final = Table.FromRecords(
        table2, schema, MissingField.Error),
    schema = type table [SY = text, #"SHIP GENERAL" = text, #"1" = text ]

in
    Final