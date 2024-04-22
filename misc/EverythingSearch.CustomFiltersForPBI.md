Summary:

- [Base: PBI Traces and hide empty logs](#base-pbi-traces-and-hide-empty-logs)
  - [Also Show Folders](#also-show-folders)
- [Base Path: PBI Traces root](#base-path-pbi-traces-root)
- [Filter using date modified and ignoring roots](#filter-using-date-modified-and-ignoring-roots)
- [By filetypes](#by-filetypes)
  - [Main PBI types](#main-pbi-types)
  - [Parquet only](#parquet-only)

I **love** [EverythingSearch](https://www.voidtools.com/support/everything/). 

Here's a collection of filters that are PowerBI related

## Base: PBI Traces and hide empty logs

```js
path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" ( file: size:>0 )
```
### Also Show Folders
```js
path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces" ( ( file: size:>0 ) | folder: )
```
## Base Path: PBI Traces root
```js
path:ww:"%LocalAppData%\Microsoft\Power BI Desktop\Traces"
```

## Filter using date modified and ignoring roots
```js
dm:last200seconds                                            ( !path:"%LocalAppData%\Packages\Spotify*" !path:"*windows*search*" !path:"c:\windows\prefetch" !path:ww:"c:\windows\system"    !path:ww:"%LocalAppData%" !path:ww:"%AppData%\Code" )              

```

## By filetypes

### Main PBI types
```js
 ( ext:pbix;pbit;pbir;pbip;pq;csv;sql;json;csv;parquet )
```

### Parquet only

```js
 ( ext:parquet )
```
