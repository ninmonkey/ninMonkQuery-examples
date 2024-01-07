let
    /*
     versions to try:

    - [ ] basic unpivot
    - [ ] (this file)
        Table.AddColumn to merge and split multiple columns
    - [ ] Table.TransformRows
        similar to Table.AddColumn. Perhaps easier to optimize?
    - [ ] Table.Group - to grab tables in chunks, after one unpiviot?

    */
    Text.ContainsCI = (source as text, substring as text) as logical =>
        Text.Contains(source, substring, Comparer.OrdinalIgnoreCase ),

    Source = RawSource[Final],
    manualProcessRow = (row as record) as any => [
        All = row,
        rec_hat  = [ ItemKind = "hat" ],
        rec_shoe = [ ItemKind = "shoe" ],

        pair_hat = [
            #"Item Kind" = "hat",
            #"Inv Date" = row[Hat Inv Date]?,
            #"Sale Date" = row[Hat Sale Date]?
        ],

        pair_shoe = [
            #"Item Kind" = "shoe",
            #"Inv Date" = row[Shoe Inv Date]?,
            #"Sale Date" = row[Shoe Sale Date]?
        ],

        merged = Record.Combine(
            // rec_hat,
        ),

        return = List.Combine({ pair_hat, pair_shoe } )
    ][return],
    schema = type table [
        // #"Inv Date" = datetime,
        // #"Sale Date" = datetime
    ],
    #"Added Custom" = Table.AddColumn(processRow, "Data", (row) => manualProcessRow(row) as record, Record.Type)
in
    #"Added Custom"