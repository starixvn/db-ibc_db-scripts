/*	
	Created: 20200406@Sol
	Task: Insert data to SettlementSpecialBettypeProfile table for new bet option of bettype 613 of basketball - [Redmine:#131795]
	DB: DBTXN/bodb02
*/

USE bodb02

GO 

-- Affected rows = 4
INSERT [dbo].[SettlementSpecialBettypeProfile] 
	([pfID], [BetType], [SportType], [BetID], [ResourceID], [SettleType], [GroupType], [OrdNo], [RoundID], [OddsType]) 
VALUES 
(0,613,2,80125,'6130125','EAR','SP',70,801,0),
(0,613,2,80225,'6130225','EAR','SP',71,802,0),
(0,613,2,80325,'6130325','EAR','SP',72,803,0),
(0,613,2,80425,'6130425','EAR','SP',73,804,0)