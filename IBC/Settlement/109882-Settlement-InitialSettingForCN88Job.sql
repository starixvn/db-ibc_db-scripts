/*
	Created: 20190327@Kathy
	DB: DBTXN/bodb02
	Task: insert new setting on SystemSetting for cn88 [Redmine:#109882]
*/

USE [bodb02]
GO
INSERT INTO dbo.SystemSettings (VName, VValue) VALUES ('CN88MaxCustID', 0)
GO