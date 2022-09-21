/*<info serverAlias="DBSIG-bodb02"></info>*/
/*
	Created: 20220920@Sol
	DB : DBSIG-bodb02
	Task: Check data - [Redmine: #175881]
*/

USE bodb02;

GO 
/*
---get min/max transid auto
SELECT MIN(t.transid) AS MinTransID, MAX(t.transid) AS MaxTransID 
FROM Transfer t WITH (NOLOCK) 
WHERE WinlostDate = '20220922'

*/

GO 

CREATE TABLE #Rule46_SiteDB_Data(TableName VARCHAR(50), SiteDBGroupID TINYINT, Recommend INT, TicketCount INT, TotalCheckSum INT)
CREATE TABLE #Rule46_CentralDB_Data(TableName VARCHAR(50), SiteDBGroupID TINYINT, Recommend INT, TicketCount INT, TotalCheckSum INT)

DECLARE 
	@SiteDBGroupID TINYINT = 1, 
	@TransferLastTransId BIGINT = 30539807344033792, 
	@NewTransferLastTransId BIGINT = 30539807344033793, 
	@ErrCode INT, 
	@ErrMsg VARCHAR(MAX)

DECLARE 
	@CentralDBServer VARCHAR(50) = 'DBTP',
	@BatchSize INT = 1000

--- get SiteDBGroupID
SELECT @SiteDBGroupID = CASE 
							WHEN @@SERVERNAME IN ('DBTRANS','SITDBTRANS','TESTDBTRANS','db-60\devdbtrans') THEN 0
							WHEN @@SERVERNAME IN ('DBGRP01N1','DBGRP01N2','SITDBGRP01N1','SITDBGRP01N2','db62\DEVSITEDB','testdb053\TESTSITEDB') THEN 1
							WHEN @@SERVERNAME IN ('DBGRP02N1','DBGRP02N2','SITDBGRP02N1','SITDBGRP02N2') THEN 2
						ELSE 1023 END 


---get data from site db
INSERT INTO #Rule46_SiteDB_Data
SELECT TOP (@BatchSize)
	'Transfer' AS TableName,
	@SiteDBGroupID AS SiteDBGroupID, 
	Recommend,
	COUNT(1) AS TicketCount,
	CHECKSUM_AGG(
			CHECKSUM(
				CustId,TransDate,WinlostDate,Bettype,Stake,Actual_Stake,Winlost,AWinlost,MWinlost,SWinlost,PlayerComm
				,Comm,AComm,SComm,StatusId,RefNo,TransDesc,Recommend,MRecommend,SRecommend,Username,Currency,CurrencyName
				,ActualRate,Creator,Balance,[IP],CheckTime,SerialNo,TransId
				)
		) AS TotalCheckSum
FROM dbo.Transfer t WITH (NOLOCK)
WHERE t.TransId > @transferLastTransId
	AND t.TransId <= @NewTransferLastTransId
	AND t.Bettype NOT IN (19999, 20000)
GROUP BY Recommend 
			
UNION ALL

SELECT TOP (@BatchSize)
	'TransferInfo' AS TableName,
	@SiteDBGroupID AS SiteDBGroupID, 
	t.Recommend, 
	COUNT(1) AS TicketCount,
	CHECKSUM_AGG(
			CHECKSUM(
				ti.TransId,APositiontaking,MPositiontaking,SPositiontaking,EPositiontaking,PlayerDiscount,Discount
				,ADiscount,SDiscount,WalletType,BonusID,Amount,CheckerId,CheckerName,IsCollection,IsDel
				)
		) AS TotalCheckSum
FROM dbo.TransferInfo ti WITH (NOLOCK)
	INNER JOIN Transfer t with(nolock)
		on ti.TransId = t.TransId
WHERE ti.TransId > @transferLastTransId
	AND ti.TransId <= @NewTransferLastTransId
	AND t.Bettype NOT IN (19999, 20000)
GROUP BY t.Recommend 

UNION ALL

