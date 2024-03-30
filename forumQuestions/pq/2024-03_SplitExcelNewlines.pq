// RawExcel
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("VY3BEQAhCAN74e0MEkG9WtQW7P95iPe5D2SSJYxBIkKJWn/mVqsuxZXk7MpYGTp35YdhtNIgAAe5YEDKxsjQiEspbkHgZaonNT+f+3zg9pVZ7OAv1Fr3+etaLw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Part = _t, Invoice = _t, Qty = _t, Expected = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Part", Int64.Type}, {"Invoice", type text}, {"Qty", type text}, {"Expected", type text}})
in
    #"Changed Type"

// Invoice
let
    /*
    The original question has rows with repeated part numbers
        the columns have multiple values delimited by newlines
        using the GUI and expand columns was giving the OP a cartesian product,
        instead of expanding records

    First expand records into multiple rows
    That makes the logic for transforming column types easier
    */
    ExpandRows = (row as record) as any => [
        // enter data uses a "LF". you'll have to test if excel uses a CRLF or just LF
        CrLf    = "#(cr,lf)",
        Lf      = "#(lf)",
        Delim   = Lf,
        partId  = row[Part],
        invoiceList = Text.Split(row[Invoice], Delim ),
        qtyList     = Text.Split( row[Qty], Delim ),
        datesList   = Text.Split( row[Expected], Delim ),
        totalRecords = List.Max({
            List.Count(invoiceList),
            List.Count(qtyList),
            List.Count(datesList)
        }),
        return = List.Transform(
            { 0..(totalRecords - 1) },
            (num) => [
                Part        = partId,
                Invoice     = invoiceList{ num }?,
                Qty         = qtyList{ num }?,
                Expected    = datesList{ num }?,
                LineNumber  = num
            ]
        )
    ][return],

    ConvertDate = (source as text) as any =>
        // if input is null, output is null
        let
            Format1 = "M/d/yy",
            Format2 = "M/d/yyyy",
            return =
                try Date.FromText(source, [ Format = Format1, Culture = "en-us" ] )
                    catch (e) =>
                        try Date.FromText(source, [ Format = Format2, Culture = "en-us" ] )
                        catch (e2) => error e2
        in
            return,

    Summary = [
        Source  = RawExcel,
        try1    = ExpandRows( Source{0} ),
        rows    = Table.TransformRows( Source, each ExpandRows( _ ) )
    ],
    rows = Summary[rows],
    #"Converted to Table" = Table.FromList(rows, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.FromRecords( Table.ExpandListColumn(#"Converted to Table", "Column1")[Column1] ),
    #"Uppercased Text" = Table.TransformColumns(#"Expanded Column1",{ {"Expected", each ConvertDate(_), type any}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Uppercased Text",{{"Part", Int64.Type}, {"Invoice", Int64.Type}, {"Qty", Int64.Type}, {"LineNumber", Int64.Type}})
in
    #"Changed Type"