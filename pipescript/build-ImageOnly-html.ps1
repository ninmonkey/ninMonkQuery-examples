import-module ninmonkey.console -Scope Global *>$null


# push-location .. -stack 'bps_start'
function buildRelative {
    param(
        [string]$StartingPath = '.',
        [string]$OutFile = 'readme.images.md'
    )
    # push-location '.' -stack 'buildRelativeFunc'
    push-location -path $StartingPath -stack 'buildRelativeFunc'
    function md.Path.escapeSpace { process { $_ -replace ' ', '%20' } }
    function Path.Shorten { # relative cwd
        param() #  $RelativeTo
        process {
            $_  | Ninmonkey.Console\ConvertTo-RelativePath
                | %{ $_ -replace '\\', '/' }
        }
    }

    $ElemPre = '<img src="{0}" />'
    $ElemSuffix = "`n"
$parentOP = @'
<style>
.parent {
    display: flex;
    flex-wrap: wrap;
}
img {
    max-width: 200px;
    /* max-height: 200px; */

}
</style>
<div class='parent'>
'@
    $parentOS = '</div>'

    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match '\.(png|gif|jpe?g|mp4|svg)'#
    | Where-Object Extension -NotMatch '\.ps\.(svg|md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object LastWriteTime -Desc | ForEach-Object FullName
    | ForEach-Object {
        # '![{0}]({1})' -f @(
            # $_ | Path.Shorten

        '<img src="{0}"/>' -f @(
            $_ | Path.Shorten
            | md.Path.escapeSpace
        )
    } | Join-String -sep "`n"
    | Join-String -op $parentOP -os $parentOS
    # | sc 'test.images.md' -PassThru
    | sc 'readme.images.md' -PassThru

    code -g (gi ./test.images.md)
    pop-location -stack 'buildRelativeFunc'
}

push-location -path '.' -stack 'bps_start'

# goto 'H:\data\2023\BI\git\ninMonkQuery-examples\forumQuestions\readme.ps.md'

goto 'H:\data\2023\BI\git\ninMonkQuery-examples'
buildRelative -relPath 'H:\data\2023\BI\git\ninMonkQuery-examples' -outFile 'readme.images.md'
code -g (gi 'readme.images.md')

# goto 'H:\data\2023\BI\git\ninMonkQuery-examples\forumQuestions\readme.ps.md'
# buildRelative -relpath '../../..'
pop-location -stack 'bps_start'