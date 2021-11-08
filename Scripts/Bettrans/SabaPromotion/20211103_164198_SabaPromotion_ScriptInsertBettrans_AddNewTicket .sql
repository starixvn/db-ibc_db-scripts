/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20211103@Sophia
	DB : DBTXN-bodb02
	Task: Insert bet ticket SabaPromotion - bettype 17005 - e8casino in Oct and nov [Redmine: #164198]
*/

 
----------------------------------------
----------- Deposit------------- 	
	DECLARE 
				 @TransID 		BIGINT		 
				, @TransDate	DATETIME 
				, @RefNo 		BIGINT	 
				, @Balance      MONEY	 
				, @ErrCode 		INT		 
				, @ErrMsg 		NVARCHAR(200) 
				, @CustID 		INT
				, @Amount 		MONEY
				, @i 			INT = 1
				, @Max 			INT

	CREATE TABLE #CustList ( ID INT IDENTITY(1,1), CustID INT, Amount MONEY)
	INSERT INTO #CustList (CustID, Amount) 
	VALUES  (27462608,15000)
		 
	
	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID , @Amount = Amount FROM #CustList WHERE ID = @i
			
			-------------------------- October ------------------------
			SELECT @TransID = NULL
				, @TransDate = NULL
				, @RefNo 	 = NULL
				, @Balance   = NULL
				, @ErrCode 	 = NULL
				, @ErrMsg 	 = NULL
				
			EXEC Dot_Dep_BettransIns_SabaPromotion
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= @Amount			
				, @Bettype		= 17005
				, @sporttype	= 246	
				, @Betfrom		= 'd'
				, @TransDesc	= 'Promote e8casino Oct 2021 RMB 15,000'
				, @IP			= ''
				, @Creator		= 10278938  ---starixIT  
				, @Winlostdate  = '2021-10-31'
				------------------------------------------
				, @TransID 		= @TransID OUTPUT
				, @TransDate	= @TransDate OUTPUT
				, @RefNo 		= @RefNo OUTPUT
				, @Balance      = @Balance OUTPUT
				, @ErrCode 		= @ErrCode OUTPUT
				, @ErrMsg 		= @ErrMsg OUTPUT
			  
			  SELECT  @TransID AS TransID, @TransDate AS TransDate, @RefNo AS RefNo, @Balance AS Balance, @ErrCode AS ErrCode, @ErrMsg AS ErrMsg
			  
			  
			  ------------------------ November------------------------
			  SELECT @TransID = NULL
				, @TransDate = NULL
				, @RefNo 	 = NULL
				, @Balance   = NULL
				, @ErrCode 	 = NULL
				, @ErrMsg 	 = NULL
				
			EXEC Dot_Dep_BettransIns_SabaPromotion
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= @Amount			
				, @Bettype		= 17005
				, @sporttype	= 246	
				, @Betfrom		= 'd'
				, @TransDesc	= 'Promote e8casino Nov 2021 RMB 15,000'
				, @IP			= ''
				, @Creator		= 10278938  ---starixIT  
				, @Winlostdate  = '2021-11-03'
				------------------------------------------
				, @TransID 		= @TransID OUTPUT
				, @TransDate	= @TransDate OUTPUT
				, @RefNo 		= @RefNo OUTPUT
				, @Balance      = @Balance OUTPUT
				, @ErrCode 		= @ErrCode OUTPUT
				, @ErrMsg 		= @ErrMsg OUTPUT
			  
			  SELECT  @TransID AS TransID, @TransDate AS TransDate, @RefNo AS RefNo, @Balance AS Balance, @ErrCode AS ErrCode, @ErrMsg AS ErrMsg
			 
			  
			  

			  SELECT @i = @i + 1
	END
	DROP TABLE #CustList
	
	GO
	
	GO