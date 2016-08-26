/*
	Created: Elodie
	Date: 20160301
	Task: copy stake level for newly created customers
	DB: DBCUST/CustDB
*/
--step 0: backup & copy stake level setting from LCS DB to DBTP for newly customers

DECLARE @StakeLevelList_2401_Lowest VARCHAR(100)= ''
		,@StakeLevelList_2402 VARCHAR(100)= ''
		
		,@currency INT
		,@custid INT
		,@uplineID INT
		,@roleid INT
		,@syncLiveCasino BIT
		,@max_custid INT
		,@max_custid2 INT
		,@srecommend INT
		
SELECT @max_custid = 23134000
		,@max_custid2 = 23134062


CREATE TABLE #supers (custid int, currency INT)

INSERT INTO #supers(custid,currency)

SELECT custid, currency
FROM Customer WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site in ('INDO','755555','Koribc')

--step 1: copy settings for newly created customers

---- data preparation ----
CREATE TABLE #tmpCustGameType (
	[CustID] [int] NOT NULL PRIMARY KEY,
	[ExchangeID] [int] NOT NULL, 
	[StakeLevelList_LC] [varchar](100) NULL,
	[StakeLevelList_AllBet] [varchar](100) NULL
 )

CREATE TABLE #CodeCurrency (ID INT, Currency VARCHAR(1000) )

INSERT INTO #CodeCurrency (ID,Currency)
VALUES(1,'$US, NTD, US$, UT, Yen, IRR, EURO, SD$, GBP'),
(1,''),
(1,''),
(1,''),
(2,'HK$,HKK, RMB'),
(2,''),
(2,''),
(2,''),
(3,'RM'),
(3,''),
(3,''),
(3,''),
(5,'Won'),
(5,''),
(5,''),
(5,''),
(6,'TB, THB'),
(6,''),
(6,''),
(6,''),
(7,'INH'),
(7,''),
(7,''),
(7,''),
(8,'IDD,IDR,IN, IND, DDD'),
(8,''),
(8,''),
(8,''),
(9,'INR'),
(9,''),
(9,''),
(9,''),
(10,'MMK,MKK'),
(10,''),
(10,''),
(10,''),
(11,'UUS'),
(11,''),
(11,''),
(11,''),
(11,'')


DELETE #CodeCurrency WHERE currency = ''

CREATE TABLE #ExchangeIDListPerCurrency (ID INT, ExchangeID INT, Currency VARCHAR(20) )
INSERT INTO #ExchangeIDListPerCurrency (ID,ExchangeID,Currency)
SELECT t.ID,cur.exchangeid,cur.currency as currency
FROM #CodeCurrency t
	OUTER APPLY (SELECT e.exchangeid AS exchangeid,e.currency
				FROM strSplit (t.Currency,',') AS T
					INNER JOIN DBCUST.CUSTDB.dbo.exchange e(NOLOCK) ON LTRIM(RTRIM(T.val)) =e.currency) AS cur

-- Dummy processing
CREATE TABLE #Dummy_temp
	(
		ID INT IDENTITY,
		CustID INT ,
		srecommend INT, mrecommend INT, recommend INT, roleid TINYINT,exchangeID INT
	)

INSERT INTO #Dummy_temp (custid, srecommend, mrecommend, recommend, roleid,exchangeID)
SELECT  c.custid, c.srecommend, c.mrecommend, c.recommend, c.roleid,c.currency
FROM Customer c WITH (NOLOCK)
	JOIN Acc_CustDirect a WITH(NOLOCK) ON c.custid = a.custid
	JOIN custInfo CI WITH (NOLOCK) ON ci.custid = c.custid
WHERE c.site in ('INDO','755555','Koribc') AND c.srecommend = @srecommend AND CI.Enabled = 1 AND ci.custid > @max_custid
	AND ci.custid <= @max_custid2

CREATE TABLE #Dummy_Result
(
		CustID INT PRIMARY KEY CLUSTERED,
		SyncLiveCasino BIT,
		ExchangeID INT
)
	
------Member processing ----------
DECLARE @Start INT = 1, @Stop INT = 1, @ExchangeID INT

DECLARE @mrecommend INT, @recommend INT

