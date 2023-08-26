// Log
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("vZbdc+I2EMD/FQ19SaexYskYDH0JBabJTHJNY/rSyw0jbAUEtuSTZAzX6f9eCWPzcb7k0mbKA3j2S7ur3R/++LH1F3hq6W1Gn1p9+/TUurQ/LKV3Yj6ncSnGLvYcFzvYAyjou27f6/zkms/B+vec5k3WXh/5fYSOrIVk89JuVawYk4lciucNWcr5OuOaw+WCreL0ukCwIClhCZUwEmnpK6NMl74zMbumG5JmCT2oxUFfCmLFB5FmgpfCmCZka7Pc60JNdK5KXRsi6IKLnK+4KDggcSypUo40LprGQO1Mf6xdR4zsq1Cpzn5uYwTKCG2IO9DrwR4Gk4UUWifG2wFabgGZE8aBjScheEgoURQoSsFC60z1r64yoXRKlC4rjswT5FRf2QMcKqWQTiRiqmC2yH54vLMddb06oXtNynzSDY7QcQBw0etA5GKIAojavX0NM5HziA7JSb+UjCb1LNhza3EdnmSZkykGLpALu6bkjgt9t+pLsm5yN+JQ5DKit1mpQl0MsQtdk1VtMaJKM07sZVVmJ2nXhmMbeLA2k0Fmyf6s8YebwYfheBROBpM/wuFvo3F4GfxyO7m/vR9fhrd/mq/J4HEyuQsPGbEv9Lj0dVpVWCBvWo3etJ6tpZjdVvPtBx2/XYopX1fiUvDZLkIpOL7E5qD20AchkpOZNU1M1IMZHRFVGpP4GkF8bDBk2YLKffnD0c3YeQwHzmAcYr/j/Dq8d8KbgRfss1xQEptzN06UKy1SKh22Tzp58w7WsRJaBTH3iYJu2wu6ZyamaV+3rNaSKDJDuB9AhIPOmZ5xs3VmSEsDM3TZmUEmmaGJ3lbb/UzyRJ/ZrJnUOUmc+nrPY+SS2ltyooTRKhnCzfYXqlgQqS08mj0U5THjc5ZVBKk2/9tH5Ha792O27+yuseDv1qfLcxjP3hvGpbXfDGNYxF8S/nm2TJRI0+WiUEzS7XJNVrP02qaKoRJcpITTIqUxI++G5Wfbh2Yq+wYSOyqby2X8dQ77vgseqdlBZaFNdocALjTQZEV5H9g6ZmIDzvIEOScHonxNVBdB67kzvTDUw24AfYjxO7A0ZfEJS/FbWdrpQezblF6h6VHaL7L0X3NzNyPT0xlp5GeAfOyi1/lZtfzq5chvg6h3bHAMUaOeGnxODT+nhp/T7+Tnf1ibBpKa9wgXBajrfZOkx81rJmngey+C1Ezc+v8CaSI0qsbyOwDqtaF5NUDu+T9BM0FP+1pz9NM/", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"RawText", type text}}),
    /*
    Example input:
        "smtp;421 4.1.0 4.26.39.92 Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003",
    Output:
        4.26.39.92
    */
    ExtractIP = (input as text) =>
        let
            segments = Text.Split(input, " "),
            message = segments{2}
        in
            message,


    /*
    Example input:
        "smtp;550 Requested action not taken: mailbox bob@example.com unavailable"
    Output:
        mailbox bob@example.com unavailable
    */
    ExtractEmail = (input as text) =>
        let
            segments = Text.Split(input, ":"),
            mail = List.LastN( segments, 1 ){0}?
        in
            mail,
    AddJsonCol = Table.AddColumn(
        #"Changed Type", "Json",
        (row) =>
            try Json.Document( row[RawText] )
            catch (e) => e, Record.Type
        ),
    AddColType = Table.AddColumn(AddJsonCol , "Type", (row) => row[Json][type], type text),

    GetEventMessage = Table.AddColumn(
        AddColType, "Target",
        (row) =>
            if row[Type] = "t"
            then ExtractIP( row[Json]?[dsnDiag]? )
            else ExtractEmail( row[Json]?[dsnDiag]? ),

        type text )
in
    GetEventMessage