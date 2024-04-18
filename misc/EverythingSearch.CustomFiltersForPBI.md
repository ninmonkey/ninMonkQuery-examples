- [Base: PBI Traces and hide empty logs](#base-pbi-traces-and-hide-empty-logs)
- [Base Path: PBI Traces root](#base-path-pbi-traces-root)
- [Filter using date modified and ignoring roots](#filter-using-date-modified-and-ignoring-roots)


## Base: PBI Traces and hide empty logs

```js
path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" ( file: size:>0 )
```

## Base Path: PBI Traces root
```js
path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces"
```

## Filter using date modified and ignoring roots
```js
dm:last200seconds                                            ( !path:"%LocalAppData%\Packages\Spotify*" !path:"*windows*search*" !path:"c:\windows\prefetch" !path:ww:"c:\windows\system"    !path:ww:"%LocalAppData%" !path:ww:"%AppData%\Code" )              

```