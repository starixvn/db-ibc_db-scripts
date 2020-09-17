/*<info serverAlias="DBSUM-bodb_Summary" step="2"></info>*/
/*
	Create: 20200910@Malcolm
	DB : DBSUM-bodb_Summary
	Task: re-generate data for sum_winloss_old [redmine: #139575]
*/

USE bodb_Summary
GO

DECLARE @MoveBetsDay SMALLDATETIME, @BalanceUpDay SMALLDATETIME		
DECLARE @MoveBetAndBalanceUp TABLE( MoveBetsDay SMALLDATETIME, BalanceUpDay SMALLDATETIME)

INSERT INTO @MoveBetAndBalanceUp (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay

SELECT @MoveBetsDay = MoveBetsDay, @BalanceUpDay = BalanceUpDay
FROM @MoveBetAndBalanceUp

CREATE TABLE #CustId (CustId INT)

DECLARE cursor_custId CURSOR FOR SELECT CustId FROM #CustId

DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE, @CustId INT

SELECT
	@FromDate = '20200831'
   ,@Todate = '20200911'

SELECT @WinlostDate = @FromDate

WHILE (@WinlostDate <= @Todate)
BEGIN

	DELETE FROM #CustId

	INSERT INTO #CustId(CustId)
	SELECT DISTINCT s.custid
	FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp s WITH (NOLOCK)
	WHERE s.winlostdate = @WinlostDate 

	OPEN cursor_custId 
	FETCH NEXT FROM cursor_custId INTO @custId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DELETE s
		FROM dbo.sum_winloss_old s WITH(ROWLOCK, UPDLOCK)
		WHERE s.winlostdate = @WinlostDate
			AND s.custid = @CustId
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
		FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp t
		WHERE t.winlostdate = @WinlostDate
			AND t.CustId = @CustId

		FETCH NEXT FROM cursor_custId INTO @custId

	END

	CLOSE cursor_custId

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END

DEALLOCATE cursor_custId
DROP TABLE #CustId
GO