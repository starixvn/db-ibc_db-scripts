/*<info serverAlias="DBCTG-bodb02"></info>*/

/*
Create: 20230712@Lewis
Task: ReGen Data of Sum_Winloss_14 - SabaTennis [RedmineID: #190459]
DB: DBCTG-bodb02

*/

DECLARE @FromDate SMALLDATETIME = '20230630',
		@ToDate SMALLDATETIME = '20230708'

CREATE TABLE #databettrans14 (
	winlostdate SMALLDATETIME,
	custid INT
)
INSERT INTO #databettrans14 (
	winlostdate,
	custid
)
SELECT DISTINCT
	b.winlostdate,
	b.custid
FROM bettrans14 b WITH (NOLOCK)
INNER JOIN match14 m WITH (NOLOCK)
	ON b.matchid = m.matchid
INNER JOIN (
			SELECT  leagueid,LeagueGroupID 
			FROM League WITH (NOLOCK) 
			WHERE LeagueGroupID = 42 AND sporttype = 5
		  ) l
	ON l.leagueid = m.leagueid
WHERE b.winlostdate >= @FromDate
	AND b.winlostdate <= @ToDate
	AND b.statusID IN (111,112,113)

DECLARE @wldate SMALLDATETIME = @FromDate, @ErrCode INT

WHILE @wldate <= @ToDate
BEGIN 
	DECLARE @custids VARCHAR(MAX)
	
	SELECT @custids = STRING_AGG(CAST(b.custid AS VARCHAR(MAX)),',')
	FROM #databettrans14 b
	WHERE b.winlostdate = @wldate
	
	BEGIN TRY
		PRINT @wldate
		EXEC Task_sum_winloss_14 @WinlostDate = @wldate,@CustIds = @custids
	END TRY
	BEGIN CATCH
		SELECT @ErrCode = ERROR_NUMBER()
		BREAK
	END CATCH
	
	SET @wldate = DATEADD(d,1,@wldate) 
	WAITFOR DELAY '00:00:02'

END 
DROP TABLE #databettrans14
