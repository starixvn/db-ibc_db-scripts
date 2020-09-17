/*<info serverAlias="DBACC-bodb02" step="2"></info>*/
/*
	Create: 20200910@Malcolm
	DB : DBACC-bodb02
	Task: re-generate data for sum_winloss_old [redmine: #139575]
*/

USE bodb02;

GO

DECLARE @MoveBetsDay SMALLDATETIME, @BalanceUpDay SMALLDATETIME		
DECLARE @MoveBetAndBalanceUp TABLE( MoveBetsDay SMALLDATETIME, BalanceUpDay SMALLDATETIME)

INSERT INTO @MoveBetAndBalanceUp (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay

SELECT @MoveBetsDay = MoveBetsDay, @BalanceUpDay = BalanceUpDay
FROM @MoveBetAndBalanceUp

TRUNCATE TABLE  bodb_Archive.dbo.sum_winloss_old_tmp;

CREATE TABLE #tblRunningSuperIds (SuperId INT PRIMARY KEY)
CREATE TABLE #tblSuperIdsTemp (SuperId INT PRIMARY KEY)

DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE
DECLARE @strSuperIds VARCHAR(MAX) = ''

SELECT
	@FromDate = '20200904'
   ,@Todate = '20200913'

--- run from 2020-08-15 to current movebet date
SELECT @WinlostDate = @FromDate

WHILE (@WinlostDate <= @Todate)
BEGIN

	--DELETE FROM @tblSuperIds

	--INSERT INTO @tblSuperIds(SuperId)
	
	--- reset temp table
	DELETE FROM #tblSuperIdsTemp
	
	--- list super to run
	INSERT INTO #tblSuperIdsTemp
	SELECT DISTINCT b.srecommend
	FROM bodb_Archive.dbo.bettrans_bk b WITH(NOLOCK)
	WHERE b.winlostdate = @WinlostDate 
		AND b.statusID IN (111, 112, 113)
		AND b.bettype IN (4297, 4298)

	--- run sp to generate data
	WHILE 1 = 1
	BEGIN
		
		--- clear data from temp table
		DELETE FROM #tblRunningSuperIds
		SELECT @strSuperIds = ''

		DELETE TOP (500) FROM #tblSuperIdsTemp
		OUTPUT DELETED.SuperId INTO #tblRunningSuperIds

		IF @@ROWCOUNT = 0 BREAK

		--- create string superids
		SELECT @strSuperIds = @strSuperIds + CAST(SuperId AS VARCHAR(20)) + ','
		FROM #tblRunningSuperIds

		--- generate data
		EXEC Task_Sum_Winloss_Old  @WinlostDate = @WinlostDate
								,@CustIds = @strSuperIds	
								,@ProductIds = '32'

	END

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END

DROP TABLE #tblRunningSuperIds
DROP TABLE #tblSuperIdsTemp

GO