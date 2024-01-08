let
    /*
    original: <https://github.com/ninmonkey/ninMonkQuery-examples/blob/ce4979d0c21af3cbc27d5c36d10c502a256bdc49/Types/pq/DeclaringNestedTypes-ListsAsIntegers.pq#L0-L1>
    About:
        showing correct and incorrect types

    Apply this query, and go to the model view.

things to notice:
    - It might pop up saying there are were errors, but it'll let you apply the query to your model
    - In PowerQuery
        - there are no visible errors in your cells (or rows)
        - the column-type icon shows [NotReallyInt] is an [Int64.Type]

    - Once you apply the model
        - [NotReallyInt] loaded as an integer [Whole number]
        - a bunch of values were dropped. anything not an integeter loaded as nulls
        - so now you have a bunch of blanks in your data

    - compare that with [EnforcedInt] which imports all values correctly

    */

    Source = #table( type table [Raw = number], { {12.3}, {40.5}, {3.14156} }),
    schema_NumList = type { number },
    schema_IntList = type { Int64.Type },
    t0 = Table.AddColumn(
        Source, "DoubleNum", (row) as list =>
            { 1, 2, row[Raw]*2 }, ( type { number } ) ),

    t1 = Table.AddColumn( t0, "EnforcedInt",
        (row) as list =>
            List.Transform( { 1, 2, row[Raw]*2 }, (item) as number => Int64.From( item ) ),
            schema_IntList ),

    t2 = Table.AddColumn( t1, "NotReallyInt",
        (row) as list =>
            { 1, 2, row[Raw]*2 },
            schema_IntList ),

    #"step1_beforeExpand" = t2,

    #"Expanded DoubleNum" = Table.ExpandListColumn( #"step1_beforeExpand", "DoubleNum"),
    #"Expanded EnforcedInt" = Table.ExpandListColumn(#"Expanded DoubleNum", "EnforcedInt"),
    #"Expanded NotReallyInt" = Table.ExpandListColumn(#"Expanded EnforcedInt", "NotReallyInt")
in
    #"Expanded NotReallyInt"
