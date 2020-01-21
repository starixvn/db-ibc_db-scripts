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

UPDATE dbo.SystemSettings WITH (ROWLOCK)
SET VValue = '2020-02-11'
WHERE VName = 'CutOffDate_ExtraPT'
GO