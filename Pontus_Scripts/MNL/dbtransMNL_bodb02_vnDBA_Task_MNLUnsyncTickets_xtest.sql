USE [bodb02]
CREATE PROCEDURE [dbo].[vnDBA_Task_MNLUnsyncTickets_xtest]
/*
	Created: 20190325@Helen
	Task: MNL Sync Tickets
	DB: DBTRANS@MNL/bodb02
	
	
	EXEC vnDBA_Task_MNLUnsyncTickets_xtest
*/
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @datetime DATETIME 
	SET @datetime = GETDATE()

	DECLARE @query_bettrans NVARCHAR(MAX)
	DECLARE @query_bettransm NVARCHAR(MAX)
	
	CREATE TABLE #transid_DBMNL_bettrans (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	CREATE TABLE #transid_DBMNL_bettransm (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	
	CREATE TABLE #transid_DBMNL_bettrans_recheck (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	CREATE TABLE #transid_DBMNL_bettransm_recheck (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	
	CREATE TABLE #transid_UnSync_bettrans (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	CREATE TABLE #transid_UnSync_bettransm (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	
	CREATE TABLE #tmpTable (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)
	CREATE TABLE #tmpTable_recheck (TransID BIGINT PRIMARY KEY,statusID TINYINT,status NVARCHAR(10), checktime DATETIME, creator INT, ruben TINYINT,actual_stake MONEY,statuswinlost TINYINT, winlostdate SMALLDATETIME)	
	------------------- bettrans preparation ----------------------
	SELECT	@query_bettrans = N'
