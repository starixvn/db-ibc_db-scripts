/*
	Created: 20170710@Helen
	Task: https://nexdev.net/issues/79239
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
-- We will have 2 new RNG mobile games soft launch on 20 July 2017.
INSERT INTO Winlimit_GameGroupSetting (ProductID, BetTypeID, GroupID)
VALUES (6,2315,3),(6,2316,3)
