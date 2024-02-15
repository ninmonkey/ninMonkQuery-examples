let
    ToHex   = lib[Number.FormatHexString],
    RGB     = lib[Rgb.FromHexString],
    FromHex = lib[Number.FromHexString],
    summary = [
        rgb             = RGB( "feaa99"),
        what1           = 0x2400,
        what            = 203,
        what_hex        = ToHex( what ),
        what_hex_prefix = ToHex( what, [Prefix = true]),
        fromHex2        = FromHex( "0x2432" ),
        a               = Text.ToList(rgb_str),
        group           = [ r = a{0} & a{1} ],
        rgb_str         = "fe99aa",
        myStr           = "fe99",
        expr_const      = Expression.Constant("0x" & "fefe"),
        eval_const      = Expression.Evaluate(expr_const)
    ]
in
    summary