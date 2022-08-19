let
    Source = Record.RemoveFields( #sections[Section1], "Listing of Queries" ),
    base = Record.ToTable( Source ),
    renamed_columns = Table.RenameColumns(base,
        { {"Name", "Query Name"} }),

    add_QueryType = Table.AddColumn(
        renamed_columns, "Query Type",
        (row) => Type.ToText( row[Value]  ),
        type text
    ),

    add_Schema = Table.AddColumn(
        add_QueryType, "Schema",
        (row) =>
            try Table.Schema( row[Value]  )
            catch (e) => e[Message],
        type any //type table
    ),
    add_Profile = Table.AddColumn(
        add_Schema, "Profile",
        (row) =>
            try Table.Profile( row[Value]  )
            catch (e) => e[Message],
        type any
        // type table
    ),

    // converts object to plain text
    Type.ToText = (typeInfo as any) as text =>
        let
            name =
                if typeInfo is table then "Table"
                else if typeInfo is type then "Type"
                else if typeInfo is record then "Record"
                else if typeInfo is list then "List"
                else "Other" meta [ Original = typeInfo ]
        in
            name,

    foo = Record.ToTable(Source),
    #"Added Custom1" = Table.AddColumn(foo, "Column_Profile",
        each try Table.Profile([Value]) otherwise null
    ),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "Column_Schema", each try Table.Schema([Value]) otherwise null),
    #"Renamed Columns" = Table.RenameColumns(#"Added Custom2",{{"Value", "Data_Tables"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each [Column_Schema] <> null and [Column_Schema] <> ""),
    fin = add_Profile,
    Profile = fin{7}[Profile],
    final = add_Profile
in
    final