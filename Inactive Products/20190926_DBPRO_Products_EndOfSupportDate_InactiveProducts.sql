use bodb02
go

/*
	Created: 20190926@Percy
	DB: DBPRO.bodb02
	Task: Products - Update EndOfSupportDate of Inactive Products
*/

update dbo.Products with (rowlock, updlock)
set EndOfSupportDate = case ProductID
						when 7 then '2017-01-11'
						when 9 then '2017-01-11'
						when 13 then '2018-08-28'
						when 14 then '2015-08-18'
						when 17 then '2018-08-28'
						else EndOfSupportDate end
where ProductID in (7,9,13,14,17)
	and EndOfSupportDate is null