![query summary screenshot](Testing/img/Summarize%20⁞%20Queries%20┐main_query.png)

- [Query Summary Listing](./Testing)

## Web Requests

- [OData Requests](./WebRequests/OData/readme.md)
- [Web Requests](./WebRequests/readme.md)


### Catching `Web.Contents` Errors using and `ManualStatusHandling`

![using-web.contents-catching-datasource-errors](./WebRequests/img/WebContents%20⁞%20Catch%20uncatchable%20Datasource%20errors┐main_query.png)

[Catch uncatchable Datasource errors - main query.pq](./WebRequests/pq/WebContents%20⁞%20Catch%20uncatchable%20Datasource%20errors┐main_query.pq)



```pq
try Web.Contents( "https://httpbin.org", [
    RelativePath =  "/status/codes/418",
    ManualStatusHandling = {401, 402, 404} & {405..500}
    ] )
catch (e) =>
    "Error, but we caught it" meta e
```
