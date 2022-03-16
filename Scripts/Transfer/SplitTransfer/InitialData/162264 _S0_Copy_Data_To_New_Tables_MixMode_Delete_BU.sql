/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

---get latest transid from bettrans
DECLARE 
	@RowInBatch INT = 2000,
	@Msg VARCHAR(MAX) = '',
	@TransIdList VARCHAR(MAX) = '',
	@TotalRow INT = 0,
	@BalanceUpDate SMALLDATETIME = '20220106'

---truncate temp table before run
CREATE TABLE #TransIdList_Temp(TransId BIGINT)

---get all transid and insert into temp table
INSERT INTO #TransIdList_Temp(TransId)
SELECT b.TransID
FROM dbo.Transfer b WITH(NOLOCK) 
WHERE 
	b.bettype >= 19999
	AND b.winlostdate < @BalanceUpDate

SET @TotalRow = @@ROWCOUNT

SELECT @Msg = 'Insert to temp table completed: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

---create temp table by batch
CREATE TABLE #BatchTrans (TransactionId BIGINT PRIMARY KEY)
DECLARE @Transfer TABLE(TransId BIGINT)

---Loop
WHILE EXISTS (SELECT TOP 1 1 FROM #TransIdList_Temp)
BEGIN

	---delete all rows in batch table
	DELETE FROM #BatchTrans

	---detele trans list
	DELETE TOP (@RowInBatch) FROM #TransIdList_Temp OUTPUT DELETED.TransId INTO #BatchTrans(TransactionId)

	BEGIN TRY

		DELETE FROM @Transfer

		---delete data transfer
		DELETE FROM dbo.Transfer 
		OUTPUT DELETED.TransId INTO @Transfer(TransId) 
		WHERE TransId IN (SELECT TransactionId FROM #BatchTrans)

		---delete data transferInfo
		DELETE FROM dbo.TransferInfo 
		WHERE TransId IN (SELECT TransId FROM @Transfer)
		

	END TRY
	BEGIN CATCH

		SET @Msg = ERROR_MESSAGE()
		RAISERROR(@Msg, 16, 1)

	END CATCH

	SELECT @Msg = 'Batch Done'
	RAISERROR (@Msg, 0, 1) WITH NOWAIT
	
END

SELECT @Msg = 'Total Rows affected: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

DROP TABLE #BatchTrans

GO 