SELECT TOP (@BatchSize)
	'Transfer_Coll' AS TableName,
	@SiteDBGroupID AS SiteDBGroupID, 
	tc.Recommend, 
	COUNT(1) AS TicketCount,
	CHECKSUM_AGG(
			CHECKSUM(
				CustId,WinlostDate,TransDate,Bettype,Debit,Credit,Currency,ActualRate,TransID,RefNo,Username
				,Recommend,MRecommend,SRecommend,Creator,TransDesc,[IP]
				)
		) AS TotalCheckSum
FROM dbo.Transfer_Coll tc WITH (NOLOCK)
WHERE tc.TransId > @transferLastTransId
	AND tc.TransId <= @NewTransferLastTransId
	AND tc.Bettype NOT IN (19999, 20000)
GROUP BY tc.Recommend 

select * from #Rule46_SiteDB_Data
--##################################################################################################################################

---get data from central db
DECLARE @query NVARCHAR(MAX) = ''
DECLARE @execSql NVARCHAR(MAX) = ''

SET @query = '	SELECT TOP (@BatchSize)
						''Transfer'' AS TableName,
						@SiteDBGroupID AS SiteDBGroupID, 
						t.Recommend,
						COUNT(1) AS TicketCount,
						CHECKSUM_AGG(
									CHECKSUM(
										t.CustId,TransDate,WinlostDate,Bettype,Stake,Actual_Stake,Winlost,AWinlost,MWinlost,SWinlost,PlayerComm
										,Comm,AComm,SComm,StatusId,RefNo,TransDesc,t.Recommend,t.MRecommend,t.SRecommend,t.Username,t.Currency,
										CurrencyName,ActualRate,t.Creator,Balance,[IP],CheckTime,SerialNo,TransId
										)
								) AS TotalCheckSum
					FROM bodb02.dbo.Transfer t WITH (NOLOCK)
						INNER JOIN bodb02.dbo.vw_Customer c WITH(NOLOCK)
							ON t.CustId = c.custid
						INNER JOIN bodb02.dbo.Site s WITH(NOLOCK)
							ON s.site = c.site
					WHERE t.TransId > @TransferLastTransId
						AND t.TransId <= @NewTransferLastTransId
						AND s.SiteDBGroupID = @SiteDBGroupID
						AND t.Bettype NOT IN (19999, 20000)
					GROUP BY t.Recommend 
			
					UNION ALL

					SELECT TOP (@BatchSize)
						''TransferInfo'' AS TableName,
						@SiteDBGroupID AS SiteDBGroupID, 
						t.Recommend, 
						COUNT(1) AS TicketCount,
						CHECKSUM_AGG(
									CHECKSUM(
										ti.TransId,APositiontaking,MPositiontaking,SPositiontaking,EPositiontaking,PlayerDiscount,Discount
										,ADiscount,SDiscount,WalletType,BonusID,Amount,CheckerId,CheckerName,IsCollection,IsDel
										)
								) AS TotalCheckSum
					FROM bodb02.dbo.TransferInfo ti WITH (NOLOCK)
						INNER JOIN bodb02.dbo.Transfer t WITH(NOLOCK)
							ON ti.TransId = t.TransId
						INNER JOIN bodb02.dbo.vw_Customer c WITH(NOLOCK)
							ON t.CustId = c.custid
						INNER JOIN bodb02.dbo.Site s WITH(NOLOCK)
							ON s.site = c.site
					WHERE ti.TransId > @TransferLastTransId
						AND ti.TransId <= @NewTransferLastTransId
						AND s.SiteDBGroupID = @SiteDBGroupID
						AND t.Bettype NOT IN (19999, 20000)
					GROUP BY t.Recommend 

					UNION ALL

					SELECT TOP (@BatchSize)
						''Transfer_Coll'' AS TableName,
						@SiteDBGroupID AS SiteDBGroupID, 
						tc.Recommend, 
						COUNT(1) AS TicketCount,
						CHECKSUM_AGG(
									CHECKSUM(
										tc.CustId,WinlostDate,TransDate,Bettype,Debit,Credit,tc.Currency,ActualRate,TransID,RefNo,tc.Username
										,tc.Recommend,tc.MRecommend,tc.SRecommend,tc.Creator,TransDesc,[IP]
										)
								) AS TotalCheckSum
					FROM bodb02.dbo.Transfer_Coll tc WITH (NOLOCK)
						INNER JOIN bodb02.dbo.vw_Customer c WITH(NOLOCK)
							ON tc.CustId = c.custid
						INNER JOIN bodb02.dbo.Site s WITH(NOLOCK)
							ON s.site = c.site
					WHERE tc.TransId > @TransferLastTransId
						AND tc.TransID <= @NewTransferLastTransId
						AND s.SiteDBGroupID = @SiteDBGroupID
						AND tc.Bettype NOT IN (19999, 20000)
					GROUP BY tc.Recommend 	
					'

