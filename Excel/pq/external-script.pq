let
    /* this is the script that you are importing */
    summary = [
        Activity = Diagnostics.ActivityId(),
        Now = DateTime.LocalNow(),
        Species = "🐒"
    ],

    schema = type table [
        Activity = text,
        Now = datetime,
        Species = text
    ],
    t = Table.FromRecords({summary}, schema, MissingField.Error)
in
    t
