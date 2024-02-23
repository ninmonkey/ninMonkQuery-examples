let
    Json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("jc8xCoQwFATQq4TUQpJv4mqvhQewEgvBLYRFtvD+mFEQ5H+NxRQJj8yk77Wj3OtM28o4a8hSHg8OUe0yr/P400MmK0JU95/G9XuL9qhmmU4RQMjY8NzGmFjH1NGXUpjpkwoX4bq9gHEmsmj8/Xjm5PWMyfMZk/cz9uYDuChU/fzQB0n3lcjRN2w=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Id = _t, Date = _t, Number = _t, Type = _t]),
    Source = Table.TransformColumnTypes(Json,{{"Id", Int64.Type}, {"Date", type date}, {"Number", Int64.Type}, {"Type", type text}}),
        
    // first nest the row, creating dynamic column names
    RowToRecord = (row as record) => 
        let return = Record.AddField([], Name, When ),
            When   = row[Date],
            Name   = row[Type]             
        in  return,

    // merge all of the custom column names in the current  Incident Id group
    ListToColumns = (source as list) as record =>
        Record.Combine(source),

    CollapseColumn = Table.AddColumn(Source, "Collapse", each RowToRecord(_), Record.Type),
    
    #"Removed Other Columns" = Table.SelectColumns(CollapseColumn,{"Id", "Collapse"}),

    #"Grouped Rows" = Table.Group(
        #"Removed Other Columns", {"Id"}, {
            { "Data",
               each ListToColumns(_[Collapse]),
               Record.Type
            }
        } ),

    #"Expanded Data1" = Table.ExpandRecordColumn(
        #"Grouped Rows", "Data", 
        {"1 Initial", "2 Update", "3 End", "3 Update", "4 Update", "5 End", "6 Date", "7 Update", "8 End"} , 
        {"1 Initial", "2 Update", "3 End", "3 Update", "4 Update", "5 End", "6 Date", "7 Update", "8 End"} ),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Expanded Data1",{
            {"8 End", type date}, {"7 Update", type date}, {"6 Date", type date},
            {"5 End", type date}, {"4 Update", type date}, {"3 Update", type date},
            {"3 End", type date}, {"2 Update", type date}, {"1 Initial", type date} })
in
    #"Changed Type"