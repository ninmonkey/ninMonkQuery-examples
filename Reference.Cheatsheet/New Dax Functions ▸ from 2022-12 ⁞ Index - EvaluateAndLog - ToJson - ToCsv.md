sdf


## new DAX functions

- [EvaluateAndLog](https://powerbi.microsoft.com/en-us/blog/power-bi-november-2022-feature-summary/#post-21321-_Toc117515805)
- A good explanation and examples[Index, Offset, Window](https://powerbi.microsoft.com/en-us/blog/power-bi-december-2022-feature-summary/#post-21693-_Toc121395731)


- This links to a bunch of sub links using the new functions: [https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/](https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/)

There's two optional parameters:
```ts
EvaluateAndLog(
    <scalar or table Expression>
    [, <label>[, <max_rows> ] ]
)
```

![thumbnail jeffrey wang](https://pbidax.files.wordpress.com/2022/08/annotated-dax-debug-output-1.png)
- from: <https://github.com/pbidax/DAXDebugOutput/releases>
- usage: [https://pbidax.wordpress.com/2022/08/22/understand-the-output-of-evaluateandlog-function-of-scalar-expressions/](https://pbidax.wordpress.com/2022/08/22/understand-the-output-of-evaluateandlog-function-of-scalar-expressions/)
- usage: [https://pbidax.wordpress.com/2022/08/22/understand-the-output-of-evaluateandlog-function-of-scalar-expressions/](https://blog.crossjoin.co.uk/2022/09/19/diagnosing-switch-related-performance-problems-in-power-bi-dax-using-evaluateandlog/)
- more: [https://blog.crossjoin.co.uk/2022/08/22/why-im-excited-about-the-new-dax-evaluateandlog-function/](https://blog.crossjoin.co.uk/2022/08/22/why-im-excited-about-the-new-dax-evaluateandlog-function/)
- https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/

### duplicate url dump

https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/
- [EvaluateAndLog](https://powerbi.microsoft.com/en-us/blog/power-bi-november-2022-feature-summary/#post-21321-_Toc117515805)
- <https://pbidax.wordpress.com/2022/08/22/understand-the-output-of-evaluateandlog-function-of-scalar-expressions>
- from: <https://github.com/pbidax/DAXDebugOutput/releases>
- https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/
- https://powerbi.microsoft.com/en-us/blog/power-bi-august-2022-feature-summary/
- more:  [https://blog.crossjoin.co.uk/2022/08/22/why-im-excited-about-the-new-dax-evaluateandlog-function/](https://blog.crossjoin.co.uk/2022/08/22/why-im-excited-about-the-new-dax-evaluateandlog-function/)
- This links to a bunch of sub links using the new functions: [https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/](https://blog.crossjoin.co.uk/2022/10/24/diagnosing-calculation-group-related-performance-problems-in-power-bi-using-evaluateandlog/)
- usage: <https://blog.crossjoin.co.uk/2022/09/19/diagnosing-switch-related-performance-problems-in-power-bi-dax-using-evaluateandlog>
- usage: <https://pbidax.wordpress.com/2022/08/22/understand-the-output-of-evaluateandlog-function-of-scalar-expressions/>
ail jeffrey wang](https://pbidax.files.wordpress.com/2022/08/annotated-dax-debug-output-1.png)


## Example

```ts
YoYGrowth :=
    [Sales Amount] – CALCULATE(
        [Sales Amount],
        SAMEPERIODLASTYEAR('Date'[Date]) 
    )
```
```ts
YoYGrowth :=
    EVALUATEANDLOG( [Sales Amount] ) – EVALUATEANDLOG(
        CALCULATE(
            [Sales Amount],
            SAMEPERIODLASTYEAR('Date'[Date])
        )
        
```