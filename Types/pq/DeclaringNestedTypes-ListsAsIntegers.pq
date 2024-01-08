let
    /* here's a comparison of
        correct and incorrect types. If you fully apply this query
        then go to the model / DAX view

    notice that
        1. [NotReallyInt] loaded as an integer [Whole number]
        2. some values were completely dropped, they loaded as a bunch of null values (in the model)


    */

    Source = #table( type table [Raw = number], { {12.3}, {40.5}, {3.14156} }),
    schema_NumList = type { number },
    schema_IntList = type { Int64.Type },
    t0 = Table.AddColumn(
        Source, "DoubleNum", (row) as list =>
            { 1, 2, row[Raw]*2 }, ( type { number } ) ),

    t1 = Table.AddColumn( t0, "EnforcedInt",
        (row) as list =>
            List.Transform( { 1, 2, row[Raw]*2 }, (item) as number => Int64.From( item ) ),
            schema_IntList ),

    t2 = Table.AddColumn( t1, "NotReallyInt",
        (row) as list =>
            { 1, 2, row[Raw]*2 },
            schema_IntList ),

    #"step1_beforeExpand" = t2,

    #"Expanded DoubleNum" = Table.ExpandListColumn( #"step1_beforeExpand", "DoubleNum"),
    #"Expanded EnforcedInt" = Table.ExpandListColumn(#"Expanded DoubleNum", "EnforcedInt"),
    #"Expanded NotReallyInt" = Table.ExpandListColumn(#"Expanded EnforcedInt", "NotReallyInt")
in
    #"Expanded NotReallyInt"