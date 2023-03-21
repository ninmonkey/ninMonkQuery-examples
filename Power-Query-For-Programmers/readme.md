## Operators

| Operator                                        | description                                                       |
| ----------------------------------------------- | ----------------------------------------------------------------- |
| `x as y`                                        | type assertions. Where `y` is a `primitive datatype`              |
| `x meta [ Extra = "Info" ] `                    | add metadata to values                                            |
| `x ?? y`                                        | null coalesce. Use `x` except if it's `null`. Then use `y`        |
| `hash[Key]?`                                    | lookup `Key`, if it does not exist, returns `null`                |
| `hash{10}?`                                     | lookup `list index` at `10`. if it does not exist, returns `null` |
| `try x catch (e) => value `                     | try catch expression. Consumes ErrorRecord information            |
| `try x catch () => value`                       | also valid but doesn't matter here                                |
| `try x catch (e) => e`                          | try catch expression : returns the ErrorRecord                    |
| `try x catch (e) => e[Message]`                 | try catch expression                                              |
| `try x catch (e) => null meta [Extra = "Info"]` | try catch expression                                              |

## `local variables` or `scoped variables`

## There are no classes

`Number.From`, `Number.ToText`, etc are all **flat top level functions**


        
## `each` is a "regular" function

`each` keyword is just sugar for an anonymous method. 

Note: It *always* take 1 parameter with `type any`, and it returns 1 value of `type any`.
Which is one reason I use named functions
It's more relevant when you have nested each functions. 

Each nested inside an each ends up shadowing the outer `_` ,
as the inner variable `_`. 
You can use that on purpose for local variables in functions, regardless of declared names

<!--
```js
msg = (x as text) =>
        let     
            x = {0..10}                       
            // now it's confusing, is it referencing the string or the list? 
            finalResult = List.Transform( x, each Text.From(_) & x)
        in
            finalResult,

    message = "hi world",


    msg = (x as text) =>
        let     
            x = {0..10}
            finalResult = List.Transform( x, each _ & x)
        in
            finalResult,

    tryIt = msg("hi world")
    
    
    
    = each [Sales] * 2
    = each each [Sales] * 2
```

-->

In the docs you can look it up in the lexical grammar.
It's literally:
    a custom function body, without the header / signature

## `each` Described

```js
= each [Sales] * 2
```
Is implicitly evaluating as
    
```js
    = each _[Sales] * 2

// which is
    = (_) => _[Sales] * 2
```    

which implicitly evaluates like this

```js
    = (_ as any) as any 
        => _[Sales] * 2

// is what it's really evaluating as,  when you use this expression:
= each [Sales] * 2
```

## `Table.AddColumn` : Why do columns lose their types?


Do you ever lose types after using Table.AddColumn ? That's because you're forcing the type to be `any`
So take the each function, 
```js

    = (_) =>
        _[Sales] * 2
```


It's the same thing. The first one has a variable with a weird, name, "_"
but it's  the same thing as this

```js
    = (row) =>
         row[Sales] * 2 

    = (row as any) as any => row[Sales] * 2 
```

## `Table.AddColumn` : How to prevent columns from turning into `type any`

Say you're adding values that *should* be numeric. Like an `integer` times 2.
you can enforce the `primitive-datatype` of `type number`

Lets take an id column so it's an int to begin with
with a `type assertion` for numeric 

```js
    Table.AddColumn(
        Source,
        "DoubleInt",
        (row) as number =>
            row[Id] * 2,
        type number
    )
```


you can use a more specific ascribed type if you know it's right. 

```js
    Table.AddColumn(
        Source,
        "DoubleInt",
        (row) as number =>
            row[Id] * 2,
        Int64.Type
    )
```


in real code, you may want to enforce the int using a constructor ( which is a subset of numeric )

```js
    Table.AddColumn(
        Source,
        "DoubleInt",
        (row) as number =>
           Int64.From( row[Id] * 2 )
        Int64.Type
    )

```

    
## Using Try Catch: `try x catch (e) => e`

 Catch is synactic sugar, it's one expression like try otherwise
 without losing the error record. Or just return a value other than `e` if you were using `otherwise x`

catch the error, then output the error record. kind of like doing nothing
you might do this with extra metadata 

```js
    try SomethingMayFail catch (e) => e
```

```js
    nums = { -1..3 }
    tryDividing = List.Transform(
        nums,
        (item) => 
            try item / 0 catch (e) => null
    )
```

## using operator `meta` on `null` values

if you have
- a column of type `nullable number`
- but you want errors as `text`
- **without breaking** the column's `number` `data type`, you can use the `meta` operator 

```js

    (item) => 
            try item / 0 catch (e) => null [
                What = "BadStuff",
                When = datetimelocal.Now(),
                // grab this to filter events in the trace log file
                ErrorGuid = activity.Current()
            ]
```

then later on you can inspect

```js

    Table.AddColumn(
        Source, "ErrorsMessages", 
        (row) => 
            Value.Metadata( row[ColumnWithNulls] ),
        type text
    )
```

## too convoluted example
### `local variables` or `scoped variables`

```js
let
    name = "bob",
    id = 20,
    Double  = "''"

    QouteEmployee = (name as text, id as number ) =>
        Str = [
            Double = """"
        ],

        name = name ?? "unknown",
        id = Text.From( id ?? -100 ),
        render = Text.Format(
            "#[double]#[name]#[id]#[double]",
            [
                double = Str[Double],
                name = name,
                id = id
            ]
        ),
```
