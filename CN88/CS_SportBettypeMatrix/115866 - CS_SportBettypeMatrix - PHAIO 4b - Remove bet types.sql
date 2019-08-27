use bodb02
go

/*
	Created: 20190827@Percy
	DB: DBPRO.bodb02
	Task: CN88 - CS_SportBettypeMatrix - Remove Sporting Solution, Bet radar, 11, 38, 480, 502 bet types
*/

delete dbo.CS_SportBettypeMatrix with (rowlock, updlock)
where SubProduct in ('SS', 'BetRadar')
	or BetType IN (11, 38, 480, 502)