let

    flattenSpans = (activeDurations as list, exhaustedDurations as list) as list =>
        let
            listLength = List.Count(activeDurations)
        in
            if listLength = 0 then
                exhaustedDurations
            else if listLength = 1 then
                activeDurations & exhaustedDurations
            else
                let
                    head = activeDurations{0},
                    tail = List.RemoveFirstN(activeDurations, 1),
                    partialSum = mergeSpans(head, tail, []),
                    newExhausted = exhaustedDurations & (partialSum[Removed] ?? []) & {(partialSum[Result] ?? [])},
                    newActive = List.Difference(tail, (partialSum[Removed] ?? []))
                in
                    @flattenSpans(newActive, newExhausted),
    mergeSpans = (base as record, toExamine as list, partial as record) as record =>
        if List.Count(toExamine) = 0 then
            partial & [Result = base]
        else
            let
                head = toExamine{0}, tail = List.RemoveFirstN(toExamine, 1), merged = findMaxSpanOrNull(base, head)
            in
                if merged <> null then
                    let
                        newPartial = partial & [Removed = partial[Removed]? ?? {} & {head}]
                    in
                        @mergeSpans(merged, tail, newPartial)
                else
                    @mergeSpans(base, tail, partial),

    findMaxSpanOrNull = // Given two records with the schema [Start = number, End = number] either:
//  * returns null if the two records don't overlap
//  * returns the merged times
        (A as record, B as record) as record =>
            // If they overlap
            if (A[Start] < B[End]) and (B[Start] < A[End])
            // Then find Min(A[Start], B[Start]) and Max(A[End, B[End])
            then
                [Start = if A[Start] < B[Start] then A[Start] else B[Start], End = if A[End] > B[End] then A[End] else B[End]]
            else
                null


in
    [
        flattenSpans = flattenSpans,
        mergeSpans = mergeSpans,
        findMaxSpanOrNull = findMaxSpanOrNull

    ]
