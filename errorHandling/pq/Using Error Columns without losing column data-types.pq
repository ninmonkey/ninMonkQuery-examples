let
    // mixed data where some will fail for different reasons
    Source = Table.FromList(
        {
            "a", 20.3, "100", 39,
            DateTime.LocalNow(),
            TextEncoding.Utf8,
            #duration(1,2,3,4),                
            Binary.FromList({244})                
        }, Splitter.SplitByNothing(),
        type table[ RawValue = any ], null, ExtraValues.Error),

    // the column is type number, so we can't have it return errors as text 
    // you could incude metadata on it, which works even for null values
    // or create an error column
    CoerceNumber = Table.AddColumn(
        Source, "CoerceNumber",
        (row) =>
            try 
                Number.From( row[RawValue], "en-us" )
            catch (e) =>
                null meta [ ErrorInfo = e ],
                
        Number.Type
    ),

    Str = [ 
        NL = "#(cr,lf)",
        Quote = """"
    ],

    // take an error record and render it as a string with lines for spacing
    RenderError = (source as nullable record, optional options as nullable record) as text => [
        render = Text.Format( template, args, "en-us"),
        template = "Reason: #[Reason]#[NL]Message: #[FormattedText]#[NL]Detail: #[Detail]",
        args = [
            FormattedText = Text.Format( 
                source[Message.Format]?     ?? "",
                source[Message.Parameters]? ?? {},
                options[Culture]? ?? "en-us"
            ),
            Reason = source[Reason], 
            Detail = source[Detail],
            NL = Str[NL]
        ]
    ][render],

    // this column has an exception that you can expand to columns
    // you could have it return an empty record instead of a null value
    // I used null because then it's easy to know whether there's no information nested
    ErrorColumn = Table.AddColumn(
        CoerceNumber,
        "Error Info", 
        (row) =>
            let 
                item = Value.Metadata( row[CoerceNumber] ),
                errorInfo = item[ErrorInfo]? ?? null
            in 
                errorInfo,
        Record.Type
    ),
            
    // this column is purely text
    ShowRenderError = Table.AddColumn(
            ErrorColumn,
            "Show Error", 
            (row) =>                
                let
                    item = Value.Metadata( row[CoerceNumber] ),
                    errorInfo = item[ErrorInfo]?
                in 
                    if errorInfo = null then "" else RenderError( errorInfo ),                
            Text.Type
        )
in
    ShowRenderError