IF EXISTS (SELECT 1 FROM #Dummy_temp)
BEGIN
	SET @Stop = (SELECT MAX(ID) FROM #Dummy_temp)

	WHILE (@Start < = @Stop)
	BEGIN
		
		SELECT @CustID= custid, @srecommend =srecommend, @mrecommend =mrecommend, @recommend = recommend,@RoleID = roleid,@ExchangeID = exchangeID
		FROM #Dummy_temp WHERE ID = @Start
		
		IF @RoleID = 1
		BEGIN
			INSERT INTO #Dummy_Result (CustID, SyncLiveCasino,ExchangeID)
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.custid = @CustID 
			UNION ALL
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.custid IN (@srecommend,@mrecommend,@recommend) 
			
		END
		ELSE IF @RoleID = 2
		BEGIN
			INSERT INTO #Dummy_Result (CustID, SyncLiveCasino,ExchangeID)
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.recommend = @CustID AND CI.roleid = 1 AND CI.Enabled = 1 AND ci.custid > @max_custid AND ci.custid <= @max_custid2
			UNION ALL
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.custid IN (@srecommend,@mrecommend,@recommend)
		END
		ELSE IF @RoleID = 3
		BEGIN
			INSERT INTO #Dummy_Result (CustID, SyncLiveCasino,ExchangeID)
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.mrecommend = @CustID AND CI.roleid = 1 AND CI.Enabled = 1 AND ci.custid > @max_custid AND ci.custid <= @max_custid2
			
			UNION ALL
			SELECT CI.custid, CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.mrecommend = @CustID AND CI.roleid IN (2,3) AND CI.Enabled = 1 AND ci.custid > @max_custid AND ci.custid <= @max_custid2
			
			UNION ALL
			SELECT CI.custid,CI.SyncLiveCasino,@ExchangeID
			FROM custInfo CI WITH (NOLOCK)
			WHERE CI.custid = @srecommend
			
		END
		
		SET @Start = @Start + 1

	END		
END	

CREATE TABLE #tmpCust (custid INT, roleid INT, syncLiveCasino BIT, currency INT)

INSERT INTO #tmpCust(custid, roleid, syncLiveCasino, currency)
SELECT DISTINCT ci.custid, roleid, syncLiveCasino, s.currency
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN #Supers s ON ci.srecommend = s.custid
WHERE ci.custid > @max_custid
	AND ci.custid <= @max_custid2
UNION ALL
SELECT DISTINCT ci.custid, roleid, d.syncLiveCasino, d.ExchangeID
FROM custinfo ci WITH(NOLOCK) 
INNER JOIN #Dummy_Result D ON ci.custid = d.CustID
	
INSERT INTO #tmpCustGameType ([CustID], [StakeLevelList_LC],[ExchangeID])
SELECT ci.custid, ISNULL (cs.StakeLevelList,'') AS StakeLevelList,ci.currency	
FROM #tmpCust ci WITH(NOLOCK)
	LEFT JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType cs WITH (NOLOCK) ON cs.custid = ci.custid AND cs.custid > @max_custid AND cs.custid <= @max_custid2
	
CREATE TABLE #StakeLevel_PreMapping (ID INT IDENTITY (1,1),ExchangeID INT, StakeLevelList_LC VARCHAR(1000),StakeLevelList_Allbet VARCHAR (1000))

INSERT INTO #StakeLevel_PreMapping (StakeLevelList_LC,ExchangeID)
SELECT DISTINCT StakeLevelList_LC,ExchangeID
FROM #tmpCustGameType WITH (NOLOCK)

DECLARE @Index_Start INT  = 0
DECLARE @Index_Stop INT = (SELECT MAX(ID) FROM #StakeLevel_PreMapping)

DECLARE @v_str NVARCHAR(1000)

WHILE @Index_Start <= @Index_Stop
BEGIN 
	SELECT @v_str = StakeLevelList_LC,@ExchangeID = ExchangeID  FROM #StakeLevel_PreMapping WHERE ID =  @Index_Start 
	IF @v_str <> ''
	BEGIN
		SELECT @v_str = REPLACE(@v_str,StakeLevelID_LC, StakeLevelID_AllBet)
		FROM tmpStakeLevelMapping WITH (NOLOCK)
		WHERE ExchangeId = @ExchangeID
		
		UPDATE #StakeLevel_PreMapping SET StakeLevelList_Allbet = @v_str
		WHERE ID= @Index_Start
	END
	SET @Index_Start =  @Index_Start + 1
END

UPDATE T1
	SET StakeLevelList_Allbet = T2.StakeLevelList_Allbet
FROM #tmpCustGameType T1
	INNER JOIN #StakeLevel_PreMapping T2 ON T1.ExchangeID = T2.ExchangeID AND T1.StakeLevelList_LC = T2.StakeLevelList_LC

	
--Bettype 2402: Lowest VIP Bet limit
	
--Member Level
CREATE TABLE #CustStakeLevel_Member_2401 (CustID INT, SportType INT, BetType INT, StakeLevelList VARCHAR(100),ExchangeID INT,syncLiveCasino BIT)		
CREATE TABLE #CustStakeLevel_Agent_2401 (CustID INT, SportType INT, BetType INT, StakeLevelList VARCHAR(100), ExchangeID INT, syncLiveCasino BIT)		

INSERT INTO #CustStakeLevel_Member_2401(CustID, SportType, BetType, StakeLevelList,ExchangeID,syncLiveCasino)		
SELECT C.custid, 211, 2401, CASE WHEN c.syncLiveCasino = 1 THEN ISNULL(StakeLevelList_Allbet,'') ELSE '' END AS StakeLevelList, C1.ExchangeID,C.syncLiveCasino
FROM #tmpCust c
	LEFT JOIN #tmpCustGameType C1 ON c.custid = c1.CustID
WHERE c.roleid = 1 AND NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member sk WITH (NOLOCK) WHERE sk.CustID = c.custid AND sk.SportType = 211 AND sk.BetType = 2401)

INSERT INTO #CustStakeLevel_Agent_2401(CustID, SportType, BetType, StakeLevelList,ExchangeID,syncLiveCasino)		
SELECT C.custid, 211, 2401, CASE WHEN c.syncLiveCasino = 1 THEN ISNULL(StakeLevelList_Allbet,'') ELSE '' END AS StakeLevelList, C1.ExchangeID,C.syncLiveCasino
FROM #tmpCust c
	LEFT JOIN #tmpCustGameType C1 ON c.custid = c1.CustID
WHERE c.roleid IN (2,3,4) AND NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent sk WITH (NOLOCK) WHERE sk.CustID = c.custid AND sk.SportType = 211 AND sk.BetType = 2401)


-- Get lowest if not offer Live Bacarat
UPDATE T
	SET StakeLevelList = T1.StakeLevelList
FROM #CustStakeLevel_Member_2401 T
	CROSS APPLY (SELECT TOP 1 ISNULL(StakeLevelID ,'') AS StakeLevelList
									FROM dbo.StakeLevel sl WITH(NOLOCK) 
									WHERE sl.ExchangeId = T.ExchangeID AND GameTypeID = 2401 
									ORDER BY MaxStake, MinStake
					) AS T1
WHERE T.StakeLevelList = '' AND T.syncLiveCasino = 1 


UPDATE T
	SET StakeLevelList = T1.StakeLevelList
FROM #CustStakeLevel_Agent_2401 T
	CROSS APPLY (SELECT TOP 1 ISNULL(StakeLevelID ,'') AS StakeLevelList
									FROM dbo.StakeLevel WITH(NOLOCK) 
									WHERE ExchangeId = T.ExchangeId AND GameTypeID = 2401 
									ORDER BY MaxStake, MinStake
					) AS T1
WHERE T.StakeLevelList = '' AND T.syncLiveCasino = 1 


INSERT INTO CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)		
SELECT CustID, SportType, BetType, StakeLevelList
FROM (  SELECT CustID, SportType, BetType, StakeLevelList
		FROM #CustStakeLevel_Member_2401
		UNION ALL 
		SELECT c.custid, 211, 2402, CASE WHEN C.syncLiveCasino = 1 THEN T1.StakeLevelList ELSE '' END AS StakeLevelList
		FROM #tmpCust c
			CROSS APPLY (SELECT TOP 1 ISNULL(StakeLevelID ,'') AS StakeLevelList
						FROM dbo.StakeLevel sl WITH(NOLOCK) 
						WHERE sl.ExchangeId = c.currency AND GameTypeID = 2402 
					) AS T1
		WHERE c.roleid = 1 
		) AS tmp

