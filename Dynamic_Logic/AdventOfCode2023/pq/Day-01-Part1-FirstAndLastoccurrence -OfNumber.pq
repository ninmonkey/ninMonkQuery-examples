/*
Question: https://adventofcode.com/2023/day/1
Input 1:

    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
*/
let

    Json     = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMkxMSjZSitWJViooLDIuLim1KCuvAPMTDZOMko1TTFJN08D8kqLUJPPS5IzUEqXYWAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    Source0  = Table.TransformColumnTypes(Json,{{"Text", type text}}),
    Source1  = Day01_Input1,
    digits   = List.Transform({ 0..9 }, Number.ToText ),

    // returns first+last merged, as one number
    Text.FindFirstLastDigits = ( source as text ) as number => [
        first = Text.PositionOfAny( source, digits, Occurrence.First ),
        last = Text.PositionOfAny( source, digits, Occurrence.Last ), chars = Text.ToList(source),
        textNumber = chars{first} & chars{last},
        return = Number.FromText( textNumber, null )
    ][return],

    t = Table.AddColumn( Source1, "FirstLast",
        (row) => Text.FindFirstLastDigits( row[Text] ),
        Number.Type
    ),
    finalSum = List.Sum( t[FirstLast] ),
    Summary = [
        Input_Part1 = Source1,
        Input_Part0 = Source0,
        Output_Table_Part1 = t,
        Answer_Part1 = finalSum
    ]

in
    Summary