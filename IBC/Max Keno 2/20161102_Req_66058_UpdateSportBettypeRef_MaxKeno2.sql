/*
	Created by: Winnie
	Date: 2016-11-02
	Task: update Sport_Bettype_Reference for Max Keno 2 [Redmine:#66058]	
*/ 

----------------------------------------------------------------
--Update data DBTXN.bodb02.dbo.Sport_Bettype_Reference -- 1 row affected
----------------------------------------------------------------
USE bodb02 
GO

UPDATE Sport_Bettype_Reference SET isActive=1 WHERE Sporttype=202 and bettype=1516 and isLicensee=0

GO
