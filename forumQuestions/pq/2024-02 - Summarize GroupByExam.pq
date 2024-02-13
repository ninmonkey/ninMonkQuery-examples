// Exams
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45W8k4syahU0lEyNwAShkDsl68Uq4MQtzAFEkZAHJlajCJhCdJgjNDglJoHUmmMagxE1NQCagiKqKUl1ASY0RBhQwOQySYI1cElqWWpIKdYQs2GqYdJWKK4MRYA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, Score = _t, #"Exam number" = _t, Proctored = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Name", type text}, {"Score", Int64.Type}, {"Exam number", Int64.Type}, {"Proctored", type text}})
in
    #"Changed Type"

// FirstProc
let
    Source = Exams,
    filter_proctored = Table.SelectRows(Source, each ([Proctored] = "Yes")),
    sortby_first = Table.Sort(filter_proctored,{{"Exam number", Order.Ascending}}),
    ensure_sorted = Table.StopFolding( sortby_first ),
    #"distinct_ proctored" = Table.Distinct( ensure_sorted, {"Name"} )
in
    #"distinct_ proctored"
