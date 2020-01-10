/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO
CREATE TABLE #DefaultValue (ProfileID SMALLINT, Sporttype SMALLINT,Site NVARCHAR(50), MaxTurnover MONEY, ToCurrency INT )
/* STEP 1: Initial Default Value */
INSERT INTO #DefaultValue (ProfileID, Sporttype ,Site, MaxTurnover, ToCurrency)
SELECT 1  ProfileID, 1 Sporttype, '789y'  Site, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, '789y'  Site, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, '789y'  Site, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, '789y'  Site, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, '789y'  Site, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
-- CN88

SELECT 1  ProfileID, 1 Sporttype, 'CN88'  Site, 300000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, 'CN88'  Site, 300000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, 'CN88'  Site, 300000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, 'CN88'  Site, 300000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, 'CN88'  Site, 100000  MaxTurnover, 81  ToCurrency
UNION ALL
-- OTHER SITE SPORTTYPE = 1

SELECT 1  ProfileID, 1 Sporttype, ''  Site, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, ''  Site, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, ''  Site, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, ''  Site, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
-- OTHER SPORT ALL SITE SPORT ID = 99

SELECT 11  ProfileID, 99 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 12  ProfileID, 99 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 13  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 14  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 15  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 16  ProfileID, 99 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 17  ProfileID, 99 Sporttype, ''  Site, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 18  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 19  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 20  ProfileID, 99 Sporttype, ''  Site, 30000  MaxTurnover, 2  ToCurrency


/* STEP 2: Insert new default setting into ToControl_GlobalSetting */
INSERT INTO TOControl_GlobalSetting(CustID, Sporttype, IsGroupHeadLine, MaxTurnOver, ProfileID)
SELECT tmp.custid
	,tmp.Sporttype
	,IsGroupHeadLine
	,CASE 
		WHEN df.ToCurrency = 2 THEN CONVERT(MONEY, df.MaxTurnover/ex.actualrate) 
		ELSE CONVERT(MONEY, df.MaxTurnover * ex2.actualrate/ ex.actualrate) 
		END AS MaxTurnover
	,pf.ProfileID	
FROM TOControl_GlobalSetting_temp tmp WITH (NOLOCK)
  INNER JOIN dbo.Customer ci WITH (NOLOCK) ON tmp.CustID = ci.custid AND ci.currency NOT IN (20, 27 , 28)
  INNER JOIN dbo.exchange ex WITH (NOLOCK) ON ci.currency =  ex.exchangeid
  INNER JOIN #DefaultValue df WITH (NOLOCK) ON tmp.Sporttype = df.Sporttype AND df.Site = CASE WHEN ci.site IN ('789y', 'CN88') AND df.Sporttype = 1 THEN ci.site ELSE '' END  
  INNER JOIN dbo.exchange ex2 WITH (NOLOCK) ON df.ToCurrency = ex2.exchangeid
  INNER JOIN dbo.TOControl_Profile  pf WITH (NOLOCK) ON pf.Sporttype = df.Sporttype AND pf.ProfileID = df.ProfileID

DROP TABLE #DefaultValue

GO
