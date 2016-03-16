use bodb02
go
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBPRO
*/

--match
alter table dbo.match
add IsAutoPayout bit null

--match14
alter table dbo.match14
add IsAutoPayout bit null

--league
alter table dbo.league
add IsAutoPayout bit null

go
