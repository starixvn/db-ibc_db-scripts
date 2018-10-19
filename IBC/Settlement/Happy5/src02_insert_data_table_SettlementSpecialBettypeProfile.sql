/*
	Created: Vicky
	Task: insert data for Happy5
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb02]
GO
-------------------DELETE DATA
DELETE SettlementSpecialBettypeProfile
WHERE Sporttype = 164



INSERT [dbo].[SettlementSpecialBettypeProfile] ([pfID], [BetType], [SportType], [BetID], [ResourceID], [SettleType], [GroupType], [OrdNo], [RoundID], [OddsType]) 
VALUES (8101, 8101, 164, 0, N'00', N'', N'', 1, N'',NULL)
	  ,(8102, 8102, 164, 0, N'00', N'', N'', 2, N'',NULL)
	  ,(8103, 8103, 164, 0, N'00', N'', N'', 3, N'',1)
	  ,(8104, 8104, 164, 0, N'8104', N'', N'', 4, N'',NULL)
	  ,(8105, 8105, 164, 0, N'00', N'', N'', 5, N'',1)
