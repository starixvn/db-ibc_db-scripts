
/*
	Created: Winnie	
	Task:  Insert into table temp on db052. RedmineID : #80013
	DB:DB052/bodb02
	Date: 20170717
	1.ActionID	
		--ActionID=1105: Update closed on NAP,ALpha,EXT-NAP	
	2.ClosedReason     
    If the field = 2, show orange (RGB(247,150,70)) high lighted username. On mouse over, show tooltip with text text "This account was closed by upline."   
  

*/ 
		
		DECLARE @maxcustid INT,	@maxLogDate DATETIME
		SET @maxLogDate	=xxx -- SELECT MAX (logdate) FROM UserLog_RunSP WITH(NOLOCK)

		CREATE TABLE #tempUser (UserID INT PRIMARY KEY)

		INSERT INTO #tempUser(UserID)
		SELECT u.userid  
		FROM bodb_EAS.dbo.eaUserInfo u WITH (NOLOCK)
				INNER JOIN bodb_EAS.dbo.eaGroup g WITH (NOLOCK) ON g.GroupID=u.GroupID
		WHERE g.GroupName NOT IN ('IT','Finance','ACCUUS','Test Group')

		TRUNCATE TABLE TempClosedReason
		TRUNCATE TABLE TempClosedReasonMember
		
		INSERT INTO TempClosedReason (CustID,ClosedReason)
		SELECT c.custid,1
		FROM Custinfo c WITH(NOLOCK)
			INNER JOIN DBCUST.CUSTDB.dbo.CustLoginInfo  cl WITH(NOLOCK) ON c.custid=cl.CustID
		WHERE closed=1 	AND roleid BETWEEN 2 AND 4 AND Enabled=1 AND cl.ClosedReason=1

		INSERT INTO TempClosedReasonMember (CustID,ClosedReason)
		SELECT	c.custid,1
		FROM Custinfo c WITH(NOLOCK) 
			INNER JOIN DBCUST.CUSTDB.dbo.CustLoginInfo_Member  cl WITH(NOLOCK) ON c.custid=cl.CustID
		WHERE closed=1 AND roleid=1 AND Enabled=1 AND cl.ClosedReason=1

		-- update logid
		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReason t 
			CROSS APPLY (	SELECT MAX(logdate) logdate
							FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
							WHERE logdate<=@maxLogDate AND  u.CustID=t.CustID AND u.ActionID IN (1105,1149) 
			) AS a (Logdate)
		

		UPDATE t 
		SET Logdate= a.Logdate
		FROM TempClosedReasonMember t 
			CROSS APPLY (	SELECT MAX(logdate) logdate
							FROM bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK) 
							WHERE logdate<=@maxLogDate AND u.CustID=t.CustID AND u.ActionID IN (1105,1149) 
			) AS a (Logdate)

	
		----update ClosedReason Member
		DECLARE  @MinDateMem DATETIME = 0, @MaxDateMem DATETIME = 0, @CrrDateMem DATETIME		
		SELECT @MinDateMem = CONVERT(DATE,MIN(Logdate)) 	
		FROM TempClosedReasonMember WITH(NOLOCK) 
				
		SELECT @MaxDateMem = MAX(Logdate) 	
		FROM TempClosedReasonMember WITH(NOLOCK) 		
		
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
		
			UPDATE t SET t.ClosedReason= 2									 
			FROM TempClosedReasonMember t 
				INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
				INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE  t.logdate >= @MinDateMem 
				AND t.logdate< @CrrDateMem	
				AND u.ActionID=1105 
				AND  u.TrackingValue like '%Closed="1"%' 
				AND c.roleid >= 5 
				AND u.userid IN (SELECT userid FROM #tempUser)

			SELECT @MinDateMem=@CrrDateMem
			IF @MinDateMem=@MaxDateMem
				SET @MinDateMem=@MaxDateMem+1
		END

		----update ClosedReason SMA
		DECLARE  @MinDateSMA DATETIME = 0, @MaxDateSMA DATETIME = 0, @CrrDateSMA DATETIME		

		SELECT @MinDateSMA =  CONVERT(DATE,MIN(Logdate)) 	
		FROM TempClosedReason WITH(NOLOCK) 

		SELECT @MaxDateSMA =  MAX(Logdate)	
		FROM TempClosedReason WITH(NOLOCK) 			

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

			UPDATE t SET t.ClosedReason= 2									 
			FROM TempClosedReason t 
				INNER JOIN bodb_CustomerLog.dbo.[UserLog_RunSP] u WITH(NOLOCK)  ON t.LogDate=u.LogDate AND t.CustID=u.custid
				INNER JOIN Customer c WITH(NOLOCK) ON u.userid=c.custid
			WHERE t.logdate >= @MinDateSMA	
				AND t.logdate< @CrrDateSMA	
				AND u.ActionID=1105 
				AND  u.TrackingValue like '%Closed="1"%' 
				AND c.roleid >= 5 
				AND u.userid IN (SELECT userid FROM #tempUser)

			SELECT @MinDateSMA=@CrrDateSMA	
			IF @MinDateSMA=@MaxDateSMA
				SET @MinDateSMA=@MaxDateSMA+1
		END