See more: 
- <https://ninmonkeys.com/blog/2024/06/04/what-not-to-do-in-power-query/>

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
###

```powerquery
let
    SomeConfig = [ user = "bob", region = "north" ],
    CopyRecord = SomeConfig   /*            stuff             */                                 [ region ]
    ,Name = CopyRecord[user]?
in
    Name
```


