@Trayox#3017 if you see this syntax , it's doing a **one-or-none** style query

```ts
= Table{ [ ... ] }
```

```ts
// one or none
= Table{ [ ... ] }

// first row of table, as a table
= Table{0}

// return [Data] column as a list
= Table[Data]

// return [Data] column as a list
= Table.Column( Source, "Data" ) 
```




```ts
= Source{[ Item = "GArt....77", Kind = "Sheet" ] }[Data]

// I'll rename it, and drop data for now
= Source{[ User = "Bob", Region = "West" ]}
```
it basically means: 
- in the table named `Source`
- filter rows by: column `User = "Bob"`
- and by column `Region = "West"`

If you get one record as the result, then return it. 
- if it's more than one, result: error
- if 0 matches, error ( that's in the screenshot )