use bodb02
go

/*
	Created: 20190307@Percy
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix - Add new bettype of PP
*/

insert into bodb02.dbo.SportBettypeMatrix (SportType, BetType, IsLive, IsTest, Enabled, EventType, ProductID, SubProduct, RefTable)
values (248, 4300, 0, 0, 1, 0, 32, '', 1)
go