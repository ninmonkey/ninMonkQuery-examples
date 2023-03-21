let

    "throw: this get the latest from the pbix, then post",

    #"Query Summary" = let
    /*
    future code
        get: Number of Table Rows
        test: Table.IsDistinct()
        additional metadata of table
            which primary keys are set

            generate record of table schema, then ToString()

    */
    options = [
        IgnoreQueries = {"pqLib", "Query1", "Query Summary"},
        HideNonTables = false
    ],
    SummarizeQueries.Type = ...,
    SummarizeQueries = (optional options as nullable record) =>
    let
        Source = Record.RemoveFields( #sections[Section1], options[IgnoreQueries], MissingField.Ignore  ),
        base = Record.ToTable( Source ),
        renamed_columns = Table.RenameColumns(base,
            { {"Name", "Query Name"} }),

        add_QueryType = Table.AddColumn(
            renamed_columns, "Query Type",
            (row) => Type.ToText( row[Value]  ),
            type text
        ),
        optional_removeNonTables =
            if not options[HideNonTables] then add_QueryType
            else Table.SelectRows( add_QueryType, each ([Query Type] = "Table" or [Value] is table)),

        add_Schema = Table.AddColumn(
            optional_removeNonTables, "Schema",
            (row) =>
                if not (row[Value] is table) then null
                else
                    try Table.Schema( row[Value]  )
                    catch (e) => error Error.Record(
                        "InnerException", "Table.Schema() failed",
                        e),
            type table
        ),
        add_Profile = Table.AddColumn(
            add_Schema, "Profile",
            (row) =>
                if not (row[Value] is table) then null
                else
                    try Table.Profile( row[Value]  )
                    catch (e) => error Error.Record(
                        "InnerException", "Table.Profile() failed",
                        e),
            type table
        ),
        add_ColumnNames = Table.AddColumn(
            add_Schema, "ColumnNames",
            (row) =>
                if not (row[Value] is table) then null
                else
                    try Table.ColumnNames( row[Value]  )
                    catch (e) => error Error.Record(
                        "InnerException", "Table.ColumnNames() failed",
                        e),
            type { text }

        ),
        add_ColNameSummary = Table.AddColumn(
            add_ColumnNames, "Summary",
            (row) =>
                if not (row[Value] is table) then null
                else
                    Text.Combine( List.Distinct( List.Sort(row[ColumnNames] )), ", "),
            type text

        ),
        sort_type = Table.Sort( add_ColNameSummary, {
            {"Query Type", Order.Descending}} ),

        final = sort_type,

        // converts values to typenames as text
        Type.ToText = (typeInfo as any) as text =>
                let
                    name =
                        if typeInfo is null then "Null"
                        // else if typeinfo is Uri.Type then fd
                        else if typeInfo is text then "Text"
                        else if typeInfo is type then "Type"
                        else if typeInfo is binary then "Binary"
                        else if typeInfo is number then "Number"
                        else if typeInfo is function then "Function"
                        else if typeInfo is list then "List"
                        else if typeInfo is table then "Table"
                        else if typeInfo is record then "Record"
                        else "Other" meta [ ValueType = typeInfo ]
                in
                    name
        in
            final,
            #"Reordered Columns" = Table.ReorderColumns(#"Query Summary",{"Summary", "Query Name", "Value", "Query Type", "Schema", "ColumnNames"})

    in
        #"Reordered Columns"
