let
    // enumerate all possible key names, for a depth of 1.
    IterKeys = (sourceTable as table, columnName as text) as list => [
        record_list = Table.Column( sourceTable, columnName ),
        nested_keys_list = List.Transform( record_list,
            (item) =>
                try
                    if item = null then {}
                    else Record.FieldNames( item )
                catch (e) =>
                    error e // [Message]
        ),
        flatten_names = List.Combine( nested_keys_list ),
        unique_names = List.Distinct( flatten_names ),
        return = List.Sort( unique_names )
    ][return],
    // next: no prefixes unless required, or, rename original
    Table.ExplodeColumn = (source as table, columnName as text) as table => [
        source = Table.RenameColumns(source, {{"Name", "N"}} ),
        keys_depth1 = IterKeys( source, columnName ),
        expand = Table.ExpandRecordColumn( source, columnName, IterKeys( source, columnName))
    ][expand],


    Source = ExpandImages,
    remove_other = Table.SelectColumns(Source,{"Name", "DataSource.Kind", "Publish"}),
    t3 = Table.TransformColumnTypes(remove_other,{{"DataSource.Kind", type text}}),
    /*
    #"Removed Other Columns" = Table.RenameColumns( remove_other, { {"Publish", "Pub"}, {"Name", "N"} }),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Publish", "Pub"}}),



    Custom1 = List.Transform( #"Renamed Columns"[Pub], (i) => try if i = null then {} else Record.FieldNames( i ) catch (e) => e[Message] ),
    Custom2 = List.Sort( List.Distinct( List.Combine( Custom1 ) ) ),
    tryNew = IterKeys( #"Renamed Columns", "Pub" ),
    Custom3 = Table.ExpandRecordColumn( #"Changed Type", "Pub", IterKeys( #"Changed Type", "Pub" ) ),
    */
    t4 = Table.ExplodeColumn( t3, "Publish" )
in
    t4