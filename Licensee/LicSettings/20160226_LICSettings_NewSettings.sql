/*
	Created: 20190226@Percy
	DB:
		DB052.bodb_licensee
		DB053.bodb_licensee
		DB06.bodb_licensee
		DBTP.bodb_licensee

	Task: Insert new configuration for BA Verify tickets Job
*/

USE [bodb_licensee]
GO

INSERT INTO dbo.LICSettings (VName, VValue, VValue2)
SELECT 'BA_MaxOfFailedCount', '1', '' UNION ALL
SELECT 'BA_MissingTransID', '0', ''