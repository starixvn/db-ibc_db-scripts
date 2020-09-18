/*<info serverAlias="DBSUM-bodb_Summary" step="2"></info>*/
/*
	Create: 20200910@Malcolm
	DB : DBSUM-bodb_Summary
	Task: Copy Data from Sum_Winloss_Old_Tmp to sum_winloss_old [redmine: #139575]
*/

USE bodb_Summary
GO

 
DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE, @CustId INT

SELECT
	@FromDate = '20200831'
   ,@Todate = '20200910'

SELECT @WinlostDate = @FromDate

SELECT winlostdate
			,username
			,custid
			,roleid
			,recommend
			,mrecommend
			,srecommend
			,turnover
			,winlost
			,awinlost
			,mwinlost
			,swinlost
			,playercomm
			,comm
			,acomm
			,scomm
			,BetCount
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw
			,ExtraWinloss
			,ExtraComm
INTO #tmp 
FROM  DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp t 
WHERE 1 = 2 


WHILE (@WinlostDate <= @Todate)
BEGIN

	DELETE #tmp
	
	INSERT INTO #tmp
	SELECT 
			winlostdate
			,username
			,custid
			,roleid
			,recommend
			,mrecommend
			,srecommend
			,turnover
			,winlost
			,awinlost
			,mwinlost
			,swinlost
			,playercomm
			,comm
			,acomm
			,scomm
			,BetCount
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw
			,ExtraWinloss
			,ExtraComm
		FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp t
		WHERE t.winlostdate = @WinlostDate
 
		
		DELETE s
		FROM dbo.sum_winloss_old s WITH(ROWLOCK) 
		INNER JOIN #tmp t ON t.WinlostDate = s.WinlostDate and t.CustID = s.CustID AND t.Sporttype = s.Sporttype
		WHERE s.winlostdate = @WinlostDate		
			AND s.sporttype = 248

		INSERT INTO dbo.sum_winloss_old
		(
			winlostdate
			,username
			,custid
			,roleid
			,recommend
			,mrecommend
			,srecommend
			,turnover
			,winlost
			,awinlost
			,mwinlost
			,swinlost
			,playercomm
			,comm
			,acomm
			,scomm
			,BetCount
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw
			,ExtraWinloss
			,ExtraComm
		)
		SELECT 
			winlostdate
			,username
			,custid
			,roleid
			,recommend
			,mrecommend
			,srecommend
			,turnover
			,winlost
			,awinlost
			,mwinlost
			,swinlost
			,playercomm
			,comm
			,acomm
			,scomm
			,BetCount
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw
			,ExtraWinloss
			,ExtraComm
		FROM #tmp  

	  

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END
 