let
    ToRemove = {"lib", "Query1", "BaseListing", "ByTypeMinimalInfo"},
    // future, *maybe* I can remove key names that exist in sections1[Section1], generating a dynamic exclude list
    // but that sounds fragile and not worth it
    BaseList = Record.RemoveFields( #shared, ToRemove, MissingField.UseNull),
    InspectField = (name as text, source as any) as record => [
        Name = name,
        Type = Value.Type( source ),
        // ShortName = NameOf( Type ),
        Typedef.String = LongType( Type ),
        Obj.Meta = Value.Metadata( source ),
        Doc.Meta = Value.Metadata( Value.Type( source ) )
        // TinMdata = Value.Type( Value.Metadata( source ) ), // never useful?
    ],
     // enumerate all possible key names, for a depth of 1.
        IterKeys = (sourceTable as table, columnName as text) as list => [
            record_list = Table.Column( sourceTable, columnName ),
            nested_keys_list = List.Transform( record_list,
                (item) =>
                    try
                        if item = null then {}
                        else Record.FieldNames( item )
                    catch (e) =>
                        error e[Message]
            ),
            flatten_names = List.Combine( nested_keys_list ),
            unique_names = List.Distinct( flatten_names ),
            return = List.Sort( unique_names )
        ][return],
    // Dive = a,
    // Fact = lib[Fact],
    // final = [
    //     lib = lib,
    //     a = Value.Type( LongType ),
    //     Dive = Dive
    // ],
    // last = final[Dive],




    LongType = lib[ValueToText],
    NameOf = (x, optional funtype as logical) =>
            // Optional parameter: Is this being used as part of a function signature?
            let
                isFunctionType = (x as type) =>
                    try if Type.FunctionReturn(x) is type then true else false otherwise false,
                isTableType = (x as type) => try if Type.TableSchema(x) is table then true else false otherwise false,
                isRecordType = (x as type) => try if Type.ClosedRecord(x) is type then true else false
            otherwise
                false,
                isListType = (x as type) => try if Type.ListItem(x) is type then true else false otherwise false
            in
                if funtype = null and isTableType(x) then
                    "table" // "nyi: _serialize_table_type(x)"
                else if funtype = null and isListType(x) then
                    "table"
                    // "{ " & @NameOf(Type.ListItem(x)) & " }"
                else if funtype = null and isFunctionType(x) then
                    // "function " & _serialize_function_type(x)
                    // "function " & "nyi: _serialize_function_type(x)"
                    "function"
                else if funtype = null and isRecordType(x) then
                    "record"
                else if x = type any then
                    "any"
                else
                    let
                        base = Type.NonNullable(x)
                    in
                        (if Type.IsNullable(x) then "nullable " else "")
                            & (
                                if base = type anynonnull then
                                    "anynonnull"
                                else if base = type binary then
                                    "binary"
                                else if base = type date then
                                    "date"
                                else if base = type datetime then
                                    "datetime"
                                else if base = type datetimezone then
                                    "datetimezone"
                                else if base = type duration then
                                    "duration"
                                else if base = type logical then
                                    "logical"
                                else if base = type none then
                                    "none"
                                else if base = type null then
                                    "null"
                                else if base = type number then
                                    "number"
                                else if base = type text then
                                    "text"
                                else if base = type time then
                                    "time"
                                else if base = type type then
                                    "type"
                                else
                                // Abstract types
                                if base = type function then
                                    "function"
                                else if base = type table then
                                    "table"
                                else if base = type record then
                                    "record"
                                else if base = type list then
                                    "list"
                                else
                                    "any /*Actually unknown type*/"
                            ),

    t0 = Record.ToTable( BaseList ),
    t1 = Table.AddColumn( t0, "Info", (row) => InspectField( row[Name], row[Value] ) as record, Record.Type ),

    Final = [
        t0 = t0, t1 = t1
        // , t2 = t2
]


in
    Final