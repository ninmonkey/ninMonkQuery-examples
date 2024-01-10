let
    // example using format strings correctly:
    example = Date.ToText( #date(2020, 1, 1), [ Format = "yyyy-MM-dd", Culture = "en-us" ] ),

    RequestNHLDate = ( when as any ) =>
        let
            base_url = "https://api-web.nhle.com",
            asDate = Date.From( when ), // allows dates or datetimes to be used
            relativePath = Text.Format(
                "/v1/standings/#[when]", [
                    when =
                        Date.ToText( asDate,
                            [ Format = "yyyy-MM-dd", Culture = "en-us" ] )
                ]
            ),
            response = Web.Contents( base_url, [ RelativePath = relativePath ] ),
            json = Json.Document( response ),
            standings = json[standings],
            schema = null, // I'm transforming it next step anyway
            baseTable = Table.FromRecords( standings, schema, MissingField.Error),
            expand1 = Table.ExpandRecordColumn( baseTable , "teamCommonName", {"default"}, {"teamCommonName"}),
            expand2 = Table.ExpandRecordColumn( expand1, "teamName", {"default"}, {"teamName"}),
            expand3 = Table.ExpandRecordColumn( expand2, "teamAbbrev", {"default"}, {"teamAbbrev"}),
            expand4 = Table.ExpandRecordColumn( expand3, "placeName", {"default"}, {"placeName"}),
            finalTransform = Table.TransformColumnTypes( expand4, standingSchema, "en-us" )
        in
            finalTransform,

    standingSchema = {
        // I grabbed just the default teamnames. there were extra translations for a few.
        // some percentages columns go outside the range of [0, 1], so I left them as decimal
        {"teamName", type text}, {"teamCommonName", type text}, {"teamAbbrev", type text},
        {"regulationWinPctg", Percentage.Type}, {"placeName", type text},
        {"conferenceAbbrev", type text}, {"conferenceHomeSequence", Int64.Type}, {"conferenceL10Sequence", Int64.Type}, {"conferenceName", type text},
        {"conferenceRoadSequence", Int64.Type}, {"conferenceSequence", Int64.Type}, {"date", type date}, {"divisionAbbrev", type text},
        {"divisionHomeSequence", Int64.Type}, {"divisionL10Sequence", Int64.Type}, {"divisionName", type text}, {"divisionRoadSequence", Int64.Type},
        {"divisionSequence", Int64.Type}, {"gameTypeId", Int64.Type}, {"gamesPlayed", Int64.Type}, {"goalDifferential", Int64.Type},
        {"goalDifferentialPctg", type number}, {"goalAgainst", Int64.Type}, {"goalFor", Int64.Type}, {"goalsForPctg", type number},
        {"homeGamesPlayed", Int64.Type}, {"homeGoalDifferential", Int64.Type}, {"homeGoalsAgainst", Int64.Type}, {"homeGoalsFor", Int64.Type},
        {"homeLosses", Int64.Type}, {"homeOtLosses", Int64.Type}, {"homePoints", Int64.Type}, {"homeRegulationPlusOtWins", Int64.Type},
        {"homeRegulationWins", Int64.Type}, {"homeTies", Int64.Type}, {"homeWins", Int64.Type}, {"l10GamesPlayed", Int64.Type},
        {"l10GoalDifferential", Int64.Type}, {"l10GoalsAgainst", Int64.Type}, {"l10GoalsFor", Int64.Type}, {"leagueL10Sequence", Int64.Type},
        {"leagueHomeSequence", Int64.Type}, {"l10Wins", Int64.Type}, {"l10Ties", Int64.Type}, {"l10RegulationWins", Int64.Type},
        {"l10RegulationPlusOtWins", Int64.Type}, {"l10Points", Int64.Type}, {"l10OtLosses", Int64.Type}, {"l10Losses", Int64.Type},
        {"leagueRoadSequence", Int64.Type}, {"leagueSequence", Int64.Type}, {"losses", Int64.Type}, {"otLosses", Int64.Type},
        {"points", Int64.Type}, {"regulationPlusOtWins", Int64.Type}, {"regulationWins", Int64.Type}, {"roadGamesPlayed", Int64.Type},
        {"roadGoalsAgainst", Int64.Type}, {"roadGoalDifferential", Int64.Type}, {"roadGoalsFor", Int64.Type}, {"roadLosses", Int64.Type},
        {"roadOtLosses", Int64.Type}, {"roadPoints", Int64.Type}, {"roadRegulationPlusOtWins", Int64.Type}, {"roadRegulationWins", Int64.Type},
        {"roadTies", Int64.Type}, {"roadWins", Int64.Type}, {"streakCount", Int64.Type}, {"seasonId", Int64.Type}, {"shootoutLosses", Int64.Type},
        {"shootoutWins", Int64.Type}, {"streakCode", type text}, {"ties", Int64.Type}, {"waiversSequence", Int64.Type}, {"wildcardSequence", Int64.Type},
        {"wins", Int64.Type}, {"winPctg", type number}, {"pointPctg", type number}, {"regulationPlusOtWinPctg", type number}, {"teamLogo", type text} },

    TestIt = RequestNHLDate( DateTime.LocalNow() ),
    t0 = TestIt

    // applySchema = Table.TransformColumnTypes( t0, )
in
    t0