INSERT INTO #transid_DBMNL_bettrans (transid,statusID,status,checktime,creator,ruben, actual_stake )
SELECT transid,statusID,status,checktime,creator,ruben, actual_stake 
FROM OPENQUERY(DBMNL,''
SELECT	transid,statusID,status,checktime,creator,ruben,actual_stake 
FROM	bodb02.dbo.bettrans AS t1 WITH (NOLOCK)
INNER JOIN (
	SELECT	matchid
	FROM bodb02.dbo.match WITH (NOLOCK) WHERE eventstatus = ''''running''''
	UNION ALL
	SELECT	Match3rdId
	FROM bodb02.dbo.Match3rd WITH (NOLOCK) WHERE eventstatus = ''''running''''
	UNION ALL	
	SELECT	orid
	FROM bodb02.dbo.outright WITH (NOLOCK) WHERE oddsstatus = ''''running''''
	UNION ALL	
	SELECT DISTINCT	vsr.EventID as matchid
	FROM bodb02.dbo.VSRaceInfo vsr WITH (NOLOCK) 
		INNER JOIN bodb02.dbo.VSOutright vs WITH (NOLOCK) ON vsr.EventID = vs.EventID
	WHERE vs.eventstatus = ''''running'''') AS t2 ON t2.matchid = t1.matchid 

WHERE  t1.bettype < 19999 AND t1.statusID IN (0,101) ;'')'

	EXECUTE	sys.sp_executesql @query_bettrans

	------------------- bettransm preparation ----------------------
	SELECT	@query_bettransm = N'
INSERT INTO #transid_DBMNL_bettransm (transid,statusID,status,checktime, statuswinlost, winlostdate )
SELECT transid,statusID,status,checktime, statuswinlost, winlostdate 
FROM OPENQUERY(DBMNL,''
SELECT	transid,statusID,status,checktime,statuswinlost, winlostdate 
FROM	bodb02.dbo.bettransm AS t1 WITH (NOLOCK)
INNER JOIN (
	SELECT	matchid
	FROM bodb02.dbo.match WITH (NOLOCK) WHERE eventstatus = ''''running''''
	UNION ALL
	SELECT	Match3rdId
	FROM bodb02.dbo.Match3rd WITH (NOLOCK) WHERE eventstatus = ''''running''''
	UNION ALL	
	SELECT	orid
	FROM bodb02.dbo.outright WITH (NOLOCK) WHERE oddsstatus = ''''running''''
	UNION ALL	
	SELECT DISTINCT	vsr.EventID as matchid
	FROM bodb02.dbo.VSRaceInfo vsr WITH (NOLOCK) 
		INNER JOIN bodb02.dbo.VSOutright vs WITH (NOLOCK) ON vsr.EventID = vs.EventID
	WHERE vs.eventstatus = ''''running'''') AS t2 ON t2.matchid = t1.matchid 

WHERE  t1.bettype < 19999 AND t1.statusID IN (0,101) ;'')'

	EXECUTE	sys.sp_executesql @query_bettransm
	
	------------------- bettrans Unsyn Tickets ----------------------
	INSERT INTO #transid_UnSync_bettrans (transid,statusID,status,checktime,creator,ruben,actual_stake)
	SELECT t1.transid,t1.statusID,t1.status,t1.checktime,t1.creator,t1.ruben,t1.actual_stake
	FROM #transid_DBMNL_bettrans t1
		INNER JOIN bodb02.dbo.bettrans t2 WITH (NOLOCK, INDEX = PK_bettrans) ON t1.TransID = t2.transid 
	WHERE (t1.statusID = 0 AND t2.statusID = 101) OR (t1.statusID = 101 AND t2.statusID = 0)

	------------------- bettransm Unsyn Tickets ----------------------
	INSERT INTO #transid_UnSync_bettransm (transid,statusID,status,checktime,creator,ruben,actual_stake, statuswinlost, winlostdate)
	SELECT t1.transid,t1.statusID,t1.status,t1.checktime,t1.creator,t1.ruben,t1.actual_stake, t1.statuswinlost, t1.winlostdate
	FROM #transid_DBMNL_bettransm t1
		INNER JOIN bodb02.dbo.bettransm t2 WITH (NOLOCK, INDEX = PK_bettransm) ON t1.TransID = t2.transid 
	WHERE (t1.statusID = 0 AND t2.statusID = 101) OR (t1.statusID = 101 AND t2.statusID = 0)
	
	-------------- FIX DATA FOR bettrans ---------------------------------
	
	DECLARE @TransIdList_bettrans XML, @TransIdStr_bettrans VARCHAR(MAX)
	DECLARE @TransIdList_bettransm XML, @TransIdStr_bettransm VARCHAR(MAX)
	DECLARE @TransIdList_old_xml XML, @TransIdList_old VARCHAR(MAX)
	DECLARE @transID_tmp VARCHAR(MAX) = ''
	
	IF EXISTS (SELECT 1 FROM #transid_UnSync_bettrans)
	BEGIN
			WHILE EXISTS(SELECT 1 FROM #transid_UnSync_bettrans)
			BEGIN
				SELECT @transID_tmp = ''
				
				TRUNCATE TABLE #tmpTable
				TRUNCATE TABLE #tmpTable_recheck
				TRUNCATE TABLE #transid_DBMNL_bettrans_recheck
				
				DELETE TOP (1000) #transid_UnSync_bettrans 
				OUTPUT deleted.transid,deleted.statusID,deleted.status,deleted.checktime,deleted.creator,deleted.ruben,deleted.actual_stake, deleted.statuswinlost, deleted.winlostdate 
				INTO #tmpTable
				
				SELECT @transID_tmp = @transID_tmp + ',' + convert(varchar(20),transid)
				FROM #tmpTable

				SET @transID_tmp = STUFF(@transID_tmp,1,1,'')
				--SELECT @transID_tmp
				
				WAITFOR DELAY '00:00:05'
				
				SELECT	@query_bettrans = N'
INSERT INTO #transid_DBMNL_bettrans_recheck (transid,statusID,status,checktime,creator,ruben, actual_stake )
SELECT transid,statusID,status,checktime,creator,ruben, actual_stake 
FROM OPENQUERY(DBMNL,''
SELECT	transid,statusID,status,checktime,creator,ruben,actual_stake 
FROM	bodb02.dbo.bettrans AS t1 WITH (NOLOCK)
WHERE  t1.transid IN ('+ @transID_tmp + ');'')'
				EXECUTE	sys.sp_executesql @query_bettrans
				
				INSERT INTO #tmpTable_recheck (TransID,statusID,status,checktime,creator,ruben,actual_stake,statuswinlost,winlostdate)
				SELECT  
						t2.transid 
						,t2.statusID 
						,t2.status 
						,t2.checktime 
						,t2.creator 
						,t2.ruben 
						,t2.actual_stake 
						,t2.statuswinlost 
						,t2.winlostdate 
				FROM #tmpTable t1
					INNER JOIN #transid_DBMNL_bettrans_recheck t2 ON t1.TransID = t2.TransID 
					INNER JOIN	bodb02.dbo.bettrans b WITH (NOLOCK) ON t1.TransID = b.transid 
				WHERE t2.statusID <> b.statusID AND b.statusID IN (0,1,101) AND t2.statusID IN (0,1,101)
				
				IF EXISTS (SELECT 1 FROM #tmpTable_recheck)
				BEGIN
					SELECT @TransIdList_bettrans =  (
											SELECT  
													transid AS '@t'
													,statusID AS '@sid'
													,status AS '@s'
													,checktime AS '@c'
													,creator AS '@cr'
													,ruben AS '@r'
													,actual_stake AS '@a'
													,statuswinlost AS '@sw'
													,winlostdate AS 'wld'
											FROM #tmpTable_recheck	
											FOR XML PATH('r'),TYPE
									)
					
					SELECT @TransIdStr_bettrans = CONVERT(VARCHAR(MAX), @TransIdList_bettrans)
					
					-- Get old value for Write log
					SELECT @TransIdList_old_xml =  (
								SELECT  
										t1.transid AS '@t'
										,t1.statusID AS '@sid'
										,t1.status AS '@s'
										,t1.checktime AS '@c'
										,t1.creator AS '@cr'
										,t1.ruben AS '@r'
										,t1.actual_stake AS '@a'
										,t1.statuswinlost AS '@sw'
										,t1.winlostdate AS 'wld'
								FROM bodb02.dbo.bettrans t1 WITH (NOLOCK)
									INNER JOIN #tmpTable_recheck t2 ON t1.transid = t2.TransID
								FOR XML PATH('r'),TYPE
						)
						
					SELECT @TransIdList_old = CONVERT(VARCHAR(MAX),@TransIdList_old_xml)
			
					-- FIX DATA
					EXEC bodb02.dbo.Acc_ExecRep_03 @TransIdList = @TransIdStr_bettrans, @tablename = 'bettrans'
					
					INSERT INTO tmp_vnDBA_CaptureDataUnSyncTicket_xtest (logdate,TransIdList_old,TransIdList_new,tablename) 
					VALUES (@datetime, @TransIdList_old,@TransIdStr_bettrans,'bettrans')
					
				END
			END
			
	END
	
	-------------- FIX DATA FOR bettransm ---------------------------------
	TRUNCATE TABLE #tmpTable
	
	SELECT @transID_tmp = ''
	
	IF EXISTS(SELECT 1 FROM #transid_UnSync_bettransm)
	BEGIN
		WHILE EXISTS(SELECT 1 FROM #transid_UnSync_bettransm)
		BEGIN
			SELECT @transID_tmp = ''
			TRUNCATE TABLE #tmpTable
			TRUNCATE TABLE #tmpTable_recheck	
			TRUNCATE TABLE #transid_DBMNL_bettransm_recheck 	
			
			DELETE TOP (1000) #transid_UnSync_bettransm 
			OUTPUT deleted.transid,deleted.statusID,deleted.status,deleted.checktime,deleted.creator,deleted.ruben,deleted.actual_stake,deleted.statuswinlost, deleted.winlostdate  
			INTO #tmpTable
			
			SELECT @transID_tmp = @transID_tmp + ',' + convert(varchar(20),transid)
			FROM #tmpTable

			SET @transID_tmp = STUFF(@transID_tmp,1,1,'')
			--SELECT @transID_tmp
			
			WAITFOR DELAY '00:00:05'
			
			SELECT	@query_bettransm = N'
INSERT INTO #transid_DBMNL_bettransm_recheck (transid,statusID,status,checktime, statuswinlost, winlostdate )
SELECT transid,statusID,status,checktime, statuswinlost, winlostdate 
FROM OPENQUERY(DBMNL,''
SELECT	transid,statusID,status,checktime, statuswinlost, winlostdate 
FROM	bodb02.dbo.bettransm AS t1 WITH (NOLOCK)
WHERE  t1.transid IN ('+ @transID_tmp + ');'')'
			EXECUTE	sys.sp_executesql @query_bettransm
			
			INSERT INTO #tmpTable_recheck (TransID,statusID,status,checktime,creator,ruben,actual_stake,statuswinlost,winlostdate)
			SELECT  
					t2.transid 
					,t2.statusID 
					,t2.status 
					,t2.checktime 
					,t2.creator 
					,t2.ruben 
					,t2.actual_stake 
					,t2.statuswinlost 
					,t2.winlostdate 
			FROM #tmpTable t1
				INNER JOIN #transid_DBMNL_bettransm_recheck t2 ON t1.TransID = t2.TransID 
				INNER JOIN	bodb02.dbo.bettransm b WITH (NOLOCK) ON t1.TransID = b.transid 
			WHERE t2.statusID <> b.statusID AND b.statusID IN (0,1,101) AND t2.statusID IN (0,1,101)
			
			IF EXISTS (SELECT 1 FROM #tmpTable_recheck)
			BEGIN	
				SELECT @TransIdList_bettransm =  (
										SELECT  
												t1.transid AS '@t'
												,t1.statusID AS '@sid'
												,t1.status AS '@s'
												,t1.checktime AS '@c'
												,t1.creator AS '@cr'
												,t1.ruben AS '@r'
												,t1.actual_stake AS '@a'
												,t1.statuswinlost AS '@sw'
												,t1.winlostdate AS 'wld'
										FROM #tmpTable_recheck t1
										FOR XML PATH('r'),TYPE
								)
				
				SELECT @TransIdStr_bettransm = CONVERT(VARCHAR(MAX), @TransIdList_bettransm)
				
				-- -- Get old value for Write log WRITE LOG
				SELECT @TransIdList_old_xml =  (
								SELECT  
										t1.transid AS '@t'
										,t1.statusID AS '@sid'
										,t1.status AS '@s'
										,t1.checktime AS '@c'
										,NULL AS '@cr'
										,NULL AS '@r'
										,NULL AS '@a'
										,t1.statuswinlost AS '@sw'
										,t1.winlostdate AS 'wld'
								FROM bodb02.dbo.bettransm t1 WITH (NOLOCK)
									INNER JOIN #tmpTable_recheck t2 ON t1.transid = t2.TransID
								FOR XML PATH('r'),TYPE
						)
				
				SELECT @TransIdList_old = CONVERT(VARCHAR(MAX),@TransIdList_old_xml)
				
				-- FIX DATA
				
				EXEC bodb02.dbo.Acc_ExecRep_03 @TransIdList = @TransIdStr_bettransm, @tablename = 'bettransm'
				
				INSERT INTO tmp_vnDBA_CaptureDataUnSyncTicket_xtest (logdate,TransIdList_old,TransIdList_new,tablename) 
				VALUES (@datetime, @TransIdList_old,@TransIdStr_bettransm,'bettransm')
			END
		END
	END
	
	DROP TABLE #transid_DBMNL_bettrans
	DROP TABLE #transid_DBMNL_bettransm
	DROP TABLE #transid_UnSync_bettrans
	DROP TABLE #transid_UnSync_bettransm
	DROP TABLE #tmpTable
	DROP TABLE #tmpTable_recheck
	DROP TABLE #transid_DBMNL_bettrans_recheck
	DROP TABLE #transid_DBMNL_bettransm_recheck
	
	SET NOCOUNT OFF
END


GO


