let

    /* capture the latest Xkcd comic and metadata
    Using a CssSelector means you don't have to parse the html yourself

    the original html is structred like this

        <div id="comic">
            <img src= ... >
        </div>

    an 'Id' is great because that narrows it down to one distinct element
    then, grab the first child that's an image

    Here's a couple of important selectors that you can use

        # means an id name
        . means a class name
        > means a direct descendant

    You can learn more here:
    - https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Selectors

    */

    Fetch.xkcd = () as record => [
        root_url = "https://xkcd.com",
        CssSelector = "div#comic > img",
        response = Web.Contents("https://xkcd.com/", []),
        navigateDom =  Html.Table(response, {
            {"img", CssSelector, each _[Attributes] }}),
        target = navigateDom[img]{0},
        return = [
            ImageUrl     = Uri.Combine(root_url, target[src] ),
            ImageUrlBig  = Uri.Combine( root_url, SrcBig ),
            Alt          = target[alt],
            Title        = target[title],
            SrcSet       = target[srcset]?,
            SrcBig       = Text.Split( SrcSet, " "){0}?,
            AsBase64     = Image.ToBase64Text( ImageUrl ),
            DateCaptured = DateTime.LocalNow()
        ]
    ][return],


    /*
        convert image binaries into base64 text in a format expected by browsers (and pbi)
    */
    Image.ToBase64Text = (imageUrl as text) as any => [
        bytes = Web.Contents( imageUrl ),
        bytesAsText = Binary.ToText( bytes, BinaryEncoding.Base64 ),
        mime_prefix =
            if Text.EndsWith( imageUrl, ".png", Comparer.OrdinalIgnoreCase ) then
                "data:image/png;base64, "
            // else if Text.EndsWith( imageUrl, ".jpg", Comparer.OrdinalIgnoreCase ) then
            //     "data:image/jpg;base64, "
            else if (
                Text.EndsWith( imageUrl, ".jpeg", Comparer.OrdinalIgnoreCase ) or
                Text.EndsWith( imageUrl, ".jpg", Comparer.OrdinalIgnoreCase ) )
            then
                    "data:image/jpg;base64, "
            else
                error [ Message.Format = "Unhandled Image type: {0}", Message.Parameters = { imageUrl } ],

        return = mime_prefix & bytesAsText
    ][return],

    fin = Fetch.xkcd(),
    #"Converted to Table" = Table.FromRecords({fin}),
     #"Changed Type" = Table.TransformColumnTypes(
        #"Converted to Table",
        {
            {"ImageUrl", type text}, {"ImageUrlBig", type text},
            {"Alt", type text},      {"Title", type text},    {"SrcSet", type text},
            {"SrcBig", type text},   {"AsBase64", type text}, {"DateCaptured", type datetime}
        }
    ),
    #"Removed Columns"    = Table.RemoveColumns(#"Changed Type",{"SrcSet", "SrcBig"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",{"AsBase64", "Title", "Alt", "ImageUrl", "DateCaptured", "ImageUrlBig"})
in
    #"Reordered Columns"
