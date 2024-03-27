This started as a [/r/powerbi thread](https://www.reddit.com/r/PowerBI/comments/1bp0uxl/what_do_you_use_custom_power_query_m_functions_for/)


## About:

A function I've found useful to simplify code when converting text is the splitter named `ByEachDelimeter` verses the `ByAnyDelimiter`

Splits are more deterministic because
- they must split in the exact same order, else it fails
- it must split exactly the number of segments + 1 times

```pq
Employee = ConvertText.ToEmployee( "last, first,12345,bob@smith.com" ),
ConvertText.ToEmployee = ( source as text ) as record => [
    SplitRevCsv = Splitter.SplitTextByEachDelimiter({",",","}, QuoteStyle.Csv, true),
    crumbs = SplitRevCsv( source ),            
    return = [
        Fullname = crumbs{0},
        Id = Number.FromText( crumbs{1} ),
        Email = crumbs{2}
    ]
][return]
```

outputs:

| FullName        | Id      | Email             |
| --------------- | ------- | ----------------- |
| `"last, first"` | `12345` | `"bob@smith.com"` |
