/*
	Created by: Helen
	Date 20200317
	Task: Remove commissions for some lines under Sportsbook product - [Redmine:130487]
	DB: DBTXN/bodb02
	

*/
USE bodb02
GO
--- define temporary tables
CREATE TABLE #Match_Final (Matchid INT, ID INT IDENTITY(1,1))
CREATE TABLE #tmp_recommend (custid INT)

CREATE TABLE #input_Super (custid INT)
CREATE TABLE #input_Master (custid INT)

CREATE TABLE #tickets_tmp (transid BIGINT, matchid INT)
CREATE TABLE #tickets_Final (transid BIGINT, matchid INT, IsFinish BIT)

CREATE TABLE #Ticket_OldValue_BackupForCompare ( transid BIGINT
												, [playerdiscount] [decimal](9, 8) NULL
												, [discount] [decimal](9, 8) NULL
												, [adiscount] [decimal](9, 8) NULL
												, [sdiscount] [decimal](9, 8) NULL
												)

DECLARE @ClearcommByBatch_tmp AS TABLE (transid BIGINT)
DECLARE  @start INT  = 1
		, @end INT = 0
		, @matchid INT
		
-- input Super
INSERT INTO #input_Super (custid)
SELECT ci.custid
FROM CustDB.dbo.custInfo ci WITH (NOLOCK)
WHERE ci.username IN ('FNH','FNN','TEK','THG','THR','THS','PYA','PYB','PYG','PYH','Pyy','A312D','A312E','A312RMB','R312R','S312A','S312C','S312D','S312E','S312H','S312K','S312RMA','S312RMB','SF8')

-- input Master
INSERT INTO #input_Master (custid)
SELECT ci.custid
FROM CustDB.dbo.custInfo ci WITH (NOLOCK)
WHERE ci.username IN ('M62AH')

-------------------------- DATA PREPARATION  ------------------------
------ GET list of recommend to utilize index IX_recommend on bettrans
INSERT INTO #tmp_recommend (custid)
SELECT ci.custid
FROM CustDB.dbo.custInfo ci WITH (NOLOCK)
	INNER JOIN #input_Super s WITH (NOLOCK) ON s.custid = ci.srecommend
WHERE ci.roleid = 2
UNION ALL
SELECT ci.custid
FROM CustDB.dbo.custInfo ci WITH (NOLOCK)
	INNER JOIN #input_Master s WITH (NOLOCK) ON s.custid = ci.mrecommend
WHERE ci.roleid = 2

---- GET affected transid
INSERT INTO #tickets_tmp(transid, Matchid)
SELECT b.transid, m.Matchid
FROM #tmp_recommend r
	INNER JOIN bettrans b WITH (NOLOCK) ON r.custid = b.recommend
	INNER JOIN dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid 
WHERE m.sporttype < 99 AND eventstatus <> 'completed'
	AND b.statusID IN (0,1,102)
	AND b.playerdiscount + b.discount + b.adiscount + b.sdiscount  > 0
	AND b.bettype < 19999
	AND b.bettype NOT IN (29,38)

---- final list to clear comm, exclude matchid under settlement
INSERT INTO #Match_Final(Matchid)
SELECT DISTINCT m.Matchid
FROM #tickets_tmp m
	LEFT JOIN dbo.TempVariableNumber tv WITH (NOLOCK) ON m.matchid = tv.KeyValue
WHERE tv.KeyValue IS NULL

INSERT INTO #tickets_Final (transid, matchid)
SELECT t.transid, t.matchid
FROM #tickets_tmp t
	INNER JOIN #Match_Final m ON t.matchid = m.matchid
GROUP BY t.matchid,	t.transid

----- BACKUP before update if need
INSERT INTO #Ticket_OldValue_BackupForCompare (transid,playerdiscount,adiscount,discount,sdiscount)
SELECT t.transid, b.playerdiscount, b.adiscount, b.discount, b.sdiscount
FROM #tickets_Final t
	INNER JOIN bettrans b WITH (NOLOCK) ON t.transid = b.transid

------------ STARTING clear comm ----------------------------
SET @end = (SELECT MAX(ID) FROM #Match_Final)

-- Deployer Info
DECLARE @Match_cnt INT, @index INT = 0, @ticket_cnt INT
SET @Match_cnt = @end
DECLARE @msg nvarchar(200) = 'Currently at order %d, MatchID: %d, Ticket_cnt: %d'
DECLARE @msg_total nvarchar(200) = 'Total of Match: %d.'
RAISERROR (@msg_total, 0, 1, @Match_cnt) WITH NOWAIT

-- LOOP BY matchid
WHILE @start <= @end
BEGIN

	SET @matchid = (SELECT matchid FROM #Match_Final WHERE ID = @start)
	SET @ticket_cnt = (SELECT COUNT(1) FROM #tickets_Final WHERE matchid = @matchid)
	
	SET @index = @index + 1
	RAISERROR (@msg, 0, 1, @index, @matchid,@ticket_cnt) WITH NOWAIT
	
	WHILE (1=1)
	BEGIN
		DELETE @ClearcommByBatch_tmp
			
		UPDATE TOP(2000) t
			SET isFinish = 1
		OUTPUT DELETED.TransId
				
		INTO @ClearcommByBatch_tmp(TransId)
		FROM #tickets_Final t 
		WHERE isFinish IS NULL
			AND t.Matchid = @matchid
		
		IF @@ROWCOUNT = 0 BREAK
		
		/*
		-- FOR CHECKING
		SELECT b.matchid,playerdiscount 
				, discount 
				, adiscount 
				, sdiscount 
		FROM dbo.bettrans b WITH (nolock)
			INNER JOIN @ClearcommByBatch_tmp c ON b.transid = c.transid
		WHERE b.statusID IN (0,1)
			AND b.matchid = @matchid
		*/
		
		UPDATE b
			SET playerdiscount = 0
				, discount = 0
				, adiscount = 0
				, sdiscount = 0
		FROM dbo.bettrans b WITH (ROWLOCK)
			INNER JOIN @ClearcommByBatch_tmp c ON b.transid = c.transid
		WHERE b.statusID IN (0,1)
			AND b.matchid = @matchid
	
	END
	
	SET @start = @start + 1
	
END

--- check data after update between bettrans & #Ticket_OldValue_BackupForCompare 
/*
SELECT t.transid
	, b.playerdiscount, b.discount, b.adiscount, b.sdiscount
	, c.playerdiscount, c.discount, c.adiscount, c.sdiscount
FROM #tickets_Final t
	INNER JOIN dbo.bettrans b WITH (NOLOCK) ON t.transid = b.transid
	INNER JOIN #Ticket_OldValue_BackupForCompare c ON c.transid = t.transid


DROP TABLE #Match_Final
DROP TABLE #input_Master
DROP TABLE #input_Super
DROP TABLE #tickets_Final
DROP TABLE #tickets_tmp
DROP TABLE #tmp_recommend
DROP TABLE #Ticket_OldValue_BackupForCompare	
	
*/


		
		