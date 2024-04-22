## Int to base2/bits


From: <https://dax.guide/bitor/>

```js
DEFINE
    VAR ValA = SELECTCOLUMNS ( GENERATESERIES ( -5, 5 ), "A", [Value] )
    VAR ValB = SELECTCOLUMNS ( GENERATESERIES ( -5, 5 ), "B", [Value] )
EVALUATE
    ADDCOLUMNS (
        CROSSJOIN ( ValA, ValB ),
        "BITAND", BITAND ( [A], [B] ),
        "BITOR", BITOR ( [A], [B] ),
        "BITXOR", BITXOR ( [A], [B] )
    )
ORDER BY [A] DESC, [B] DESC
```

```js
// This longer code produces an easier to read output 
// by showing the result in both decimal and binary formats
//
// The second query also shows how to implement a BITNOT function,
// which is not available in DAX
//
// Contribution by Kenneth Barber
DEFINE
    VAR MinimumValue = -3
    VAR MaximumValue = 3
    TABLE 'Numbers' =
        VAR NumberOfBitsToShow =
            // This excludes the sign bit before the "…"
            ROUNDUP (
                LOG ( MAX ( ABS ( MinimumValue ), ABS ( MaximumValue ) ) + 1, 2 ),
                0
            )
        RETURN
            ADDCOLUMNS (
                VAR Limit =
                    BITLSHIFT ( 1, NumberOfBitsToShow )
                RETURN
                    GENERATESERIES ( - Limit, Limit - 1 ),
                // We precompute the binary representations of all possible values
                // so that we can simply look them up later
                "Value (Binary)",
                    VAR Number = [Value]
                    RETURN
                        INT ( Number < 0 ) & "…"
                            & CONCATENATEX (
                                ADDCOLUMNS (
                                    GENERATESERIES ( 0, NumberOfBitsToShow ),
                                    "Bit", MOD ( BITRSHIFT ( Number, [Value] ), 2 )
                                ),
                                [Bit],
                                "",
                                [Value], DESC
                            )
            )
    MEASURE 'Numbers'[Binary] =
        // Where this measure is used, we could have used LOOKUPVALUE instead,
        // but it would have been more verbose
        CALCULATE (
            VALUES ( 'Numbers'[Value (Binary)] ),
            ALLEXCEPT ( 'Numbers', 'Numbers'[Value] )
        )
    VAR TableOfValuesToShow =
        CALCULATETABLE (
            'Numbers',
            'Numbers'[Value] >= MinimumValue,
            'Numbers'[Value] <= MaximumValue
        )
    VAR TableA =
        SELECTCOLUMNS (
            TableOfValuesToShow,
            "A", [Value],
            "A (Binary)", [Value (Binary)]
        )
    VAR TableB =
        SELECTCOLUMNS (
            TableOfValuesToShow,
            "B", [Value],
            "B (Binary)", [Value (Binary)]
        )
 
EVALUATE
GENERATE (
    CROSSJOIN ( TableA, TableB ),
    VAR BITANDresult =
        BITAND ( [A], [B] )
    VAR BITORresult =
        BITOR ( [A], [B] )
    VAR BITXORresult =
        BITXOR ( [A], [B] )
    RETURN
        ROW (
            "BITAND", BITANDresult,
            "BITAND (Binary)", CALCULATE ( [Binary], 'Numbers'[Value] = BITANDresult ),
            "BITOR", BITORresult,
            "BITOR (Binary)", CALCULATE ( [Binary], 'Numbers'[Value] = BITORresult ),
            "BITXOR", BITXORresult,
            "BITXOR (Binary)", CALCULATE ( [Binary], 'Numbers'[Value] = BITXORresult )
        )
)
ORDER BY
    [A] DESC,
    [B] DESC
 
// There is no "BITNOT" function in DAX to perform a bitwise NOT,
// but BITXOR(,-1) achieves the same result (-1 = 1…1111)
EVALUATE
GENERATE (
    SELECTCOLUMNS (
        // This ensures that the column name is not preceded with the table name
        TableOfValuesToShow,
        "Value", [Value],
        "Value (Binary)", [Value (Binary)]
    ),
    VAR BITNOTresult =
        BITXOR ( [Value], -1 )
    RETURN
        ROW (
            """BITNOT""", BITNOTresult,
            """BITNOT"" (Binary)", CALCULATE ( [Binary], 'Numbers'[Value] = BITNOTresult )
        )
)
ORDER BY [Value] DESC
```