let
    GlobalCulture = Culture.Current,
    Json     = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("JcsxDoAgEETRu1DbCCQehlCoGYVmUUBFTi+s5bzMN0bkJ4zkCcIORsDvrkF2ET/MyxoIkqG8la20B0Ft4Yq8dc+5TLhBkrG2SyepNO/pOGPKyZcMkLD2Aw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    Source_Part2_Input0  = Table.TransformColumnTypes(Json,{{"Text", type text}}),
    Source = Source_Part2_Input0,

    // Source1  = Day01_Input2,
    digits   = List.Transform({ 0..9 }, Number.ToText ),
    wordMapping = {
        { "zero", "0" },
        { "one",  "1" },
        { "two",  "2" },
        { "three","3" },
        { "four", "4" },
        { "five", "5" },
        { "six",  "6" },
        { "seven","7" },
        { "eight","8" },
        { "nine", "9" }
    },

    // edit: I should have read the whole question. order of replacement matters, because partial-number names exist, and overlap
    Text.TransformWordNumbers_0 = (source as text) as text => [
        lowercase = Text.Lower( source ),
        return =
            List.Accumulate(
                wordMapping, lowercase,
                (state, current) => Text.Replace( state, current{0}, current{1} )
            )
    ][return],


    wordNames = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"},
    Text.FindEachPotentialMatch = (source as text) as any => [
        query = List.Transform(
            wordNames,
            (currentWord) =>
                [
                    Word = currentWord,
                    Position = Text.PositionOf( source, currentWord, Occurrence.First, Comparer.OrdinalIgnoreCase )
                ]
        ),
        dropNonMatches = List.Select( query, each [Position] <> -1 ),
        sorted = List.Sort( dropNonMatches, each [Position] ),
        // querySchema = type [ word = Text.Type, position = Int64.Type ],
        // querySchema = null,
        // return = Value.ReplaceType( query, querySchema ) meta [
        //     Description = "A table of the first index of matching text. Negative 1 means never found"
        return = sorted
    ][return],

    // returns first+last merged, as one number
    Text.FindFirstLastDigits = ( source as text ) as number => [
        first = Text.PositionOfAny( source, digits, Occurrence.First ),
        last = Text.PositionOfAny( source, digits, Occurrence.Last ), chars = Text.ToList(source),
        textNumber = chars{first} & chars{last},
        return = Number.FromText( textNumber, null )
    ][return],

    // t = Table.AddColumn( Source, "FirstLast",

    //     Number.Type
    // ),
    ReplaceWords = Table.AddColumn(
        Source, "NumberWord",
        (row) => Text.TransformWordNumbers_0( row[Text]  ),
        Text.Type
    ),
    FirstLast = Table.AddColumn(
        ReplaceWords, "FirstLast",
        (row) => Text.FindFirstLastDigits( row[NumberWord] ),
        type any
    ),

    // sample = "one four one",
    // finalSum = List.Sum( t[FirstLast] ),
    Summary = [
        ReplaceWords = ReplaceWords,
        FirstLast = FirstLast,
        SampleT = Source,
        SampleText2 = Source{0}[Text],


        step1_start        = "o eightwothree",
        step1_TryFind      = Text.FindEachPotentialMatch( step1_start ),
        step1_TryFind_t    = Table.FromRecords( step1_TryFind ),
        step1_ReplaceToken = step1_TryFind{0}[Word],                                              //{0}[Word],
        step1_ReplaceStr   = "8",
        step1_End          = Text.Replace( step1_start, step1_ReplaceToken, step1_ReplaceStr ),

        step2_start        = step1_End,
        step2_TryFind      = Text.FindEachPotentialMatch( step2_start  ),
        step2_TryFind_t    = Table.FromRecords( step2_TryFind ),
        step2_ReplaceToken = step2_TryFind{0}[Word],                                             //{0}[Word],
        step2_ReplaceStr   = "8",
        step2_End          = Text.Replace( step2_start, step2_ReplaceToken, step2_ReplaceStr ),



        tryFind_T =
            Table.FromRecords( step1_TryFind )
        // Input_Part1 = Source1,
        // Input_Part0 = Source0,
        // Output_Table_Part1 = t,
        // s = sample,
        // Answer_Part1 = finalSum
    ]

in
    Summary