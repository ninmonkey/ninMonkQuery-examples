#Requires -Version 7
#Requires -Modules NameIt

Import-Module NameIt -ea stop
function pq_randomTable {
    <#
    .SYNOPSIS
        Outputs a full powerquery literal  that builds a table
    #>
    param(
        [Parameter()]$Options = @{}
    )
    $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
        EmptyStrCount = 6
        IgTemplate    = '[color]-[noun]'
    }
    $allRows = @()
    0..5 | ForEach-Object {
        $row = @(
            # ig '[color]-[noun]' -Count 10
            ig '[color]' -Count 10
            '.', '.', '.', '.', '.'
        ) | Get-Random -Count 6


($row | Join-String -sep ', ' -DoubleQuote ) -replace '\.', ''
        | Join-String -op '{ ' -os ' }'
        #$allRows += $row | Join-String -Separator ', ' -DoubleQuote -op ",`n"
    } | Join-String -sep ",`n"
}

$allRows

pq_randomTable
return

#
$allRows = @()
0..5 | ForEach-Object {
    $row = @(
        ig '[color]' -Count 10
        '.', '.', '.', '.', '.'
    ) | Get-Random -Count 6


($row | Join-String -sep ', ' -DoubleQuote ) -replace '\.', ''
    | Join-String -op '{ ' -os ' }'
    #$allRows += $row | Join-String -Separator ', ' -DoubleQuote -op ",`n"
} | Join-String -sep ",`n"


$allRows

pq_randomTable