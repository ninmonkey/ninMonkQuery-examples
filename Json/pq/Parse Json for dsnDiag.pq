// Log
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("vZVtc9o4EMe/ioZ7k87FiiVjMPRNOGAuzCS9XMy9adNhZFsBgS25ksxDb+67n4SxeShpmk6mvDCe3f+uVqvVz58+Nf4Fjw29yeljo2vfHhuX9o9l9FZMpzQpzdjFnuNiB3sABV3X7Xqt313z26v/LmhxTu11kd9F6EAtJJuWuvmMLZLseoXgkxAwFlkpkHGuS0Ekomu6Jlme0r1b7P2lIVG8F2smeGlMaEo2tpSdL9REF6r0NSGCLrgo+IKLFQckSSRVypEmRNMEqK30XR06YGRXqsp0/r6JESgzNCFuQa8DOxiMZ1JonZpoB2i5AWRKGAc2n4TgPqVEUaAoBTOtc9W9sjvlVF/ZhA6VUkgnFglVMJ/lvz3c2ja5Xl3AnSbl+tkax2WbTDC46LQgcjFEAUTNzq7eSBQ8pn1y1Bsl43F9uHbN2lynJnnu5IqBC+TCttley4W+W/UgXZ4LN+ZQFDKmo7x0oTaG2IWuqapWDKjSjBN7MJXsqOxaOLSJe0vCUhKlu7WGH256H/rDQTjujf8J+38NhuFl8MdofDe6G16Go4/mMe49jMe34b4i9pUebn2ZVTtcIW+yIplZgMpJPUdzEY2qgfWDlt8szZQvK3Np+GInuzRUh3c+oV3wXoj0aDZNA1N1b0ZExJXHFL1EEB8K+iyfUbnben9wM3Qewp7TG4bYbzl/9u+c8KbnBbsKZ5QkZt21ExdKi4xKh+0KTlcLxmQq5+JpTeZyusy55seXqw5OaRVlDg8F7aYXtE8kpkPf9qf2kjg2E7ebNoSD1omfcXOdzESWAjNh+Ykgl8ywQG+qa/tEilSfaJZM6oKkTn2WpzkKSWOitBOnjFbFzMWMq4zp2XNiRXnC+JTlFRWq2/x8dtPq6oBMPyNi3sF/jc+XpwCN3hqgpdo/C9AFXCVfU/4lmqdKZNl8tlJM0s18SRZRdm3nE78pWp/sxJ8nq28u/5as5hwZf5mlvu+CB2rulrLgJdtFABcaaLKgvAts8ZFYg5M6QcHJnhSnlLR7tYFb5YWBGXYD6EOM3wCRGUuOEIlfi8hWB2LflvQCJA/K/i4ifxqH27mYmF6dZWGAfOyil1lY9fnqTLrXkdA7FByS0LgnhoETA8GJgeDkByH42ktxBonmS++iALW9Z5F42KbzSAx877tENAO1/FVETIVG1dT9AA69JjQfdOSeIv1ZHm57aXn4+X8=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),
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