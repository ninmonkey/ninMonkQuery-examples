let
    Csv = lib[Csv],
    xray = lib[XRay],
    GlobalCulture = Culture.Current,
    Json     = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("JcsxDoAgEETRu1DbCCQehlCoGYVmUUBFTi+s5bzMN0bkJ4zkCcIORsDvrkF2ET/MyxoIkqG8la20B0Ft4Yq8dc+5TLhBkrG2SyepNO/pOGPKyZcMkLD2Aw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    Source_Part2_Input0  = Table.TransformColumnTypes(Json,{{"Text", type text}}),
    Source = Source_Part2_Input0,

    // Source1  = Day01_Input2,
    digits   = List.Transform({ 0..9 }, Number.ToText ),
    wordMappingPair = {
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
                wordMappingPair, lowercase,
                (state, current) => Text.Replace( state, current{0}, current{1} )
            )
    ][return],


    wordNames = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"},
    Text.FindEachPotentialMatch_0 = (source as text) as any => [
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

    // Search a subset of words, skipping any that can't match again
    Text.FindNextPotentialMatchList = (source as text, words as list ) as any => [
        query = List.Transform(
            words,
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

    // replaces one single instance of a word, then ends

    Text.ReplaceFirstOnly = (source as text, oldValue as text, newValue as text) as text => [
        found = Text.PositionOf( source, oldValue, Occurrence.First, Comparer.OrdinalIgnoreCase ),
        replaced = Text.ReplaceRange( source, found, Text.Length( oldValue ), newValue ),
        return =
            if found = -1 then source
            else replaced
    ][return],
    Text.PositionOf.CI = (source as text, substring as text,
        optional occurrence as nullable number,
        optional comparer as nullable function) as any => [
            occurrence = options[Occurrence]? ?? Occurrence.First,
            comparer = options[Comparer]? ?? Comparer.OrdinalIgnoreCase,
            ret = Text.PositionOf( source, substring, occurrence, comparer )
        ][ret],


    Text.ReplaceLastOnly = (source as text, oldValue as text, newValue as text) as text => [
        found = Text.PositionOf( source, oldValue, Occurrence.Last, Comparer.OrdinalIgnoreCase ),
        replaced = Text.ReplaceRange( source, found, Text.Length( oldValue ), newValue ),
        return =
            if found = -1 then source
            else replaced
    ][return],


    Summary = [
        newVal = Record.FieldOrDefault( wordMap, "one", ""),
        af = List.First( List.Select( wordMappingPair, each _{0} = "one" ) ),
        s00 = "one two three two one one",
        // s01 = Text.ReplaceFirst( s00, "two", "2"),
        s01 = Text.ReplaceFirstOnly( "two one two three", "two", "2"),
        state0 = [
            str = s00,
            wordNames = wordNames
        ],
        find0 = Text.FindNextPotentialMatchList( state0[str], state0[wordNames] ),
        find0_ = xray(find0),
        replaceK = find0{0}[Word],
        replaceV = Record.FieldOrDefault( wordMap, replaceK, ""),
        // replace0 = Text.ReplaceFirstOnly( state0[str], find0{0}[Word], "_" ),
        replaced = Text.ReplaceFirstOnly( state0[str], replaceK, replaceV ),
        state1 = [
            str = s01,
            wordNames = wordNames
        ],

        s0 = xray( state0 ),
        s1 = xray( state1 )

    ],
    wordMap = [
        zero = "0",
        one = "1",
        two = "2",
        three = "3",
        four = "4",
        five = "5",
        six = "6",
        seven = "7",
        eight = "8",
        nine = "9"
    ],

    Summary2 = [

        // newVal = Record. Value( wordMap, "one" ),
        s00 = "one two three two one one",
        // s01 = Text.ReplaceFirst( s00, "two", "2"),
        s01 = Text.ReplaceFirstOnly( "two one two three", "two", "2"),
        cur_text0 = "oeighttwofiveight",
        cur_words0 = wordNames,
        words0 = Csv( cur_words0 ),
        query_0 = Text.FindNextPotentialMatchList( cur_text0, cur_words0 ),
        query_0_ = xray(query_0),
        Then = [
            replaceToken = query_0{0}[Word],
            s = Text.Replace
        ],

        query_1 = Text.FindNextPotentialMatchList( cur_text0, cur_words0 ),


        t_0 = Table.FromRecords( query_0 ),
        t_0_ = xray(t_0),
        cur_words1 = t_0[Word],
        words1  = Csv( cur_words1  )
    ],


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
    SummaryLong = [
        ReplaceWords = ReplaceWords,
        FirstLast = FirstLast,
        SampleT = Source,
        SampleText2 = Source{0}[Text],


        step1_start        = "o eightwothree",
        step1_TryFind      = Text.FindEachPotentialMatch_0( step1_start ),
        step1_TryFind_t    = Table.FromRecords( step1_TryFind ),
        step1_ReplaceToken = step1_TryFind{0}[Word],                                              //{0}[Word],
        step1_ReplaceStr   = "8",
        step1_End          = Text.Replace( step1_start, step1_ReplaceToken, step1_ReplaceStr ),

        step2_start        = step1_End,
        step2_TryFind      = Text.FindEachPotentialMatch_0( step2_start  ),
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