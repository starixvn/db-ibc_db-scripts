/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210726@Sophia
	DB : DBTXN-bodb02
	Task: Update Amount on bettrans for SabaPromotion - bettype 17005 [Redmine: #155337]
*/ 

	DECLARE @LogInfo VARCHAR(1000) 

	----AB88Dummy3rdRMB - 52017417

	UPDATE 	Bettrans WITH (ROWLOCK)
	SET 	aWinlost = 279024.90
	WHERE 	TransID = 112713451530
	
	SELECT @LogInfo = 'Update Saba Promotion Amount - CustID: 52017417, bettype:17005, New Amount: 279024.90, Old Amount:200000.00, transid:112713451530;, creatorid:10278938'
	EXEC dbo.WriteLog_UserLog @UserID = 52017417, @Doing = @LogInfo



	----TLCDummy3rdRMB - 52017508
	UPDATE 	Bettrans WITH (ROWLOCK)
	SET 	aWinlost = 56450
	WHERE 	TransID = 112713451537
	
		
 	SELECT @LogInfo = 'Update Saba Promotion Amount - CustID: 52017508, bettype:17005, New Amount:56450.00 , Old Amount:75000.00, transid:112713451537;, creatorid:10278938'
	EXEC dbo.WriteLog_UserLog @UserID = 52017508, @Doing = @LogInfo


			
	------Select 
		
	 SELECT  * FROM  Bettrans (NOLOCK)
	 WHERE TransID  IN (112713451530, 112713451537)
 		   
 
	GO