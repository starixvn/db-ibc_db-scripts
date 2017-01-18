/*
	Created: Johnson
	Date: 2016-12-30
	Task: mapping stake level from LCS to GD for customers
	DB: DBCUST/CustDB
*/

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'tmpCustGameType' and TYPE = 'u')
    DROP TABLE tmpCustGameType
GO  
CREATE TABLE [dbo].[tmpCustGameType](
	[CustID] [int] NOT NULL,
	[roleID] [int] ,
	[DirectUplineID] [int],
	[ExchangeID] [int] NOT NULL, 
	[GameTypeID] [int],
	[StakeLevelList_LC] [varchar](100) NULL,
	[StakeLevelList_GD] [varchar](100) NULL
 CONSTRAINT [PK_tmpCustGameType] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO

SELECT custid
INTO #supers
FROM customer c WITH(NOLOCK)
WHERE site = '789y'
	AND roleID = 4
	
--mapping GameTypeID from LCS to GD
INSERT INTO [dbo].[tmpCustGameType]
           ([CustID]
		   ,[roleID]
		   ,[exchangeID]
           ,[GameTypeID]
           ,[StakeLevelList_LC]
          )
SELECT cs.custid
	,roleID
	,CASE WHEN GameTypeID = 108 THEN 1701 
		WHEN GameTypeID = 109 THEN 1702 END	
	,ci.currency
	,StakeLevelList	
FROM CustGameType_LCS cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
WHERE GameTypeID IN (108,109)
	AND ci.srecommend IN (SELECT custid FROM #supers)
GO


CREATE TABLE #StakeLevel_PreMapping (ID INT IDENTITY (1,1),ExchangeID INT, StakeLevelList_LC VARCHAR(1000),StakeLevelList_GD VARCHAR (1000))

INSERT INTO #StakeLevel_PreMapping (StakeLevelList_LC,ExchangeID)
SELECT DISTINCT StakeLevelList_LC,ExchangeID
FROM tmpCustGameType WITH (NOLOCK)

DECLARE @Index_Start INT  = 0
DECLARE @Index_Stop INT = (SELECT MAX(ID) FROM #StakeLevel_PreMapping)

DECLARE @v_str NVARCHAR(1000), @ExchangeID INT

WHILE @Index_Start <= @Index_Stop
BEGIN 
	SELECT @v_str = StakeLevelList_LC,@ExchangeID = ExchangeID  FROM #StakeLevel_PreMapping WHERE ID =  @Index_Start
	
	SELECT @v_str = REPLACE(@v_str,StakeLevelID_LC, StakeLevelID_GD)
	FROM tmpStakeLevelMapping WITH (NOLOCK)
	WHERE ExchangeId = @ExchangeID
	
	UPDATE #StakeLevel_PreMapping SET StakeLevelList_GD = @v_str
	WHERE ID= @Index_Start
	
	SET @Index_Start =  @Index_Start + 1
END	


-- Update StakelevelistUpline in case of not having stakelavel

UPDATE T1
	SET StakeLevelList_GD = T2.StakeLevelList_GD
FROM tmpCustGameType T1
	INNER JOIN #StakeLevel_PreMapping T2 ON T1.ExchangeID = T2.ExchangeID AND T1.StakeLevelList_LC = T2.StakeLevelList_LC


-- use this table to trace problem #CustList_ResetLowest

-- Update mapping	
SELECT T1.CustID,T1.roleID
INTO #CustList_ResetLowest
FROM tmpCustGameType T1 (NOLOCK)
	INNER JOIN custInfo ci (NOLOCK) ON T1.CustID = CI.custid AND CI.SyncLiveCasino = 1 AND CI.Enabled = 1
WHERE T1.StakeLevelList_GD = '' OR T1.StakeLevelList_GD IS NULL


UPDATE T1
	SET DirectUplineID = CASE WHEN ci.roleid = 1 THEN CI.recommend
								 WHEN ci.roleid = 2 THEN CI.mrecommend
								 WHEN ci.roleid = 3 THEN CI.srecommend
							ELSE 0 END 	 
FROM tmpCustGameType T1
	INNER JOIN #CustList_ResetLowest T2 on T1.CustID = T2.CustID
	INNER JOIN custInfo ci (NOLOCK) ON T1.CustID = CI.custid
	
-- Process roleid = 4
;WITH temp AS(
	SELECT StakeLevelID, GameTypeID, ROW_NUMBER() OVER(PARTITION by SL.GameTypeID ORDER BY MaxStake, MinStake) rn
	FROM dbo.StakeLevel SL WITH(NOLOCK) 
	WHERE SL.ExchangeId IN (3,16,17,20,35,40,64) AND GameTypeID IN (1701,1702)
)
UPDATE T1
	SET StakeLevelList_GD = CONVERT(VARCHAR(100),temp.StakeLevelID)
FROM tmpCustGameType T1
	INNER JOIN custInfo CI WITH (NOLOCK) ON T1.CustID = CI.custid AND CI.Enabled = 1 AND CI.SyncLiveCasino = 1
	INNER JOIN temp ON t1.gameTypeID = temp.GameTypeID
WHERE (T1.StakeLevelList_LC = '' OR T1.StakeLevelList_LC IS NULL ) AND CI.roleid = 4	
	AND rn = 1
	
-- Process RoleID = 3
;WITH temp AS (
	SELECT t1.custid, t1.GameTypeID, t2.StakeLevelList_GD
	FROM tmpCustGameType T1 WITH (NOLOCK) 
		INNER JOIN tmpCustGameType T2 WITH (NOLOCK) ON t2.custid = t1.DirectUplineID
													AND t2.GameTypeID = t1.GameTypeID
	WHERE (T1.StakeLevelList_LC = '' OR T1.StakeLevelList_LC IS NULL ) AND T1.roleID = 3 AND T1.DirectUplineID <> 0 
)
,temp2 AS (
	SELECT t1.custid,t1.gametypeid,val as stakelevelID from temp t1 
			CROSS APPLY strSplit(
							(SELECT ISNULL(t2.StakeLevelList_GD,-1) 
							FROM temp t2
							WHERE t1.custid = t2.custid AND t1.gameTypeID = t2.gameTypeID
							),
						',')
		)
,temp3 as (
	SELECT custid, sl.GameTypeID, sl.StakeLevelID, ROW_NUMBER() OVER(PARTITION by custid,SL.GameTypeID ORDER BY MaxStake, MinStake) rn 
	from temp2 t INNER JOIN StakeLevel sl ON t.stakelevelID = sl.StakeLevelID
	
)		

UPDATE T1
	SET StakeLevelList_GD = CONVERT(VARCHAR(100),temp3.StakeLevelID)
FROM tmpCustGameType T1
	INNER JOIN temp3 ON t1.custid = temp3.custid 
						AND t1.GameTypeID = temp3.GameTypeID
WHERE temp3.rn = 1						
	
-- Process RoleID = 2
;WITH temp AS (
	SELECT t1.custid, t1.GameTypeID, t2.StakeLevelList_GD
	FROM tmpCustGameType T1 WITH (NOLOCK) 
		INNER JOIN tmpCustGameType T2 WITH (NOLOCK) ON t2.custid = t1.DirectUplineID
													AND t2.GameTypeID = t1.GameTypeID
	WHERE (T1.StakeLevelList_LC = '' OR T1.StakeLevelList_LC IS NULL ) AND T1.roleID = 2 AND T1.DirectUplineID <> 0 
)
,temp2 AS (
	SELECT t1.custid,t1.gametypeid,val as stakelevelID from temp t1 
			CROSS APPLY strSplit(
							(SELECT ISNULL(t2.StakeLevelList_GD,-1) 
							FROM temp t2
							WHERE t1.custid = t2.custid AND t1.gameTypeID = t2.gameTypeID
							),
						',')
		)
,temp3 as (
	SELECT custid, sl.GameTypeID, sl.StakeLevelID, ROW_NUMBER() OVER(PARTITION by custid,SL.GameTypeID ORDER BY MaxStake, MinStake) rn 
	from temp2 t INNER JOIN StakeLevel sl ON t.stakelevelID = sl.StakeLevelID
	
)		

UPDATE T1
	SET StakeLevelList_GD = CONVERT(VARCHAR(100),temp3.StakeLevelID)
FROM tmpCustGameType T1
	INNER JOIN temp3 ON t1.custid = temp3.custid 
						AND t1.GameTypeID = temp3.GameTypeID
WHERE temp3.rn = 1	

-- Process RoleID = 1

;WITH temp AS (
	SELECT t1.custid, t1.GameTypeID, t2.StakeLevelList_GD
	FROM tmpCustGameType T1 WITH (NOLOCK) 
		INNER JOIN tmpCustGameType T2 WITH (NOLOCK) ON t2.custid = t1.DirectUplineID
													AND t2.GameTypeID = t1.GameTypeID
	WHERE (T1.StakeLevelList_LC = '' OR T1.StakeLevelList_LC IS NULL ) AND T1.roleID = 1 AND T1.DirectUplineID <> 0 
)
,temp2 AS (
	SELECT t1.custid,t1.gametypeid,val as stakelevelID from temp t1 
			CROSS APPLY strSplit(
							(SELECT ISNULL(t2.StakeLevelList_GD,-1) 
							FROM temp t2
							WHERE t1.custid = t2.custid AND t1.gameTypeID = t2.gameTypeID
							),
						',')
		)
,temp3 as (
	SELECT custid, sl.GameTypeID, sl.StakeLevelID, ROW_NUMBER() OVER(PARTITION by custid,SL.GameTypeID ORDER BY MaxStake, MinStake) rn 
	from temp2 t INNER JOIN StakeLevel sl ON t.stakelevelID = sl.StakeLevelID
	
)		

UPDATE T1
	SET StakeLevelList_GD = CONVERT(VARCHAR(100),temp3.StakeLevelID)
FROM tmpCustGameType T1
	INNER JOIN temp3 ON t1.custid = temp3.custid 
						AND t1.GameTypeID = temp3.GameTypeID
WHERE temp3.rn = 1	

	

