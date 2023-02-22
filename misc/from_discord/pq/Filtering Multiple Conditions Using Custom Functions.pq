let
    Source = ...,
    // not used: A Case insensitive version of Text.Contains()
    Text.IContains = (source as text, substring as text) as logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),

    // see more: <https://learn.microsoft.com/en-us/powerquery-m/text-functions>
    IsValidCode = (source  as text) as logical =>
        let
            Len = Text.Length(source),
            Is3Digits = Len = 3,
            FirstLetterIsANumber =
                try true = Number.FromText(Text.At(source, 0))
                    catch (e) => false,

            errMessage = error [
                Message.Format = "InvalidCodeException: Input = #{0}#, Len = #{1}, FirstIsNumber = #{2}#",
                Message.Parameters = {
                    source, Len, FirstLetterIsANumber
                }],

            Result =
                if Is3Digits and FirstLetterIsANumber then true
                else errMessage
        in
            Result,


    AddCol_IsValidID = Table.AddColumn(
        Source, "IsValidID",
        (row) => IsValidCode( row[ID] ), Logical.Type )
in
    AddCol_IsValidID
