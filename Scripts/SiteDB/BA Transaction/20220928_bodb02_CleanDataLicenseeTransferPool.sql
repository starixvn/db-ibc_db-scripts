/*<info serverAlias="DBSID-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20220928@Evan
	DB: DBSID-bodb02
	Task: Clean data LicenseeTransferPool [RedmineID: #178145]
*/

-- Step 0: Clean data LicenseeTransferPool 

TRUNCATE TABLE LicenseeTransferPool
