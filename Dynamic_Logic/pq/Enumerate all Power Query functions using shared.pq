// api_listing
let
    Source = Record.RemoveFields( #shared, {"api_listing"}, MissingField.Ignore ),
    PrimitiveShortName = ( source as any ) as text =>
        if source is function then "function"
        else if source is number then "number"
        else if source is text then "text"
        else if source is logical then "logical"
        else if source is list then "list"
        else if source is table then "table"
        else if source is function then "function"
        else if source is type then "type"
        else error [
            Message.Format = "Unhandled primitive type: #{0}",
            Message.Parameters = { Value.Type(source)  }
        ],

    t1 = Record.ToTable( Source ),
    Inspect = (source as any) as record => [
        Original = source,
        ShortName = PrimitiveShortName( source ),
        tinfo = Value.Type( source ),
        minfo = Value.Metadata( source ),
        tinfo_tinfo = Value.Type( tinfo ),
        tinfo_minfo = Value.Metadata( tinfo ),
        left_off = "short type name as text"
    ],
    AddInspect_Col = Table.AddColumn( t1, "Info", (row) => Inspect( row[Value] ), Record.Type ),
    Custom1 = AddInspect_Col,
    onlyErrors = false,
    #"Expanded Info" = Table.ExpandRecordColumn(Custom1, "Info", {"Original", "ShortName", "tinfo", "minfo", "tinfo_tinfo", "tinfo_minfo", "left_off"}, {"Info.Original", "Info.ShortName", "Info.tinfo", "Info.minfo", "Info.tinfo_tinfo", "Info.tinfo_minfo", "Info.left_off"}),
    #"Kept Errors" = Table.SelectRowsWithErrors(#"Expanded Info", {"Info.ShortName"}),
    maybeErrors = if onlyErrors then #"Kept Errors" else #"Expanded Info"
in
    maybeErrors