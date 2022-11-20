let
    /* this is the script that you are importing */
    x = {0..20},
    y = {"a".."e"},
    summary = [
        Activity = Diagnostics.ActivityId(),
        Now = DateTime.LocalNow()
    ],
    schema = type table [Activity = text, Now = datetime],
    t = Table.FromRecords({summary}, schema, MissingField.Error)
in
    t
