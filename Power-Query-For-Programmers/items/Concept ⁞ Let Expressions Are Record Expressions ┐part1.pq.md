```js
let
    name = "Bob",
    species = "Cat",
    Message = Text.Combine({ name, species })
in
    Message
```
is equivalent to
```js
[
    name = "Bob",
    species = "Cat",
    Message = Text.Combine({ name, species })
][Message]
```