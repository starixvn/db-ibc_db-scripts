USE bodb02
GO

/*
	Created: 20200306@Percy
	DB: DBEXT.bodb02
	Task: Initialize new setting for PRMS - Abnormal Bet Alert
*/

INSERT INTO dbo.SystemSettings (VName, VValue)
VALUES ('AbnormalBetAlert_LastTransDate', '2020-03-02')