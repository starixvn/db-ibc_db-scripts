/*<info serverAlias="DBLIC-bodb_LicenseeReportArchive"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReportArchive
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/


USE [bodb_LicenseeReportArchive]
GO

/*=================================================================================================*/

ALTER TABLE dbo.rptCustomerTurnover_bk ADD Currency_NEW SMALLINT
GO

/*=================================================================================================*/

DECLARE @recommend INT
		,@Max_recommend INT

SELECT @recommend = MIN(recommend)
	, @Max_recommend = MAX(recommend)
FROM dbo.rptCustomerTurnover_bk(NOLOCK)

WHILE (@recommend <= @Max_recommend)
BEGIN

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP(20000) rptCustomerTurnover_bk
		SET Currency_NEW = Currency
		WHERE recommend = @recommend AND Currency_NEW IS NULL

		IF @@ROWCOUNT < 20000
			BREAK;

		WAITFOR DELAY '00:00:00.280'
	END

	IF @recommend = @Max_recommend
		BREAK;

	SELECT @recommend = MIN(recommend) FROM dbo.rptCustomerTurnover_bk(NOLOCK) WHERE recommend > @recommend

END

/* 
SELECT c.name, s.name AS StatisticName
FROM sys.stats AS s
INNER JOIN sys.stats_columns AS sc ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
INNER JOIN sys.columns AS c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
WHERE s.object_id = OBJECT_ID('dbo.rptCustomerTurnover_bk') AND c.name IN ('Currency','Currency_NEW');

UPDATE STATISTICS dbo.rptCustomerTurnover_bk [%__StatisticName_Currency]; --Currency
UPDATE STATISTICS dbo.rptCustomerTurnover_bk [%__StatisticName_Currency_NEW]; --Currency_NEW

DBCC SHOW_STATISTICS ('dbo.rptCustomerTurnover_bk', 'Currency');
DBCC SHOW_STATISTICS ('dbo.rptCustomerTurnover_bk', 'Currency_NEW');


--Check all data updated
SELECT COUNT(*)
FROM rptCustomerTurnover_bk WITH(NOLOCK)
WHERE Currency_NEW IS NULL

SELECT COUNT(*)
FROM rptCustomerTurnover_bk WITH(NOLOCK)
WHERE Currency_NEW <> Currency

*/

/*=================================================================================================*/

BEGIN TRY
	BEGIN TRAN
	EXEC sp_rename 'rptCustomerTurnover_bk.Currency', 'DEL_Currency', 'COLUMN';
	EXEC sp_rename 'rptCustomerTurnover_bk.Currency_NEW', 'Currency', 'COLUMN';
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT ('RENAME COLUMN WAS FAILED')
END CATCH

/*=================================================================================================*/

GO
ALTER TABLE dbo.rptCustomerTurnover_bk DROP COLUMN DEL_Currency