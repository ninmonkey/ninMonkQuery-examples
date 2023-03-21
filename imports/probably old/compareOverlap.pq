
// This file contains your Data Connector logic
section compareOverlap;

[DataSource.Kind="compareOverlap", Publish="compareOverlap.Publish"]
shared compareOverlap.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from compareOverlap: " & _message
    in
        a;

// Data Source Kind description
compareOverlap = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
compareOverlap.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = compareOverlap.Icons,
    SourceTypeImage = compareOverlap.Icons
];

compareOverlap.Icons = [
    Icon16 = { Extension.Contents("compareOverlap16.png"), Extension.Contents("compareOverlap20.png"), Extension.Contents("compareOverlap24.png"), Extension.Contents("compareOverlap32.png") },
    Icon32 = { Extension.Contents("compareOverlap32.png"), Extension.Contents("compareOverlap40.png"), Extension.Contents("compareOverlap48.png"), Extension.Contents("compareOverlap64.png") }
];










//
// Load common library functions
//
// TEMPORARY WORKAROUND until we're able to reference other M modules
Extension.LoadFunction = (name as text) =>
    let
        binary = Extension.Contents(name),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);

//Table.ChangeType = Extension.LoadFunction("Table.ChangeType.pqm");
//Table.GenerateByPage = Extension.LoadFunction("Table.GenerateByPage.pqm");
//Table.ToNavigationTable = Extension.LoadFunction("Table.ToNavigationTable.pqm");

// Diagnostics module contains multiple functions. We can take the ones we need.
Value.ToText = Diagnostics[Value.ToText];
Diagnostics = Extension.LoadFunction("diagnostics.pq");
Diagnostics.LogValue = Diagnostics[LogValue];
Diagnostics.LogFailure = Diagnostics[LogFailure];