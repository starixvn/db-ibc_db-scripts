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
	@MaxTransId BIGINT = 0,
	@TotalRow INT = 0

SELECT @MaxTransId = MAX(b.transid) FROM dbo.bettrans b WITH(NOLOCK)
SELECT 'Max TransId' = @MaxTransId

---truncate temp table before run
TRUNCATE TABLE TransIdList_Temp

---get all transid and insert into temp table
INSERT INTO TransIdList_Temp(TransId)
SELECT b.TransID
FROM dbo.bettrans b WITH(NOLOCK) 
WHERE 
	b.transid <= @MaxTransId
	AND b.bettype >= 19999
	AND b.bettype NOT IN 
	(
		23001,23002,23101,23102,23201,23202
	) --bettype stopped supporting

SET @TotalRow = @@ROWCOUNT

SELECT @Msg = 'Insert to temp table completed: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

---create temp table by batch
CREATE TABLE #BatchTrans (TransactionId BIGINT PRIMARY KEY)

---Loop
WHILE EXISTS (SELECT TOP 1 1 FROM TransIdList_Temp)
BEGIN

	---delete all rows in batch table
	DELETE FROM #BatchTrans

	---detele trans list
	DELETE TOP (@RowInBatch) FROM TransIdList_Temp OUTPUT DELETED.TransId INTO #BatchTrans(TransactionId)

	---create string transid to pass into Transfer_ExecRep_01 sp
	SET @TransIdList = ''
	SELECT @TransIdList = @TransIdList + CAST(b.TransactionId AS VARCHAR(50)) + ','
	FROM #BatchTrans b

	BEGIN TRY

		---insert data
		EXEC bodb02.dbo.Transfer_ExecRep_01 @TransIdList = @TransIdList, @IsDelete = 0

	END TRY
	BEGIN CATCH

		SET @Msg = ERROR_MESSAGE()
		RAISERROR(@Msg, 16, 1)

	END CATCH

	SELECT @Msg = 'Rows affected in current batch: ' + CONVERT(VARCHAR(50), @RowInBatch, 112)
	RAISERROR (@Msg, 0, 1) WITH NOWAIT
	
END

SELECT @Msg = 'Total Rows affected: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

DROP TABLE #BatchTrans

GO 