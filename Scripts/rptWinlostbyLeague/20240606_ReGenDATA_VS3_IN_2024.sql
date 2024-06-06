
/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20240606@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Re-gen VS3 from 2024-01-01 
	

*/

USE bodb_LicenseeReport
SET NOCOUNT ON

DECLARE @Msg VARCHAR (500),@rowCount BIGINT;
SET @Msg =   'Start checking ...';
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay
DECLARE @MoveBetsDay SMALLDATETIME, @BalanceUpDate SMALLDATETIME
SELECT  @MoveBetsDay = MoveBetsDay, @BalanceUpDate = BalanceUpDay FROM @MBBU

DECLARE @LstWLdate TABLE (winlostdate SMALLDATETIME, IsCheck BIT DEFAULT(0))
INSERT INTO @LstWLdate (winlostdate)
SELECT DISTINCT winlostdate from dbo.rptLicenseeWinloss WITH(NOLOCK)
where Sporttype IN (179,178) and winlostdate >= '2024-01-01'
group by winlostdate
--VALUES ('20240501', DEFAULT);

SET @rowCount = @@rowcount;
SET @Msg =  'Insert into @LstWLdate - Affected row : ' + CAST (@rowCount AS VARCHAR(50));
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

DECLARE @winlostdate SMALLDATETIME
DECLARE @sqlCmd NVARCHAR(MAX)

WHILE EXISTS (SELECT 1 FROM @LstWLdate WHERE IsCheck = 0)
BEGIN
	SELECT TOP 1 @winlostdate = winlostdate FROM @LstWLdate WHERE IsCheck = 0 ORDER BY winlostdate
	SET @Msg =  'DOING - @winlostdate : ' + CONVERT(VARCHAR(20),@winlostdate,112)
	RAISERROR (@Msg , 0, 1) WITH NOWAIT;
	
	IF @winlostdate < @BalanceUpDate
	BEGIN
    	SET @sqlCmd = N'SELECT t.*
		FROM OPENQUERY(DBARC, ''
		;WITH cte_bettrans AS (
		SELECT a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,SUM(ABS(a.stake)) AS stake
			,SUM(a.winlost - a.actual_stake) AS winlost
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,COUNT(a.custid) AS betcount
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS comm
			,SUM(a.playercomm) AS playercomm
			,a.currency
			,a.liveindicator
		FROM bodb_archive.dbo.bettrans_bk AS a WITH (NOLOCK)
			INNER JOIN bodb_licensee.dbo.f_SelLicenseeCust(0) AS LC ON a.recommend = lc.custid AND a.currency = lc.currency
		WHERE a.winlostdate ='''''+CONVERT(VARCHAR(20),@winlostdate,112)+'''''
			AND a.statusID IN (111, 112, 113) 
			AND a.matchid >= 0
			AND a.bettype in (5302,5303,5304,5305,5306,5307)
		GROUP BY a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,a.currency
			,a.liveindicator
		)
		SELECT a.winlostdate
			,a.matchid
			,a.oddsid
			,ISNULL(b.LeagueID, -1) LeagueID
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,SUM(a.stake) AS stake
			,SUM(winlost) AS winlost
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS Comm
			,SUM(a.playercomm) AS playercomm
			,a.recommend
			,0 AS isBA
			,SUM(a.betcount) AS betcount
			,a.currency
			,a.liveindicator
			,NULL AS TicketType
		FROM cte_bettrans AS a
			LEFT JOIN bodb_archive.dbo.match_bk AS b WITH (NOLOCK) ON a.matchid = b.matchid
		GROUP BY a.winlostdate
			,a.matchid
			,a.oddsid
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,a.recommend
			,ISNULL(b.LeagueID, -1)
			,a.currency
			,a.liveindicator'') AS t'	
		INSERT INTO dbo.rptWinlostbyLeague (
			winlostdate
			,matchid
			,oddsid
			,LeagueID
			,bettype
			,odds
			,oddstype
			,statusID
			,stake
			,winlost
			,awinlost
			,Comm
			,playercomm
			,recommend
			,isBA
			,betcount
			,currency
			,liveindicator
			,TicketType
		)
		EXEC sp_executesql @sqlCmd 
		SET @rowCount = @@rowcount;
		SET @Msg =  ' DONE - @winlostdate : ' + CONVERT(VARCHAR(20),@winlostdate,112) + ' - Affected row : ' + CAST (@rowCount AS VARCHAR(50));
		RAISERROR (@Msg , 0, 1) WITH NOWAIT;
    END
	
	IF @winlostdate >= @BalanceUpDate AND @winlostdate <= @MoveBetsDay
	BEGIN
    	;WITH cte_bettrans AS (
		SELECT a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,SUM(ABS(a.stake)) AS stake
			,SUM(a.winlost - a.actual_stake) AS winlost
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,COUNT(a.custid) AS betcount
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS comm
			,SUM(a.playercomm) AS playercomm
			,a.currency
			,a.liveindicator
		FROM bodb02.dbo.bettrans14 AS a WITH (NOLOCK)
			INNER JOIN bodb_licensee.dbo.f_SelLicenseeCust(0) AS LC ON a.recommend = lc.custid AND a.currency = lc.currency
		WHERE a.winlostdate = @winlostdate
			AND a.statusID IN (111, 112, 113)
			AND a.matchid >= 0
			AND a.bettype in (5302,5303,5304,5305,5306,5307)
		GROUP BY a.recommend
			,a.matchid
			,a.oddsid
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,a.currency
			,a.liveindicator
		)
		INSERT INTO dbo.rptWinlostbyLeague (
			winlostdate
			,matchid
			,oddsid
			,LeagueID
			,bettype
			,odds
			,oddstype
			,statusID
			,stake
			,winlost
			,awinlost
			,Comm
			,playercomm
			,recommend
			,isBA
			,betcount
			,currency
			,liveindicator
			,TicketType
		)
		SELECT a.winlostdate
			,a.matchid
			,a.oddsid
			,ISNULL(b.LeagueID, -1) LeagueID
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,SUM(a.stake) AS stake
			,SUM(winlost) AS winlost
			,SUM(a.awinlost) AS awinlost
			,SUM(a.comm) AS Comm
			,SUM(a.playercomm) AS playercomm
			,a.recommend
			,0 AS isBA
			,SUM(a.betcount) AS betcount
			,a.currency
			,a.liveindicator
			,NULL AS TicketType
		FROM cte_bettrans AS a
			LEFT JOIN bodb02.dbo.match AS b WITH (NOLOCK) ON a.matchid = b.matchid
		GROUP BY a.winlostdate, a.matchid
			,a.oddsid
			,a.bettype
			,a.odds
			,a.oddstype
			,a.statusID
			,a.winlostdate
			,a.recommend
			,ISNULL(b.LeagueID, -1)
			,a.currency
			,a.liveindicator

		SET @rowCount = @@rowcount;
		SET @Msg =  ' DONE - @winlostdate : ' + CONVERT(VARCHAR(20),@winlostdate,112) + ' - Affected row : ' + CAST (@rowCount AS VARCHAR(50));
		RAISERROR (@Msg , 0, 1) WITH NOWAIT;
    END

	 
	UPDATE @LstWLdate SET IsCheck = 1 WHERE winlostdate = @winlostdate
END



 