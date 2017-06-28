
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
		SELECT custid,0 FROM Custinfo(NOLOCK) WHERE closed=1 and roleid between 2 and 4 AND Enabled=1

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		SELECT custid,0 FROM Custinfo(NOLOCK) WHERE closed=1 and roleid=1 AND Enabled=1

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

	
		----update ClosedReason Member
		DECLARE  @MinDateMem DATETIME = 0, @MaxDateMem DATETIME = 0, @CrrDateMem DATETIME		
		SELECT @MinDateMem = CONVERT(DATE,MIN(Logdate)) 	FROM TempClosedReasonMember WITH(NOLOCK) 		
		SELECT @MaxDateMem = MAX(Logdate) 	FROM TempClosedReasonMember WITH(NOLOCK) 		
		
		WHILE (@MinDateMem <= @MaxDateMem)
		BEGIN		
			
			SELECT @CrrDateMem = @MinDateMem+5
			IF MONTH(@CrrDateMem)<>MONTH(@MinDateMem)
			BEGIN
				SELECT @CrrDateMem= DATEADD(MONTH, DATEDIFF(MONTH, 0, @CrrDateMem), 0) 
			END

			DECLARE @strMindate VARCHAR(50),@strcrrDate  VARCHAR(50)
			SELECT @strMindate= CAST(@MinDateMem AS VARCHAR(50))
			SELECT @strcrrDate= CAST(@CrrDateMem AS VARCHAR(50))		
			
			RAISERROR ('@MinDateMem', 0, 1) WITH NOWAIT
			RAISERROR (@strMindate, 0, 1) WITH NOWAIT
			RAISERROR ('@CrrDateMem', 0, 1) WITH NOWAIT
			RAISERROR (@strcrrDate, 0, 1) WITH NOWAIT
		
			UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 1 
												WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 2
												WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
												WHEN u.ActionID IN(918,931) THEN 3
												ELSE 0 END										 
			FROM TempClosedReasonMember t 
			INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
			INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE  t.logdate >= @MinDateMem AND t.logdate< @CrrDateMem	

			SELECT @MinDateMem=@CrrDateMem
			IF @MinDateMem=@MaxDateMem
				SET @MinDateMem=@MaxDateMem+1
		END

		----update ClosedReason SMA
		DECLARE  @MinDateSMA DATETIME = 0, @MaxDateSMA DATETIME = 0, @CrrDateSMA DATETIME		
		SELECT @MinDateSMA =  CONVERT(DATE,MIN(Logdate)) 	FROM TempClosedReason WITH(NOLOCK) 
		SELECT @MaxDateSMA =  MAX(Logdate)	FROM TempClosedReason WITH(NOLOCK) 			
		WHILE (@MinDateSMA <= @MaxDateSMA)
		BEGIN		
			
			SELECT @CrrDateSMA = @MinDateSMA+5		
			IF MONTH(@CrrDateSMA)<>MONTH(@MinDateSMA)
			BEGIN
				SELECT @CrrDateSMA= DATEADD(month, DATEDIFF(month, 0, @CrrDateSMA), 0) 
			END
			DECLARE @strMindateSMA VARCHAR(50),@strcrrDateSMA  VARCHAR(50)
			SELECT @strMindateSMA= CAST(@MinDateSMA AS VARCHAR(50))
			SELECT @strcrrDateSMA= CAST(@CrrDateSMA AS VARCHAR(50))		
			
			RAISERROR ('@MinDateSMA', 0, 1) WITH NOWAIT
			RAISERROR (@strMindateSMA, 0, 1) WITH NOWAIT
			RAISERROR ('@CrrDateSMA', 0, 1) WITH NOWAIT
			RAISERROR (@strcrrDateSMA, 0, 1) WITH NOWAIT
		
			UPDATE t SET t.ClosedReason= CASE	WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid >= 5 THEN 1 
												WHEN u.ActionID = 1105 AND u.TrackingValue like '%Closed="1"%' AND c.roleid < 5 THEN 2
												WHEN u.ActionID = 1149 AND u.TrackingValue like '%Closed="1"%' THEN 2
												WHEN u.ActionID IN(918,931) THEN 3
												ELSE 0 END													 
			FROM TempClosedReason t 
			INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
			INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE  t.logdate >= @MinDateSMA AND t.logdate< @CrrDateSMA	

			SELECT @MinDateSMA=@CrrDateSMA	
			IF @MinDateSMA=@MaxDateSMA
				SET @MinDateSMA=@MaxDateSMA+1
		END