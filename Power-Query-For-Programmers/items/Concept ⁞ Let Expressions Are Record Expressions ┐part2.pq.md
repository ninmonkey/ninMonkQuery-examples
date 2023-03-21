```js
let 
    Csv = (source as list) as text =>
        let
            text_list = List.Transform( source, each Text.From(_) ),
            joined = Text.Combine( text_list, ", ")
        in 
            joined,

    // is equal to this record expression.
    Csv2 = (source as list) as text => [
            text_list = List.Transform( source, each Text.From(_) ),
            joined = Text.Combine( text_list, ", ")
        ][joined],


    Summary = [
        letters = Csv({"a".."f"}),
        letters2 = Csv({"a".."f"})
    ]        
in 
        Summary     
```