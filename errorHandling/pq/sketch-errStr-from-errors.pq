let
    errSummary = (sourceError as any, optional options as nullable record) =>
        let
            config = Record.Combine( {defaults, options ?? {} } ),
            defaults = [
                Mode = "errNL"
            ],
            Str = [
                DoubleQuote = """",
                DoubleDoubleQuote = DoubleQuote & DoubleQuote,
                TransitionComma = DoubleQuote & "," & DoubleQuote,
                NL = "#(cr,lf)",
                ReplaceNL = DoubleQuote & "," & NL & DoubleQuote
            ],
            // errJson = Text.FromBinary( Json.FromValue((try sourceError)), TextEncoding.Utf8 ),
            errJson = Text.FromBinary( Json.FromValue(sourceError), TextEncoding.Utf8 ),
            errComma = Text.Replace( errJson, ",", "#(cr,lf)#(cr,lf)" ),
            errNL = Text.Replace( errJson, Str[TransitionComma], Str[ReplaceNL] ),
            // errNL = Text.Replace( errJson, Str[TransitionComma], Str[ReplaceNL] ),
            final =
                if config[Mode] = "errNL" then errNL else errComma // #errNL
        in final,

    errStr = (source as any) =>
        let x = 10  ,
            final = [
                source = source,
                sourceTry = try source,
                asText = Text.FromBinary( targetErr, TextEncoding.Utf8 ),
                targetErr =
                    try Json.FromValue(source)
                    catch (e) => Json.FromValue(source)
            ]
        in final[asText] ,

    Str = [
                DoubleQuote = """",
                DoubleDoubleQuote = DoubleQuote & DoubleQuote,
                TransitionComma = DoubleQuote & "," & DoubleQuote,
                NL = "#(cr,lf)",
                ReplaceNL = DoubleQuote & "," & NL & DoubleQuote
            ],
    Summary =  [
        fStr ="yyy/MM/d", cult = "en-us",
        e = errSummary( Parse1 ),
        errStr1 = errStr( Parse1 ),
        errStr2 = errStr( (try Parse1) ),
        errStr3 = errStr( (try Parse1 catch (e) => e)),
        errJson2 = errSummary( try Parse1 ),
        errJson3 = errSummary( Parse1, [ Mode = "cadfd" ]  ),
        SourceText = "2022/01/20",
        SourceDate = #date(2022, 1, 20),
        Render1 = Date.ToText( SourceDate, fStr ),
        Render2 = Date.ToText( SourceDate, [ Culture = "en-us", Format = fStr] ),
        errJson = Text.FromBinary( Json.FromValue((try Parse1)), TextEncoding.Utf8 ),
        errNL = Text.Replace( errJson, """" & "," & """", "#(cr,lf)"""""),
        errNL2 = Text.Replace( errJson, """" & "," & """", "#(cr,lf)"),
        Parse1 = Date.FromText( Render1, [ Culture = cult, Format = fStr ]),
        err1 = try Parse1 catch (e) => e[Message],
        validate_1 = Render1 = SourceText,
        validate_2 = Render2 = SourceText,
        validate_baseline = Render2 = "dsf"
    ]
in
    Summary