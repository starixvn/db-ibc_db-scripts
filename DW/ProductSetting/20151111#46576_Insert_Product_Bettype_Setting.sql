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
		13
		,'Microgaming - Live Casino'
		,203
		,2001
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2002
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2003
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2004
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2005
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2006
		)
		,(
		13
		,'Microgaming - Live Casino'
		,203
		,2007
		)
		,(
		17
		,'Microgaming - RNG Casino'
		,205
		,2008
		)
		,(
		17
		,'Microgaming - RNG Casino'
		,205
		,2009
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

DELETE bodb_account.dbo.tbl_sport
WHERE Sportid IN (203, 205)

INSERT INTO bodb_account.dbo.tbl_sport
SELECT 203
	,'Microgaming - Live Casino'

UNION ALL
SELECT 205
	,'Microgaming - RNG Casino'
	
DROP TABLE #tmpSetting

