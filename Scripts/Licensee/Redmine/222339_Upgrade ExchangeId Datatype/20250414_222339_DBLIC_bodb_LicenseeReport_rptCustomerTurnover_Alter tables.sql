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

CREATE INDEX IDX_rptCustomerTurnover_Currency_NEW ON dbo.rptCustomerTurnover(Currency_NEW)
GO

/*=================================================================================================*/

DECLARE @FromDate DATE
		, @ToDate DATE
		, @rowcnt INT = 0

SELECT @FromDate = MIN(WinlostDate)
		,@ToDate = MAX(WinlostDate)
FROM dbo.rptCustomerTurnover WITH(NOLOCK)

WHILE @FromDate <= @ToDate
BEGIN
	SET @rowcnt = 1 -- KICK OFF

	WHILE @rowcnt <> 0
	BEGIN
		UPDATE TOP(2000) rptCustomerTurnover
		SET Currency_NEW = Currency
		WHERE Currency_NEW IS NULL AND WinlostDate = @FromDate

		SET @rowcnt = @@ROWCOUNT

		WAITFOR DELAY '00:00:00.280'
	END

	SET @FromDate = DATEADD(D, 1, @FromDate)
END

/*
SELECT TOP 100 WinlostDate,Currency,Currency_NEW
FROM rptCustomerTurnover WITH(NOLOCK)
WHERE Currency_NEW <> Currency
*/

/*=================================================================================================*/


DROP INDEX IDX_rptCustomerTurnover_Currency_NEW ON dbo.rptCustomerTurnover
GO

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



