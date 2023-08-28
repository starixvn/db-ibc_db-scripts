/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Create: 20230825@Lewis
	DB : DBPRO-bodb02
	Task: Add more columns for tbl Bettype [RedmineId: #193092]
*/

USE bodb02
GO

ALTER TABLE bettype
ADD typenamePTBR NVARCHAR(128) NULL
	,typenameDE NVARCHAR(128) NULL
	,typenameBENG NVARCHAR(128) NULL
	,typenameURD NVARCHAR(128) NULL
	,typenameMSA NVARCHAR(128) NULL
	,typenameKH NVARCHAR(128) NULL
	,typenameLAO NVARCHAR(128) NULL
	,typenameAR NVARCHAR(128) NULL
	,typenameTAM NVARCHAR(128) NULL