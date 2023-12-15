let
    // Path = "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\Day-01-Part2-FirstAndLastoccurrence-AsWords-OfNumber.pq",
    EvalQuery = (filePath as text, optional options as nullable record) as any => [
        encoding = options[Encoding]? ?? TextEncoding.Utf8,
        environment = options[Environment]? ?? #shared,
        bytes = File.Contents(filePath),
        lines = Text.FromBinary( bytes, encoding ),
        return = Expression.Evaluate( lines, environment )
    ]
    // bytes = File.Contents(Path),
    // a = Text.FromBinary(bytes, TextEncoding.Utf8 ),
    // eval = Expression.Evaluate( a, #shared )
in
    EvalQuery