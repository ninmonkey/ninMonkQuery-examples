var render =  "123";

var minDates = "min";
var maxDates = "max";


foreach(var c in Selected.Columns)
{
    minDates = minDates + "MIN(" + c.DaxObjectFullName + "),";
    maxDates = maxDates + "MAX(" + c.DaxObjectFullName + "),";
}

if (Selected.Columns.Count > 1)
{
    minDates = "MIN(" + minDates.TrimEnd(',') + ")";
    maxDates = "MAX(" + maxDates.TrimEnd(',') + ")";

}
else
{
    minDates = minDates.TrimEnd(',');
    maxDates = maxDates.TrimEnd(',');
}
var dax = @String.Format("ADDCOLUMNS(CALENDAR({0},{1}),\"Month\" , FORMAT( [Date] , \"Mmm\" ),\"Month No\" , MONTH([Date]),\"Year\" , YEAR([Date]),\"Month Year No\" , (YEAR([Date]) * 100) + MONTH ([Date]),\"Month Year\" , FORMAT( [Date] , \"Mmm yyyy\"),\"Quarter\" , QUARTER([Date]),\"Year Qtr\" , FORMAT( [Date] , \"YYYY QQ\"),\"Week Day\" , WEEKDAY([Date],2),\"Week\" , FORMAT( [Date] , \"Dddd\" ))", minDates, maxDates);

Output(dax);
Console.WriteLine(dax);

// Model.AddCalculatedTable("dimDate", dax);

//var dax = @String.Format("ADDCOLUMNS(CALENDAR({0},{1}),\"Month\" , FORMAT( [Date] , \"Mmm\" ),\"Month No\" , MONTH([Date]),\"Year\" , YEAR([Date]),\"Month Year No\" , (YEAR([Date]) * 100) + MONTH ([Date]),\"Month Year\" , FORMAT( [Date] , \"Mmm yyyy\"),\"Quarter\" , QUARTER([Date]),\"Year Qtr\" , FORMAT( [Date] , \"YYYY QQ\"),\"Week Day\" , WEEKDAY([Date],2),\"Week\" , FORMAT( [Date] , \"Dddd\" ))", minDates, maxDates);

//Console.WriteLine(dax);

// Model.AddCalculatedTable("dimDate", dax);