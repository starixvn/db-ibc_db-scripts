USE bodb_Account
GO
SET NOCOUNT ON

SELECT ProductID
	,ProductName
	,SportID
	,Bettype
INTO #tmpSetting
FROM (
	VALUES (
		1
		,'SportsBook'
		,44
		,1
		)
		,(
		1
		,'SportsBook'
		,44
		,3
		)
		
	) A(ProductID, ProductName, SportID, Bettype)

--ProductBettypeSetting
DELETE SP
FROM bodb_Account.dbo.ProductBettypeSetting SP
	INNER JOIN #tmpSetting A ON A.ProductID = SP.ProductID
	AND A.Bettype = SP.Bettype

INSERT INTO bodb_Account.dbo.ProductBettypeSetting (
	ProductID
	,ProductName
	,Bettype
	,excluded
	,excluded_BetCount
	,excluded_TO
	,excluded_WL
	)
SELECT P.ProductID
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
	INNER JOIN #tmpSetting A ON 
	A.Bettype = SP.Bettype

INSERT INTO bodb_Account.dbo.Product_Bettype (
	ProductID
	,ProductName
	,Bettype
	)
SELECT P.ProductID
	,P.ProductName
	,P.Bettype
FROM #tmpSetting P

--Dot_Admin_3rdProduct_Bettype
DELETE SP
FROM bodb_Account.dbo.Dot_Admin_3rdProduct_Bettype SP
	INNER JOIN #tmpSetting A ON A.Bettype = SP.Bettype

INSERT INTO bodb_account.dbo.Dot_Admin_3rdProduct_Bettype (
	[SportType]
	,[Bettype]
	,[Mode]
	,[enable]
	)
SELECT P.SportID
	,P.[Bettype]
	,0 [Mode]
	,1 [enable]
FROM #tmpSetting P
UNION ALL
SELECT P.SportID
	,P.[Bettype]
	,1 [Mode]
	,1 [enable]
FROM #tmpSetting P


DELETE S 
FROM bodb_account.dbo.tbl_sport S
INNER JOIN #tmpSetting P
ON S.Sportid = P.SportID
 
 
INSERT INTO bodb_account.dbo.tbl_sport(sportid,sport)
SELECT DISTINCT S.SportType,S.SportName
FROM bodb02.dbo.Sports S
INNER JOIN #tmpSetting P
ON S.SportType = P.SportID
LEFT JOIN bodb_account.dbo.tbl_sport SDW
ON S.SportType = SDW.SportID
WHERE SDW.SportID IS NULL


DROP TABLE #tmpSetting
