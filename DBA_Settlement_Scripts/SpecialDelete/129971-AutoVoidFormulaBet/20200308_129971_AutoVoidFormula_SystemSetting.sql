/*
	Created by: Helen
	Date 20200308
	Task:  Auto Void Settled Tickets of Formula Bet Feature [Redmine:#129971]
	DB: DBTXN/BODB02
*/
USE BODB02
GO
INSERT INTO SystemSettings (VName, VValue)
SELECT 'AutoVoidFormula', 0
GO