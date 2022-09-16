## Using the New Structured Errors Format

Example that validates a table. If it's good, it returns as normal. Otherwise return errors with extra info. You can even drill down if you catch it.

- The Report: [Using Structured Errors: Validate Query Is Distinct.pbix](./Using%20Structured%20Errors%20%E2%81%9E%20custom%20errors.pbix)
- The Query: [StructuredErrors ValidateQueryIsDistinct.pq](./pq/UsingStructuredErrors-ValidateQueryIsDistinct.pq)

![screen of distinct](./img/UsingStructuredErrors-ValidateQueryIsDistinct.png)



## Examples and docs:
        
- <https://bengribaudo.com/blog/2020/01/15/4883/power-query-m-primer-part-15-error-handling>
- docs [Text.Format](https://docs.microsoft.com/en-us/powerquery-m/text-format)

TheValid Field names are: `Reason`, `Message`, `Message.Format`, `Message.Parameters` and `Detail`

```pq
errMessage = [
    Reason = "InvalidDataException",
    Detail = "Too many records",
    Message.Format = "query #{0} was not distinct, for PrimaryKeys = { #{1} }",
    Message.Parameters = {
        Diagnostics.ActivityId(),
        Text.Combine( primaryKeys, ", ")
    } ],

someWhere =
    if true then ...
    else error errMessage
```
