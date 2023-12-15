let
    About = "shared helper functions",
    Text.ContainsCI = (source as text, substring as text) as logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase )
in
    Text.ContainsCI