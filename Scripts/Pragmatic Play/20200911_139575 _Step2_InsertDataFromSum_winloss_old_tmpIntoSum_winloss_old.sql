/*<info serverAlias="DBSUM-bodb_Summary" step="2"></info>*/
/*
	Create: 20200910@Malcolm
	DB : DBSUM-bodb_Summary
	Task: re-generate data for sum_winloss [redmine: #139575]
*/

USE bodb_Summary
GO

CREATE TABLE #CustId (CustId INT)

DECLARE cursor_custId CURSOR FOR SELECT CustId FROM #CustId

DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE, @CustId INT

SELECT
	@FromDate = '20200816'
   ,@Todate = '20200821'

SELECT @WinlostDate = @FromDate

WHILE (@WinlostDate <= @Todate)
BEGIN

	DELETE FROM #CustId

	INSERT INTO #CustId(CustId)
	SELECT DISTINCT b.custid
	FROM bodb_Archive.dbo.bettrans_bk b WITH(NOLOCK)
	WHERE b.winlostdate = @WinlostDate 
		AND b.statusID IN (111, 112, 113)
		AND EXISTS(SELECT 1
			FROM bodb02.dbo.SportBettypeMatrix m WITH(NOLOCK)
			WHERE m.BetType = b.bettype 
				AND m.SportType = 248)

	OPEN cursor_custId 
	FETCH NEXT FROM cursor_custId INTO @custId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DELETE s
		FROM dbo.sum_winloss_old s WITH(ROWLOCK, UPDLOCK)
		WHERE s.winlostdate = @WinlostDate
			AND s.custid = @CustId

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
	END

	CLOSE cursor_custId

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END

DEALLOCATE cursor_custId
GO