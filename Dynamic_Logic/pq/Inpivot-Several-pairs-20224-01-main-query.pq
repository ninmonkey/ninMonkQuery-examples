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
    Source = RawSource,
    final = Source[final],
    processRow = (row as record) as record => [
        All = row,
        return = [
            #"Inv Date" = DateTime.FixedLocalNow(),
            #"Sale Date" = DateTime.FixedLocalNow(),
            #"Item Type" = text,
            #"Item Name" = text
        ]
    ][return],
    schema = type table [
        #"Inv Date" = datetime,
        #"Sale Date" = datetime
    ],
    #"Added Custom" = Table.AddColumn(final, "Data", (row) => processRow(row) as record, Record.Type)
in
    #"Added Custom"