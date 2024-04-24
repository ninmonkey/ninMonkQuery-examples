original question: <https://www.reddit.com/r/PowerBI/comments/1brmxet/split_lines_in_excel_and_delimiters_in_power_query/>

The problem causing duplicates is from splitting and expanding in multiple steps. 

There's a different function you can call named `Table.TransformRows`
That lets you modify multiple columns in one pass. Here's the full code:

- [Final results screenshot.png](https://raw.githubusercontent.com/ninmonkey/ninMonkQuery-examples/main/forumQuestions/img/2024-03_SplitExcelNewlines.png)
- [SplitExcelNewlines.pq](https://github.com/ninmonkey/ninMonkQuery-examples/blob/5e0b338b6d211c4e712b0819588f83c90f014256/forumQuestions/pq/2024-03_SplitExcelNewlines.pq#L19-L56)
- [SplitExcelNewlines.pbix](https://github.com/ninmonkey/ninMonkQuery-examples/blob/5e0b338b6d211c4e712b0819588f83c90f014256/forumQuestions/2024-03_SplitExcelNewlines.pbix)

### Importing multiple date formats

As a bonus: I wrote a function that imports both date formats in your example

    try Something catch (e) => // ... handler function

It's better than `try otherwise` because you can optionally return any value, including the original error record. Like `null meta [ info = e ]` 

### The Main Code

- Split each column by a newline
- then generate a list of N records, using position and expanding the PartId

    ExpandRows = (row as record) as any => [
            Delim = "#(lf)", // some apps use #(cf,lf) instead
            invoiceList = Text.Split(row[Invoice], Delim ),
            qtyList     = Text.Split( row[Qty], Delim ),
            datesList   = Text.Split( row[Expected], Delim ),

            totalRecords = List.Max({
                List.Count(invoiceList),
                List.Count(qtyList),
                List.Count(datesList)
            }),
            
            return = List.Transform(
                { 0..(totalRecords - 1) },
                (num) => [
                    Part        = partId,
                    Invoice     = invoiceList{ num }?,
                    Qty         = qtyList{ num }?,
                    Expected    = datesList{ num }?,
                    LineNumber  = num
                ]
            )
        ][return]