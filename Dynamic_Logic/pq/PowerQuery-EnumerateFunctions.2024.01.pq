let
    BaseList = Record.RemoveFields( #shared, {"lib", "Query1"}, MissingField.UseNull),
    InspectField = (name as text, source as any) as record => [
        Name = name,
        Type = Value.Type( source ),
        ShortName = NameOf( Type ),
        Typedef.String = LongType( Type ),
        Obj.Meta = Value.Metadata( source ),
        Doc.Meta = Value.Metadata( Value.Type( source ) )
        // TinMdata = Value.Type( Value.Metadata( source ) ), // never useful?
    ],
    Dive = a,
    Fact = lib[Fact],
    LongType = lib[ValueToText],
    final = [
        lib = lib,
        a = Value.Type( LongType ),
        Dive = Dive
    ],
    last = final[Dive],




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
                    "nyi: _serialize_table_type(x)"
                else if funtype = null and isListType(x) then
                    "{ " & @NameOf(Type.ListItem(x)) & " }"
                else if funtype = null and isFunctionType(x) then
                    // "function " & _serialize_function_type(x)
                    "function " & "nyi: _serialize_function_type(x)"
                else if funtype = null and isRecordType(x) then
                    "nyi: _serialize_record_type(x)"
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
    Info = t1{10}[Info],
    MdataTin = t1

in
    MdataTin