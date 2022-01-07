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
	@Winlostdate SMALLDATETIME = '20220108',
	@Bettype SMALLINT = 19999

---truncate temp table before run
CREATE TABLE #TransIdList_Temp(TransId BIGINT)

---get all transid and insert into temp table
INSERT INTO #TransIdList_Temp(TransId)
SELECT b.TransID
FROM dbo.bettrans b WITH(NOLOCK) 
WHERE 
	b.bettype = @Bettype
	AND EXISTS (
				SELECT TOP 1 1 
				FROM CustDB.dbo.Customer c WITH(NOLOCK)
				WHERE c.custid = b.custid
					AND c.srecommend IN 
						(
							24975830
							,24975831
							,24975832
							,24975833
							,10063437 -- super deposit
							,1338545 -- super TW
						)
				)
	AND b.winlostdate = @winlostdate

SET @TotalRow = @@ROWCOUNT

SELECT @Msg = 'Insert to temp table completed: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

---create temp table by batch
CREATE TABLE #BatchTrans (TransactionId BIGINT PRIMARY KEY)

---Loop
WHILE EXISTS (SELECT TOP 1 1 FROM #TransIdList_Temp)
BEGIN

	---delete all rows in batch table
	DELETE FROM #BatchTrans

	---detele trans list
	DELETE TOP (@RowInBatch) FROM #TransIdList_Temp OUTPUT DELETED.TransId INTO #BatchTrans(TransactionId)

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

	SELECT @Msg = 'Batch Done'
	RAISERROR (@Msg, 0, 1) WITH NOWAIT
	
END

SELECT @Msg = 'Total Rows affected: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

DROP TABLE #BatchTrans

GO 