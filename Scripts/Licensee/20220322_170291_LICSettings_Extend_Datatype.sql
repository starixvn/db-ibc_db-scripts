/*<info serverAlias="DBEXT-bodb_licensee,DBACC-bodb_licensee,DBBOF-bodb_licensee,DBBAL-bodb_licensee"></info>*/
/*
	Created: 20220322@Sol
	DB: DBEXT-bodb_licensee,DBACC-bodb_licensee,DBBOF-bodb_licensee,DBBAL-bodb_licensee
	Description: 
*/

USE bodb_licensee;

GO 


ALTER TABLE LICSettings
	ALTER COLUMN VValue2 VARCHAR(8000)

GO