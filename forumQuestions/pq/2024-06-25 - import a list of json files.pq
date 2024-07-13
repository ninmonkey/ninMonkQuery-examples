let
    /*
        about: this creates example json files inline, without requiring files to exist
        source: <https://github.com/ninmonkey/ninMonkQuery-examples/new/main/forumQuestions/pq/2024-06-25 - import a list of json files.pq>
    */
    Source = 
        let 
            FakeJson1 = { 
                [ name = "Jen", id = 2222 ],
                [ name = "Stan", id = 1111 ]
            },
            FakeJson2 = { 
                [ region = "West",  color = "blue"],
                [ region = "South", color = "salmon" ]
            },
            FakeFiles = {
                [ filename = "employees.json", Content = Json.FromValue( FakeJson1 ) ],
                [ filename = "region.json", Content = Json.FromValue( FakeJson2 ) ],
                [ filename = "shouldFail.json", Content = null ]
            }
        in 
            Table.FromRecords( FakeFiles, type table [ filename = text, Content = binary ] ) ,

    // real code starts here. 
    Column_ConvertJson = Table.AddColumn(
        Source,
        "Json",        
        (row) => [            
            // I threw in extra record fields to make errors easier to read
            // you only need the field "Table"
            JsonList    = Json.Document( row[Content] ), 
            Table       = Table.FromRecords( JsonList ),
            HasError    = (try Table)[HasError]
        ],
        type [ JsonList = list, Table = Table.Type, HasError = logical ]
    ),
    // if you want json to be a table, it expects it to be an array (aka list) at
    // the top level. if yours is not, you'll need to either shape it, or drill down into an array.

    #"Expanded Json" = Table.ExpandRecordColumn(Column_ConvertJson, 
        "Json", 
        {"Table", "HasError" }, 
        {"Table", "HasError" } )

    // now you have an array of json tables 
in
    #"Expanded Json"
