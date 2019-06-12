/*
	Created: 20190605@Helen
	Task: Script top update existing setting of CN88 [Redmine:113233]
	DB: DBCUST/CUSTDB
	
	-- Check data CN88
	SELECT COUNT(1)
	FROM dbo.TOControl_GlobalSetting g WITH (ROWLOCK, UPDLOCK)
		 INNER JOIN dbo.Customer c WITH (NOLOCK) ON g.CustId = c.CustId
	WHERE c.Site = 'CN88'

*/
USE CustDB

GO

DECLARE @MaxTurnOver MONEY =  660000

CREATE TABLE #Global_tmp (CustID INT,MaxTurnOver MONEY )
CREATE TABLE #Match_running (Matchid INT)

--------------1 - DATA PREPARATION ------------------
INSERT INTO #Global_tmp (CustID, MaxTurnOver)
SELECT DISTINCT g.custID, CASE WHEN c.currency = 20 THEN @MaxTurnOver ELSE CONVERT(MONEY,(@MaxTurnOver /e.actualrate)) END AS MaxTurnOver
FROM dbo.TOControl_GlobalSetting g WITH (NOLOCK)
     INNER JOIN dbo.Customer c WITH (NOLOCK) ON g.CustId = c.CustId
     INNER JOIN dbo.Exchange e WITH (NOLOCK) ON c.Currency = e.ExchangeId
WHERE c.Site = 'CN88'

--------- 2 - Update TOControl_GlobalSetting ---------------------------
UPDATE g
	SET g.MaxTurnOver = c.MaxTurnOver
FROM dbo.TOControl_GlobalSetting g WITH (ROWLOCK)
     INNER JOIN #Global_tmp c WITH (NOLOCK) ON g.CustId = c.CustId

--------- 3 - Update TOControl_Setting ---------------------------     
----Get running match(s)
INSERT INTO #Match_running (Matchid)
SELECT MatchId 
FROM OPENQUERY (DBAGE,'SELECT MatchId
FROM bodb02.dbo.Match WITH (NOLOCK)
WHERE EventStatus = ''running'' AND SportType = 1')
    
CREATE TABLE #TOMatchList
(
	Id INT IDENTITY(1, 1),
	CustId INT,
    MatchId INT,
    MaxTurnOver MONEY
)

INSERT INTO #TOMatchList (CustId, MatchId, MaxTurnOver)
SELECT DISTINCT s.CustId, s.MatchId, gl.MaxTurnOver
FROM dbo.TOControl_Setting s WITH (NOLOCK)
	INNER JOIN #Match_running m ON s.Matchid = m.Matchid
    INNER JOIN #Global_tmp gl ON gl.CustID = s.CustID
    
-- TOControl_Setting: batch update 1000
DECLARE @MaxId INT
SELECT @MaxId = MAX(Id) FROM #TOMatchList

DECLARE @Index INT = 1

WHILE @Index <= @MaxId
BEGIN
    UPDATE s
		SET MaxTurnOver = t.MaxTurnOver
			,IsNotified = 0
			,PercentLevel = ISNULL((SELECT MAX(PercentLevel) 
									FROM dbo.TOControl_LevelSetting WITH (NOLOCK) 
									WHERE (HouseTurnOver * 100 / t.MaxTurnOver) >= PercentValue), 0)
									
	FROM dbo.TOControl_Setting s WITH (ROWLOCK)
		INNER JOIN #TOMatchList t WITH (NOLOCK) ON s.CustId = t.CustId AND s.MatchId = t.MatchId
	WHERE t.Id BETWEEN @Index AND @Index + 999

	SET @Index += 1000
END 

/* 
-- check data
SELECT g.MaxTurnOver,currency, g.*
FROM dbo.TOControl_GlobalSetting g WITH (ROWLOCK, UPDLOCK)
	 INNER JOIN dbo.Customer c WITH (NOLOCK) ON g.CustId = c.CustId
WHERE c.Site = 'CN88' 
ORDER BY g.custID

SELECT g.MaxTurnOver,currency, g.*
FROM dbo.TOControl_Setting g WITH (ROWLOCK, UPDLOCK)
	 INNER JOIN dbo.Customer c WITH (NOLOCK) ON g.CustId = c.CustId
WHERE c.Site = 'CN88' 
ORDER BY g.custID


*/

DROP TABLE #Global_tmp
DROP TABLE #Match_running
DROP TABLE #TOMatchList


