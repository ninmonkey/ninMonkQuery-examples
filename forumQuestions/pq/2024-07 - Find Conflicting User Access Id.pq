// Readme
let
    Source = "
• The original question is from: <https://www.reddit.com/r/PowerBI/comments/1e26lk5/table_based_on_multiple_rows_joined_to_two/>

• 'Find Conflicts' is an expanded query that shows details
    you can visually inspect each stage of filtering

• 'Short Find Conflicts' is simplified. it does not show each individual step.


"
in
    Source

// User Perms
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCi1OLXJU0lEKdnU2MjZSitVBETIxN0UXMrY0QRcyNDLG0IhplrkZQpUTpllOSGbFAgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [User = _t, Access = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"User", type text}, {"Access", type text}})
in
    #"Changed Type"

// Conflicts
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjQwsTQ1VtJRCnZ1NrY0gTAMjYyVYnWgklAxf39PLJKmaJLmpkiSZmiSBgYmCElziJiRsRGEYQJkxMYCAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Id = _t, Source = _t, Destination = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Id", Int64.Type}, {"Source", type text}, {"Destination", type text}})
in
    #"Changed Type"

// Find Conflicts
let
    Source = #"User Perms",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"User"}),
    #"Removed Duplicates"    = Table.Distinct(#"Removed Other Columns"),

    // I could have used the "Group" command.
    // I chose this to let you visualize each step along the way.

    // grab all user values as a list
    #"AddCol Access List"    = Table.AddColumn( #"Removed Duplicates", "Access List",
        (row) =>
            Table.SelectRows( Source, each [User] = row[User] )[Access]
        , Table.Type),

    #"AddCol MatchesSource" = Table.AddColumn(  #"AddCol Access List", "Matches First",
        (row) => Table.SelectRows( Conflicts,
            (perms) => List.Contains( row[Access List], perms[Source] ) )
        , Table.Type
    ),
    #"AddCol Found Conflicts" = Table.AddColumn(  #"AddCol MatchesSource", "Found Conflicts",
        (row) => Table.SelectRows( row[Matches First],
            (perms) => List.Contains( row[Access List], perms[Destination] ) )
        , Table.Type
    ),
    #"Expanded Found Conflicts" = Table.ExpandTableColumn(#"AddCol Found Conflicts", "Found Conflicts", {"Id", "Source", "Destination"}, {"Conflict.Id", "Conflict.Source", "Conflict.Destination"}),
    #"Changed Type"             = Table.TransformColumnTypes(#"Expanded Found Conflicts",{{"Conflict.Id", Int64.Type}, {"Conflict.Source", type text}, {"Conflict.Destination", type text}}),
    #"Removed Columns"          = Table.RemoveColumns(#"Changed Type",{"Access List", "Matches First"})
in
    #"Removed Columns"