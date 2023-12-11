/*<info serverAlias="DBPTCS-bodb_PlaytechCS" executers="" viewers="" ></info>*/
/*
	Created: 20231130@Evan
	DB: DBLIC-bodb_PlaytechCS
	Task: Step2: Gen data bettrans_AGCasino_Temp (run on db053)

*/
USE [bodb_PlaytechCS]
GO
SET NOCOUNT ON
DECLARE @QueueID BIGINT = NULL
	  , @XmlData XML

DECLARE @fromdate DATE = '20231001'
DECLARE @todate DATE = '20231130'

DECLARE @QueueIDs TABLE (
	  QueueID BIGINT
)

INSERT INTO @QueueIDs (QueueID)
SELECT MAX(QueueID)
FROM dbo.Product3rd_ImportQueue(NOLOCK)
WHERE ProductID = 10
	AND Winlostdate BETWEEN @fromdate AND @todate
GROUP BY Winlostdate
	   , LicenseeName

DROP TABLE IF EXISTS #Product3rd_ImportQueue

CREATE TABLE #Product3rd_ImportQueue (
	  QueueID INT
	, XmlData XML
	, IsFinished BIT
)

INSERT INTO #Product3rd_ImportQueue (QueueID, XmlData, IsFinished)
SELECT a.QueueID
	 , a.XmlData
	 , 0 IsFinished
FROM dbo.Product3rd_ImportQueue(NOLOCK) a
	INNER JOIN @QueueIDs b ON a.QueueID = b.QueueID

DROP TABLE IF EXISTS #TmpData

CREATE TABLE #TmpData (
	  BillNo BIGINT
	, IBCCustID INT
	, BetTime DATETIME
	, GameType VARCHAR(10)
	, GameCode VARCHAR(50)
	, BetAmount MONEY
	, NetAmount MONEY
	, PlayType SMALLINT
	, LoginIP VARCHAR(45)
	, Currency TINYINT
	, Flag SMALLINT
)

WHILE EXISTS (
		SELECT 1
		FROM #Product3rd_ImportQueue
		WHERE IsFinished = 0 
	)
BEGIN
	SELECT TOP 1 @QueueID = QueueID
			   , @XmlData = XmlData
	FROM #Product3rd_ImportQueue
	WHERE IsFinished = 0

	INSERT INTO #TmpData (BillNo, IBCCustID, BetTime, GameType, GameCode, BetAmount, NetAmount, PlayType, LoginIP, Currency, Flag)
	SELECT x.v.value('(BILLNO/text())[1]', 'BIGINT') AS BillNo
		 , x.v.value('(IBCCUSTID/text())[1]', 'INT') AS IBCCustID
		 , CONVERT(VARCHAR(10), x.v.value('(BETTIME/text())[1]', 'DATETIME'), 120) AS BetTime
		 , x.v.value('(GAMETYPE/text())[1]', 'VARCHAR(10)') AS GameType
		 , x.v.value('(GAMECODE/text())[1]', 'VARCHAR(50)') AS GameCode
		 , x.v.value('(BETAMOUNT/text())[1]', 'MONEY') AS BetAmount
		 , x.v.value('(NETAMOUNT/text())[1]', 'MONEY') AS NetAmount
		 , x.v.value('(PLAYTYPE/text())[1]', 'SMALLINT') AS PlayType
		 , x.v.value('(LOGINIP/text())[1]', 'VARCHAR(45)') AS LoginIP
		 , x.v.value('(CURRENCY/text())[1]', 'TINYINT') AS Currency
		 , x.v.value('(FLAG/text())[1]', 'SMALLINT') AS Flag
	FROM @XmlData.nodes('/TransList/TRANSACTION') x (v)
	OPTION (OPTIMIZE FOR (@XmlData = NULL))

	--Import data to DB
	MERGE dbo.bettrans_AGCasino_Temp AS dest USING (
		SELECT d.BillNo
			 , d.IBCCustID
			 , d.BetTime
			 , d.GameType
			 , d.GameCode
			 , d.BetAmount
			 , d.BetAmount
			 , d.BetAmount + d.NetAmount
			 , CASE
				   WHEN d.NetAmount > 0 THEN 'WON'
				   WHEN d.NetAmount < 0 THEN 'LOSE'
				   ELSE 'DRAW'
			   END
			 , CASE
				   WHEN d.NetAmount > 0 THEN '112'
				   WHEN d.NetAmount < 0 THEN '113'
				   ELSE '111'
			   END
			 , d.PlayType
			 , d.BetTime
			 , c.Username
			 , d.LoginIP
			 , c.recommend
			 , c.mrecommend
			 , c.srecommend
			 , c.currency
			 , CASE
				   WHEN GameType LIKE 'CBAC' THEN 1
				   ELSE 0
			   END -- IsVIPGame
		FROM #TmpData d
			INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON c.CustID = d.IBCCustID
	) AS src (BillNo, IBCCustID, Transdate, GameType, GameCode, Stake, Actual_Stake, Winlost, [Status], StatusID,
	PlayType, Winlostdate, Username, LoginIP, recommend, mrecommend, srecommend, currency, IsVIPGame)
	ON (dest.TicketID = src.BillNo)
	WHEN MATCHED
		THEN UPDATE
			SET dest.CustID = src.IBCCustID
			  , dest.Transdate = src.Transdate
			  , dest.GameType = src.GameType
			  , dest.GameCode = src.GameCode
			  , dest.Stake = src.Stake
			  , dest.Actual_Stake = src.Actual_Stake
			  , dest.Winlost = src.Winlost
			  , dest.[Status] = src.[Status]
			  , dest.StatusID = src.StatusID
			  , dest.PlayType = src.PlayType
			  , dest.Winlostdate = src.Winlostdate
			  , dest.Username = src.Username
			  , dest.IP = src.LoginIP
			  , dest.recommend = src.recommend
			  , dest.mrecommend = src.mrecommend
			  , dest.srecommend = src.srecommend
			  , dest.currency = src.currency
			  , dest.IsVIPGame = src.IsVIPGame
	WHEN NOT MATCHED
		THEN INSERT (TicketID, CustID, Transdate, GameType, GameCode, Stake, Actual_Stake, Winlost, [Status], StatusID, PlayType, Winlostdate, Username, IP, recommend, mrecommend, srecommend, Currency, IsVIPGame)
			VALUES (src.BillNo, src.IBCCustID, src.Transdate, src.GameType, src.GameCode, src.Stake, src.Actual_Stake, src.Winlost, src.[Status], src.StatusID, src.PlayType, src.Winlostdate, src.Username, src.LoginIP, src.recommend, src.mrecommend, src.srecommend, src.currency, src.IsVIPGame);
	
	UPDATE #Product3rd_ImportQueue SET IsFinished = 1 WHERE QueueID = @QueueID

	WAITFOR DELAY '00:00:00.280'
END


