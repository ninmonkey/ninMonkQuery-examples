let
    // sugar for an xray function
    _ = (source as any) => [
        render = Text.Replace( str, ",", ",#(cr,lf)" ),
        str = Text.FromBinary( Json.FromValue( source, TextEncoding.Utf8 ), TextEncoding.Utf8 ),
        ret = render
    ][ret],

    /* question:

    99 -Mike Surname 2022 - 2023
    99 - Antonis test 2022 - 2023.

    How can I keep only the name and the date period. The preferable result should be "Mike Surname 2022 - 2023" , "Antonis test 2022 - 2023".
    */

    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WsrRU0PXNzE5VCC4tykvMTVUwMjAyUtAFUcZKsToQBQqOeSX5eZnFCiWpxSVYVOi5p+YXpacqBCQW4Neflp+vkJRYpFBcUpqWpgAEKKpjAQ==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Text", type text}}),


    // stricter split
    // will error if the number of strings is not exactly ExpectedLength
    SplitBy_Dash3 = (string as text) as any => [
        ExpectedLength = 3,
        SplitFunc = Splitter.SplitTextByEachDelimiter(
            { "-", "-" }, QuoteStyle.None ),
        Segments = SplitFunc( string ),
        SegmentCount = List.Count( Segments ),
        return =
            if SegmentCount = ExpectedLength
            then Segments
            else error [
                Message.Parameters = { ExpectedLength, string },
                Message.Format = "InvalidResultException: SplitByEachDelimiter did not return exactly #{0} segments #(cr,lf)  String: '#{1}',"
            ]
    ][return],

    // basically the same as SplitBy_Dash3, duplcate except the parameter
    SplitBy_MixedDash3 = (string as text) as any => [
        ExpectedLength = 3,
        SplitFunc = Splitter.SplitTextByEachDelimiter(
            { ".", "-" }, QuoteStyle.None ),
        Segments = SplitFunc( string ),
        SegmentCount = List.Count( Segments ),
        return =
            if SegmentCount = ExpectedLength
            then Segments
            else error [
                Message.Parameters = { ExpectedLength, string },
                Message.Format = "InvalidResultException: SplitByEachDelimiter did not return exactly #{0} segments #(cr,lf)  String: '#{1}',"
            ]
    ][return],
    Rows = #"Changed Type",

    // Try the more specific type first. if it fails, try the second
    Col_Step1 = Table.AddColumn(
        Rows, "Step1",
        (row) =>
            try          SplitBy_MixedDash3( row[Text] )
            catch (e) => SplitBy_Dash3( row[Text] ),
        (type { text } )
    ),

    // You can add the {0}? operator if you want to coerce missing items as null values
    Col_LineAsRecord = Table.AddColumn(
        Col_Step1, "Step2",
        (row) => [
            Crumbs = row[Step1],
            Id      = Text.Trim( Crumbs{0} ),
            Name    = Text.Trim( Crumbs{1} ),
            YearEnd = Text.Trim( Crumbs{2} ),
            NameWithoutYear = Text.BeforeDelimiter( Name, " ", Occurrence.Last ),
            YearStart       = Text.AfterDelimiter(  Name, " ", {0, RelativePosition.FromEnd } ),
            return          = [
                Id        = Id,
                Name      = NameWithoutYear,
                YearStart = YearStart,
                YearEnd   = YearEnd
            ]
        ][return],
        schema_ParsedRecord
        // Record.Type
    ),
    schema_ParsedRecord = type table [ Id = Int64.Type, Name = text, YearStart = Int64.Type, YearEnd = Int64.Type ],

    // error if fields are ever missing:
    Step2             = Col_LineAsRecord{0}[Step2],
    Custom1           = Col_LineAsRecord,
    #"Expanded Step2" = Table.ExpandRecordColumn(Custom1, "Step2", {"Id", "Name", "YearStart", "YearEnd"}, {"Id", "Name", "YearStart", "YearEnd"}),
    #"Final Table"  = Table.TransformColumnTypes(#"Expanded Step2",{{"Id", Int64.Type}, {"Name", type text}, {"YearStart", Int64.Type}, {"YearEnd", Int64.Type}})
in
    #"Final Table"