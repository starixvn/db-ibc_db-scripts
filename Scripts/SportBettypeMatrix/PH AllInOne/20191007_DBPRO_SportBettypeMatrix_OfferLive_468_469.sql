use bodb02
go

/*
	Created: 20191007@Percy
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix/CS_SportBettypeMatrix - Offer live (IsLive = 1) for 2 bet types: 468, 469
*/

insert into dbo.SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable)
select SportType, BetType, 1 as IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable from dbo.SportBettypeMatrix with (nolock)
where bettype in (468,469)

insert into dbo.CS_SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable, SportTypeGroup, BetTypeGroup)
select SportType, BetType, 1 as IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable, SportTypeGroup, BetTypeGroup from dbo.CS_SportBettypeMatrix with (nolock)
where bettype in (468,469)