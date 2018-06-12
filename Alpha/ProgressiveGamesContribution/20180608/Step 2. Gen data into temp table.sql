USE [bodb_Summary]
GO

/*
	Created: 20180608@Percy
	Task: Regen data for rptProgressiveGamesContribution [Redmine: #96053]
	DB: DBSUM.bodb_Summary

	Step 2. Gen data into temp table
*/

TRUNCATE TABLE dbo.rptProgressiveGamesContribution_tmp

-- Member - RoleId = 1
BEGIN
	-- bettrans
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		b.WinlostDate,
		b.CustId,
		1 AS RoleId,
		b.Recommend,
		b.MRecommend,
		b.SRecommend,
		6 AS ProductId,
		b.Bettype,
		COUNT(b.TransID) AS Betcount,
		SUM(ISNULL(b.oddsspread, 0)),
		SUM(ISNULL(CONVERT(DECIMAL, b.betid)/100000000, 0)),
		SUM(ISNULL(b.awinlost, 0)) AS ContributionA,
		SUM(ISNULL(b.mwinlost, 0)) AS ContributionM,
		SUM(ISNULL(b.swinlost, 0)) AS ContributionS
	FROM bodb02.dbo.Bettrans b WITH (NOLOCK)
	WHERE b.StatusID NOT IN (0,1,102,101,103)
		AND b.bettype IN (2198, 2398, 2998)
	GROUP BY
		b.WinlostDate,
		b.CustId,
		b.Recommend,
		b.MRecommend,
		b.SRecommend,
		b.Bettype

	-- bettrans14
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		b.WinlostDate,
		b.CustId,
		1 AS RoleId,
		b.Recommend,
		b.MRecommend,
		b.SRecommend,
		6 AS ProductId,
		b.Bettype,
		COUNT(b.TransID) AS Betcount,
		SUM(ISNULL(b.oddsspread, 0)),
		SUM(ISNULL(CONVERT(DECIMAL, b.betid)/100000000, 0)),
		SUM(ISNULL(b.awinlost, 0)) AS ContributionA,
		SUM(ISNULL(b.mwinlost, 0)) AS ContributionM,
		SUM(ISNULL(b.swinlost, 0)) AS ContributionS
	FROM bodb02.dbo.Bettrans14 b WITH (NOLOCK)
	WHERE b.StatusID NOT IN (0,1,102,101,103)
		AND b.bettype IN (2198, 2398, 2998)	 
	GROUP BY
		b.WinlostDate,
		b.CustId,
		b.Recommend,
		b.MRecommend,
		b.SRecommend,
		b.Bettype

	-- bettrans_bk
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		6 AS ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	FROM OPENQUERY(DBARC, '
		SELECT b.WinlostDate,
			b.CustId,
			1 AS RoleId,
			b.Recommend,
			b.MRecommend,
			b.SRecommend,
			b.Bettype AS GameId,
			COUNT(b.TransID) AS Betcount,
			SUM(ISNULL(b.oddsspread, 0)) AS Turnover,
			SUM(ISNULL(CONVERT(DECIMAL, b.betid)/100000000, 0)) AS Contribution,
			SUM(ISNULL(b.awinlost, 0)) AS ContributionA,
			SUM(ISNULL(b.mwinlost, 0)) AS ContributionM,
			SUM(ISNULL(b.swinlost, 0)) AS ContributionS
		FROM bodb_Archive.dbo.Bettrans_bk b WITH (NOLOCK)
		WHERE b.StatusID NOT IN (0,1,102,101,103)
			AND b.WinlostDate >= ''2018-04-12''
			AND b.bettype IN (2198, 2398, 2998)
		GROUP BY
			b.WinlostDate,
			b.CustId,
			b.Recommend,
			b.MRecommend,
			b.SRecommend,
			b.Bettype'
		)
END

-- Agent - RoleId = 2
BEGIN
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		WinlostDate,
		Recommend AS CustId,
		2 AS RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		SUM(Betcount) AS Betcount,
		SUM(Turnover) AS Turnover,
		SUM(Contribution) AS Contribution,
		SUM(ContributionA) AS ContributionA,
		SUM(ContributionM) AS ContributionM,
		SUM(ContributionS) AS ContributionS
	FROM dbo.rptProgressiveGamesContribution_tmp
	WHERE RoleId = 1 
	GROUP BY
		WinlostDate,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId
END
				
-- Master - RoleId = 3
BEGIN
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		WinlostDate,
		MRecommend AS CustId,
		3 AS RoleId,
		0 AS Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		SUM(Betcount) AS Betcount,
		SUM(Turnover) AS Turnover,
		SUM(Contribution) AS Contribution,
		SUM(ContributionA) AS ContributionA,
		SUM(ContributionM) AS ContributionM,
		SUM(ContributionS) AS ContributionS
	FROM dbo.rptProgressiveGamesContribution_tmp
	WHERE RoleId = 1 
	GROUP BY
		WinlostDate,
		MRecommend,
		SRecommend,
		ProductId,
		GameId
END
							
-- Super - RoleId = 4
BEGIN
	INSERT INTO dbo.rptProgressiveGamesContribution_tmp
	(
		WinlostDate,
		CustId,
		RoleId,
		Recommend,
		MRecommend,
		SRecommend,
		ProductId,
		GameId,
		Betcount,
		Turnover,
		Contribution,
		ContributionA,
		ContributionM,
		ContributionS
	)

	SELECT
		WinlostDate,
		SRecommend AS CustId,
		4 AS RoleId,
		0 AS Recommend,
		0 AS MRecommend,
		SRecommend,
		ProductId,
		GameId,
		SUM(Betcount) AS Betcount,
		SUM(Turnover) AS Turnover,
		SUM(Contribution) AS Contribution,
		SUM(ContributionA) AS ContributionA,
		SUM(ContributionM) AS ContributionM,
		SUM(ContributionS) AS ContributionS
	FROM dbo.rptProgressiveGamesContribution_tmp
	WHERE RoleId = 1 
	GROUP BY
		WinlostDate,
		SRecommend,
		ProductId,
		GameId
END