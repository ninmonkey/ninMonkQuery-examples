Make it easier to write code like



@'
```powerquery
text meta [
    Documentation.Name = "Text.JoinSpecialValues",
    Documentation.LongDescription = Text.Combine({
        "Convert a list of values into text, then join them like a Csv.",
        "",
        "The <b>default</b> will replace <i>true</i><code>null</code> values with symbols.",
        "<br><br><hr>",

        "<b>Testing Help Syntax</b>: Table",
        "<table>
            <tr><td>true <code>null</code></td><td>␀</td></tr></table>",

        "<b>Testing Help Syntax</b>: Unordered List",
        "<ul>
            <li>true <code>null</code> ⇒ '␀'</li></ul>
            <li>true <code>EmptyString</code> ⇒ '␠'</li></ul>␠

        "

    }, "<br>" )
```
'@
