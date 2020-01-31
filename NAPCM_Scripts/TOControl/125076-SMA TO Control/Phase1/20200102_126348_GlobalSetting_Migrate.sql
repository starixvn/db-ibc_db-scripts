/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO

CREATE TABLE #DefaultValue (ProfileID SMALLINT, Sporttype SMALLINT, Site NVARCHAR(50), ExchangeID SMALLINT, MaxTurnover MONEY, ToCurrency INT )
/* STEP 1: Initial Default Value */
INSERT INTO #DefaultValue (ProfileID, Sporttype, Site, ExchangeID, MaxTurnover, ToCurrency)
SELECT 1  ProfileID, 1  Sporttype, '789y'   Site,0  ExchangeID, 60000  MaxTurnover,3   ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, '789y'  Site, 0 ExchangeID,30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 60000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, '789y'  Site,0 ExchangeID, 30000  MaxTurnover, 3  ToCurrency
UNION ALL
	
-- 789y UUS
SELECT 1  ProfileID, 1  Sporttype, '789y'   Site,20  ExchangeID, 60000  MaxTurnover,20   ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 60000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 30000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 30000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, '789y'  Site, 20 ExchangeID,30000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 60000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 60000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 30000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 30000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, '789y'  Site,20 ExchangeID, 30000  MaxTurnover, 20  ToCurrency
UNION ALL
	
-- CN88

SELECT 1  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 225000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 225000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 225000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 225000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, 'CN88'  Site,0 ExchangeID, 80000  MaxTurnover, 81  ToCurrency
UNION ALL
--CN88 UUS
	
SELECT 1  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 225000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 225000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 225000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 225000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, 'CN88'  Site,20 ExchangeID, 80000  MaxTurnover, 20  ToCurrency
UNION ALL
-- OTHER SITE SPORTTYPE = 1

SELECT 1  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 100000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, ''  Site, 0 ExchangeID,50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, ''  Site,0 ExchangeID, 50000  MaxTurnover, 2  ToCurrency
UNION ALL
-- Other site for UUS, sporttype = 1
SELECT 1  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 100000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 2  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 100000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 3  ProfileID, 1 Sporttype, ''  Site,20ExchangeID, 50000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 4  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 50000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 5  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 50000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 6  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 100000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 7  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 100000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 8  ProfileID, 1 Sporttype, ''  Site, 20 ExchangeID,50000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 9  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 50000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 10  ProfileID, 1 Sporttype, ''  Site,20 ExchangeID, 50000  MaxTurnover, 20  ToCurrency
UNION ALL
-- OTHER SPORT ALL SITE SPORT ID = 99

SELECT 11  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 37500  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 12  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 37500  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 13  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 14  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 15  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 16  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 37500  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 17  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 37500  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 18  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 19  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
UNION ALL
SELECT 20  ProfileID, 99 Sporttype, ''  Site,0 ExchangeID, 24000  MaxTurnover, 2  ToCurrency
   
-- other sport, other site for UUS
UNION ALL
SELECT 11  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 37500  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 12  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 37500  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 13  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 14  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 15  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 16  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 37500  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 17  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 37500  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 18  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 19  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency
UNION ALL
SELECT 20  ProfileID, 99 Sporttype, ''  Site,20 ExchangeID, 24000  MaxTurnover, 20  ToCurrency

/* STEP 2: Insert new default setting into ToControl_GlobalSetting */
INSERT INTO TOControl_GlobalSetting(CustID, Sporttype, IsGroupHeadLine, MaxTurnOver, ProfileID)
SELECT gl.CustID
    , CASE 
		-- currency RM in default Setting
		WHEN TO_tmp.TOCurrency = 2 THEN CONVERT(MONEY,TO_tmp.MaxTurnOver / E1.actualrate) 
		-- NOT currency RM in default Setting
		ELSE  CONVERT(MONEY,(TO_tmp.MaxTurnOver * E.actualrate)/E1.actualrate)
		END AS MaxTurnOver
	, TO_tmp.Sporttype
	, 0
	, TO_tmp.ProfileID
	            
FROM dbo.TOControl_GlobalSetting gl WITH(NOLOCK)
	INNER JOIN  dbo.Customer ci WITH (NOLOCK) ON gl.CustID = ci.custid	
	CROSS APPLY
		(        
			-- Soccer 
			SELECT TOP 10 f1.sporttype, f1.MaxTurnOver,f1.TOCurrency,f1.ProfileID
			FROM #DefaultValue f1                
			WHERE f1.site IN (ci.site,'') AND f1.ExchangeID IN (ci.currency,0) AND f1.sporttype = 1  AND gl.Sporttype = 1     
			ORDER BY f1.site DESC, f1.ExchangeID DESC 
			
			UNION ALL
			-- Others sport
			SELECT TOP 10 sporttype, MaxTurnOver,TOCurrency,f2.ProfileID
			FROM #DefaultValue f2                
			WHERE f2.site IN (ci.site,'') AND f2.ExchangeID IN (ci.currency,0) AND f2.sporttype = 99 AND gl.Sporttype = 99
			ORDER BY f2.site DESC, f2.ExchangeID DESC
		) AS TO_tmp
	INNER JOIN dbo.Exchange e WITH (NOLOCK) ON e.ExchangeID = TO_tmp.TOCurrency
	INNER JOIN dbo.Exchange e1 WITH (NOLOCK) ON e1.ExchangeID = ci.currency
	INNER JOIN TOControl_Profile pf WITH(NOLOCK) ON pf.ProfileID = TO_tmp.ProfileID 

DROP TABLE #DefaultValue

GO
