use bodb02
go

/*
	Created: 20190926@Percy
	DB: DBPRO.bodb02
	Task: Products - Disable Microgaming
*/

update dbo.Products with (rowlock, updlock)
set Enabled = 0
where ProductID in (13, 17) -- Microgaming - Live Casino / Microgaming - RNG Casino
	and Enabled = 1