USE [bodb02]
GO

/*
	Created: 20181201@Percy
	DB: DBPRO.bodb02
	Task: Add new Sports - Happy 5
	Specs: https://nexdev.net/projects/p101023/wiki
*/

INSERT INTO dbo.SportBettypeMatrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable)
	VALUES
		(164,8101,0,3,1,0,1,'',0),
		(164,8102,0,3,1,0,1,'',0),
		(164,8103,0,3,1,0,1,'',0),
		(164,8104,0,3,1,0,1,'',0),
		(164,8105,0,3,1,0,1,'',0)
GO