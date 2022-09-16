let
    // sample input
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcspPUtJR8ssvKslQitWJVvJKzQPyXROLS8Bcp3yguI5ScH4pFvlYAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [CustomerId = _t, RegionId = _t]),
    /*
    about:
        validate table, else return structured errors

    valid keys:
        Reason, Message, Message.Format, Message.Parameters and Detail

    parameterSet
        = [ Message ] or [ Message.Format and Message.Parameters ]

    ref/docs/tuts
        - https://bengribaudo.com/blog/2020/01/15/4883/power-query-m-primer-part-15-error-handling
        - https://docs.microsoft.com/en-us/powerquery-m/text-format

    */

    primaryKeys = {"CustomerId", "RegionId" },

    isDistinct = Table.IsDistinct( Source, primaryKeys ),
    // record with most of the possible fields
    errMessage = [
            Reason = "InvalidDataException",
            Detail = "Too many records",
            Message.Format = "query #{0} was not distinct, for PrimaryKeys = { #{1} }",
            Message.Parameters = {
                Diagnostics.ActivityId(),
                Text.Combine( primaryKeys, ", ")
            } ],

    // return the source table if it's valid
    // else raise an exception using the "error" keyword
    finalTable =
        if isDistinct then Source
        else error errMessage,

    // if you catch the error, you can drill down into "Message.Parameters" values
    example_with_catch = try finalTable catch (e) => e,
    finalResult = finalTable
in
    finalResult