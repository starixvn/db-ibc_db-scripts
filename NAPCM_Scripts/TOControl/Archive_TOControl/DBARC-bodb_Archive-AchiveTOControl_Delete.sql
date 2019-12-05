/*
	Created: 20191128@Helen
	Task: TO Control Archive - https://nexdev.net/issues/124447
	DB: DB061/bodb_Archive
*/
USE bodb_Archive
GO
CREATE TABLE #archiveDate (ID INT IDENTITY (1,1), winlostdate DATETIME)

CREATE TABLE #Match_tbl (winlostate DATETIME, Matchid INT)

CREATE TABLE #Match_tbl_tmp  (winlostate DATETIME, Matchid INT)

INSERT INTO #archiveDate (winlostdate)
SELECT winlostdate 
FROM DBTRANS.bodb02.dbo.Task_ArchiveDate WITH (NOLOCK)

INSERT INTO #Match_tbl (winlostate, Matchid)
SELECT  eventdate, matchid
FROM bodb02.dbo.match14 m WITH (NOLOCK)
	INNER JOIN #archiveDate wld ON m.eventdate = wld.winlostdate
ORDER BY m.eventdate

DECLARE @start INT = 1
	, @end INT
	, @winlostdate DATETIME   
	, @winlostdate_tmp VARCHAR(12)
	, @matchIDs VARCHAR(MAX)
	
SET @end = (SELECT MAX(ID) FROM #archiveDate)

-- Deployer Info
DECLARE @msg nvarchar(200) = 'Currently at batch %d, wld: %s.'
WHILE @start <= @end
BEGIN
	
	SET @winlostdate = (SELECT winlostdate FROM #archiveDate WHERE ID = @start )
	SET @winlostdate_tmp  = CONVERT(VARCHAR(10),@winlostdate,101)
	
	RAISERROR (@msg, 0, 1,@start, @winlostdate_tmp) WITH NOWAIT
	
	WHILE (1=1)
	BEGIN
		TRUNCATE TABLE #Match_tbl_tmp

		DELETE TOP (500)
		FROM #Match_tbl OUTPUT DELETED.Matchid, DELETED.winlostate INTO #Match_tbl_tmp (Matchid,winlostate)
		
		IF @@ROWCOUNT = 0 BREAK
		
		SET @matchIDs = ''
		SET @matchIDs = STUFF((SELECT ',' + CONVERT(VARCHAR(50),matchid) FROM #Match_tbl_tmp FOR XML PATH ('')),1,1,'')
		
		RAISERROR (@msg, 0, 1,@start, @matchIDs) WITH NOWAIT
		
		INSERT INTO dbo.TOControl_Setting_bk (CustID, matchid, MaxTurnOver, TotalTurnOver, IsNotified, HouseTurnover, PercentLevel, IsGroupHeadLine)
		EXEC DBCUST.CUSTDB.dbo.Task_Archive_TOControl_Copy @matchIDs
		
	END	
	
	SET @start = @start + 1
	
	WAITFOR DELAY '00:00:00.280'
				
END	

DROP TABLE #Match_tbl
DROP TABLE #Match_tbl_tmp
DROP TABLE #archiveDate




