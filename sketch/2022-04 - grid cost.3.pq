let
    Source = Table.NestedJoin(#"Raw_Observations_Data", {"Risk Rating"}, #"Risk Label", {"Risk Rating"}, "Risk Rating Dim", JoinKind.LeftOuter),
    #"Expanded Risk Rating Dim" = Table.ExpandTableColumn(Source, "Risk Rating Dim", {"Severity Prefix", "Severity Group", "Weight"}, {"Severity Prefix", "Severity Group", "Weight"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Risk Rating Dim", each ([Severity Prefix] <> "Commendation" )),
    #"Reordered Columns" = Table.ReorderColumns(#"Filtered Rows",{"Workflow Due Date", "Observation Type", "Severity Group", "Weight", "Risk Rating", "Report Suffix", "Report Name", "Reference Id", "Severity Prefix"})
in
    #"Reordered Columns"