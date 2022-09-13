/*<info serverAlias="DBSID-bodb02,DBBAL-bodb02"></info>*/
USE [bodb02]
GO
/*
	Created: 20220913@Evan
	DB: DBSID-bodb02, DBBAL-bodb02
	Task: Alter tables LICSettings [RedmineID: #175297]
*/
ALTER TABLE LICSettings
ALTER COLUMN VValue2 VARCHAR (8000);

GO