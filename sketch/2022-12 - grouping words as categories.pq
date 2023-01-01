let
    Source = if true then base_table else Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WciwoyElVcM5ILSqqVIrViVZyzshPzs9JLElVcMosTi7NLAGLQtkghanFqWChkPzcxJJ8BefUnFSoVv+8zPw8ZIGg1JzM4gxkTRCLFJIS84BQKTYWAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [FoodItem = _t]),

    // return next string, else null
    nextItem = ( source as table, item as nullable text ) as nullable text =>
        let
            x = Table.SelectRows( source, each [From] = item  ),
            // nextItem = x[To]?{0}?
            nextItem = x[To]?{0}?
        in
            try nextItem 
            catch (e) => null,

    Csv = (source as any) as text =>
        if source is text then
            source as text
        else if source is list then 
                "{ "
                & Text.Combine( List.Transform(source,
                    each try Text.From(_) catch (e) => "<??>"
                ), ", " )
                & " }"
        else
            error [
                Message.Format = "Invalid Argument Type, Expected [ list | text ], found #{0}", 
                Message.Parameters = { Value.Type(source) }
            ],   
  
    #"Split Segments" = Table.AddColumn(
        Source, "Crumbs", (row) => [
            crumbs = Text.Split( row[FoodItem], " " ),
            From = crumbs{0}?,
            To = crumbs{1}?
        ][[From],[To]],
 //[From,To],
// From = Text.Split([FoodItem]," "), 


            ( type [From = text, To=text ] )),
                Custom = #"Split Segments",
    #"Expanded Crumbs" = Table.ExpandRecordColumn(Custom, "Crumbs", {"From", "To"}, {"From", "To"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded Crumbs",{"From", "To"}),
    #"coerce proper case" = Table.TransformColumns(#"Removed Other Columns",{{"From", Text.Proper, type text}, {"To", Text.Proper, type text}}),

    LookupTable = Table.Distinct( #"coerce proper case" ),
    target = base_table,
  
    lastInvoke = findPath( LookupTable, "Apple" ),


    findPath_try1 = (source as any, startItem as text) =>
        let 
            

            gen = List.Generate( 
                    // () => [ State = Text.From(Next), Next = nextItem(LookupTable, "Apple") ],
                    ()  => [ State = startItem, Next = nextItem(LookupTable, startItem) ],
                    (i) => i[Next] <> null,
                    (i) => [
                        Next = nextItem( source, i[Next] ), 
                        State =
                            Text.From( i[State] ) & ", " & Text.From( i[Next]? )
                        
                        // Prev = 1 + i[Prev]
                    ],
                    each [State]
                    // each [State]
            ),
            final = List.LastN( gen, 1){0}
            in final,
    findPath = (source as any, startItem as text) =>
        let 
                        

            gen = List.Generate( 
                    // () => [ State = Text.From(Next), Next = nextItem(LookupTable, "Apple") ],
                    ()  => [ State = startItem, Next = nextItem(LookupTable, startItem) ],
                    (i) => i[Next] <> null,
                    (i) => [
                        Next = nextItem( source, i[Next] ), 
                        State =
                            Text.From( i[State] ) & ", " & Text.From( i[Next]? )
                        
                        // Prev = 1 + i[Prev]
                    ],
                    each [State]
                    // each [State]
            ),

                final1 = List.LastN( gen, 1){0},
                final = startItem
            in final,

    Custom8 = List.Generate( 
        // () => [ State = Text.From(Next), Next = nextItem(LookupTable, "Apple") ],
        () => [ State = "Apple", Next = nextItem(LookupTable, "Apple") ],
        (i) => i[Next] <> null,
        (i) => [
            Next = nextItem( LookupTable, i[Next] ), 
            // Next = "Apple",
            State = Text.From( i[State] ) & ", " & Text.From( i[Next]? )
            
            // Prev = 1 + i[Prev]
        ],
        each [State]
        // each [State]
),
    semifinal = List.LastN( Custom8, 1){0},
    Custom90 = findPath( LookupTable, "Relish" ),
    Custom92 = findPath( LookupTable, "Cherry" ),
    Custom9 = findPath( LookupTable, "Tomato" ),
    summary = [
        CsvFail = try Csv( #date(2022, 1,1)) catch (e) => e[Message],
        Relish_Next = nextItem( LookupTable, "Relish" ),
        Relish_Path = findPath( LookupTable, "Relish" ),
        Relish_Csv  = Csv( Relish_Path ),

        Apple_Next = nextItem( LookupTable, "Apple" ),
        Apple_Path = findPath( LookupTable, "Apple" ),
        Apple_Csv  = Csv( Apple_Path ),
        
        Cherry_Next = nextItem( LookupTable, "Cherry" ),
        Cherry_Path = findPath( LookupTable, "Cherry" ),
        Cherry_Csv = Csv( Cherry_Path ),


        zed = 10 
    ]
in
    summary
      /*
    Custom1 = Table.AddColumn( LookupTable, "nk", (row) => nextItem(LookupTable, row[From]), type any),
    Custom2 = { nextItem( LookupTable, "Apple"), nextItem( LookupTable, "Cherry") },
      #"base example" = List.Generate( 
        () => [Prev = 2],
        (i) => i[Prev] < 5,
        (i) => [ 
            Prev = 1 + i[Prev]],
        each [Prev]
),
*/
/*
    Custom7 = List.Generate( 
        () => [ Item = "Apple", State = {} ],
        (i) => i[Item] <> null,
        (i) => [
            Next = nextItem(LookupTable, i[Item]), 
            State = List.Combine(
                { i[State], {Next} } )
            // Prev = 1 + i[Prev]
        ],
        each _
        // each [State]
),
*/