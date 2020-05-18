use bodb02
go

/*
	Created: 20191107@Percy
	DB: DBPRO.bodb02
	Task: BMAIO - Update SportTypeGroup
*/

update dbo.CS_SportBettypeMatrix with (rowlock)
set SportTypeGroup = 6
where SportType = 9 and SportTypeGroup = 9