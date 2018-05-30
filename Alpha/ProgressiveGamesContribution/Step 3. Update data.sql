USE [bodb_Summary]
GO

/*
	Created: 20180530@Percy
	Task: Regen data for rptProgressiveGamesContribution [Redmine: #96053]
	DB: DBSUM.bodb_Summary

	Step 3: Update data
*/

-- 3133 rows
TRUNCATE TABLE dbo.rptProgressiveGamesContribution

INSERT INTO dbo.rptProgressiveGamesContribution
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
	ProductId,
	GameId,
	Betcount,
	Turnover,
	Contribution,
	ContributionA,
	ContributionM,
	ContributionS
FROM dbo.rptProgressiveGamesContribution_tmp WITH (NOLOCK)