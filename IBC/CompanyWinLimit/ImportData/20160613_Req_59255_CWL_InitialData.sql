/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBPRO/bodb02 (DB230 - DB206)
	
*/

INSERT INTO Winlimit_LevelSetting (LevelID, LevelName) 
VALUES 
 (1,	'Orange')
, (2,	'Yellow')
, (3,	'Red')
GO

INSERT INTO Winlimit_ActionSetting (ActionID, ActionName) 
VALUES 
 (0,	'Warning') 
,(1,	'Blocked Placebet')
,(2,	'Unblocked Placebet')
,(3,	'Blocked Transfer/Withdraw')
,(4,	'Unblocked Transfer/Withdraw')

GO

INSERT INTO Winlimit_ProductSetting (ProductID,	BettypeID, LevelID, SettingStatus)
VALUES
(6,	2101,	1,	1)
,(6,	2101,	2,	1)
,(6,	2101,	3,	1)
,(13,	2001,	1,	1)
,(13,	2001,	2,	1)
,(13,	2001,	3,	1)
,(17,	2008,	1,	1)
,(17,	2008,	2,	1)
,(17,	2008,	3,	1)
,(22,	4001,	1,	1)
,(22,	4001,	2,	1)
,(22,	4001,	3,	1)

GO

INSERT INTO Winlimit_ProductSiteCurrencyRef (ProductID,SiteID,ExchangeID)
--RNG Casino: all
SELECT DISTINCT 6 AS ProductID, Siteid, c.currency
FROM DBCUST.CustDB.dbo.Site S
	INNER JOIN DBCUST.CustDB.dbo.Customer C WITH(NOLOCK) ON C.site = S.site
WHERE S.Islicensee = 0 AND S.isactive = 1
	AND C.roleid=2 AND C.srecommend NOT IN (SELECT custid FROM DBCUST.CustDB.dbo.Dep_CustSuper WITH(NOLOCK))
UNION ALL	
--	Macau Games: 
SELECT DISTINCT 22 AS ProductID, Siteid, c.currency
FROM DBCUST.CustDB.dbo.Site S
	INNER JOIN DBCUST.CustDB.dbo.Customer C WITH(NOLOCK) ON C.site = S.site
WHERE S.Islicensee = 0 AND S.isactive = 1
	AND C.roleid=2 AND C.srecommend NOT IN (SELECT custid FROM DBCUST.CustDB.dbo.Dep_CustSuper WITH(NOLOCK))
	AND c.site IN ('755555', 'INDO', 'KORIBC','611111','789y','733333')
	