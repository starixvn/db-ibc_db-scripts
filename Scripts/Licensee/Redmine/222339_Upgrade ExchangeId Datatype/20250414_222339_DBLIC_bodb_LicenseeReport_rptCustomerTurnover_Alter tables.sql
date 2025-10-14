/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/


USE [bodb_LicenseeReport]
GO

/*=================================================================================================*/

ALTER TABLE dbo.rptCustomerTurnover ADD Currency_NEW SMALLINT
GO

/*=================================================================================================*/
DECLARE @recommend INT
		,@Max_recommend INT
		,@rowcnt INT = 0
		,@i BIGINT = 0

SELECT @recommend = MIN(recommend)
	, @Max_recommend = MAX(recommend)
FROM dbo.rptCustomerTurnover(NOLOCK)

WHILE (@recommend <= @Max_recommend)
BEGIN

	WHILE (1 = 1)
	BEGIN
		
		UPDATE TOP(20000) rptCustomerTurnover
		SET Currency_NEW = Currency
		WHERE recommend = @recommend AND Currency_NEW IS NULL

		SELECT @rowcnt = @@ROWCOUNT

		SELECT @i = @i + @rowcnt
		PRINT CAST(@i AS VARCHAR)

		IF @rowcnt < 20000
			BREAK;

		WAITFOR DELAY '00:00:00.280'
	END

	IF @recommend = @Max_recommend
		BREAK;

	SELECT @recommend = MIN(recommend) FROM dbo.rptCustomerTurnover(NOLOCK) WHERE recommend > @recommend

END

/* 
SELECT c.name, s.name AS StatisticName
FROM sys.stats AS s
INNER JOIN sys.stats_columns AS sc ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
INNER JOIN sys.columns AS c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
WHERE s.object_id = OBJECT_ID('dbo.rptCustomerTurnover') AND c.name IN ('Currency','Currency_NEW');

UPDATE STATISTICS dbo.rptCustomerTurnover [%__StatisticName_Currency]; --Currency
UPDATE STATISTICS dbo.rptCustomerTurnover [%__StatisticName_Currency_NEW]; --Currency_NEW

DBCC SHOW_STATISTICS ('dbo.rptCustomerTurnover', 'Currency');
DBCC SHOW_STATISTICS ('dbo.rptCustomerTurnover', 'Currency_NEW');

--Check all data updated
SELECT COUNT(*)
FROM rptCustomerTurnover WITH(NOLOCK)
WHERE Currency_NEW IS NULL

SELECT COUNT(*)
FROM rptCustomerTurnover WITH(NOLOCK)
WHERE Currency_NEW <> Currency

*/

/*=================================================================================================*/

BEGIN TRY
	BEGIN TRAN
	EXEC sp_rename 'rptCustomerTurnover.Currency', 'DEL_Currency', 'COLUMN';
	EXEC sp_rename 'rptCustomerTurnover.Currency_NEW', 'Currency', 'COLUMN';
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT ('RENAME COLUMN WAS FAILED')
END CATCH

/*=================================================================================================*/

GO
ALTER TABLE dbo.rptCustomerTurnover DROP COLUMN DEL_Currency



