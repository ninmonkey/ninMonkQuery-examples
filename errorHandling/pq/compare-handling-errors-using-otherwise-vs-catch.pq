let
    main_preserve_errors = [
    // Source = Folder.Contents( "C:\nin_temp\pq" ),
    // #"Filtered Rows" = Table.SelectRows(Source, each ([Extension] = ".csv")),

//     path1 = "c:\nin_temp\pq",
//     Summary = [
//         source1  = Folder.Contents( path1 ),
//         source2  = Folder.Contents( Text.Combine({0..4})  ),

//         final1 =
//             try source2
//             otherwise "fallback value",

//         final2 =
//             try source2
//             catch (e) => e


// ],


    /*
     My example has 2 files. The first is real, the 2nd one is garbage data
        a valid file at:
            "c:\nin_temp\pq\json.is_good"

        and a file, but broken one at
            "c:\nin_temp\pq\json.is_bad",
     */
    //  pathz = "c:\pq",
    path1 = "c:\nin_temp\pq",
    dirListing = Folder.Contents( path1 ),
    dirListing21 = dirListing,
    source_bad = dirListing{[Name="json.is_bad"]}[Content],
    source_bad2 = dirListing{[Name="file_does_not_exist"]}[Content],
    source_bad3 = dirListing{[Name="file_does_not_exist"]}[NoKey][Content],
    source_bad4 = Folder.Contents( "some_invalid_path" ),
    source_good = dirListing{[Name="json.is_valid"]}[Content],

    json_bad = Json.Document( source_bad ),
    json_bad2 = Json.Document( source_bad2 ),
    json_good = Json.Document( source_good ),

    // #"Imported CSV" = Json.Document(#"json is_valid"),
    // #"Changed Type" = Table.TransformColumnTypes(#"Imported CSV",{{"Column1", type text}, {"Column2", type text}}),
    // Custom1 = dirListing,
    // you lose all the information in the error record using `otherwise`
    lost_it_all1 =
        try json_bad  otherwise json_good,
    lost_it_all2 =
        try json_bad2 otherwise json_good,

    final1 =
        try json_bad
        catch (e) => e,

    final2 =
        try json_bad2
        catch (e) => e,

    final3 =
        try json_good
        catch (e) => e,


    tableSummary = {
        [ Name = "Catch",       Actual = "File exists, but Json was an invalid format", Data = final1],
        [ Name = "Catch2",      Actual = "Key 'file_does_not_exist' #(cr,lf)does not match rows in table", Data = final2 ],
        [ Name = "Catch3",      Actual = "Actual Good, with no errors", Data = final3 ],

        [ Name = "Lost It All", Actual = "Actual", Data = lost_it_all1 ],

        [ Name = "Lost It All", Actual = "Actual", Data = lost_it_all1 ],
        [ Name = "Lost It All2",Actual = "Actual", Data = lost_it_all2 ]
    },


    z = Table.FromRecords(
            tableSummary
    )

],
    z = main_preserve_errors[z],
    #"Expanded Data" = Table.ExpandRecordColumn(z, "Data", {"Reason", "Message", "Detail", "Message.Format", "Message.Parameters", "name"}, {"Reason", "Message", "Detail", "Message.Format", "Message.Parameters", "name.1"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Data",{{"Reason", type text}, {"Message", type text}, {"Detail", type any}, {"Message.Format", type text}, {"Message.Parameters", type text}, {"name.1", type text}, {"Name", type text}})
in
    #"Changed Type"