// Using Merge Query
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCi4tSC0qTk1JTVHSUTKzNDE2BtKGFkqxOrjkTPDImeGRMwLLBaUmplRChU2BNA7TQFKWuKWghmGXw+EIkJyRAaacoZGxCdwhMOdBBYHhEAsA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [State = _t, #"Work Item Id" = _t, Week = _t]),

    All_Records =
        Table.TransformColumnTypes(Source,{{"State", type text},
            {"Work Item Id", Int64.Type}, {"Week", Int64.Type}} ),

    // depending on the data source, you may need to wrap a step in
    // Table.StopFolding() to ensure evaluation at that location

    #"Only Ids To Keep" = Table.SelectRows( All_Records,
        each 0 <> Comparer.OrdinalIgnoreCase( [State], "superseded") ),

    #"Records To Keep" = Table.NestedJoin(
        All_Records, {"Work Item Id"},
        #"Only Ids To Keep", {"Work Item Id"},
        "Joined", JoinKind.Inner),

    FinalTable = Table.RemoveColumns( #"Records To Keep", { "Joined" } )

in
    FinalTable

// Using Join
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCi4tSC0qTk1JTVHSUTKzNDE2BtKGFkqxOrjkTPDImeGRMwLLBaUmplRChU2BNA7TQFKWuKWghmGXw+EIkJyRAaacoZGxCdwhMOdBBYHhEAsA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [State = _t, #"Work Item Id" = _t, Week = _t]),

    All_Records =
        Table.TransformColumnTypes(Source,{{"State", type text},
            {"Work Item Id", Int64.Type}, {"Week", Int64.Type}} ),

    // depending on the data source, you may need to wrap a step in
    // Table.StopFolding() to ensure evaluation at that location

    #"Only Ids To Keep" = Table.SelectRows( All_Records,
        each 0 <> Comparer.OrdinalIgnoreCase( [State], "superseded") ),

    // this by itself causes an error because column names collide
    // Custom1 = Table.Join( All_Records, "Work Item Id", #"Only Ids To Keep", "Work Item Id", JoinKind.Inner ),

    // we only care about one column in this case, so we can rename it, and drop the rest. preventing collisions
    #"To Keep Column" = Table.SelectColumns( #"Only Ids To Keep", {"Work Item Id"}, MissingField.Error ),
    #"Wanted Ids Column" = Table.RenameColumns( #"To Keep Column", {"Work Item Id", "Wanted Id"} ),

    #"Filtered Records" = Table.Join(
        All_Records, "Work Item Id", #"Wanted Ids Column", "Wanted Id", JoinKind.Inner ),

    #"Removed Columns" = Table.RemoveColumns( #"Filtered Records", { "Wanted Id" })

in
    #"Removed Columns"