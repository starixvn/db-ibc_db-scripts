/*
	Created by: Helen
	Date: 2015-08-21
	Task: # Colossus Bet Product - [Redmine: #42655]
	DB: DBCUST / CustDB
*/
USE CustDB
GO
INSERT INTO MsgError (MsgID,MsgGroupID,MsgNameEN,IsActive) VALUES (10,1,'Invalid Cash-In Share rate.',1)
GO

INSERT INTO MsgError (MsgID,MsgGroupID,MsgNameEN,IsActive) VALUES (60032,7,'Account was disabled Colossus Bets. Unable to edit downlines.',1)

GO

INSERT INTO ProductGlobalSetting (Sporttype,Bettype,Maxsdiscount,IsDep)
VALUES (204,18001,0.06075,0)

GO

INSERT INTO ProductGlobalSetting (Sporttype,Bettype,Maxsdiscount,IsDep)
VALUES (204,18002,0.225,0)

GO
