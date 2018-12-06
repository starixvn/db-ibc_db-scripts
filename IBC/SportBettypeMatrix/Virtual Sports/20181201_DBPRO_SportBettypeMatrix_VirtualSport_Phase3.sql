USE [bodb02]
GO

/*
	Created: 20181201@Percy
	DB: DBPRO.bodb02
	Task: Add new Sports - Virtual Soccer Asian Cup
	Specs: https://nexdev.net/projects/betradar-virtual-sports/wiki/201704_BetradarVS_SystemOverview
*/

INSERT INTO dbo.SportBettypeMatrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable)
	VALUES
		(194,2701,0,27,1,0,1,'',0),
		(194,2702,0,27,1,0,1,'',0),
		(194,2703,0,27,1,0,1,'',0),
		(194,2704,0,27,1,0,1,'',0),
		(194,2705,0,27,1,0,1,'',0),
		(194,2706,0,27,1,0,1,'',0),
		(194,2707,0,27,1,0,1,'',0),
		(194,2799,0,27,1,0,0,'',0)
GO