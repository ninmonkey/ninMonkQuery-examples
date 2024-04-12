let

    // Write.Html.Bold = (source as text) as text => "<b>" & source & "</b>",
    Str = [
        LineEnding = "#(cr,lf)",
        NullStr    = "#(2400)",
        SpaceStr   = "#(2420)"
    ],

    Write.Html.Element = ( elementName as text, content as text) as text =>
        Text.Format( "<#[name]>#[content]</#[name]>", [ name = elementName, content = content ] ),

    Write.Html.Bold           = (content as text) as text => Write.Html.Element("b", content),
    Write.Html.Paragraph      = (content as text) as text => Write.Html.Element("p", content),
    Write.Html.ElementClosing = (elementName as text) as text => "<" & elementName & "/>",
    Write.Html.KeyValue       = (key as text, value as text) as text =>
        Text.Format (
            "#[key]: #[value]", [
                key = Write.Html.Bold( key ),
                value = value
            ]
        ),
        // Write.Html.Bold( key ) & ": " & value,
        // "<b>" & key & "</b>: " & value,

    StringBuilder.Join        = (items as list, optional options as nullable record) as text => [
        return = Text.Combine( items, Str[LineEnding] )
    ][return],


        // "<" & elementName & ">" & content & "</",
    // Write.Html.Li = (content as text) as text => "dsf",
    Write.Html.UnorderedList = (items as list) as text => [
        itemsList = List.Transform( items, (cur) => Write.Html.Element( "li", cur ) ),
        return    = Write.Html.Element( "ul", Text.Combine( itemsList, Str[LineEnding] ) )
    ][return],

    Original = "
            <p><b>MCopilot</b></p>
            <li><b>Creator: </b>Oscar Martinez.</li>
            <li><b>LinkedIn:</b> https://www.linkedin.com/in/oscarmartinezv/.</li>
            <li><b>Web: </b>bibb.pro</li>

            <p>This function, interacts with the OpenAI API to provide responses based on given prompts. It serves as a tool for generating meaningful explanations and full code related to Power Query.</p>
            <p>The function takes three parameters:</p>
            <ul>
                <li><b>apiKey:</b> This is the Open API Key required for authentication.</li>
                <li><b>model:</b> This is the GPT chosen model.</li>
                <li><b>prompt:</b> This is the prompt provided to the function, requesting information or code related to Power Query.</li>
            </ul>
            <p>The function,  constructs a request to the OpenAI API endpoint <code>https://api.openai.com/v1/chat/completions</code>.</p>
            <p>The request body includes a system message indicating the role of the responder, as well as the user's prompt. The API key is included in the request headers for authentication.</p>
            <p>Upon receiving the response from the API, the function extracts the content of the response message and returns it as the output.</p>
        ",
    Write.Element = Write.Html.Element,
    Tag = Write.Html.Element,
    P = Write.Html.Paragraph,
    B = Write.Html.Bold,
    UL = Write.Html.UnorderedList,

    first_pass_from_copilot_to_my_lib = StringBuilder.Join({
        P( B("MCopilot") ),
        UL({
            B("Creator: ") & "Oscar Martinez.",
            B("LinkedIn:") & "https://www.linkedin.com/in/oscarmartinezv/.",
            B("Web: ") & "bibb.pro"
        }),
        P("This function, interacts with the OpenAI API to provide responses based on given prompts. It serves as a tool for generating meaningful explanations and full code related to Power Query."),
        P("The function takes three parameters:"),
        UL({
            B("apiKey:") & "This is the Open API Key required for authentication.",
            B("model:") & "This is the GPT chosen model.",
            B("prompt:") & "This is the prompt provided to the function, requesting information or code related to Power Query."
        }),
        P("The function,  constructs a request to the OpenAI API endpoint <code>https://api.openai.com/v1/chat/completions</code>."),
        P("The request body includes a system message indicating the role of the responder, as well as the user's prompt. The API key is included in the request headers for authentication."),
        P("Upon receiving the response from the API, the function extracts the content of the response message and returns it as the output.")

    }),
    Summary = [
        a = 1230,
        bold = Write.Element( "b", "BigText" ),
        Original = Original,
        first_pass_from_copilot_to_my_lib = first_pass_from_copilot_to_my_lib
    ]
in Summary