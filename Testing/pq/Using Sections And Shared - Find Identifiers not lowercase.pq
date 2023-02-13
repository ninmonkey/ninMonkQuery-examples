let 
    // Curious whether PowerQuery names functions using all-lowercase valus
    // inspecting PowerQuery's code style. are any identifiers that
    localNamesToIgnore = Record.FieldNames( #sections[Section1] ),
    Source = Record.RemoveFields(  #shared, localNamesToIgnore, MissingField.Error ),         
    baseTable = Record.ToTable( Source ),

    // '=' operator is case-sensitive by default
    add_testIsOnlyLower = Table.AddColumn(
        baseTable, "OnlyHasLowercase",
        (row) =>
            row[Name] = Text.Lower( row[Name], "en-us" ), // as ci
            type logical
    ),
    add_testContainsDot = Table.AddColumn(
        add_testIsOnlyLower, "HasADot",
        (row) =>
            Text.Contains( row[Name], "." ),
            type logical
    ),

    // extra for fun: You can 'drill down' into this column to view function metdata on a value
    add_docString = Table.AddColumn(
        add_testIsOnlyLower, "Func Metadata", 
        (row) => [
            BaseValue = row[Value],
            FuncMeta        = Value.Metadata( BaseValue ),
            FuncType        = Value.Type( BaseValue ),
            FuncMeta2       = Value.Metadata( FuncType ) 
        ],
        Record.Type
    )        
in
    add_docString
