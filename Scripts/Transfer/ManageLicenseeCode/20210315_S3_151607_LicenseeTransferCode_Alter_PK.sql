/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210315@Sol
	Task: 151607 - NAP - Enhance Manage Licensee Code to support change base currency of licensees
	DB: DBCUST/bodb_Licensee
*/

USE bodb_Licensee

GO

ALTER TABLE LicenseeTransferCode ALTER COLUMN FromDate DATE NOT NULL
ALTER TABLE LicenseeTransferCode ALTER COLUMN ToDate DATE NOT NULL

GO 

ALTER TABLE LicenseeTransferCode
DROP CONSTRAINT PK_LicenseeTransferCode

GO

ALTER TABLE LicenseeTransferCode
ADD CONSTRAINT PK_LicenseeTransferCode PRIMARY KEY (LicenseeName, CustID, FromDate)

GO

ALTER TABLE LicenseeTransferCode
ADD CONSTRAINT DF_LicenseeTransferCode_ToDate DEFAULT '2050-01-31' FOR ToDate
