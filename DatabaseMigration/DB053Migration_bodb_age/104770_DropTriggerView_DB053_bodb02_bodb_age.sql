/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	SERVER: DB053/BODB02/bodb_age
*/
USE bodb02
GO
---------STEP 1: Mark delete for Tables -----------------------------------
DROP TRIGGER bettrans_running_UPDATE 
GO
DROP TRIGGER bettrans_running_INSERT 
GO

USE bodb_Age
GO
DROP VIEW v_tablediff2
GO


