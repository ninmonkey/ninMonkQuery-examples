    // Query: LoadMySource
    let
        Load.Impl = (source as text) as text =>
            source,

        Load.Type = type function (
            input as (type text meta [
                Documentation.AllowedValues = GetFilePath,
                Documentation.FieldCaption = "Choose a file"
            ])
        ) as text meta [
            Documentation.Name = "LoadMySource",
            Documentation.LongDescription = "List my pbit/pbip/pix filepaths, as a drop down list"
        ]
    in
        Value.ReplaceType( Load.Impl, Load.Type )

    // Query: GetFilePath
let
    PathRoot = "H:\data\2023\BI\git\ninMonkQuery-examples\forumQuestions\import",
    FilesFound = Folder.Contents( PathRoot ),
    FilteredFiles = Table.SelectRows( FilesFound, each ([Extension] = ".pbip" or [Extension] = ".pbit" or [Extension] = ".pbix")),
    AbsolutePath = Table.AddColumn( FilteredFiles, "FullName", each [Folder Path] & [Name], Text.Type )
in
    List.Sort( AbsolutePath[FullName] )

