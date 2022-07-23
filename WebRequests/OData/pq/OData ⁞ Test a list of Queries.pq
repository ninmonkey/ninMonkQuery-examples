// OData Query
let
    Source = OData.Feed("https://services.odata.org/v4/TripPinService/"),
    People = Source{[Name="People"]}[Data],
    SelectColumns = Table.SelectColumns(People, {"UserName", "FirstName", "LastName"}),

    TestUrls = {
        "https://services.odata.org/v4/TripPinService/Me",
        "https://services.odata.org/v4/TripPinService/GetPersonWithMostFriends()",
        "https://services.odata.org/v4/TripPinService/People"
    },

    queries = List.Transform( TestUrls,
        (query) => let
            response =
                try OData.Feed(query)
                catch (e) => e[Message]
        in [
            Query = query,
            Response = response
        ]
    ),

    Schema = [
        Summary = type table[
            Query = text, Response = any
        ]
    ],
    queries_summary = Table.FromRecords( queries, Schema[Summary] ),
    t0 = Table.AddColumn(
        queries_summary , "AsTable",
        (r) =>
            CoerceToTable( r[Response] ), Table.Type
    ),
    t1 = Table.ReorderColumns( t0, {"AsTable", "Query", "Response"}, MissingField.Error ),
    Summary = [
        Source = Source,
        People = People,
        SelectColumns = SelectColumns,
        TestUrls = TestUrls,
        queries = queries,
        queries_summary = queries_summary,
        Final = t1

    ],
    Final = Summary[Final]
in
    Final

// CoerceToTable
// CoerceToTable
let
    // sugar to convert types to table, else text
    CoerceToTable =
        (source as any) as any => // as table =>
            let
                sourceType = Value.Type(source)
            in
                if Type.Is(sourceType, Record.Type) then
                    Record.ToTable(source) as table
                else if Type.Is(sourceType, Table.Type) then
                    source as table
                else if Type.Is(sourceType, Text.Type) then
                    #table(1, {source}) as table
                else
                    error Error.Record( "UnhandledTypeConversion", "UnhandledType", sourceType )
in
    CoerceToTable