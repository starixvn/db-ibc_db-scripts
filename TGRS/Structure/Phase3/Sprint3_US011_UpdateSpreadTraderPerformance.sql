/*
	Created: 20160309@Billy
	Task: Update Spread Data in Trader Performance table [Redmine: #53032]
	DB: DBTGRS\bodb_TGRS
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------

DECLARE	@ProcessingDay	DATETIME

CREATE TABLE	#Date (
					EventDate		DATETIME
				,	IsFinished		BIT
				)

CREATE TABLE	#Spread (
					CustId			INT
				,	MatchId			INT
				,	BetType			INT
				,	SpecialType		TINYINT
				,	BetType_TGR		INT
				,	Spread			SMALLINT
				)

INSERT INTO	#Date (
				EventDate
			,	IsFinished
			)
SELECT DISTINCT	m.eventdate, 0
FROM	bodb02.dbo.match AS m WITH (NOLOCK)

WHILE (0 = 0)
BEGIN
	UPDATE TOP(1)	d
	SET	@ProcessingDay = d.EventDate
	,	d.IsFinished = 1
	FROM	#Date AS d
	WHERE	d.IsFinished = 0

	IF	@@ROWCOUNT = 0
		BREAK

	TRUNCATE TABLE #Spread

	INSERT INTO	#Spread (
					CustId
				,	MatchId
				,	BetType
				,	SpecialType
				,	Spread
				)
	SELECT	ao.OperatorID
		,	ao.matchid
		,	CASE	WHEN (ao.BetType = 1 or ao.BetType=5) AND (ao.OperatorType = 1)
						THEN 1
					WHEN (ao.BetType = 1 AND ao.OperatorType = 2)
						THEN 7
					WHEN (ao.BetType = 2 AND ao.OperatorType = 1)
						THEN 3
					WHEN (ao.BetType = 2 AND ao.OperatorType = 2)
						THEN 8
					WHEN (ao.BetType = 3 AND ao.OperatorType = 1)
						THEN 5
					WHEN (ao.BetType = 3 AND ao.OperatorType = 2)
						THEN 15
					WHEN (ao.BetType = 4 AND ao.OperatorType = 1)
						THEN 2
					WHEN (ao.BetType = 4 AND ao.OperatorType = 2)
						THEN 12
					ELSE 0
			END		BetType
		,	CASE	WHEN l.leaguename LIKE '%SPECIFIC 15 MINS TOTAL BOOKINGS%'
						THEN 1
					WHEN l.leaguename LIKE '%SPECIFIC 15 MINS%' AND t.TeamName LIKE '%No.of Corners%'
						THEN 2
					WHEN l.leaguename LIKE '%SPECIALS' AND (t.TeamName LIKE '%Over' or t.TeamName LIKE '%Under')
						THEN 3
					WHEN l.leaguename LIKE '%SPECIFIC 15 MINS%'
						THEN 4
					WHEN l.leaguename LIKE '%SPECIFIC 10 MINS%'
						THEN 5
					WHEN t.teamname LIKE '%No.of Corners%'
						THEN 6
					WHEN t.teamname LIKE '%Total Bookings'
						THEN 7
					WHEN t.teamname LIKE '%Corner%'
						THEN 8
					WHEN t.teamname LIKE '%Booking'
						THEN 9
					ELSE 0
			END		SpecialType
		,	CAST(mm.Spread * 100 AS SMALLINT) Spread
	FROM		bodb_Archive.dbo.Dot_Admin_Assignment_Operator_bk AS ao WITH (NOLOCK)
	INNER JOIN	bodb02.dbo.match AS m WITH (NOLOCK)
			ON	m.matchid = ao.matchid
	LEFT JOIN	bodb02.dbo.Team AS t WITH (NOLOCK)
			ON	m.homeid = t.teamid
	LEFT JOIN	bodb02.dbo.league AS l WITH (NOLOCK)
			ON	l.leagueid = m.leagueid
	LEFT JOIN	bodb02.dbo.MatchMaxbet AS mm WITH (NOLOCK)
			ON	mm.MatchId = m.matchid
	WHERE	m.eventdate = @ProcessingDay
		AND	m.sporttype = 1
		AND	ao.OperatorType < 3
		AND m.matchcode NOT LIKE '%hedge%'

	UPDATE #Spread WITH (ROWLOCK, UPDLOCK)
	SET BetType_TGR =	CASE	WHEN BetType = 1 AND SpecialType = 0
									THEN 1		-- HDP
								WHEN BetType = 7
									THEN 7		-- 1st HDP
								WHEN BetType = 3 AND SpecialType = 0
									THEN 3		-- O/U		
								WHEN BetType = 8 AND SpecialType = 0
									THEN 8		-- 1st O/U
								WHEN BetType = 2
									THEN 2		-- O/E
								WHEN BetType = 12
									THEN 12		-- 1x2
					
								WHEN BetType IN (5, 124) AND SpecialType = 0
									THEN 5		-- 1x2		
								WHEN BetType IN (5, 124) AND SpecialType = 5
									THEN -14	-- 10mins 1x2
								WHEN BetType IN (15, 125) AND SpecialType = 0
									THEN 15		-- 1st 1x2

								WHEN BetType = 1 AND SpecialType = 4
									THEN -1		-- 15mins HDP
								WHEN BetType = 1 AND SpecialType = 8
									THEN -2		-- Next Corner
								WHEN BetType = 1 AND SpecialType = 5
									THEN -15	-- 10mins HDP
								WHEN BetType = 1 AND SpecialType = 9
									THEN -3		-- Next Booking

								WHEN BetType IN (5,124) AND SpecialType = 4
									THEN -4		-- 15mins 1X2

								WHEN BetType = 3 AND SpecialType = 4
									THEN -5		-- 15mins O/U
								WHEN BetType = 3 AND SpecialType = 5
									THEN -6		-- 10mins O/U
								WHEN BetType = 3 AND SpecialType = 2
									THEN -7		-- Corners 15mins O/U
								WHEN BetType = 3 AND SpecialType = 7
									THEN -8		-- Total Bookings
								WHEN BetType = 3 AND SpecialType = 1
									THEN -10	-- Total Bookings 15mins O/U
								WHEN BetType = 3 AND SpecialType = 6
									THEN -13	-- No. of Corner
									
								WHEN BetType = 8 AND SpecialType = 6
									THEN -12	-- 1st No. of Corner
								WHEN BetType = 8 AND SpecialType = 7
									THEN -9		-- 1st TotalBookings

								WHEN (BetType = 3 OR BetType = 8) AND SpecialType = 3
									THEN -11	-- Single Team O/U
								WHEN BetType IN (5, 124)
									THEN 5		-- 1x2	
								WHEN BetType IN (15, 125)
									THEN 15		-- 1st 1x2
								ELSE BetType
								END

	UPDATE	tp
	SET	tp.Spread = s.Spread
	FROM		dbo.TraderPerformance AS tp WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	#Spread AS s WITH (NOLOCK)
			ON	s.CustId = tp.CustId
			AND	s.MatchId = tp.MatchId
			AND	s.BetType_TGR = tp.BetType
END


INSERT INTO	#Date (
				EventDate
			,	IsFinished
			)
SELECT DISTINCT	m.eventdate, 0
FROM	bodb02.dbo.match14 AS m WITH (NOLOCK)

WHILE (0 = 0)
BEGIN
	UPDATE TOP(1)	d
	SET	@ProcessingDay = d.EventDate
	,	d.IsFinished = 1
	FROM	#Date AS d
	WHERE	d.IsFinished = 0

	IF	@@ROWCOUNT = 0
		BREAK

	INSERT INTO	#Spread (
					CustId
				,	MatchId
				,	BetType
				,	SpecialType
				,	Spread
				)
	SELECT	ao.OperatorID
		,	ao.matchid
		,	CASE	WHEN (ao.BetType = 1 or ao.BetType=5) AND (ao.OperatorType = 1)
						THEN 1
					WHEN (ao.BetType = 1 AND ao.OperatorType = 2)
						THEN 7
					WHEN (ao.BetType = 2 AND ao.OperatorType = 1)
						THEN 3
					WHEN (ao.BetType = 2 AND ao.OperatorType = 2)
						THEN 8
					WHEN (ao.BetType = 3 AND ao.OperatorType = 1)
						THEN 5
					WHEN (ao.BetType = 3 AND ao.OperatorType = 2)
						THEN 15
					WHEN (ao.BetType = 4 AND ao.OperatorType = 1)
						THEN 2
					WHEN (ao.BetType = 4 AND ao.OperatorType = 2)
						THEN 12
					ELSE 0
			END		BetType
		,	CASE	WHEN l.leaguename LIKE '%SPECIFIC 15 MINS TOTAL BOOKINGS%'
						THEN 1
					WHEN l.leaguename LIKE '%SPECIFIC 15 MINS%' AND t.TeamName LIKE '%No.of Corners%'
						THEN 2
					WHEN l.leaguename LIKE '%SPECIALS' AND (t.TeamName LIKE '%Over' or t.TeamName LIKE '%Under')
						THEN 3
					WHEN l.leaguename LIKE '%SPECIFIC 15 MINS%'
						THEN 4
					WHEN l.leaguename LIKE '%SPECIFIC 10 MINS%'
						THEN 5
					WHEN t.teamname LIKE '%No.of Corners%'
						THEN 6
					WHEN t.teamname LIKE '%Total Bookings'
						THEN 7
					WHEN t.teamname LIKE '%Corner%'
						THEN 8
					WHEN t.teamname LIKE '%Booking'
						THEN 9
					ELSE 0
			END		SpecialType
		,	CAST(mm.Spread * 100 AS SMALLINT) Spread
	FROM		bodb_Archive.dbo.Dot_Admin_Assignment_Operator_bk AS ao WITH (NOLOCK)
	INNER JOIN	bodb02.dbo.match14 AS m WITH (NOLOCK)
			ON	m.matchid = ao.matchid
	LEFT JOIN	bodb02.dbo.Team AS t WITH (NOLOCK)
			ON	m.homeid = t.teamid
	LEFT JOIN	bodb02.dbo.league AS l WITH (NOLOCK)
			ON	l.leagueid = m.leagueid
	LEFT JOIN	bodb02.dbo.MatchMaxbet14 AS mm WITH (NOLOCK)
			ON	mm.MatchId = m.matchid
	WHERE	m.eventdate = @ProcessingDay
		AND	m.sporttype = 1
		AND	ao.OperatorType < 3
		AND m.matchcode NOT LIKE '%hedge%'

	UPDATE #Spread WITH (ROWLOCK, UPDLOCK)
	SET BetType_TGR =	CASE	WHEN BetType = 1 AND SpecialType = 0
									THEN 1		-- HDP
								WHEN BetType = 7
									THEN 7		-- 1st HDP
								WHEN BetType = 3 AND SpecialType = 0
									THEN 3		-- O/U		
								WHEN BetType = 8 AND SpecialType = 0
									THEN 8		-- 1st O/U
								WHEN BetType = 2
									THEN 2		-- O/E
								WHEN .BetType = 12
									THEN 12		-- 1x2
					
								WHEN BetType IN (5, 124) AND SpecialType = 0
									THEN 5		-- 1x2		
								WHEN BetType IN (5, 124) AND SpecialType = 5
									THEN -14	-- 10mins 1x2
								WHEN BetType IN (15, 125) AND SpecialType = 0
									THEN 15		-- 1st 1x2

								WHEN BetType = 1 AND SpecialType = 4
									THEN -1		-- 15mins HDP
								WHEN BetType = 1 AND SpecialType = 8
									THEN -2		-- Next Corner
								WHEN BetType = 1 AND SpecialType = 5
									THEN -15	-- 10mins HDP
								WHEN BetType = 1 AND SpecialType = 9
									THEN -3		-- Next Booking

								WHEN BetType IN (5,124) AND SpecialType = 4
									THEN -4		-- 15mins 1X2

								WHEN BetType = 3 AND SpecialType = 4
									THEN -5		-- 15mins O/U
								WHEN BetType = 3 AND SpecialType = 5
									THEN -6		-- 10mins O/U
								WHEN BetType = 3 AND SpecialType = 2
									THEN -7		-- Corners 15mins O/U
								WHEN BetType = 3 AND SpecialType = 7
									THEN -8		-- Total Bookings
								WHEN BetType = 3 AND SpecialType = 1
									THEN -10	-- Total Bookings 15mins O/U
								WHEN BetType = 3 AND SpecialType = 6
									THEN -13	-- No. of Corner
									
								WHEN BetType = 8 AND SpecialType = 6
									THEN -12	-- 1st No. of Corner
								WHEN BetType = 8 AND SpecialType = 7
									THEN -9		-- 1st TotalBookings

								WHEN (BetType = 3 OR BetType = 8) AND SpecialType = 3
									THEN -11	-- Single Team O/U
								WHEN BetType IN (5, 124)
									THEN 5		-- 1x2	
								WHEN BetType IN (15, 125)
									THEN 15		-- 1st 1x2
								ELSE BetType
								END

	UPDATE	tp
	SET	tp.Spread = s.Spread
	FROM		dbo.TraderPerformance AS tp WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	#Spread AS s WITH (NOLOCK)
			ON	s.CustId = tp.CustId
			AND	s.MatchId = tp.MatchId
			AND	s.BetType_TGR = tp.BetType
END