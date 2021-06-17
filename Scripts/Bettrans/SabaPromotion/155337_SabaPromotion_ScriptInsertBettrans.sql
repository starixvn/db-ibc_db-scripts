/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210617@Sophia
	DB : DBTXN-bodb02
	Task: Insert bet ticket SabaPromotion - bettype 17005 [Redmine: #155337]
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
				, @CustID INT
				, @i INT = 1
				, @Max INT

	CREATE TABLE #CustList ( ID INT IDENTITY(1,1), CustID INT)
	INSERT INTO #CustList 
	VALUES  (18178436),
			(52017417),
			(52017465),
			(52017508),
			(52017541),
			(52017588),
			(31607896),
			(32951624),
			(33257253),
			(36351352),
			(49802202)
	
	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID FROM #CustList WHERE ID = @i

			EXEC Dot_Dep_BettransIns_SabaPromotion
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= 100			
				, @Bettype		= 17005
				, @sporttype	= 246	
				, @Betfrom		= 'd'
				, @TransDesc	= 'EC2020 Promotion - Licensee income'
				, @IP			= ''
				, @Creator		= NULL  
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