SET @execSql = @CentralDBServer + '.bodb02.dbo.sp_executesql @query, N''@SiteDBGroupID TINYINT, @TransferLastTransId BIGINT, @NewTransferLastTransId BIGINT, @BatchSize INT'' , @SiteDBGroupID, @TransferLastTransId, @NewTransferLastTransId, @BatchSize'
	
INSERT INTO #Rule46_CentralDB_Data
EXECUTE	sys.sp_executesql @execSql, N'@query NVARCHAR(MAX), @SiteDBGroupID TINYINT, @TransferLastTransId BIGINT, @NewTransferLastTransId BIGINT, @BatchSize INT', @query, @SiteDBGroupID, @TransferLastTransId, @NewTransferLastTransId, @BatchSize

select * from #Rule46_CentralDB_Data


--## COMPARE DATA ##
BEGIN
	--result data
	SELECT 
		c.TableName AS Central_TableName, s.TableName AS SiteDB_TableName,
		c.SiteDBGroupID AS Central_SiteDBGroupID, s.SiteDBGroupID AS SiteDB_SiteDBGroupID,
		c.Recommend AS Central_Recommend, s.Recommend AS SiteDB_Recommend,
		c.TicketCount AS Central_TicketCount, s.TicketCount AS SiteDB_TicketCount,
		c.TotalCheckSum AS Central_TotalCheckSum, s.TotalCheckSum AS SiteDB_TotalCheckSum
		INTO #ResultData
	FROM #Rule46_CentralDB_Data c
		FULL OUTER JOIN #Rule46_SiteDB_Data s
			ON c.TableName = s.TableName AND c.SiteDBGroupID = s.SiteDBGroupID AND c.Recommend = s.Recommend
	WHERE 
		(
			c.Recommend IS NULL
			OR s.Recommend IS NULL
			OR c.TicketCount <> s.TicketCount
			OR c.TotalCheckSum <> s.TotalCheckSum
		)

	--show data
	SELECT * FROM #ResultData
END

