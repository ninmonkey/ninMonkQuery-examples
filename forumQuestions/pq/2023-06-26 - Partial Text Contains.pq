// Partial Text Compare
let
    // sample data, you can ignore this step
    Source = #table(
        type table[ Species = text ],
        List.Transform( { "Catdog", "elephant", "monkey", "CAT", "tiger" }, (item) => { item } )
    ),
    
    // I'm essentially defining a default value for the 3rd parameter
    Text.CaseInsensitiveContains = (source as text, substring as text) as logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),

    // You can create a shorter alias
    Text.ContainsCI = Text.CaseInsensitiveContains,
    
    // text for a list of substrings. always case-insensitive.
    Text.ContainsAnyCI = (source as text, substring as list) as logical =>
        let tests = 
            List.Transform(
                substring, (item) => 
                    Text.ContainsCI(source, item) )
        in List.AnyTrue( tests ),

    // another route you can go is roughly: List.MatchesAny( {"cat", "ele"}, (item) => Text.CaseInsensitiveContains( item )),
        
    wanted_substr = { "cat", "tiger"},
    
    Column_IsCat = Table.AddColumn( Source, "IsCat", 
        (row) => Text.ContainsAnyCI( row[Species], wanted_substr ), Logical.Type ),

    Column_IsDog = Table.AddColumn( Column_IsCat, "IsDog", 
        (row) => Text.ContainsAnyCI( row[Species], { "dog" } ), Logical.Type ),    

    Summary = [
        Source = Source,
        func = Text.CaseInsensitiveContains,
        Column_IsDog = Column_IsDog
    ],
    Column_IsDog1 = Summary[Column_IsDog]
in
    Column_IsDog1
