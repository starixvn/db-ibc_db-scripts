/*
	Created: 20200107@Percy
	Task: Initialize data for Cut-Off Date of Extra PT (using new column epositiontaking on bettrans)
	DB: 
	    DBACC-bodb02,
		DBAGE-bodb02,
		DBWH-bodb02,
		DB042-bodb02
*/

USE bodb02
GO

INSERT INTO dbo.SystemSettings (VName, VValue)
VALUES ('CutOffDate_ExtraPT', '2020-01-12')
GO