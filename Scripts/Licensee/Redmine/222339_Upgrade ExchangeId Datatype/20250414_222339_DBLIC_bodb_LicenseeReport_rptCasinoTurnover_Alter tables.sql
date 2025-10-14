/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE [bodb_LicenseeReport]
GO

/*=================================================================================================*/

ALTER TABLE dbo.rptCasinoTurnover ADD Currency_NEW SMALLINT
GO

CREATE INDEX IDX_rptCasinoTurnover_Currency_NEW ON dbo.rptCasinoTurnover(Currency_NEW) INCLUDE (Currency)
GO

/*=================================================================================================*/

WHILE (1 = 1)
BEGIN
	UPDATE TOP(2000) rptCasinoTurnover
	SET Currency_NEW = Currency
	WHERE Currency_NEW IS NULL

	IF @@ROWCOUNT < 2000
		BREAK;

	WAITFOR DELAY '00:00:00.280'
END

/* 
--Check all data updated
SELECT COUNT(*)
FROM rptCasinoTurnover WITH(NOLOCK)
WHERE Currency_NEW IS NULL

SELECT COUNT(*)
FROM rptCasinoTurnover WITH(NOLOCK)
WHERE Currency_NEW <> Currency

*/

/*=================================================================================================*/

DROP INDEX IDX_rptCasinoTurnover_Currency_NEW ON dbo.rptCasinoTurnover
GO

/*=================================================================================================*/

BEGIN TRY
	BEGIN TRAN
	EXEC sp_rename 'rptCasinoTurnover.Currency', 'DEL_Currency', 'COLUMN';
	EXEC sp_rename 'rptCasinoTurnover.Currency_NEW', 'Currency', 'COLUMN';
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT ('RENAME COLUMN WAS FAILED')
END CATCH

/*=================================================================================================*/

GO
ALTER TABLE dbo.rptCasinoTurnover DROP COLUMN DEL_Currency



