use bodb02
go

/*
	Created: 20191008@Percy
	DB: DBPRO.bodb02
	Task - BMAIO - Insert new bet types into SportBettypeMatrix and CS_SportBettypeMatrix [RedmineID: #118622]
*/

insert into dbo.SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable)
select 9 AS SportType, t.BetType, l.IsLive, 1 AS ProductID, 1 AS Enabled, 0 AS IsTest, 1 AS EventType, '' AS SubProduct, 0 AS RefTable
from (values (701),(702),(703),(704),(705),(706),(707),(708),(709),(710),(711),(712),(713),(714)) as t (BetType)
	cross join (values (0), (1)) as l (IsLive)

insert into dbo.CS_SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable, SportTypeGroup, BetTypeGroup)
select 9 AS SportType, t.BetType, l.IsLive, 1 AS ProductID, 1 AS Enabled, 0 AS IsTest, 1 AS EventType, '' AS SubProduct, 0 AS RefTable, 9 AS SportTypeGroup, t.BetType AS BetTypeGroup
from (values (701),(702),(703),(704),(705),(706),(707),(708),(709),(710),(711),(712),(713),(714)) as t (BetType)
	cross join (values (0), (1)) as l (IsLive)