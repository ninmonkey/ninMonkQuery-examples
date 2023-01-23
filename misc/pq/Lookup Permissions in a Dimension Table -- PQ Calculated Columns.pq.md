## Colorize Bool

```sql
Colorize Bool :=
if( SELECTEDVALUE('Transaction Logs'[Valid Login]) == true,
    "green", "red"
)
```

## Transaction Logs


```typescript
let
    EnableBuffer = true,
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlTSAeJYHQjLCMwywsIyhrMsgSxLLCxDA7gxJnCWqVJsLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Account Id" = _t, #"Logged User Id" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Account Id", Int64.Type}, {"Logged User Id", Int64.Type}}),
    Source1 = Table.AddIndexColumn(#"Changed Type", "Transaction Id", 0, 1, Int64.Type),
    Source2 =
        if not EnableBuffer then Permissions
        else Table.Buffer( Permissions, [ BufferMode = BufferMode.Delayed ] ),
    
    FindValidPermissions = Value.ReplaceType( FindValidPermissions.impl, FindValidPermissions.Type ),
    FindValidPermissions.Type = type function (
        source as table, ownedAccountId as number, userId as number
    ) as logical meta [
        Documentation.Name = "FindValidPermissions",
        Documentation.LongDescription = Text.Combine({
            "Lookup a (AccountId, UserId) pair in the permissions table",
            "",
            "Returns true when there is exactly 1 match. Zero and anything more than 1 returns false.",
            "source is a dimension table, so more than 1 should never occur"
        },"<br>")
    ],    
    FindValidPermissions.impl = (source as table, ownedAccountId as number, userId as number) as logical => 
        let        
            filter_users = Table.SelectRows(
                source,
                (row) => 
                     row[Owned Account Id] = ownedAccountId and 
                     row[User Id] = userId
            ),
            rows = Table.RowCount( filter_users ),
            return = 
                if rows > 1 then
                    error [ 
                        Message.Format = "Dimension table not distinct for [ ownedAccountId = #{0}, userId = #{1} ]",
                        Message.Parameters = {
                            ownedAccountId, userId
                        }
                    ]
                else if rows = 1 then true
                else false
        in return,

    #"Add Permissions Col" = Table.AddColumn(Source1, 
        "Valid Login",
        (row) =>  FindValidPermissions( Source2, row[Account Id], row[Logged User Id] ),
        Logical.Type )

    
in
    #"Add Permissions Col"
```

## Permissions

```typescript
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlTSAeJYHQjLCMwygrOMgSxjpdhYAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Account Id" = _t, #"User Id" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Account Id", Int64.Type}, {"User Id", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Account Id", "Owned Account Id"}})
in
    #"Renamed Columns"
```