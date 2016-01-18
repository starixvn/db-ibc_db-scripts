USE bodb_Account
GO

SET NOCOUNT ON

SELECT 1 ProductID
	,'SportsBook' ProductName
	,1 SportID
	,Bettype
	,Typenamee
	,isLive
	,SubProduct
INTO #tmpSetting
FROM (
	SELECT 413 Bettype
		,1 isLive
		,'Correct Score (aos)' Typenamee
		,'' SubProduct
	
	UNION ALL
	SELECT 414 Bettype
		,1 isLive
		,'1H Correct Score (aos)' Typenamee
		,'' SubProduct
	) AA

--ProductBettypeSetting
DELETE SP
FROM bodb_Account.dbo.ProductBettypeSetting SP
	INNER JOIN #tmpSetting A
	ON A.Bettype = SP.Bettype

INSERT INTO bodb_Account.dbo.ProductBettypeSetting (
	ProductID
	,ProductName
	,Bettype
	,excluded
	,excluded_BetCount
	,excluded_TO
	,excluded_WL
	)
SELECT DISTINCT P.ProductID
	,P.ProductName
	,P.Bettype
	,0 excluded
	,0 excluded_BetCount
	,0 excluded_TO
	,0 excluded_WL
FROM #tmpSetting P

--Product_Bettype
DELETE SP
FROM bodb_Account.dbo.Product_Bettype SP
	INNER JOIN #tmpSetting A
	ON A.Bettype = SP.Bettype

INSERT INTO bodb_Account.dbo.Product_Bettype (
	ProductID
	,ProductName
	,Bettype
	)
SELECT DISTINCT P.ProductID
	,P.ProductName
	,P.Bettype
FROM #tmpSetting P

--Dot_Admin_Sport_Bettype
DELETE SP
FROM bodb_Account.dbo.Dot_Admin_Sport_Bettype SP
	INNER JOIN #tmpSetting A
	ON A.Bettype = SP.Bettype

INSERT INTO bodb_account.dbo.Dot_Admin_Sport_Bettype (
	[SportType]
	,[Bettype]
	,[Mode]
	,[enable]
	)
SELECT DISTINCT P.SportID
	,P.[Bettype]
	,P.islive [Mode]
	,1 [enable]
FROM #tmpSetting P
GO

UPDATE dbo.bettype
SET Typenamee = 'Exact Total Goals'
WHERE Typeid = 159

UPDATE dbo.bettype
SET Typenamee = 'Exact Home Team Goals'
WHERE Typeid = 161

UPDATE dbo.bettype
SET Typenamee = 'Winning Margin'
WHERE Typeid = 171

UPDATE dbo.bettype
SET Typenamee = 'Exact Away Team Goals'
WHERE Typeid = 162

UPDATE dbo.bettype
SET Typenamee = '1H Double Chance'
WHERE Typeid = 151

UPDATE dbo.bettype
SET Typenamee = '1H Draw No Bet'
WHERE Typeid = 191

UPDATE dbo.bettype
SET Typenamee = 'Exact Total Goals (own)'
WHERE Typeid = 406

UPDATE dbo.bettype
SET Typenamee = 'Exact Home Team Goals (own)'
WHERE Typeid = 407

UPDATE dbo.bettype
SET Typenamee = 'Winning Margin (own)'
WHERE Typeid = 408

UPDATE dbo.bettype
SET Typenamee = 'Exact Away Team Goals (own)'
WHERE Typeid = 409

UPDATE dbo.bettype
SET Typenamee = '1H Double Chance (own)'
WHERE Typeid = 410

UPDATE dbo.bettype
SET Typenamee = '1H Draw No Bet (own)'
WHERE Typeid = 411


DROP TABLE #tmpSetting