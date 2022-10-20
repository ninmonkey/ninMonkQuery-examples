/*
  returns a table of [ Rune, Codepoint ] pairs
  
  Note that this is the equivalent of [String]::ToCharArray()
  meaning each item is a [char] (2bytes) , some codepoints will become split, breaking them
  this just means it's not truely enumerating the codepoints in a string, because some break
  compared to enumerating codepoints with [Rune]s in dotnet
*/
    
    inspect = (source as text) as any =>
            [   charList = List.Transform(
                    Text.ToList(source), (char) => [
                        Rune = char, Codepoint = Character.ToNumber(char)
                    ]),
                t = Table.FromRecords(charList, type table[Rune = Character.Type,
                    Codepoint = Int64.Type ])
            ][t],
