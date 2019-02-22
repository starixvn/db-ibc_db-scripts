/*
	Created: Vicky
	Task: insert profile for BBD
	DB: DBTXN/bodb02
	Date: 20190115
	
*/
USE [bodb02]
GO


--profile
INSERT INTO SettlementSpecialBettypeProfile(pfID, Sporttype, Bettype, BetId, ResourceID, SettleType, GroupType)
VALUES (38, 1, 38, 0, 0, 'BBD', 'FT')