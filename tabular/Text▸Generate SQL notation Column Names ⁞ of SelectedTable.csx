
/*
Output selected table's columns:
*/
string.Join(", ", 
    Selected.Table.DataColumns
        .OrderBy(c => c.SourceColumn)
        .Select(c => "[dbo].[" + c.SourceColumn + "]")
    ).Output();

/*

Output:
    [Date], [Event Id], [Name], [User Id]

*/