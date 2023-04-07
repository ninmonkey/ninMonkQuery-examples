var myMeasure = SelectMeasure();

var tFirst = Model.Tables.First();
tFirst.AddMeasure( myMeasure.Name + " copy ", myMeasure.Expression );

Output( tFirst ) ;
