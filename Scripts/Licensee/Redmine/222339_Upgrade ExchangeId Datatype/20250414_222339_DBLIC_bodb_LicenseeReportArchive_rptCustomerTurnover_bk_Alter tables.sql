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

CREATE INDEX IDX_rptCustomerTurnover_bk_Currency_NEW ON dbo.rptCustomerTurnover_bk(Currency_NEW)
GO

/*=================================================================================================*/

DECLARE @FromDate DATE
		, @ToDate DATE
		, @rowcnt INT = 0

SELECT @FromDate = MIN(WinlostDate)
		,@ToDate = MAX(WinlostDate)
FROM dbo.rptCustomerTurnover_bk WITH(NOLOCK)

WHILE @FromDate <= @ToDate
BEGIN
	SET @rowcnt = 1 -- KICK OFF

	WHILE @rowcnt <> 0
	BEGIN
		UPDATE TOP(2000) rptCustomerTurnover_bk
		SET Currency_NEW = Currency
		WHERE Currency_NEW IS NULL AND WinlostDate = @FromDate

		SET @rowcnt = @@ROWCOUNT

		WAITFOR DELAY '00:00:00.280'
	END

	SET @FromDate = DATEADD(D, 1, @FromDate)
END

/*
SELECT TOP 100 WinlostDate,Currency,Currency_NEW
FROM rptCustomerTurnover_bk WITH(NOLOCK)
WHERE Currency_NEW <> Currency
*/

/*=================================================================================================*/

DROP INDEX IDX_rptCustomerTurnover_bk_Currency_NEW ON dbo.rptCustomerTurnover_bk
GO

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