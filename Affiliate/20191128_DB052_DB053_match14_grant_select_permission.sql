use bodb02
go

/*
	Created: 20191128@Percy
	DB: DB052, DB053
	Task: Grant select permission on match14
*/

grant select on dbo.match14 to bodbAdminNet as dbo
go

grant select on dbo.match14 to bodbDownlineNet as dbo
go

grant select on dbo.match14 to bodbDownlineNetView as dbo
go