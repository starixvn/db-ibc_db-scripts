/*	
	Created: 20200420@Sol
	Task: Insert data to SettlementSpecialBettypeProfile table for bettype 4 of Esport - [Redmine:#132401]
	DB: DBTXN/bodb02
*/

USE bodb02

GO 

-- Affected rows = 1
INSERT [dbo].[SettlementSpecialBettypeProfile] 
	([pfID], [BetType], [SportType], [BetID], [ResourceID], [SettleType], [GroupType], [OrdNo], [RoundID], [OddsType]) 
VALUES 
(4,4,43,0,'00','MNL','FT',99,0,1)