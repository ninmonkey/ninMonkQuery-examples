// BaseData
let // 2023-05-14
    schema_root = type table [
        GroupId = Int64.Type,
        Kittens = (type { text }),
        Url = text
    ],
    Source = Table.FromRecords( {
        [ GroupId = 1, Kittens = {"bob", "frank"}, Url = "https://cdn2.thecatapi.com/images/e7.jpg" ],
        [ GroupId = 2, Kittens = {"bob", "frank"}, Url = "https://cdn2.thecatapi.com/images/cdh.jpg" ],
        [ GroupId = 0, Kittens = {"bob", "frank"}, Url = "https://cdn2.thecatapi.com/images/ZKuiRpWtD.jpg" ],
        [ GroupId = 1, Kittens = {"bob", "frank"}, Url = "https://cdn2.thecatapi.com/images/ycoqoHPqh.jpg" ],
        [ GroupId = 2, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/SCHe-SekW.jpg" ],
        [ GroupId = 0, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/dnb.jpg" ],
        [ GroupId = 1, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/e7.jpg" ],
        [ GroupId = 2, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/cdh.jpg" ],
        [ GroupId = 0, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/ZKuiRpWtD.jpg" ],
        [ GroupId = 1, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/ycoqoHPqh.jpg" ],
        [ GroupId = 2, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/SCHe-SekW.jpg" ],
        [ GroupId = 0, Kittens = {}, Url = "https://cdn2.thecatapi.com/images/dnb.jpg" ]
    }, schema_root ),

    AddRandomDatetimes = Table.AddColumn(
        Source, "Date Modified",
        (row) =>
            Int64.From(Number.RandomBetween(0, 1000)), Int64.Type ),

    FinalTable = AddRandomDatetimes
in
    FinalTable

// Newest Child
let
    Source = BaseData,
    Table.SelectNewestChild = (source as table) as table =>
        let
            forceSort = false,
            sortByDate = Table.Sort(
                source, {
                {"Date Modified", Order.Descending} } ),
            forcedSort = Table.StopFolding( sortByDate ), // maybe not required needed
            selectNewest = Table.FirstN( forcedSort, 1 )
        in
            selectNewest,

    child_schema = Table.Type,
    GroupedById = Table.Group(
        BaseData,
        {"GroupId"},
        {
            {
                "Rows",
                (curTable) => curTable,
                child_schema
            },
            {
                "Newest Child",
                (curTable) => Table.SelectNewestChild( curTable ),
                child_schema
            }
        }
    )
in
    GroupedById