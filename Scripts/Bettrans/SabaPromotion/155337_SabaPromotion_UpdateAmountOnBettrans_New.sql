/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210727@Sophia
	DB : DBTXN-bodb02
	Task: Update Amount on bettrans for SabaPromotion - bettype 17005- New [Redmine: #155337]
*/ 

	DECLARE @LogInfo VARCHAR(1000) 

	----W88Dummy3rdRMB - 52017541

	UPDATE 	Bettrans WITH (ROWLOCK)
	SET 	aWinlost = 230000.00
	WHERE 	TransID = 112713451529
	
	SELECT @LogInfo = 'Update Saba Promotion Amount - CustID: 52017541, bettype:17005, New Amount: 230000.00, Old Amount:200000.00, transid:112713451529;, creatorid:10278938'
	EXEC dbo.WriteLog_UserLog @UserID = 52017541, @Doing = @LogInfo

 
			
	------Select 
		
	 SELECT  * FROM  Bettrans (NOLOCK)
	 WHERE TransID  IN (112713451529 )
 		   
 
	GO