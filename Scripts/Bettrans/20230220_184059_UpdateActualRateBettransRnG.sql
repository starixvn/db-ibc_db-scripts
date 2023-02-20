 /*<info serverAlias="DBTXN-bodb02"></info>*/
 /*
	Creator: 20230220@Evan
 	DB: DBTXN/bodb02
 	Task : Update rates for bettransRng table [redmine: #184059]
 	 
	
*/	

DECLARE @Winlostdate SMALLDATETIME = '20230217'

CREATE TABLE #BettransRNG (transid BIGINT, actualrate FLOAT, virtualrate FLOAT, old_actualrate FLOAT)

INSERT INTO #BettransRNG(transid, actualrate, virtualrate, old_actualrate)
SELECT transid, e.actualrate, e.actualrate*(b.virtualrate/b.actualrate) as virtualrate,b.virtualrate
FROM dbo.BettransRNG b WITH(NOLOCK) 				
	INNER JOIN CustDB.dbo.ExchangeDailyOanda e WITH (NOLOCK) ON b.currency = e.exchangeid AND e.ExchangeDate = @Winlostdate
WHERE b.actualrate <> e.actualrate AND b.winlostdate = @Winlostdate 

DECLARE @__table TABLE (transid BIGINT, actualrate FLOAT, virtualrate FLOAT)
DECLARE @rowcount INT = 1
SET @rowcount = 1 
WHILE @rowcount <> 0
BEGIN
	DELETE FROM @__table
			
	DELETE TOP(500) FROM #BettransRNG 
	OUTPUT deleted.transid, deleted.actualrate, deleted.virtualrate into @__table
	SET @rowcount = @@ROWCOUNT
			
	UPDATE b WITH(ROWLOCK, UPDLOCK)
	SET b.actualrate = t.actualrate,
		b.virtualrate = t.virtualrate
	FROM @__table t 
		INNER JOIN dbo.BettransRNG b ON t.transid = b.transid 

	WAITFOR DELAY '000:00:02'
END

DROP TABLE #BettransRNG