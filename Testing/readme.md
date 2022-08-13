## Query Metadata

### Summarize All Queries

![summarize-pq-queries](img/Summarize%20⁞%20Queries%20┐main_query.png)

[Summarize-All-Queries.pq](./pq/Summarize-All-Queries.pq)

<!--

```pq
try Web.Contents( "https://httpbin.org", [
    RelativePath =  "/status/codes/418",
    ManualStatusHandling = {401, 402, 404} & {405..500}
    ] )
catch (e) =>
    "Error, but we caught it" meta e
```

-->