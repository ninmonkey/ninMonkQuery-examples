let
    ExcelConfig = [
        UseHeaders = false,
        DelayTypes = true,
        InferSheetDimensions = true
    ],
   Source1 = Excel.Workbook(File.Contents(ExcelExamplePath), ExcelConfig ),

    target = Source1{[Item="Page2",Kind="Sheet"]}[Data],
    Summary = [
        s1 = Source1,
        // s2 = Source2,
        collected = CollectRoot( target )
    ],
    short = Summary,

    // sketch that is called once per worksheet to include
    CollectRoot = (source as any, optional options as nullable record) as any => [
        defaults = [
            ColumnSelectCount = 5,
            PageTitle = 
                source{0}[Column1]? ?? "default title",
            Culture =  GlobalCulture
        ],
        config = Record.Combine({defaults, options ?? [] }),
        PageTitle = config[PageTitle],
        nextTarget = source,
        allNames = Table.ColumnNames( source ),
        firstFew =  List.Buffer( List.FirstN( allNames, config[ColumnSelectCount] ) ),
        dropExtraCols = 
            Table.Skip(
                Table.SelectColumns( source, firstFew ), 1 ),
        
        keyValPairCols = 
            {
                Table.RenameColumns(
                    Table.SelectColumns(
                        dropExtraCols,
                        List.Range( firstFew, 0, 2 ) ),                                 
                    { {"Column1", "Key"},  {"Column2", "Value"} } 
                ),
                Table.RenameColumns(
                    Table.SelectColumns(
                        dropExtraCols,
                        List.Range( firstFew, 3, 2 ) ),                                 
                    { {"Column4", "Key"},  {"Column5", "Value"} } 
                )                

            },

                // Table.SelectColumns(
                //     dropExtraCols,                    
                //     List.Range(
                //         firstFew , 2, 2 ) )                                
            // },
        pg1 = keyValPairCols{0},
        pg2 = keyValPairCols{1},
        renamedColsAsPairs = Table.Combine(keyValPairCols),
            // renamedColsAsPairs = Table.RenameColumns(
                // Table.Combine(keyValPairCols), { {"Column1", "Key"}, {"Column2", "Value"}  } ),
               
        withPageName = 
            Table.AddColumn( renamedColsAsPairs, "Group", (row) => PageTitle, Text.Type ),

        withPartial =
            Table.TransformColumnTypes( withPageName, {"Key", type text}, GlobalCulture ),            
        
        withFillDown =
            Table.FillDown( withPartial, {"Key"} ),

        withIndex = 
            Table.AddIndexColumn( withFillDown, "Row", 0, 1, Int64.Type),
            
        asRecords = 
            withIndex,

        return = asRecords        
    // ][return],
    ],

    // return = collected[return],
    return = short,
    // return = collected[return],
    collected = return[collected],
    // return = collected[return],
    return1 = collected[return]
in
    return1