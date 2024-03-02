## About

I tested whether using library functions as records would autocomplete in **Power BI** and **VsCode**. A [/r/powerbi](https://www.reddit.com/r/PowerBI/comments/1b43ces/comment/kszlqqr/?utm_source=share&utm_medium=web2x&context=3) thread said it wasn't possible. I had to find out.

Some of the results were expected, some surprised me. 

- [About](#about)
  - [Sample Implementation](#sample-implementation)
  - [Results](#results)
    - [Part 1 : Nested lib record](#part-1--nested-lib-record)
    - [Part 2 : Aliases with nested lib record](#part-2--aliases-with-nested-lib-record)
  - [Sample Without Documentation Metadata](#sample-without-documentation-metadata)
  - [Test Constraints](#test-constraints)
  - [Future Work](#future-work)
  - [Environment](#environment)

### Sample Implementation 

I prepared two files that that try a few variations for a controlled test. They are identical, except the 2nd one uses documentation metadata.

- [withoutDocMetadata.pq](./Test-Nested-LibFunctions-For-Completion.pq)
- [withDocMetadata.pq](./Test-Nested-LibFunctions-For-Completion-withDocstringsMetadata.pq)

### Results

#### Part 1 : Nested lib record

```ts
let 
    lib = [ Csv = (x, y) => "" ],
    a = lib[Csv]( 4, 5 )
in 
    a
```

**Power BI Desktop**

| Test                             | Works? |
| -------------------------------- | ------ |
| `[` Function Name Completes?     | 👎      |
| `(` Open Parens Shows Signature? | 👍      |
| `,` Comma Shows Signature?       | 👍      |

**Vs Code**

| Test                             | Works? |
| -------------------------------- | ------ |
| `[` Function Name Completes?     | 👍      |
| `(` Open Parens Shows Signature? | 👎      |
| `,` Comma Shows Signature?       | 👎      |

![First Csv Works](./img/completion1.png)

#### Part 2 : Aliases with nested lib record

Using this query

```ts
let
    lib = [ Csv = (x, y) => "" ],
    ToCsv = lib[Csv],
    a = ToCsv(1, 3) // test complitions for this line
in 
    a
```

**Power BI Desktop**

| Test                             | Works? |
| -------------------------------- | ------ |
| Function Name Completes?         | 👍      |
| `(` Open Parens Shows Signature? | 👎      |
| `,` Comma Shows Signature?       | 👎      |

**Vs Code**

| Test                             | Works? |
| -------------------------------- | ------ |
| Function Name Completes?         | 👍      |
| `(` Open Parens Shows Signature? | 👍      |
| `,` Comma Shows Signature?       | 👍      |

- VsCode will complete the function name `Csv`.
- `(` does not


![Csv Alias Works](./img/completion2.png)

### Sample Without Documentation Metadata


ome  across gave some results I wasn't expecting across PowerBI and VsCode.

- Both of these will pop up the call signature when you type `,`, but not on the `(`. 
- they don't autocomplete nested record names, but

You get the call signature for both of these in PowerBI. Some reason it doesn't include doc strings. 


    let 
        p = lib[Add1]( 4, [] ),

        Summary = [            
            a = 10,
            b = lib[Add1]( 3 )
        ],         

        lib = [        
            Add1 = (x as number, optional r as nullable record) as number => x + 1,
            Mul2 = (x) => x*2
        ]
    in 
        Summary



### Test Constraints 

To keep things simple for this first test, I kept things simple

- For VsCode I am using the [base Power Query Extension](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery). ( There is a [Power Query SDK for VsCode](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery-sdk) too )
- I declared the library record as a hidden step of the same query
 
### Future Work

- Try `PowerBI-Copilot`
- Test with the library declared in an external file, with and without `github copilot` in the shared workspace
- Test with an external file using Evaluate on the global `environment`
- Dive into the `AST`, to see if I can statically generate more suggestions for Vs Code
- Test if I can get the function signature to display for single argument functions, or at least on the `(` press
- Sometimes a test didn't seem to be 100% reproducible. 
  - Future tests with invalidated caches
  - New tests using saved files, *after* fully running `apply`. Not just refreshing / saving.
- Experiment with VsCode Settings:

```json
"powerquery.diagnostics.typeStrategy": "Extended",
"powerquery.general.mode": "SDK", // [ Power Query* | SDK ],
"[powerquery]": {
    "github.copilot.editor.enableAutoCompletions": true,
    // "*suggest*": // a bunch of settings
},
```

- The biggest factor may be dependant on how exactly you declare the function


### Environment

```yml
PowerBI Desktop: Power Query 2.126.927.0 64-bit (February 2024)
VsCode Addon: PowerQuery.vscode-powerquery v0.1.54
Date Tested: 2024-03-02
```