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

    AssertConditions = () => [
        ExpectCols = {
            "Hat Inv Date",
            "Hat Sale Date",
            "Shoe Inv Date",
            "Shoe Sale Date"
        },
        a =  Table.SelectColumns( ),
        finalCondCondition = false
    ],

    Source = RawSource[Final],
    manualProcessRow = (row as record) as any => [
        All = row,
        rec_hat  = [ ItemKind = "hat" ],
        rec_shoe = [ ItemKind = "shoe" ],

        pair_hat = [
            #"Item Kind" = "hat",
            #"Inv Date" =  row[Hat Inv Date]?,
            #"Sale Date" = row[Hat Sale Date]?
        ],

        pair_shoe = [
            #"Item Kind" = "shoe",
            #"Inv Date"  =  row[Shoe Inv Date]?,
            #"Sale Date" = row[Shoe Sale Date]?
        ],
        return = { pair_hat, pair_shoe }
    ][return],
    // schema = type table [],

    tr = Table.TransformRows( Source, manualProcessRow ),
    asOne = List.Combine( tr ),
    schema_fromRecords = null,
    fromRecords = Table.FromRecords( asOne, schema_fromRecords, MissingField.Error),
    fin_prev = asOne,
    fin = AssertConditions()

in
    fin