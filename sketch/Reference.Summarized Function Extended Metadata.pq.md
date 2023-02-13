## summarized help info

### Minimal Syntax

```
type function(name as text, age as number) as record
type function(amount as number, optional tax as number) as number
```
Like
```
let
    repeatStuffDefinition = (input as text, count as number) as text => Text.Repeat(input, count),
    functionType = type function(input as text, count as number) as text,
    RepeatStuff = Value.ReplaceType( repeatStuffDefinition, functionType )
in
    RepeatStuff
```


### steps Nested Records Type Info

- <https://bengribaudo.com/blog/2021/09/21/6179/describing-function-record-parameters#Specifying%20the%20Shape>

```powerquery
let
  Func = (input as record) => …,
  NewType = type function (
    input as
      [
         Server = text,
         optional Port = number,
         optional CutOff = date
      ]
    ) as any,
  Ascribed = Value.ReplaceType(Func, NewType)
in
  Ascribed
```
becomes

```powerquery
let
  Func = (input as record) => ...,
  NewType = type function (
    input as
      [
        Server = (
          type text meta
          [
             Documentation.SampleValues = { "localhost"}
          ]
        ),
        optional Timeout = (
          type number meta
          [
            Documentation.FieldCaption = "Time Out [in seconds]",
            Documentation.AllowedValues = { 10, 60, 360 }
          ]
        ),
        optional CutOff = date
      ]
    ) as any,
  Ascribed = Value.ReplaceType(Func, NewType)
in
  Ascribed
```
