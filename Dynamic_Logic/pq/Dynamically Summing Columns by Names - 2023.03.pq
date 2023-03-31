// Numbers
let
    Json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcspPUtJRMjIAEsYgwtRAKVYnWskrNQ/IgSBDA4iYd2JJKkTEFKYyFgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, A = _t, B = _t, C = _t]),

    Source = Table.TransformColumnTypes( Json ,{{"A", Int64.Type}, {"B", Int64.Type}, {"C", Int64.Type}}),

    // sum by selecting N columns, defaulting to A, B, C
    // MissingField.Error is good if you want early errors
    // MissingField.Ignore will allow columnNames to be missing, without throwing an error
    SumColumns = (row as record, optional columnNames as nullable list) =>
        let 
            wanted_columns = columnNames ?? {"A", "B", "C"},
            selected_columns = Record.SelectFields( row, wanted_columns, MissingField.Error ), // or maybe Ignore, depending on the goal
            numbers = Record.FieldValues( selected_columns ),
            sum = List.Sum( numbers ) 
        in sum,

    #"Added Custom" = Table.AddColumn(
        Source, "Sum Columns",
        (row) => SumColumns( row ),
        type number)
in
    #"Added Custom"
