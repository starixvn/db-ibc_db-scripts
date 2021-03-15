/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210315@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO

DECLARE @currDate DATETIME = GETDATE()
DECLARE @lastDayOfPreviousMonth DATE = DATEADD(DAY,-1,DATEADD(MONTH, DATEDIFF(MONTH,0,@currDate),0))

UPDATE dbo.LicenseeTransferCode
	SET 
		FromDate = '2019-07-18',
		ToDate = CASE WHEN StatusID = 1 THEN '2050-01-01' ELSE @lastDayOfPreviousMonth END

GO