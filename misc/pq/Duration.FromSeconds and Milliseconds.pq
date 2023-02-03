let 
		// aliases
    Ms = Duration.FromMs, Sec = Duration.FromSecs,

    // converts milliseconds to a duration
    Duration.FromMs = (milliseconds as number) as duration =>
        #duration(0, 0, 0, milliseconds / 1000),    

    // converts seconds to a duration
    Duration.FromSecs = (seconds as number) as duration =>
        #duration(0, 0, 0, seconds),    

    Example = [ 
        now 					= DateTime.LocalNow(),
        delta 				= Ms(250),
        later 				= now + delta,
        before 				= now - delta,
        pre_before 		= before - Ms(7400),
        doubleDelta 	= delta * 2,
        expectedDelta = doubleDelta = Sec(0.5)
    ]

in 
    Example
