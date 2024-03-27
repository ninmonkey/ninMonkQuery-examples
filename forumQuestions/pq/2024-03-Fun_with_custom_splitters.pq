// Part1
{ [
        Sample1 = "Us.East:1234,""Bob Smith"" stuff",
        Bad1    = "Us,East:1234,""Bob Smith"" stuff",
        Bad2    = "Us,East:1234,""Bob Smith"" stuff",

        SplitFn =  Splitter.SplitTextByEachDelimiter({".", ":", ",", " "}, QuoteStyle.Csv ),
        segments   = SplitFn( Sample1 ),
        /* output:
            East
            1234
            Bob Smith
            stuff
        */

        // all delimiters must be possible, and in the right order, or else it will not split
        ShouldNotSplit = 1 = List.Count( SplitFn( Bad1 ) ),

        /* here's the exact same input as the original split. the only difference is the QuoteStyle.
        output: This preserves qoutes in the output. it also caused the final " " split to split earlier than we wanted.

            East
            1234
            "Bob
            Smith" stuff

        */
        SplitFnWithoutQuote  = Splitter.SplitTextByEachDelimiter({".", ":", ",", " "}, QuoteStyle.None ),
        ShouldSplitNameWrong = SplitFnWithoutQuote( Sample1 ),

        Props = [
            Country = segments{0},
            Region = segments{1},
            EmployeeId = segments{2},
            FullName = segments{3},
            Description = segments{4}
        ]
    ],
// Part2
[
        Sample2 = "last, first,12345,bob@smith.com",
       /* outputs:
            [ Fullname = "last, first", Id = 12345, Email = "bob@smith.com" ]
        */
        Employee = ConvertText.ToEmployee( Sample2 ),
        ConvertText.ToEmployee = ( source as text ) as record => [
            SplitRevCsv = Splitter.SplitTextByEachDelimiter({",",","}, QuoteStyle.Csv, true),
            crumbs = SplitRevCsv( source ),
            return = [
                Fullname = crumbs{0},
                Id = crumbs{1},
                Email = crumbs{2}
            ]
        ][return],

        Sample1 = "Us East,1234,""Bob, Smith"",""Job Description""",
        SplitA         = Splitter.SplitTextByEachDelimiter({",", ","}, QuoteStyle.Csv ),
        /* outputs:
            Us East
            1234
            Bob, Smith,Job Description
        */
        SplitA_Reverse = Splitter.SplitTextByEachDelimiter({",", ","}, QuoteStyle.Csv, true ),
        /* outputs:
            Us East,1234
            Bob, Smith
            Job Description
        */

        segments   = SplitA( Sample1 ),
        segmentsReverse   = SplitA_Reverse( Sample1 ),

        /* output:
            East
            1234
            Bob Smith
            stuff
        */
        Props = [
            Country = segments{0},
            Region = segments{1},
            EmployeeId = segments{2},
            FullName = segments{3},
            Description = segments{4}
        ]
],
[

        Sample2 = "First, Last,""some description; multi statement""",
        /* fancy assert included: This split type will always have a length of delims+1 unless an expected delim wasn't found  */
        SplitAssert = ( delims as list, line as text, optional quoteStyle as nullable number, optional fromEnd as nullable logical) => [
            splitFunc   = Splitter.SplitTextByEachDelimiter( delims, quoteStyle ?? QuoteStyle.Csv, fromEnd ?? false),
            requiredLen = List.Count( delims ) + 1,
            actualLen   = List.Count( crumbs ),
            isValid     = actualLen = requiredLen,
            crumbs      = splitFunc( line ),
            zeroTotalSplits = actualLen = 1,
            return = if isValid then crumbs else error [
                Message.Parameters = {  List.Count(crumbs), requiredLen, line, Text.Combine( delims, ", ") },
                Message.Format = Text.Combine({
                    "SplitAssertException:", "Length is #{0}, Expected Length: #{1}!",
                    "Text = #{2}","Delims = { #{3} }"},
                    "#(cr,lf)    ")
            ]
        ][return],

        shouldError  = SplitAssert( {";", " "}, Sample2, QuoteStyle.Csv, false ),
        shouldError2 = SplitAssert( {",", ";"}, Sample2, QuoteStyle.None, true ),
        shouldBeOkay = SplitAssert( {";", ","}, Sample2, QuoteStyle.None, true )
]}