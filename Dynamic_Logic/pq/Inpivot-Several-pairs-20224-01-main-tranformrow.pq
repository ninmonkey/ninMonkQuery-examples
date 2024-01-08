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

    Assert.ColumnsExist = (source as table, requiredNames as list) as any => [ // as logical => [
        config = [
            DetailedOutput = true,
            CaseSensitiveCompare = true
            // CultureComparer = null
        ],
        details = [

        ],
        return =
            if config[DetailedOutput] then details
            else error "NYI, successfull stand alone bool"
        // Table.SelectColumns( Source, ExpectCols, MissingField.Error ),
        // finalCondCondition =
        //     try a catch (e) =>
        //     error e
    ][return],

    AssertConditions = () => [
        source = Source,
        ExpectCols = List.Sort( {
            "Hat Inv Date",
            // "Hat Sale Date",
            "Hat Sell Date",
            "Shoe Inv Date",
            "Shoe Sell Date"
            // "Shoe Sale Date"
        }),
        // see also: List.RemoveMatchingItems(l1, l2, predicate)
        actualCols = List.Sort( Table.ColumnNames(source) ),
        missingCols = List.RemoveItems( ExpectedCols, actalCols ),
        extraCols   = List.RemoveItems( actualCols, ExpectCols ),

        a = Table.SelectColumns( Source, ExpectCols, MissingField.Error ),
        finalCondCondition =
            try a catch (e) =>
            error e
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






        // export values as json, for copy-pasting as text
    i = ToJson, eye = ToJson, In = ToJson,
    ToJson = (source as any, optional options as nullable record ) as text => [
        defaults = [
            Encoding = TextEncoding.Utf8,
            Expand = true
        ],
        config = Record.Combine({
            options ?? [],
            defaults
        }),
        json = Text.FromBinary( Json.FromValue( source, config[Encoding] ) , config[Encoding] ),
        json_expanded = Text.Replace( json, "},{", "},#(cr,lf){"),
        return = if config[Expand] then json_expanded else json
    ][return],

    tr = Table.TransformRows( Source, manualProcessRow ),
    asOne = List.Combine( tr ),
    schema_fromRecords = null,
    fromRecords = Table.FromRecords( asOne, schema_fromRecords, MissingField.Error),
    fin_prev = asOne,
    fin = AssertConditions(),
    Source1 = fin
in
    Source1