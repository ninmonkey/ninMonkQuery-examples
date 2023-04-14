# 'Actually, the better template to use is
#     <https://github.com/ninmonkey/ninMonkQuery-examples/tree/0018978f75cccddf09ff1929fdedc2340efa4d05/Types>'

function md.Path.escapeSpace {
    <#
    .DESCRIPTION
        escapes spaces in filepaths, making relative urls clickable
    .EXAMPLE
       PS>  'c:\foo bar\fast cat.png'
       c:\foo%20bar\fast%20cat.png
    #>
    param(
        [switch]$AndForwardSlash = $true
    )
    process {
        $accum = $_ -replace ' ', '%20'
        if($AndForwardSlash) {
            $accum = $accum -replace '\\', '/'
        }
        return $accum
    }
}
function repo.WriteFileSummary {
    <#
    .SYNOPSIS
        generates markdown urls to files, using relative filepaths, and escaping spaces for github preview
    #>
    param(
        [string]$RootPath,

        # optionally overwrite the regex selector
        [string]$IncludeExtensionRegex
    )
    $origPath = Get-Location
    Push-Location $RootPath

    repo.WriteNavigation

    $Regex = @{
        CwdPrefix        = [regex]::Escape(( Get-Item . | ForEach-Object FullName )) + '\\'
        IncludeExtension = '\.(pbix|pq|xlsx|png|md|dax)'
        ExcludeExtension = '\.ps\.(md|pbix|pq|dax)'
    }
    if($IncludeExtensionRegex) {
        $Regex.IncludeExtension = '\.({0})$' -f @( $IncludeExtensionRegex )
    }
    . {
        Get-ChildItem . -Recurse -File
        | Where-Object extension -Match $Regex.IncludeExtension #
        | Where-Object Extension -NotMatch $Regex.ExcludeExtension  # ignore pipescript
        | ForEach-Object {
            [pscustomobject]@{
                GroupMonth        = $_.LastWriteTime.ToString($fStr.YearMonth)
                Kind              = fileCategory $_.Name
                Name              = $_.Name
                RelativeWorkspace = $_.FullName -replace $Regex.CwdPrefix, ''
                BaseName          = $_.BaseName
                FullName          = $_.FullName
                Extension         = $_.Extension
                GroupDate         = $_.LastWriteTime.ToString($fStr.YearMonthDay)
                GroupParentPath   = $_.Directory
                LastModifiedDt    = $_.LastWriteTime -as 'datetime'
                SizeKb            = '{0:n} kb' -f @( $_.Length / 1kb )

            }
        }
        | Sort-Object RelativeWorkspace
        | Sort LastModifiedDt -Descending
        | ForEach-Object {
            '<small>{4}</small> <b>{0}</b> [{1}]({2}) {3}' -f @(
                $_.BaseName
                $_.RelativeWorkspace
                $_.RelativeWorkspace | md.Path.escapeSpace -AndForwardSlash
                $_.SizeKb
                $_.GroupMonth
            )
        } | join.UL
        # | CountIt
    }

    Pop-Location
    Set-Location $origPath
}

function fileCategory {
    # short filetype categorization by extension
    param(
        [string]$Path
    )
    switch -Regex ($Path) {
        '\.ps1?\.\w+$' {
            'pipescript'
            break
        }
        '\.(png|gif|jpe?g|mp4)$' { 'image' }
        '\.(csx?)$' { 'C#' }
        '\.dax$' { 'Dax' }
        '\.(xlsx|csv|tsv)$' { 'Excel' }
        '\.ps1$' { 'Powershell' }
        '\.(jsonc?)$' { 'Json' }
        '\.(ts|js)$' { 'JavaScript' }
        '\.(t?sql)$' { 'SQL' }
        '\.(pq|powerquery|m|pqm)$' { 'PowerQuery' }
        '\.pbi[xt]$' { 'PowerBI Report' }

        '\.md$' { 'markdown' }
        default { 'other' }
    }

}

function md.Write.Url {
    param(
        # rquired label, and url
        [Parameter(Mandatory, Position = 0)]
        [string]$Text,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $Url
    )
    process {
        $EscapedLabel = $Text -replace '\(', '\(' -replace '\)', '\)' -replace '\[', '\[' -replace '\]', '\]'

        @(
            '[{0}]' -f @( $EscapedLabel )
            '({0})' -f @(
                $Url | md.Path.EscapeSpace -AndForwardSlash
            )
        )

    }
}

function repo.WriteNavigation {
    @'
[Root](https://github.com/ninmonkey/ninMonkQuery-examples) | [Up ⭡](./../readme.md)
'@
}





