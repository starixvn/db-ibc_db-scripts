/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210208@Sophia
	DB : DBTXN-bodb02
	Task: Insert SabaRedEnvelope - bettype 17004 - test [Redmine: #149923]
*/


------------- Credit------------- 	
	DECLARE 
				 @TransID 		BIGINT		 
				, @TransDate	DATETIME 
				, @RefNo 		BIGINT	 
				, @Balance      MONEY	 
				, @ErrCode 		INT		 
				, @ErrMsg 		NVARCHAR(200) 
				, @LogInfo		NVARCHAR(MAX)
				, @CustID		INT
				, @i			INT = 1
				, @Max			INT
				, @Amount		MONEY
				, @LogDate		VARCHAR(50)

	SELECT * 
	INTO #Custlist
	FROM 
	(
			VALUES (1,22644318,888),
				(2,14242644,888),
				(3,14242618,888),
				(4,47319049,888),
				(5,47319055,888),
				(6,44410723,888),
				(7,14242620,888),
				(8,43439758,888),
				(9,43439767,888),
				(10,17104991,888),
				(11,14242436,888),
				(12,14307823,888),
				(13,29524723,888),
				(14,14242444,888),
				(15,43439746,888),
				(16,46359797,888),
				(17,46359832,888),
				(18,46359835,888),
				(19,14242815,888),
				(20,14242821,888),
				(21,19096713,888),
				(22,19096700,888),
				(23,36962408,888),
				(24,43100097,888),
				(25,14242912,888),
				(26,14242913,888),
				(27,14242914,888),
				(28,14242917,888),
				(29,41937183,888),
				(30,47319070,888),
				(31,26883473,888) 
	) as t(ID, CustID, Amount) 

	SELECT Count (1) FROM #CustList
		 
	
	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID, @Amount = Amount FROM #CustList WHERE ID = @i

			EXEC Dot_Dep_BettransIns_SabaRedEnvelope
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= @Amount
				, @Bettype		= 17004
				, @Betfrom		= 'i'   --- 'i' for credit , 'd' for deposit
				, @TransDesc	= ''
				, @Total		= NULL
				, @TransID2		= NULL
				, @IP			= ''
				, @Creator		= 10278938  ---starixIT
				, @Ugroup		= ''
				, @Site			= ''
				------------------------------------------
				, @TransID 		= @TransID OUTPUT
				, @TransDate	= @TransDate OUTPUT
				, @RefNo 		= @RefNo OUTPUT
				, @Balance      = @Balance OUTPUT
				, @ErrCode 		= @ErrCode OUTPUT
				, @ErrMsg 		= @ErrMsg OUTPUT
				, @LogInfo		= @LogInfo OUTPUT
			  
			  ---PRINT @LogInfo + CONVERT(VARCHAR(10),ISNULL(@ErrCode, 0) )  + ISNULL( @ErrMsg, '') 
			  
			 SELECT  @LogDate = CONVERT(VARCHAR(50),GetDate(), 121)
			 RAISERROR ('CustID: %d - at: %s', 0, 1, @Custid,@LogDate) WITH NOWAIT



			  IF @i%1000 = 0 
			  BEGIN 
					WAITFOR DELAY '00:00:01'
			  END
			  
			  SELECT @i = @i + 1
			  
		END
	DROP TABLE #CustList
	
	GO
  
 
----------------------------------------
----------- Deposit------------- 	
	DECLARE 
				 @TransID 		BIGINT		 
				, @TransDate	DATETIME 
				, @RefNo 		BIGINT	 
				, @Balance      MONEY	 
				, @ErrCode 		INT		 
				, @ErrMsg 		NVARCHAR(200) 
				, @LogInfo		NVARCHAR(MAX)
				, @CustID		INT
				, @i			INT = 1
				, @Max			INT
				, @Amount		MONEY
				, @LogDate		VARCHAR(50)

		SELECT * 
		INTO #Custlist
		FROM (VALUES
				(1,29253535,888),
				(2,29253690,888),
				(3,33343517,888),
				(4,36662879,888),
				(5,45666571,888),
				(6,46433331,888),
				(7,46533937,888),
				(8,47178574,888)
		)
		as t(ID, CustID, Amount) 

		SELECT Count (1) FROM #CustList
	
	
	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID, @Amount = Amount FROM #CustList WHERE ID = @i

			EXEC Dot_Dep_BettransIns_SabaRedEnvelope
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= @Amount
				, @Bettype		= 17004
				, @Betfrom		= 'd'   --- 'i' for credit , 'd' for deposit
				, @TransDesc	= ''
				, @Total		= NULL
				, @TransID2		= NULL
				, @IP			= ''
				, @Creator		= 10278938  ---starixIT
				, @Ugroup		= ''
				, @Site			= ''
				------------------------------------------
				, @TransID 		= @TransID OUTPUT
				, @TransDate	= @TransDate OUTPUT
				, @RefNo 		= @RefNo OUTPUT
				, @Balance      = @Balance OUTPUT
				, @ErrCode 		= @ErrCode OUTPUT
				, @ErrMsg 		= @ErrMsg OUTPUT
				, @LogInfo		= @LogInfo OUTPUT		  
			  
			 
			  -- PRINT @LogInfo + CONVERT(VARCHAR(10),ISNULL(@ErrCode, 0) )  + ISNULL( @ErrMsg, '')
			  
			  SELECT  @LogDate = CONVERT(VARCHAR(50),GetDate(), 121)
			  RAISERROR ('CustID: %d - at: %s', 0, 1, @Custid,@LogDate) WITH NOWAIT	  

			  IF @i%1000 = 0 
			  BEGIN 
					WAITFOR DELAY '00:00:01'
			  END
			  
			  SELECT @i = @i + 1
		END
	DROP TABLE #CustList
	
	GO 