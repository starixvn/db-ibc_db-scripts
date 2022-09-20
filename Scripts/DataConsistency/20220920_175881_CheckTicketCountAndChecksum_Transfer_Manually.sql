/*<info serverAlias="DBSIG-bodb02"></info>*/
/*
	Created: 20220920@Sol
	DB : DBSIG-bodb02
	Task: Check data - [Redmine: #175881]
*/

USE bodb02;

GO 
---get min/max transid auto
/*
declare @CheckConsistencyKeyName VARCHAR(50) = 'SiteDB_CheckCons_Transfer_Count_LastTransId',
	@TransferLastTransId BIGINT ,
	@NewTransferLastTransId BIGINT ,
	@SiteDBGroupID SMALLINT ,
	@ErrCode INT = 0 ,
	@ErrMsg VARCHAR(MAX)= ''  


exec [dbo].SiteDB_DBA_Consistency_SystemSetting_Select
	@CheckConsistencyKeyName = @CheckConsistencyKeyName,
	@TransferLastTransId = @TransferLastTransId OUTPUT,
	@NewTransferLastTransId = @NewTransferLastTransId OUTPUT,
	@SiteDBGroupID = @SiteDBGroupID  OUTPUT,
	@ErrCode = @ErrCode  OUTPUT,
	@ErrMsg = @ErrMsg  OUTPUT 

select 	@CheckConsistencyKeyName,
	@TransferLastTransId ,
	@NewTransferLastTransId ,
	@SiteDBGroupID ,
	@ErrCode ,
	@ErrMsg  

*/

GO 

CREATE TABLE #Rule46_SiteDB_Data(TableName VARCHAR(50), SiteDBGroupID TINYINT, Recommend INT, TicketCount INT, TotalCheckSum INT)
CREATE TABLE #Rule46_CentralDB_Data(TableName VARCHAR(50), SiteDBGroupID TINYINT, Recommend INT, TicketCount INT, TotalCheckSum INT)

DECLARE 
	@SiteDBGroupID TINYINT, 
	@TransferLastTransId BIGINT = 30028203448188929, 
	@NewTransferLastTransId BIGINT = 30128203448188929, 
	@ErrCode INT, 
	@ErrMsg VARCHAR(MAX)

DECLARE 
	@CentralDBServer VARCHAR(50) = 'DBTP',
	@BatchSize INT = 1000

--- get SiteDBGroupID
SELECT @SiteDBGroupID = dbo.f_Get_SiteDBGroupID()

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
						INNER JOIN bodb02.dbo.Customer c WITH(NOLOCK)
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
						INNER JOIN bodb02.dbo.Customer c WITH(NOLOCK)
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
						INNER JOIN bodb02.dbo.Customer c WITH(NOLOCK)
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
	--rptDepWinlost_Trans
	SELECT 
		c.TableName AS Central_TableName, s.TableName AS SiteDB_TableName,
		c.SiteDBGroupID AS Central_SiteDBGroupID, s.SiteDBGroupID AS SiteDB_SiteDBGroupID,
		c.Recommend AS Central_Recommend, s.Recommend AS SiteDB_Recommend,
		c.TicketCount AS Central_TicketCount, s.TicketCount AS SiteDB_TicketCount,
		c.TotalCheckSum AS Central_TotalCheckSum, s.TotalCheckSum AS SiteDB_TotalCheckSum
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
END

DROP TABLE #Rule46_SiteDB_Data
DROP TABLE #Rule46_CentralDB_Data