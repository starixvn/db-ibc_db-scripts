 /*
	Created: Elodie
	Date: 2015-03-12
	Task: SaveBet report - Generate data for failed match 
	DB: DBACC/bodb_ACC
 */

USE [bodb_ACC]

CREATE TABLE #Match (ID INT IDENTITY(1,1), MatchID INT)
INSERT INTO #Match(MatchID)
SELECT 12218557
UNION ALL  
SELECT 12218564

UPDATE MatchList WITH(ROWLOCK,UPDLOCK) 
SET JobFinished = 0, JobGenerated = 0 
WHERE MatchID IN (SELECT MatchID FROM #Match)

SELECT DISTINCT MatchID, Bettype, LiveIndicator
INTO #MatchBettype
FROM bodb02.dbo.bettrans14 WITH(NOLOCK)
WHERE matchid IN (SELECT MatchID FROM #Match)
	AND bettype NOT IN(SELECT bettype FROM bodb02.dbo.f_VSHorseRacingByBettype())

DECLARE @MatchID INT,@ID INT,@Total INT

SET @ID = 1
SELECT @ID = 1,@Total = COUNT(*) FROM #Match

WHILE @ID <= @Total
BEGIN
	SELECT @MatchID=MatchID FROM #Match WHERE ID = @ID
	IF(NOT EXISTS(SELECT * FROM #MatchBettype WHERE MatchID=@MatchID))
	BEGIN
		DELETE MatchList WITH(ROWLOCK,UPDLOCK) WHERE MatchID = @MatchID
	END
	ELSE
	BEGIN
		INSERT INTO ServiceJob(MatchID,Bettype,LiveIndicator,JobType,TypeName)
		SELECT DISTINCT @MatchID, 0, 0, 'SUM', ''
		FROM #MatchBettype WHERE MatchID = @MatchID
		UNION ALL
		SELECT @MatchID, Bettype, liveindicator, 'TB', typenamee
		FROM #MatchBettype mb INNER JOIN bodb02.dbo.bettype WITH(NOLOCK) ON typeid = mb.bettype
		WHERE MatchID = @MatchID 
			AND bettype IN (1,3,7,8,20)
			AND liveindicator = 0
		UNION ALL
		SELECT @MatchID, Bettype, liveindicator, 'TB', typenamee
		FROM #MatchBettype  mb INNER JOIN bodb02.dbo.bettype WITH(NOLOCK) ON typeid = mb.bettype
		WHERE MatchID = @MatchID 
			AND bettype IN (1,3,7,8,20)
			AND liveindicator = 1
		UNION ALL
		SELECT @MatchID, Bettype, liveindicator, 'BETS', typenamee
		FROM #MatchBettype mb INNER JOIN bodb02.dbo.bettype WITH(NOLOCK) ON typeid = mb.bettype 
		WHERE MatchID = @MatchID 
		UNION ALL
		SELECT DISTINCT @MatchID, 0, 0, 'END',''
		FROM #MatchBettype 
		WHERE MatchID = @MatchID 

		UPDATE MatchList SET JobGenerated = 1 WHERE MatchID = @MatchID
	END
	SET @ID = @ID + 1
	
END
	
DROP TABLE #Match
DROP TABLE #MatchBettype

