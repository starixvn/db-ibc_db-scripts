/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/

USE [bodb_3rdProduct]
GO

DECLARE   @FromDate DATE
		, @ToDate DATE		
		, @ErrMsg NVARCHAR(1000) = ''

SELECT  @FromDate = MIN(settledDate) 
	  , @ToDate   = DATEADD(yy, DATEDIFF(yy, 0, DATEADD(YEAR, -3, GETDATE())) + 1, -1)
					--DATEADD(yy, DATEDIFF(yy, 0, DATEADD(YEAR, -2, GETDATE())) , 0)	  
FROM dbo.Sum_winloss_Exchange s WITH(NOLOCK)

SELECT @FromDate FromDate, @ToDate ToDate

WHILE @FromDate <= @ToDate
BEGIN
	
	EXEC dbo.Task_Archive_SelectBettrans_Exchange @settledDate = @FromDate, @batchsize = 2000, @ErrMsg = @ErrMsg OUT

	IF ISNULL(@ErrMsg,'') <> ''
	BEGIN
		PRINT CAST(@FromDate AS VARCHAR(20))
		RAISERROR (@ErrMsg, 16, 1)
		BREAK
	END

	SET @FromDate = DATEADD(D, 1, @FromDate)
END

/*
SELECT TOP 100 * FROM Sum_winloss_Exchange_bk(NOLOCK)
SELECT TOP 100 * FROM Bettrans_Exchange_bk(NOLOCK)
SELECT TOP 100 * FROM BettransM_Exchange_bk(NOLOCK)
SELECT TOP 100 * FROM LOG_Archive_BettransExchange(NOLOCK)
SELECT TOP 100 * FROM Sum_winloss_Exchange_Archive_Staging(NOLOCK)
SELECT TOP 100 * FROM Bettrans_Exchange_Archive_Staging(NOLOCK)

*/