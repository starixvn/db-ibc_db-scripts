 /*<info serverAlias="DBTXN-bodb02"></info>*/
 /*
	Creator: 20230218@Sophia
 	DB: DBTXN/bodb02
 	Task : Update rates for bettrans table due to Parlay [redmine: #184059]
 	 
	
*/	
			DECLARE @Winlostdate SMALLDATETIME = '20230217'
			CREATE TABLE #bettrans (transid BIGINT, actualrate FLOAT, virtualrate FLOAT, old_actualrate FLOAT)

	
		-- update for SB's tickets (using virtualrate)
			INSERT INTO #bettrans(transid, actualrate, virtualrate, old_actualrate)
			SELECT transid, e.actualrate, e.actualrate*(b.virtualrate/b.actualrate) AS virtualrate, b.actualrate
			FROM dbo.bettrans b WITH(NOLOCK) 
				INNER JOIN CustDB.dbo.ExchangeDailyOanda e WITH (NOLOCK) ON b.currency = e.exchangeid and e.ExchangeDate = @Winlostdate
			WHERE b.actualrate <> e.actualrate AND b.winlostdate = @Winlostdate 
				AND (b.bettype <= 30 OR b.bettype BETWEEN 50 AND 19998) AND b.actualrate <> b.virtualrate
			 
			-- update for SB's tickets (without virtualrate)
			INSERT INTO #bettrans(transid, actualrate, virtualrate, old_actualrate)
			SELECT transid, e.actualrate, e.actualrate, b.actualrate 
			FROM dbo.bettrans b WITH(NOLOCK) 
				,CustDB.dbo.ExchangeDailyOanda e WITH (NOLOCK) 
			WHERE b.currency = e.exchangeid AND b.actualrate <> e.actualrate 
				AND e.ExchangeDate = @Winlostdate
				AND b.winlostdate = @Winlostdate AND (b.bettype <= 30 OR b.bettype BETWEEN 50 AND 19998) 
				AND b.actualrate = b.virtualrate

			INSERT INTO #bettrans(transid, actualrate, virtualrate, old_actualrate)
			SELECT transid, e.actualrate, e.actualrate, b.actualrate 
			FROM dbo.bettrans b WITH(NOLOCK) 
				,CustDB.dbo.ExchangeDailyOanda e WITH (NOLOCK)
			WHERE b.currency = e.exchangeid AND b.actualrate <> e.actualrate 
				AND e.ExchangeDate = @Winlostdate
				AND b.winlostdate = @Winlostdate AND b.bettype BETWEEN 31 AND 49 
				AND b.actualrate = b.virtualrate AND b.currency2 IS NULL

			--==	
			INSERT INTO #bettrans(transid, actualrate, virtualrate, old_actualrate)
			SELECT transid, e.actualrate, b.virtualrate, b.actualrate
			FROM dbo.bettrans b WITH(NOLOCK) 
				,CustDB.dbo.ExchangeDailyOanda e WITH (NOLOCK)
			WHERE b.currency = e.exchangeid AND b.actualrate <> e.actualrate 
				AND  e.ExchangeDate = @Winlostdate
				AND b.winlostdate = @Winlostdate AND b.bettype BETWEEN 31 AND 49 AND b.currency2 IS NOT NULL
				
		
			DECLARE @__table TABLE (transid BIGINT, actualrate FLOAT, virtualrate FLOAT)
			DECLARE @rowcount INT = 1
	
	
			SET @rowcount = 1 
			WHILE @rowcount <> 0
			BEGIN
				DELETE FROM @__table
			
				DELETE TOP(500) FROM #bettrans 
				OUTPUT deleted.transid, deleted.actualrate, deleted.virtualrate into @__table
				SET @rowcount = @@ROWCOUNT
			
				UPDATE b WITH(ROWLOCK, UPDLOCK)
				SET b.actualrate = t.actualrate,
					b.virtualrate = t.virtualrate
				FROM @__table t 
					INNER JOIN dbo.bettrans b ON t.transid = b.transid 

				WAITFOR DELAY '000:00:02'
			END
			
	 
		 	DROP TABLE #bettrans
