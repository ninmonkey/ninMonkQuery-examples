If you just want clean columns, this function is nice:

    = Table.TransformColumnNames( Source,  each Text.Trim( _ ) )

+ /u/north_bright : if you want to inspect whitespace with extra details, try this example:

- [ninMonkQuery-examples/Inspect Whitespace and Format Control Symbols.pq](https://github.com/ninmonkey/ninMonkQuery-examples/blob/1f9783645cb6459e11a100184d0e634f9bb2d158/forumQuestions/pq/2024-10%20-%20Auto%20trim%20column%20names%20for%20whitespace%20--%20InspectWhitespace%20and%20FormatShowControlSymbosl.pq#L5-L76)

If your font supports unicode: Instead of a newline you'll see `␊`. 

Trick: To convert whitespace and escape characters to safe-to-print-symbols: 

    Just add `0x2400` to the **codepoint**. Then convert it back to text

**Example output**

| HasOuterWhitespace 	|           RawName           	|              Symbols             	|                                                            HexSummary                                                           	|                                                                    DecSummary                                                                   	|
|:------------------:	|:---------------------------:	|:--------------------------------:	|:-------------------------------------------------------------------------------------------------------------------------------:	|:-----------------------------------------------------------------------------------------------------------------------------------------------:	|
| TRUE               	|   User<br> Names            	| ␠␠User␍␊␠Names                   	| Hex: 20, 20, 55, 73, 65, 72, <br>d, a, 20, 4e, 61, 6d, 65, 73                                                                   	| Dec: 32, 32, 85, 115, 101, 114, 13, <br>10, 32, 78, 97, 109, 101, 115                                                                           	|
| TRUE               	|   Has	 tabs                  	| ␠␠Has␉␠tabs␠␠␠                   	| Hex: 20, 20, 48, 61, 73, 9,<br>20, 74, 61, 62, 73, 20, 20, 20                                                                   	| Dec: 32, 32, 72, 97, 115, 9, 32,<br>116, 97, 98, 115, 32, 32, 32                                                                                	|
| TRUE               	|   Zero-Width ‍ Joiner Inside 	| ␠␠Zero-Width␠<ZWJ>␠Joiner␠Inside 	| Hex: 20, 20, 5a, 65, 72, 6f,<br> 2d, 57, 69, 64,74, 68, 20, <br>200d, 20, 4a, 6f, 69, 6e, <br>65, 72,20, 49, 6e, 73, 69, 64, 65 	| Dec: 32, 32, 90, 101, 114, 111,<br>45, 87, 105, 100, 116, 104, 32,<br>8205, 32, 74, 111, 105, 110, 101,<br>114, 32, 73, 110, 115, 105, 100, 101 	|
| TRUE               	|                             	| ␛                                	| Hex: 1b                                                                                                                         	| Dec: 27                                                                                                                                         	|
| TRUE               	| Escape  Sequence            	| Escape␠␛␠Sequence                	| Hex: 45, 73, 63, 61, 70, <br>65, 20, 1b, 20, 53, 65, <br>71, 75, 65, 6e, 63, 65                                                 	| Dec: 69, 115, 99, 97, 112, 101,<br>32, 27, 32, 83, 101, 113, 117, <br>101, 110, 99, 101                                                         	|

#### more info

- Ascii `C0` control codes: https://en.wikipedia.org/wiki/C0_and_C1_control_codes
- Ascii block https://www.compart.com/en/unicode/block/U+0000 
- The symbols they map to: https://www.compart.com/en/unicode/block/U+2400