Whitespace between function calls and the name are allowed. Including newlines. 
These are identical statements:

```ts
= DoStuff( args )
= DoStuff

                                ( args )
```
Record lookups also allow whitespace

This is totally valid: ( Syntactically valid, not morally )

```ts
let
    Func = () => [ 
        user = [ Name = "bob" ] 
    ]
in 
    Func  


(

                            )[    
     user  



]
```
