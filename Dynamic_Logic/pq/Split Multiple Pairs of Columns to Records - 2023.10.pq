let
    /*
    the question came from this thread: <https://www.reddit.com/r/PowerBI/comments/17uhc84/power_query_pivot_with_multivalue_fields>


    ## Example input
        [  {"Name":"driving;passport;company","Id":"152;157;153","Date":"20220114;20211122;20051221"},
           {"Name":"passport;company","Id":"147;256","Date":"20230114;20200812"},
           {"Name":"driving;company","Id":"236;425","Date":"20201212;20101103"} ]

    ## Example output

        [   { "driving_id": 152, "passport_id": 157, "company_id": 153, "driving_date": "2022-01-14", "passport_date": "2021-11-22", "company_date": "2005-12-21" },
            { "driving_id": null, "passport_id": 147, "company_id": 256, "driving_date": null, "passport_date": "2023-01-14", "company_date": "2020-08-12" },
            { "driving_id": 236, "passport_id": null, "company_id": 425, "driving_date": "2020-12-12", "passport_date": null, "company_date": "2010-11-03" } ]
    */
    SampleJson_export = ToJson( SampleJson ) ,
    SampleJson = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bc2xCsMwDATQf9GcQXe2koI+xXgILZQMTUxSCv37qgmhSwehu+FxpchtnV7TfPc2bltb1qdfl0cb57d0AqPDhrgUjUoqkD0CADKCWnxI7Yr883lwWn/YdFrVC7iTc/onmHrPtEMoiO8IQmqSWj8=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, Id = _t, Date = _t]),


    Source = Table.TransformColumnTypes(SampleJson,{{"Name", type text}, {"Id", type text}, {"Date", type text}}),

    // export values as json, for copy-pasting as text
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


    /*
    This looks more complicated than it is

        Basically it's just
            - split this string using a delmiter
            - do the same for the other columns
            - then merge those lists of key names to values
            - then merge those two records together
            - optionally start with a record of blank key names
    */
    ProcessRow = ( source as record) as record => [
        includeEmpty = true,
        delim = ";",
        empty_columns = [
            driving_id = null, passport_id  = null, company_id = null,
            driving_date = null, passport_date = null, company_date = null
        ],
        default_columns = if includeEmpty then empty_columns else [],
        finalResult = Record.Combine({ default_columns, columns_ids, columns_dates }),
        columns_ids = Record.FromList(
            id_list,
            List.Transform(
                name_list, (item) => item & "_id"  )
        ),
        columns_dates = Record.FromList(
            date_list,
            List.Transform(
                name_list, (item) => item & "_date"  )
        ),
        name_list = Text.Split( source[Name], delim ),  // ex: "driving, passport, company
        id_list = Text.Split( source[Id], delim ), // ex: 123, 123, 123
        date_list = Text.Split( source[Date], delim )  // ex: 20230101, 20230101, 20230101
    ][finalResult],

    transformRows = Table.TransformRows( Source, (row) => ProcessRow(row) ),
    finalValue    = Table.FromRecords( transformRows ),
    base_types = Table.TransformColumnTypes(finalValue, {
            {"driving_id", Int64.Type}, {"passport_id", Int64.Type},
            {"company_id", Int64.Type}, {"driving_date", type text},
            {"passport_date", type text}, {"company_date", type text} }),

    // pick the right culture and it'll transform using a different format string
    // in this case it doesn't change the results much
    // although there are a few cultures that do
    dates_types_export = ToJson( dates_types ),
    dates_types = Table.TransformColumnTypes(base_types,{
        {"driving_date", type date},
        {"passport_date", type date},
        {"company_date", type date}}, "en-us")
in
    dates_types