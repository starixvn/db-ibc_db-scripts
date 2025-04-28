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

CREATE INDEX IDX_rptCustomerTurnover_Currency_NEW ON dbo.rptCustomerTurnover(Currency_NEW) INCLUDE (Currency)
GO

/*=================================================================================================*/

WHILE (1 = 1)
BEGIN
	UPDATE TOP(20000) rptCustomerTurnover
	SET Currency_NEW = Currency
	WHERE Currency_NEW IS NULL

	IF @@ROWCOUNT < 20000
		BREAK;

	WAITFOR DELAY '00:00:00.280'
END

/* 
--Check all data updated
SELECT COUNT(*)
FROM rptCustomerTurnover WITH(NOLOCK)
WHERE Currency_NEW IS NULL

SELECT COUNT(*)
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



