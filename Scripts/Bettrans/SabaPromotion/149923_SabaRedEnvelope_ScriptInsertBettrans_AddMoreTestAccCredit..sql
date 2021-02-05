/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210209@Sophia
	DB : DBTXN-bodb02
	Task: Insert SabaRedEnvelope - bettype 17004 - Real acc Credit [Redmine: #149923]
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
		VALUES (1,19096713,100),
				(2,19096700,100),
				(3,36962408,100),
				(4,43100097,100),
				(5,14242912,100),
				(6,14242913,100),
				(7,14242914,100),
				(8,14242917,100),
				(9,41937183,100),
				(10,47319070,100),
				(11,26883473,100)	 
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
 