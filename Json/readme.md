[Root](https://github.com/ninmonkey/ninMonkQuery-examples) | [Up ⭡](./..)

## Nested Json

- [Filtering Nested Json.pq](./pq/filtering-nested-json.md)
- [Report.pbix](./Filter%20Json%20-%20Filtering%20Nested%20Values%20Without%20Expanding%20values.pbix) 

![Text.ReplacePartialMatch.mp4](./img/filtering-nested-values-without-expanding-json.png)

```js
/* 
    previews into the depths of an object,
    it's converted to a tiny json file, then decoded as text
*/
XRay = (source as any) as text => [
    bytes = Json.FromValue(source, TextEncoding.Utf8),
    str = Text.FromBinary(bytes, TextEncoding.Utf8)
    ][str],
```
