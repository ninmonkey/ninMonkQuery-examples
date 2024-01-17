- [\[ \] parameter assert: `assertAllowedKeys`](#--parameter-assert-assertallowedkeys)
- [\[ \] format that prefixes/predents](#--format-that-prefixespredents)


## [ ] parameter assert: `assertAllowedKeys`
    AllowedKeys = {"Reason", "Detail", "Message.Parameters", "Message.Format" },
  
## [ ] format that prefixes/predents

renders
```ts
MissingColumns: RequiredParameterMissingValues Columns:
    Wanted
        { Name, Location }
    Found
        { Name, ..., Id }
    Details:
        exact match not found ...
```
```ps1
'Wanted' | Predent 1
$wanted  | FmtList | Predent 2
'found'  | Predent 1
$found   | FmtList | Predent 2

or

JoinPre(1, {... items...} ),
JoinUL( {...items ... } )
JoinPredent
```
from this code
```ts
[ Message.Format = "RequiredParameterMissingValues ColumnNames: #(cr,lf)Wanted: #(cr,lf)    #{0}, #(cr,lf)Found: #(cr,lf)    #{1}", ... ]

[ 
                Reason = "MissingColumns",
                Details = "dsf",
                Detail = "Exact match for columns was not found. Check if capitalization or whitespace is different",
                Message.Format = "RequiredParameterMissingValues ColumnNames: #(cr,lf)Wanted: #(cr,lf)    #{0}, #(cr,lf)Found: #(cr,lf)    #{1}",
                // Message.Parameters = [ want = "a", act = "b" ]
                // Message.Parameters = { "a", "b" }
                Message.Parameters = { FmtList(columnNames), FmtList(src_colNames) }
                // Message.Parameters = [ WantedColumns = Text.Combine(columnNames, ", "), FoundColumns = Text.Combine(src_colNames, ", ") ]
            ] meta [ NinAssertName = "Columns.ThatExist", Activity = Diagnostics.ActivityId() ],
```