WHERE  NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Member sk WITH (NOLOCK) WHERE sk.CustID = tmp.custid AND sk.SportType = 211 AND sk.BetType = 2402)

--SMA Level
INSERT INTO CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
SELECT CustID, SportType, BetType, StakeLevelList
FROM (  SELECT CustID, SportType, BetType, StakeLevelList
		FROM #CustStakeLevel_Agent_2401
		UNION ALL 
		SELECT c.custid, 211, 2402, CASE WHEN C.syncLiveCasino = 1 THEN T1.StakeLevelList ELSE '' END AS StakeLevelList
		FROM #tmpCust c
			CROSS APPLY (SELECT TOP 1 ISNULL(StakeLevelID ,'') AS StakeLevelList
						FROM dbo.StakeLevel sl WITH(NOLOCK) 
						WHERE sl.ExchangeId = c.currency AND GameTypeID = 2402 
					) AS T1
		WHERE c.roleid IN (2,3,4) 
		) AS tmp

WHERE  NOT EXISTS ( SELECT 1 FROM CustStakeLevel_Agent sk WITH (NOLOCK) WHERE sk.CustID = tmp.custid AND sk.SportType = 211 AND sk.BetType = 2402)

DROP TABLE #CodeCurrency
DROP TABLE #CustStakeLevel_Agent_2401
DROP TABLE #CustStakeLevel_Member_2401
DROP TABLE #Dummy_Result
DROP TABLE #Dummy_temp
DROP TABLE #ExchangeIDListPerCurrency
DROP TABLE #StakeLevel_PreMapping
DROP TABLE #supers
DROP TABLE #tmpCust
DROP TABLE #tmpCustGameType




