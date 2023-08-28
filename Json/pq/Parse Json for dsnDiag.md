[Return](../readme.md)

- [Part 2 with Automatic Unit Tests to validate results](#part-2-with-automatic-unit-tests-to-validate-results)
- [Original Answer](#original-answer)


## Part 2 with Automatic Unit Tests to validate results

- See the Report [Parse Json for dsnDiag.pbix](../Parse%20Json%20for%20dsnDiag.pbix)
  
How can you replace all IP addresses with the string literal `a.b.c.d` ? 
etc. When I look at

> smtp;421 4.1.0 4.26.39.92 Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003

I notice a prefix that stays the same if I split by a space. I'll use indices, so it will not break when there's a variable number of spaces in the rest of the text.

```md
1. smtp;421
    <space>
2.  4.1.0
    <space>
3. 4.26.39.92
    <space>
4. Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003
```
<!-- 
```ts
    Text.BeforeDelimiter(source, " ", 1)
    Text.AfterDelimiter(source, " ",  2)
``` -->
All that's left is a join`Text.Combine( {...}, " " )`

```ts
let
    // updated with a new request: replace all ips with the literal "a.b.c.d"
    TextReplaceIP = ( source as text ) as text =>
        let
            head = Text.BeforeDelimiter( source, " ", 1 ),
                // is => smtp;421 4.1.0
            tail = Text.AfterDelimiter( source, " ", 2),
                // is => Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003
            joined = Text.Combine( { head, "a.b.c.d", tail }, " " )
        in  joined,

    cases = {[
            IsGood = Actual = Expected,
            Input = "smtp;421 4.1.0 4.26.39.92 Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003",
            Expected = "smtp;421 4.1.0 a.b.c.d Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003",
            Actual = TextReplaceIP( Input )
        ], [
            IsGood = Actual = Expected,
            Input = "smtp;421 4.1.0 128.1.128.1 Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003",
            Expected = "smtp;421 4.1.0 a.b.c.d Throttled - try again later. Please see https://postmaster.comcast.net/smtp-error-codes.php#RL000003",
            Actual = TextReplaceIP( Input )
        ]},

    unit_schema = type table [ IsGood = Logical.Type, Input = text, Expected = text, Actual = text ],
    Summary = Table.FromRecords(cases, unit_schema)
in
    Summary
```

Check out these related functions: `Splitter.SplitTextByAnyDelimiter`, `Splitter.SplitTextByDelimiter`, `Splitter.SplitTextByEachDelimiter`, `Text.AfterDelimiter`, `Text.BeforeDelimiter`, `Text.BetweenDelimiters` . Many have optional parameters that gives you even more control.

Adding a simple position or count can create a reliable, simple method of splitting. Look for optional parameters with names like these: `index`, `startIndex`, `endIndex`, `occurrence`, relativePositions, 

## Original Answer

How can you extract the IP address from the following JSON ? 

```json
{ "type": "t", "timeLogged": "2023-02-23 18:00:36+0000", "timeQueued": "2023-02-23 13:15:11+0000", "orig": "jhikdm@w1.foo.com", "rcpt": "bob@example.com", "orcpt": "", "dsnAction": "delayed", "dsnStatus": "4.1.0 (unknown address-related status)", "dsnDiag": "smtp;421 4.1.0 4.26.39.92 Throttled - try again later. Please see https:/foo.net/smtp-error-codes.php#RL000003", "dsnMta": "mx2c1.foo.net (96.102.18.149)", "bounceCat": "", "srcType": "smtp", "srcMta": "app-psi (10.74.160.50)", "dlvType": "smtp", "dlvSourceIp": "172.20.0.10", "dlvDestinationIp": "96.102.18.149", "dlvEsmtpAvailable": "ENHANCEDSTATUSCODES,8BITMIME,SIZE,STARTTLS", "dlvSize": "", "vmta": "w13_wamailer_com", "jobId": "258654", "envId": "", "queue": "foo.net/w13_wamailer_com", "vmtaPool": "", "dlvTlsProtocol": "TLSv1.2", "dlvTlsCipher": "ECDHE-RSA-AES256-GCM-SHA384", "header_x-customer-id": "lwkiirlrjofxajrgvpntn.foo.com", "header_x-leid": "1721874387", "header_x-job": "258654", "header_x-account": "1286", "header_x-instance": "psip", "header_x-priority": "default", "header_x-virtual-mta": "", "header_x-purecast-client": "johnsmith", "header_x-purecast-sendingip": "4.26.39.92", "header_x-purecast-cluster": "foobar" }
```

![screenshot](../img/Parse%20Json%20for%20dsnDiag.png)

```ts
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
```