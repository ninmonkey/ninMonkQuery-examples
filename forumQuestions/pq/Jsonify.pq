let
// Convert to Json, then decode as a string. sometime useful because the UI auto decodes
// see also: TraceLevel.Error
Jsonify = (source as any, optional options as nullable record) as text => let
        encoding    = options[encoding]? ?? TextEncoding.Utf8,
        messageArgs = source,
        bytes       = Json.FromValue( messageArgs, encoding ),
        render      = Text.FromBinary( bytes, encoding )
    in
        render
in
    Jsonify( [ Message = "Hi world", Items = {0..4} ] )