/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210315@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO

ALTER TABLE LicenseeTransferCode 
	ADD 
		FromDate DATE,
		ToDate DATE 

GO


