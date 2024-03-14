/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20240222@Evan
	DB: DBACC-bodb02
	Step 1: regen data rptDepWinlost_AGCasino T1,2 (2024) [RedmineID: #201173]
	Run on DB062, DB061
	
*/

USE bodb02
GO
SET NOCOUNT ON

DECLARE @fDate SMALLDATETIME = '2024-01-01'
DECLARE @tDate SMALLDATETIME = '2024-01-31'
DECLARE @StringVariable NVARCHAR(50);

WHILE (@fDate <= @tDate)
BEGIN
	-- regen table rptDepWinlost_AGCasino
	EXEC Task_DOT_AGCasino_DailySummary  @winlostdate = @fDate	
									  , @IsManual = 1
	

	SELECT @StringVariable = CAST(@fDate AS NVARCHAR(20))
	RAISERROR (@StringVariable, 0, 1) WITH NOWAIT

	SET @fDate = DATEADD(DAY,1,@fDate)

	WAITFOR DELAY '00:00:00.280'
END 