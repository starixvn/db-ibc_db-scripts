/*<info serverAlias="DBGRP02L-bodb02"></info>*/
/*
	Created: 20221123@Danny
	DB : DBGRP02L-bodb02
	Task: Insert bet ticket Saba Promotion - bettype 17005 - Extra discount WC 2022 [Redmine: #180710]
*/
USE bodb02
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
				, @CustID 		INT
				, @Amount 		MONEY
				, @i 			INT = 1
				, @Max 			INT

	-- Insert Licensee (SiteDBGroupID = 2)				
	CREATE TABLE #CustList ( ID INT IDENTITY(1,1), CustID INT, Amount MONEY)
	/*
	 --Example
	 INSERT INTO #CustList (CustID, Amount) 
	 VALUES   (33257253, 815.02) -- 18Luck
			,(38339001, 21842.24) -- 24AVIA
			,(37974158, 49417.15) -- 365online
			,(48317377, 21.08) -- 3ge888
			,(46774766, 11361) -- 7kplatform

	*/
	

	SELECT @Max = MAX(ID) FROM #CustList
	WHILE @i <= @Max
	BEGIN 
			SELECT @CustID = CustID , @Amount = Amount FROM #CustList WHERE ID = @i
			
 
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
				, @TransDesc	= 'Extra 10% discount for WC 2022'
				, @IP			= ''
				, @Creator		= 10278938  ---starixIT  
				, @Winlostdate  = '2022-11-30'
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
