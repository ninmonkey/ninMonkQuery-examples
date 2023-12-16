let
    Csv = lib[Csv],
    xray = lib[XRay],
    Text.ReplaceFirst = lib[Text.ReplaceFirstOnly],
    // Source1  = Day01_Input2,
    // digits   = List.Transform({ 0..9 }, Number.ToText ),
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
    ll = List.Generate(
        () => [
            x = 1,
            y = {}
        ],
        each [x] < 10,
        each [
            x = List.Count( [y] ),
            y = [y] & {x}
        ],
        each _
    ),
    ll2 = List.Generate(
        () => [
            str = "cat dog",
            words = {"dog", "cat"},
            found = null,
            firstWord = ""
        ],
        each List.Count( [words] ) < 4,
        each [
            // str = List.Count( [words] ),
            str =
                Text.ReplaceFirst( [str], [words]{0}, "_" ),
                // [str],

            words = [words] & {str},
            found = Text.FindNextPotentialMatchList( [str], [words] ),
            firstWord = found{0}
        ],
        each _
    ),
    Summary = [
        a = 1,
        w = wordMappingPair,
        w_ = xray(w),
        ll = ll,
        ll_t = Table.FromRecords( ll ),
        ll_t_t = Table.AddColumn( ll_t, "xray", each xray( [y] ), type text ),

        ll2 = ll2,
        ll2_t = Table.FromRecords( ll2 ),
        ll2_t_t = Table.AddColumn( ll2_t, "xray", each xray( [firstWord] ), type text ),
        zoom = ll2_t_t
    ]
in
    Summary[zoom]