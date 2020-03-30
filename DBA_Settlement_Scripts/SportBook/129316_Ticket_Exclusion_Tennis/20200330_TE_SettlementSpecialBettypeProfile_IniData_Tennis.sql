/*	
	Created: 20200330@Sol
	Task: Insert data to SettlementSpecialBettypeProfile table for new bettype of Tennis - [Redmine:#129316]
	DB: DBTXN/bodb02
*/

USE bodb02

GO 

-- Affected rows = 20
INSERT [dbo].[SettlementSpecialBettypeProfile] 
	([pfID], [BetType], [SportType], [BetID], [ResourceID], [SettleType], [GroupType], [OrdNo], [RoundID], [OddsType]) 
VALUES 
(1,1,5,0,'00','MNL','FT',99,0,NULL),
(3,3,5,0,'00','MNL','FT',99,0,NULL),
(2,2,5,0,'00','MNL','FT',99,0,NULL),
(20,20,5,0,'00','MNL','FT',99,0,NULL),
(1,153,5,0,'00','MNL','FT',100,0,NULL),
(20,154,5,801,'01','MNL','SP',1,801,NULL),
(20,154,5,802,'02','MNL','SP',2,802,NULL),
(20,154,5,803,'03','MNL','SP',3,803,NULL),
(20,154,5,804,'04','MNL','SP',4,804,NULL),
(20,154,5,805,'05','MNL','SP',5,805,NULL),
(1,155,5,801,'01','MNL','SP',1,801,NULL),
(1,155,5,802,'02','MNL','SP',2,802,NULL),
(1,155,5,803,'03','MNL','SP',3,803,NULL),
(1,155,5,804,'04','MNL','SP',4,804,NULL),
(1,155,5,805,'05','MNL','SP',5,805,NULL),
(3,156,5,801,'01','MNL','SP',1,801,NULL),
(3,156,5,802,'02','MNL','SP',2,802,NULL),
(3,156,5,803,'03','MNL','SP',3,803,NULL),
(3,156,5,804,'04','MNL','SP',4,804,NULL),
(3,156,5,805,'05','MNL','SP',5,805,NULL)