IF @@ROWCOUNT <> 0
BEGIN
	DECLARE @TableName VARCHAR(50)
		,@Recommend INT
		,@Central_TicketCount INT
		,@SiteDB_TicketCount INT
		,@Central_TotalCheckSum INT
		,@SiteDB_TotalCheckSum INT

	--get top 1 row to check
	SELECT TOP 1 @TableName = Central_TableName
		,@Recommend = Central_Recommend
		,@Central_TicketCount = Central_TicketCount
		,@SiteDB_TicketCount = SiteDB_TicketCount
		,@Central_TotalCheckSum = Central_TotalCheckSum
		,@SiteDB_TotalCheckSum = SiteDB_TotalCheckSum
	FROM #ResultData

	IF @Central_TicketCount <> @SiteDB_TicketCount
	BEGIN
		SELECT 'The tickets between sitebd and central db are incorrect. Please check In-House Replicator.'
	END
	ELSE IF @Central_TotalCheckSum <> @SiteDB_TotalCheckSum
	BEGIN
		IF @TableName = 'Transfer'
		BEGIN
			;WITH sitedb
			AS (
					SELECT TOP (@BatchSize) 'Transfer' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,t.TransId
						,CHECKSUM_AGG(
									CHECKSUM(
										CustId,TransDate,WinlostDate,Bettype,Stake,Actual_Stake,Winlost,AWinlost,MWinlost,SWinlost,PlayerComm
										,Comm,AComm,SComm,StatusId,RefNo,TransDesc,Recommend,MRecommend,SRecommend,Username,Currency,CurrencyName
										,ActualRate,Creator,Balance,[IP],CheckTime,SerialNo
										)
								) AS TotalCheckSum
					FROM dbo.Transfer t WITH (NOLOCK)
					WHERE t.TransId > @transferLastTransId
						AND t.TransId <= @NewTransferLastTransId
						AND t.Bettype NOT IN (19999, 20000) 
						AND t.Recommend = @Recommend
					GROUP BY t.TransId
				)
			,centraldb
			AS (
					SELECT TOP (@BatchSize) 'Transfer' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,t.TransId
						,CHECKSUM_AGG(
									CHECKSUM(
										CustId,TransDate,WinlostDate,Bettype,Stake,Actual_Stake,Winlost,AWinlost,MWinlost,SWinlost,PlayerComm
										,Comm,AComm,SComm,StatusId,RefNo,TransDesc,Recommend,MRecommend,SRecommend,Username,Currency,CurrencyName
										,ActualRate,Creator,Balance,[IP],CheckTime,SerialNo
										)
								) AS TotalCheckSum
					FROM DBTP.bodb02.dbo.Transfer t WITH (NOLOCK)
					WHERE t.TransId > @transferLastTransId
						AND t.TransId <= @NewTransferLastTransId
						AND t.Bettype NOT IN (19999, 20000) 
						AND t.Recommend = @Recommend
					GROUP BY t.TransId
				)
			SELECT c.TableName AS Central_TableName
				,s.TableName AS SiteDB_TableName
				,c.SiteDBGroupID AS Central_SiteDBGroupID
				,s.SiteDBGroupID AS SiteDB_SiteDBGroupID
				,c.Recommend AS Central_Recommend
				,s.Recommend AS SiteDB_Recommend
				,c.TransId AS Central_TransId
				,s.TransId AS SiteDB_TransId
				,c.TotalCheckSum AS Central_TotalCheckSum
				,s.TotalCheckSum AS SiteDB_TotalCheckSum
			FROM centraldb c
				FULL OUTER JOIN sitedb s
					ON c.TableName = s.TableName AND c.SiteDBGroupID = s.SiteDBGroupID AND c.TransId = s.TransId
			WHERE (c.TransId IS NULL OR s.TransId IS NULL OR c.TotalCheckSum <> s.TotalCheckSum)
		END
		ELSE IF @TableName = 'TransferInfo'
		BEGIN
				
			;WITH sitedb
			AS (
					SELECT TOP (@BatchSize) 'TransferInfo' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,t.TransId
						,CHECKSUM_AGG(CHECKSUM(APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount, Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection, IsDel)) AS TotalCheckSum
					FROM dbo.TransferInfo ti WITH (NOLOCK)
					INNER JOIN Transfer t WITH (NOLOCK)
						ON ti.TransId = t.TransId
					WHERE 
						ti.TransId > @transferLastTransId 
						AND ti.TransId <= @NewTransferLastTransId 
						AND t.Bettype NOT IN (19999, 20000) 
						AND t.Recommend = @Recommend
					GROUP BY t.TransId
				)
				,centraldb
			AS (
					SELECT TOP (@BatchSize) 'TransferInfo' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,t.TransId
						,CHECKSUM_AGG(CHECKSUM(APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount, Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection, IsDel)) AS TotalCheckSum
					FROM DBTP.bodb02.dbo.TransferInfo ti WITH (NOLOCK)
					INNER JOIN dbtp.bodb02.dbo.Transfer t WITH (NOLOCK)
						ON ti.TransId = t.TransId
					WHERE 
						ti.TransId > @transferLastTransId 
						AND ti.TransId <= @NewTransferLastTransId 
						AND t.Bettype NOT IN (19999, 20000) 
						AND t.Recommend = @Recommend
					GROUP BY t.TransId
				)
			SELECT c.TableName AS Central_TableName
				,s.TableName AS SiteDB_TableName
				,c.SiteDBGroupID AS Central_SiteDBGroupID
				,s.SiteDBGroupID AS SiteDB_SiteDBGroupID
				,c.Recommend AS Central_Recommend
				,s.Recommend AS SiteDB_Recommend
				,c.TransId AS Central_TransId
				,s.TransId AS SiteDB_TransId
				,c.TotalCheckSum AS Central_TotalCheckSum
				,s.TotalCheckSum AS SiteDB_TotalCheckSum
			FROM centraldb c
				FULL OUTER JOIN sitedb s
					ON c.TableName = s.TableName AND c.SiteDBGroupID = s.SiteDBGroupID AND c.TransId = s.TransId
			WHERE (c.TransId IS NULL OR s.TransId IS NULL OR c.TotalCheckSum <> s.TotalCheckSum)

		END
		ELSE IF @TableName = 'Transfer_Coll'
		BEGIN
			;WITH sitedb
			AS (
					SELECT TOP (@BatchSize) 'Transfer_Coll' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,tc.TransId
						,CHECKSUM_AGG(
								CHECKSUM(
									CustId,WinlostDate,TransDate,Bettype,Debit,Credit,Currency,ActualRate,RefNo,Username
									,Recommend,MRecommend,SRecommend,Creator,TransDesc,[IP]
									)
							) AS TotalCheckSum
					FROM dbo.Transfer_Coll tc WITH (NOLOCK)
					WHERE tc.TransId > @transferLastTransId
						AND tc.TransId <= @NewTransferLastTransId
						AND tc.Bettype NOT IN (19999, 20000)
						AND tc.Recommend = @Recommend
					GROUP BY tc.TransId
				)
				,centraldb
			AS (
					SELECT TOP (@BatchSize) 'Transfer_Coll' AS TableName
						,@SiteDBGroupID AS SiteDBGroupID
						,@Recommend AS Recommend
						,tc.TransId
						,CHECKSUM_AGG(
									CHECKSUM(
										CustId,WinlostDate,TransDate,Bettype,Debit,Credit,Currency,ActualRate,RefNo,Username
										,Recommend,MRecommend,SRecommend,Creator,TransDesc,[IP]
										)
								) AS TotalCheckSum
					FROM dbo.Transfer_Coll tc WITH (NOLOCK)
					WHERE tc.TransId > @transferLastTransId
						AND tc.TransId <= @NewTransferLastTransId
						AND tc.Bettype NOT IN (19999, 20000)
						AND tc.Recommend = @Recommend
					GROUP BY tc.TransId
				)
			SELECT c.TableName AS Central_TableName
				,s.TableName AS SiteDB_TableName
				,c.SiteDBGroupID AS Central_SiteDBGroupID
				,s.SiteDBGroupID AS SiteDB_SiteDBGroupID
				,c.Recommend AS Central_Recommend
				,s.Recommend AS SiteDB_Recommend
				,c.TransId AS Central_TransId
				,s.TransId AS SiteDB_TransId
				,c.TotalCheckSum AS Central_TotalCheckSum
				,s.TotalCheckSum AS SiteDB_TotalCheckSum
			FROM centraldb c
				FULL OUTER JOIN sitedb s
					ON c.TableName = s.TableName AND c.SiteDBGroupID = s.SiteDBGroupID AND c.TransId = s.TransId
			WHERE (c.TransId IS NULL OR s.TransId IS NULL OR c.TotalCheckSum <> s.TotalCheckSum)
		END
	END
END


DROP TABLE #Rule46_SiteDB_Data
DROP TABLE #Rule46_CentralDB_Data
DROP TABLE #ResultData