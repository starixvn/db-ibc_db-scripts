use bodb02
go

/*
	Created: 20190723@Percy
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix/CS_SportBettypeMatrix - Insert new bet types of RNG Keno (1525, 1526)
	RedmineID: #116466
*/

-- SportBettypeMatrix
insert into bodb02.dbo.SportBettypeMatrix
	(SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct,RefTable)
values
	(202,1525,0,8,1,0,0,'',3),
	(202,1526,0,8,1,0,0,'',3)
go

-- CS_SportBettypeMatrix
insert into bodb02.dbo.CS_SportBettypeMatrix
	(SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct,RefTable,SportTypeGroup,BetTypeGroup)
values
	(202,1525,0,8,1,0,0,'',3,12,1525),
	(202,1526,0,8,1,0,0,'',3,12,1526)