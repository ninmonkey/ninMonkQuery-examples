<!-- <a name='top'></a> -->


[Root](https://github.com/ninmonkey/ninMonkQuery-examples) | [Up ⭡](./../readme.md)

Questions from Discord:  <a href="./from_discord/readme.md">From Discord: Multiple Nested Conditions with `Switch()`, Finding Distinct Pairs, ...</a>

----

- [Replacing Text](#replacing-text)
  - [Usage:](#usage)
- [Add "Is A Valid Record" column](#add-is-a-valid-record-column)


## Replacing Text

For text that matches a partial string, replace the entire contents

![screenshot](./img/Replacements%20using%20Mapping%20Table.png)

- [Replace Partial Matches with Mapping Table.pbix](./Replacements%20using%20Mapping%20Table.pbix)
- [Text.ReplacePartialMatch.pq](./pq/Replacements%20using%20Mapping%20Table.function%20-%20Text.ReplacePartialMatches.pq)
- [main query.pq](./pq/Replacements%20using%20Mapping%20Table.query%20-%20main.pq)
<!-- - [mapping table.pq](./pq/Replacements%20using%20Mapping%20Table.query%20-%20mapping%20table.pq) -->

### Usage:

```typescript
let
    Source = ...,
    #"Replace With Mapping" = Table.AddColumn(Source, "Clean Name",
        (row) => Text_ReplacePartialMatch(
                row[Raw Name], #"Mapping Table"),
            type text)
in
    #"Replace With Mapping"
```

## Add "Is A Valid Record" column

![screen](./img/Lookup%20Permissions%20in%20a%20Dimension%20Table%20--%20PQ%20Calculated%20Columns.png)

- Report: [Lookup Permissions in a Dimension Table.pbix](./Lookup%20Permissions%20in%20a%20Dimension%20Table%20--%20PQ%20Calculated%20Columns.pbix)
- Power Query:[Lookup Permissions in a Dimension Table.pq](./pq/Lookup%20Permissions%20in%20a%20Dimension%20Table%20--%20PQ%20Calculated%20Columns.pq.md)


 <!-- [Top ⭡](#top) -->

<!--

- [Text.ReplacePartialMatch.pq](./pq/Text.ReplacePartialMatch.pq)
- [Report.pbix](https://github.com/ninmonkey/ninMonkQuery-examples/blob/main/misc/Replacements%20using%20Mapping%20Table.pbix?raw=true) 
- ![Text.ReplacePartialMatch.mp4](./img/Text.ReplacePartialMatch.mp4)
-->

<!--
- [Report.pbix](./Replacements%20using%20Mapping%20Table.pbix) -->


<!-- https://user-images.githubusercontent.com/3892031/191777597-0dbda18e-dcf0-4915-84b6-7e5cf7129332.mp4
 -->


<!-- markdown mp4 on github only show if it's a bare url, or, if it's in a bug report issue, but not readme file.  -->
<!-- ![img func vid](./img/Text.ReplacePartialMatch.mp4) -->

