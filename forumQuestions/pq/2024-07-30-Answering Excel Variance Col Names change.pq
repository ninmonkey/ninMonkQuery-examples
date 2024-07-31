// RawExcel
let
    // table layout from the question: https://www.reddit.com/r/PowerBI/comments/1echatp/best_way_to_ingest_data_from_excel_with_varying/
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjbQMzFW0lEyNtGztATSJiC2oYkpkLK0NDIG0aZm5kDSSM8QrE4PpEIpNhYA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Jan - Plan" = _t, #"Jan - Actual" = _t, Variance = _t, #"Feb - Plan" = _t, #"Feb - Actual" = _t, Variance2 = _t, Mar = _t, Apr = _t, May = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{
        {"Jan - Plan", type number}, {"Jan - Actual", type number}, {"Variance", Int64.Type}, 
        {"Feb - Plan", Int64.Type}, {"Feb - Actual", Int64.Type}, {"Variance2", Int64.Type}, 
        {"Mar", type number}, {"Apr", type number}, {"May", type text}})
in
    #"Changed Type"

// SplitTermsTable
let
    readme = "
question: <https://www.reddit.com/r/PowerBI/comments/1echatp/best_way_to_ingest_data_from_excel_with_varying/>

their example input table:   
    
| Jan - Plan 	| Jan - Actual 	| Variance 	| Feb - Plan 	| Feb - Actual 	| Variance2 	|  Mar 	| Apr 	| May 	|
|:----------:	|:------------:	|:--------:	|:----------:	|:------------:	|:---------:	|:----:	|:---:	|:---:	|
| 30.43      	| 34.99        	| 4        	| 3145       	| 99235        	| 567       	| 2.13 	| 3.4 	|     	|

Split terms  output: I made it output extra columns so that you can see how it's evaluated each step of the way

|    RawName   	| Crumbs 	|    Name   	|  Type  	|   Kind   	| MonthAsDate 	| AsMonth 	|
|:------------:	|:------:	|:---------:	|:------:	|:--------:	|:-----------:	|:-------:	|
| Jan - Plan   	| [List] 	| Jan       	| Plan   	| Month    	| 2024-01-01  	| 1       	|
| Jan - Actual 	| [List] 	| Jan       	| Actual 	| Month    	| 2024-01-01  	| 1       	|
| Variance     	| [List] 	| Variance  	| null   	| Variance 	| null        	| null    	|
| Feb - Plan   	| [List] 	| Feb       	| Plan   	| Month    	| 2024-02-01  	| 2       	|
| Feb - Actual 	| [List] 	| Feb       	| Actual 	| Month    	| 2024-02-01  	| 2       	|
| Variance2    	| [List] 	| Variance2 	| null   	| Variance 	| null        	| null    	|
| Mar          	| [List] 	| Mar       	| null   	| Variance 	| 2024-03-01  	| 3       	|
| Apr          	| [List] 	| Apr       	| null   	| Variance 	| 2024-04-01  	| 4       	|
| May          	| [List] 	| May       	| null   	| Variance 	| 2024-05-01  	| 5       	|

",
    Source = Table.ColumnNames( RawExcel ),
    SplitCol = ( source as text ) => [
        RawName = source,
        Crumbs = Text.Split( source, "-" ),
        Name = Text.Trim( Crumbs{0}? ),
        Type = Text.Trim( Crumbs{1}? ),
        Kind = 
            if Type <> null and not Text.Contains( Type, "Variance", Comparer.OrdinalIgnoreCase )        
            then "Month" else "Variance",
        MonthAsDate = 
            try Date.FromText( Name, [ 
                Format = "MMM", Culture = "en-US"] )
            catch (e) =>
                null,

        AsMonth = Date.Month( MonthAsDate )
    ],
    ColInfoList = List.Transform( Source, each SplitCol(_) ),
    schema = type table [ 
        RawName = nullable text,
        Crumbs = (type nullable { text } ),
        Name = nullable text,
        Type = nullable text,
        Kind = nullable text,
        MonthAsDate = nullable date,
        AsMonth = nullable number
    ],
    Final = Table.FromRecords( ColInfoList, schema, MissingField.UseNull )
in
    Final