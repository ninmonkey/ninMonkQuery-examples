<file:///H:\data\2023\BI\git\ninMonkQuery-examples\tabular\Text▸Generate%20SQL%20notation%20Column%20Names%20⁞%20of%20SelectedTable.csx>


### Basic join text

```csharp

/*
Output the Selected Table's ColumnNames  selected table's columns:
*/
string.Join(", ", 
    Selected.Table.DataColumns
        .OrderBy(c => c.SourceColumn)
        .Select(c => "[dbo].[" + c.SourceColumn + "]")
    ).Output();
```
Wrote
```sql
select [dbo].[Date], [dbo].[Day], [dbo].[Day Name], [dbo].[Day of Week], [dbo].[Day of Year], [dbo].[Month], [dbo].[Month Name], [dbo].[Year]
from
    [Dbo] Table?
```