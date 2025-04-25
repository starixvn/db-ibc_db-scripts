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

CREATE INDEX IDX_rptCustomerTurnover_bk_Currency_NEW ON dbo.rptCustomerTurnover_bk(Currency_NEW) INCLUDE (Currency)
GO

/*=================================================================================================*/

WHILE (1 = 1)
BEGIN
	UPDATE TOP(2000) rptCustomerTurnover_bk
	SET Currency_NEW = Currency
	WHERE Currency_NEW IS NULL

	IF @@ROWCOUNT < 2000
		BREAK;

	WAITFOR DELAY '00:00:00.280'
END

/* 
--Check all data updated
SELECT COUNT(*)
FROM rptCustomerTurnover_bk WITH(NOLOCK)
WHERE Currency_NEW IS NULL

SELECT COUNT(*)
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