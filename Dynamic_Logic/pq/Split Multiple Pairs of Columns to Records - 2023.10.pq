// Sample
let
    /*
    the question came from this thread: <https://www.reddit.com/r/PowerBI/comments/17uhc84/power_query_pivot_with_multivalue_fields>

    */
    SampleJson = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bc1BCoNADIXhu2TtIu/NRIUcZZiFtFBcqIOWQm/fUJFuugj8WXxJKXLf59e8PrxNx9G2/em3bWnT+pZOYHTYEJNio5IKZI8AQKYotQhI7Yr8O5AHp/UnThdWHcEvuX7/BFPvmXYKBcEQCKlJav0A", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, Id = _t, Date = _t]),
    Source = Table.TransformColumnTypes(SampleJson,{{"Name", type text}, {"Id", type text}, {"Date", type text}}),

    Summary = [
        full = Source,
        drill = Source{0}
    ]

in
    Summary