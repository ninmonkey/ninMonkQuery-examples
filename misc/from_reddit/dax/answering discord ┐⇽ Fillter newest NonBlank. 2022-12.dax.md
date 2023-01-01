```sql
Latest Value := 
    // if the current value is missing, grab the next most recent 
var _curIndex = max( Metric[Index] )
var _prevIndex =
calculate(
    max(  Metric[Index]),
    Metric[Index] <= _curIndex, 
    not( isblank( Metric[Value] )) 
)
var _prevValue =
calculate(
    max(  Metric[Value]),
    Metric[Index] <= _curIndex && Metric[Index] >= _prevIndex, 
    not( isblank( Metric[Value] )) 
)
return
_prevValue
```

```sql
Colorize_Inline_MissingDataRow := 
    // variables are for semantics 
    var color_red = "#f40042"
    var color_blue = "#6790d9"
    var color_default = color_blue    
    var color_black = "#2b2b2b" // others:  #5e5e5e" // #717171"
    var color_fg = color_black
    var color_fg_dim = "#999999"

    var cur_Value = SELECTEDVALUE( Metric[Value] )
    var final_color = switch(
        true,
        ISBLANK( cur_Value ), color_fg_dim,
        cur_Value == 0, "magenta",
        color_fg
    )
return final_color
```

```sql
Colorize_MissingDataRow := 
    // variables are for semantics 
    var color_red = "#f40042"
    var color_blue = "#6790d9"
    var color_default = color_blue    

    var cur_Value = SELECTEDVALUE( Metric[Value] )
    var final_color = switch(
        true,
        ISBLANK( cur_Value ), color_red,
        cur_Value == 0, "magenta",
        color_default
    )
return final_color
```
