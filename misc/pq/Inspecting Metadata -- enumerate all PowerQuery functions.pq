let
    // #shared is a reference to all declared functions and queries. First,
    // ignore the current query, otherwise you can get an accidental cyclical references
    // because the current query is also in #shared
    ignore_queries = { "test_types", "fancy_types", "test_types_basic" },
    all_functions = #shared,
    
    // for this step, you might want to use MissingField.Ignore. Or keep it on if you want to make sure there's no errors in the names
    Source = Record.RemoveFields( all_functions  , ignore_queries, MissingField.Error ),     
    all_names = Record.FieldNames( Source ),
    // side note: technically there's more than functions in #shared

    // I used the caseinsensitive version of Text.Contains
    // it doesn't actually change anything with ".", but I like to put it in there by default
    totalCount_without = 
        List.Count(
            List.Select(
                all_names,
                each not Text.Contains(_, ".", Comparer.OrdinalIgnoreCase) )
        ),

    totalCount_withPeriods = 
        List.Count(
            List.Select(
                all_names,
                each Text.Contains(_, ".", Comparer.OrdinalIgnoreCase) )
        ),

    ToCsv = (source as list) as text =>
        Text.Combine( List.Transform( source, each Text.From(_) ), ", " ),


    Summary = [
        #"Ignored queries" = ToCsv( ignore_queries ),
        #"Number of symbols with '.'" = totalCount_withPeriods,
        #"Number without '.'" = totalCount_without,
        all_names = all_names,
        all_names_summary = ToCsv( all_names )
    ]
in
    Summary