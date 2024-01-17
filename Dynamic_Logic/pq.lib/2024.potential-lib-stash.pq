let
    Source = Animal,

    GroupBy.ShowCounts = (source as table, columnNames as list) as record => [
        columnsThatExist = [
            src_colNames = Table.ColumnNames(source),
            all_exist = List.ContainsAll( src_colNames, columnNames, Comparer.Ordinal ),
            assert = all_exist,
            error_missingMandatory = [
                Message.Format = "RequiredParameterMissingValues: ColumnNames: Wanted: #[WantedColumns], Actual: #[FoundColumns]",
                Message.Parameters = [ WantedColumns = columnNames, FoundColumns = src_colNames ]],
            final_data = columnNames,
            ret = if assert then final_data else error error_missingMandatory
        ][ret],

        // grp = Table.Group( source, columnNames ),
        final_data = columnsThatExist

    ][[final_data]],
    //   distinct_per_pair = Table.Group(Source, {"Species", "Region"}, {{"Distinct", each Table.RowCount(Table.Distinct(_, {"Species", "Region"})), Int64.Type}, {"Count", each Table.RowCount(_), Int64.Type}})

    tryIt_err = GroupBy.ShowCounts( Animal, {"Species", "Region", "Cat" }),
    tryIt_ok  = GroupBy.ShowCounts( Animal, {"Species", "Region"}),

    distinct_per_pair = Table.Group(Source, {"Species", "Region"},
    {{"Distinct", each Table.RowCount(Table.Distinct(_, {"Species", "Region"})), Int64.Type}, {"Count", each Table.RowCount(_), Int64.Type}})
in
    distinct_per_pair