/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210527@Percy
	DB: DBCUST-bodb_Licensee
	Task: Initialize data for new column on Product3rd table
*/
use bodb_Licensee
go

declare @product table (productId int, OfferSite tinyint)
insert into @product (productId,OfferSite)
values
	( 3, 2),
	(10, 2),
	(23, 1),
	(31, 2),
	(43, 2),
	(46, 1),
	(47, 1),
	(50, 1),
	(52, 1),
	(60, 1),
	(65, 1)

update p with (rowlock)
set p.OfferSite = isnull(t.OfferSite, 0)
from dbo.Product3rd p
	left join @product t on p.ProductId = t.productId