use bodb02
go

/*
	Created: 20190814@Percy
	DB: DBPRO
	Task: Change DisplayedTypeID for Total Corners (11, 199) and Exact Goals (179, 187)
*/

update dbo.bettype with (rowlock)
set DisplayedTypeID = 473
where typeid in (11, 199)

update dbo.bettype with (rowlock)
set DisplayedTypeID = 412
where typeid = 179

update dbo.bettype with (rowlock)
set DisplayedTypeID = 429
where typeid = 187