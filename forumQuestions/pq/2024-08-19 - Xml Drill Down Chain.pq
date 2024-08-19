let
    Source = Xml.Document( RawXmlSrc ),
    CleanSource = Table.SelectColumns( Source, {"Name", "Value"} ),

    // replace / drill down the current [Value] column
    DrillValue = (source as table) as table =>
        Table.ExpandTableColumn( source, "Value", {"Value"}, {"Value"} ),
        
    // drill down replacing [Value] column, expanding [Name], [Value] columns
    DrillPairs = (source as table) as table =>
        Table.ExpandTableColumn( source, "Value", {"Name", "Value"}, {"Name", "Value"}),

    // convert empty tables to flat nulls. Otherwise leave non-empty tables and non-tables alone
    FlattenEmptyTables = (source as any) as any => 
        if not (source is table) then source
        else if Table.IsEmpty( source ) then null else source,

    #"Renamed Source" = Table.RenameColumns( CleanSource, { {"Name", "Root Element"} }),            

    Drill4 = 
        DrillValue( DrillValue( DrillValue( DrillValue( #"Renamed Source" ) ) ) ),

    Pairs = DrillPairs( Drill4 ),

    #"Renamed Columns1" = Table.RenameColumns( Pairs,{{"Name", "Element"}}),

    Pairs2 = DrillPairs( #"Renamed Columns1" ),

    RemoveEmptyTables = Table.TransformColumns( Pairs2, { {"Value", FlattenEmptyTables, type any} } ),

    #"Changed Type" = Table.TransformColumnTypes( RemoveEmptyTables , {   
        { "Element", type text },
        { "Name", type text }
    })
in
    #"Changed Type"
