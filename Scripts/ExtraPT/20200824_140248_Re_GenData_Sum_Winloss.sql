/*<info serverAlias="DBTXN-bodb02" step="2"></info>*/
/*
	Create: 20200824@Sol
	DB : DBTXN-bodb02
	Task: re-generate data for sum_winloss [redmine: #140248]
*/

USE bodb02;

GO

DECLARE @tblSuperIds TABLE(SuperId INT)
CREATE TABLE #tblRunningSuperIds (SuperId INT PRIMARY KEY)
CREATE TABLE #tblSuperIdsTemp (SuperId INT PRIMARY KEY)

--- get list super
INSERT INTO @tblSuperIds
SELECT DISTINCT
	superid
FROM CustDB.dbo.Acc_GroupExtraPT2Setting st WITH (NOLOCK)

--- param to run
DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE
DECLARE @strSuperIds VARCHAR(MAX) = ''

SELECT
	@FromDate = '20200816'
   ,@Todate = '20200821'

--- run from 2020-08-15 to current movebet date
SELECT @WinlostDate = @FromDate

WHILE (@WinlostDate <= @Todate)
BEGIN

	--- reset temp table
	DELETE FROM #tblSuperIdsTemp
	
	--- list super to run
	INSERT INTO #tblSuperIdsTemp
	SELECT SuperId FROM @tblSuperIds

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
		EXEC Task_sum_winloss_14 @WinlostDate
								,@strSuperIds

		WAITFOR DELAY '00:00:00:500'

	END

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END

DROP TABLE #tblRunningSuperIds
DROP TABLE #tblSuperIdsTemp

GO