use CustDB
go

/*
	Created: 20190926@Percy
	DB: DBCUST.CustDB
	Task: ExtraPT - Update End Date of Inactive Products
*/

declare @Products table (ProductId tinyint, EndOfSupportDate date)
insert into @Products (ProductId, EndOfSupportDate)
select ProductId, EndOfSupportDate from DBPRO.bodb02.dbo.Products with (nolock)
where ProductId in (2,4,7,9,13,15,17,19,26,30,33)
	and EndOfSupportDate is not null

-- 1. Acc_GroupExtraPT_Product
update sp with (rowlock)
set sp.ToDate = p.EndOfSupportDate
from dbo.Acc_GroupExtraPT_Product sp
	inner join @Products p on sp.ProductID = p.ProductId
where sp.ToDate > GETDATE()

-- 2. Acc_GroupExtraPTSetting
update sp with (rowlock)
set sp.ToDate = p.EndOfSupportDate
from dbo.Acc_GroupExtraPTSetting sp
	inner join @Products p on sp.ProductID = p.ProductId
where sp.ToDate > GETDATE()

-- 3. Acc_GroupExtraCommRate_Product
update sp with (rowlock)
set sp.ToDate = p.EndOfSupportDate
from dbo.Acc_GroupExtraCommRate_Product sp
	inner join @Products p on sp.ProductID = p.ProductId
where sp.ToDate > GETDATE()

-- 4. Acc_GroupExtraCommRateSetting
update sp with (rowlock)
set sp.ToDate = p.EndOfSupportDate
from dbo.Acc_GroupExtraCommRateSetting sp
	inner join @Products p on sp.ProductID = p.ProductId
where sp.ToDate > GETDATE()