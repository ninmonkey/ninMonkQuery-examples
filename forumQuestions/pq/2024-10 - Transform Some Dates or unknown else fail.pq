let 
    /* the original question: <https://www.reddit.com/r/PowerBI/comments/1g9qmkl/how_do_i_convert_datetime_to_date_and_ignore_text/>

        this souce is from: <https://github.com/ninmonkey/ninMonkQuery-examples/tree/main/forumQuestions/pq>
    */
    Json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjIwMtI1ACJDBUMjKwMDpVgdVEFjJEFjqKCBKUywNC87L788D8wuzs9NVUhKTFHIzCsoLQELQSVjAQ==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),

    Source = Table.TransformColumnTypes( Json, {{"RawText", type text}} ),
    /* 
    
    return type: #date, null, or throws
    Inputs: [ "2022-02-01 13:00", "unknown", or invalid ]
    output: [ #date(2022, 02, 01), null,        error ]
    
    Columns contain datetimes in en-us formats. Convert them to dates. 
    If they fail, check if they are unknown. if yes, return null. do not error.
    If everything else failed, then it's a true error. raise them so you don't accidentally 
        convert values to null when they should be errors.

    */
    FromDateOrUnknown = ( string as text ) as nullable date => 
        let         
            dt = DateTime.FromText( string, [ Culture = "en-us", Format = null ]  ),            
            return = 
                try  DateTime.Date( dt )
                catch (err) =>
                    if Text.Contains( string, "unknown", Comparer.OrdinalIgnoreCase ) 
                    then null
                    else error err
        in 
            return,

    Final = Table.TransformColumns( 
        Source, 
        { 
            { "RawText", each FromDateOrUnknown(_), Date.Type }
        })

in Final
