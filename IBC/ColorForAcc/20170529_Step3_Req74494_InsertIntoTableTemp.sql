
/*
	Created: Winnie	
	Task:  Insert into table temp on db052
	DB:DB052/bodb02
	Date: 20170523
	1.ActionID
		--ActionID=1149: Admin update closed on NAP-CM
		--ActionID=1105: Update closed on NAP,ALpha,EXT-NAP
		--ActionID=918: Account was closed because of failed Security Code over 5 times
		--ActionID=931: Account was closed because of failed OTP over 5 times
	2.ClosedReason
	
    If the field = 1, show purple (RGB(179,162,199)) high lighted username. On mouse over, show tooltip with text text "This account was closed by admin."
     
    If the field = 2, show orange (RGB(247,150,70)) high lighted username. On mouse over, show tooltip with text text "This account was closed by upline."
     
    If the field = 3, show blue (RGB(134,197,228)) high lighted username. On mouse over, show tooltip with text text "This account was closed by false input of OTP/Security Code."
     
    If the field = 0 (Input wrong password, archiving process, etc.), show grey (current color) high lighted username. On mouse over, show tooltip with text text "This account was closed by failed login or account expired."

*/ 
		--select max(logdate) from bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)
		DECLARE @maxcustid INT,@maxLogDate DATETIME
		SET @maxLogDate=xxx

		TRUNCATE TABLE TempClosedReason
		TRUNCATE TABLE TempClosedReasonMember
		
		INSERT INTO TempClosedReason (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid between 2 and 4 AND Enabled=1

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		select custid,0 from Custinfo(nolock) where closed=1 and roleid=1 AND Enabled=1

		-- update logid
		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReason t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)
		
		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReasonMember t 
			CROSS APPLY (SELECT MAX(logdate) logdate
			FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			WHERE logdate<=@maxLogDate AND u.CustID=t.CustID AND u.ActionID IN (1105,1149,918,931) 
			) AS a (Logdate)


		-- update closed reason for member
		DECLARE  @MinCustMem INT = 0, @MaxCustMem INT = 0, @CrrCustMem INT
		
		DECLARE @logdateMem DATETIME
		DECLARE @TrackingValueMem NVARCHAR(MAX), @ActionIDMem INT,@RoleIDMem INT

		SELECT @MinCustMem =  MIN(Custid) FROM TempClosedReasonMember WHERE LogDate is not null
		SELECT @MaxCustMem =  MAX(Custid) FROM TempClosedReasonMember WHERE LogDate is not null

		WHILE (@MinCustMem <= @MaxCustMem)
		BEGIN					
	
			SELECT TOP 1 @logdateMem=logdate,@CrrCustMem=Custid FROM TempClosedReasonMember WHERE CustID>=@MinCustMem AND LogDate is not null

			SELECT @ActionIDMem=u.ActionID,@RoleIDMem=c.roleid,@TrackingValueMem=u.TrackingValue
			FROM	bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE   u.logdate=@logdateMem AND u.custid=@CrrCustMem

			UPDATE t SET t.ClosedReason= CASE	WHEN @ActionIDMem= 1105 AND  @TrackingValueMem like '%Closed="1"%' AND @RoleIDMem < 5 THEN 1 
												WHEN @ActionIDMem = 1105 AND @TrackingValueMem like '%Closed="1"%' AND @RoleIDMem >= 5 THEN 2
												WHEN @ActionIDMem = 1149 AND @TrackingValueMem like '%Closed="1"%' THEN 2
												WHEN @ActionIDMem IN(918,931) THEN 3
												ELSE 0 END	
			FROM TempClosedReasonMember t 
			WHERE CustID=@CrrCustMem	

			SELECT @MinCustMem=@CrrCustMem+1	

		END
		
		

		----update ClosedReason for SMA
		DECLARE  @MinCustSMA INT = 0, @MaxCustSMA INT = 0, @CrrCustSMA INT
		
		DECLARE @logdateSMA DATETIME
		DECLARE @TrackingValueSMA NVARCHAR(MAX), @ActionIDSMA INT,@RoleIDSMA INT

		SELECT @MinCustSMA =  MIN(Custid) FROM TempClosedReason WHERE LogDate is not null
		SELECT @MaxCustSMA =  MAX(Custid) FROM TempClosedReason WHERE LogDate is not null

		WHILE (@MinCustSMA <= @MaxCustSMA)
		BEGIN					
	
			SELECT TOP 1 @logdateSMA=logdate,@CrrCustSMA=Custid FROM TempClosedReason WHERE CustID>=@MinCustSMA AND LogDate is not null

			SELECT @ActionIDSMA=u.ActionID,@RoleIDSMA=c.roleid,@TrackingValueSMA=u.TrackingValue
			FROM	bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
			INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE   u.logdate=@logdateSMA AND u.custid=@CrrCustSMA

			UPDATE t SET t.ClosedReason= CASE	WHEN @ActionIDSMA= 1105 AND  @TrackingValueSMA like '%Closed="1"%' AND @RoleIDSMA < 5 THEN 1 
												WHEN @ActionIDSMA = 1105 AND @TrackingValueSMA like '%Closed="1"%' AND @RoleIDSMA >= 5 THEN 2
												WHEN @ActionIDSMA = 1149 AND @TrackingValueSMA like '%Closed="1"%' THEN 2
												WHEN @ActionIDSMA IN(918,931) THEN 3
												ELSE 0 END	
			FROM TempClosedReason t 
			WHERE CustID=@CrrCustSMA

			SELECT @MinCustSMA=@CrrCustSMA+1	

		END
		
