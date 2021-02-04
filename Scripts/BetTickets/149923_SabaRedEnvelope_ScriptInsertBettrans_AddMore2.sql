/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210203@Sophia
	DB : DBTXN-bodb02
	Task: Insert bet ticket SabaRedEnvelope - bettype 17004 - add more acc test of Credit & deposit [Redmine: #149923]
*/

 
------------- Credit------------- 	
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
	VALUES  
			(22038202),
			(28174431),
			(23557384),
			(23994603),
			(33601274),
			(28205847),
			(26383555),
			(23003440),
			(23003452),
			(23003459),
			(23003473),
			(32949948),
			(27994298),
			(28601255),
			(28601397),
			(37208731),
			(37208758),
			(37208806),
			(27182103),
			(27531700),
			(29328553),
			(29650988)


	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID FROM #CustList WHERE ID = @i

			EXEC Dot_Dep_BettransIns_SabaRedEnvelope
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= 100
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
			  
			  SELECT  @TransID AS TransID, @TransDate AS TransDate, @RefNo AS RefNo, @Balance AS Balance, @ErrCode AS ErrCode, @ErrMsg AS ErrMsg

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
				, @CustID INT
				, @i INT = 1
				, @Max INT

	CREATE TABLE #CustList ( ID INT IDENTITY(1,1), CustID INT)
	INSERT INTO #CustList 
	VALUES  (48051231),
			(48051232),
			(48051234)
	
	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID FROM #CustList WHERE ID = @i

			EXEC Dot_Dep_BettransIns_SabaRedEnvelope
				@CustID			= @CustID
				, @ExtraInfo	= NULL
				, @Amount		= 100
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
			  
			  SELECT  @TransID AS TransID, @TransDate AS TransDate, @RefNo AS RefNo, @Balance AS Balance, @ErrCode AS ErrCode, @ErrMsg AS ErrMsg

			  SELECT @i = @i + 1
		END
	DROP TABLE #CustList
	
	GO
	
	