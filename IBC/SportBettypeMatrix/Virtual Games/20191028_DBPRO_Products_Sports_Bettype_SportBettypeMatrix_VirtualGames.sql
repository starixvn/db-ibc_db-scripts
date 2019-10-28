use bodb02
go


/*
	Created: 20191028@Percy
	DB: DBPRO.bodb02
	Task: New product: Virtual Games - Initialize data for Products, Sports, bettype, SportBettypeMatrix tables
*/


-- 1. Products
insert into dbo.Products (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,GroupType,CasinoType,IsOfferPlayForFun,VendorID)
values (38,'Virtual Games','Virtual Games','VRG',1,4,0,0,0,38)

update dbo.Products with (rowlock)
set ProductNameCh = ProductName
	,ProductNameCs = ProductName
	,ProductNameJp = ProductName
	,ProductNameIt = ProductName
	,ProductNameTh = ProductName
	,ProductNameKo = ProductName
	,ProductNameES = ProductName
	,ProductNameVN = ProductName
	,ProductNameEL = ProductName
	,ProductNameRU = ProductName
	,ProductNameID = ProductName
where ProductId = 38



-- 2. Sports
insert into dbo.Sports (SportType,SportName)
values (245,'Virtual Games')

update dbo.Sports with (rowlock)
set
	SportNameCh = SportName
	,SportNameCs = SportName
	,SportNameJp = SportName
	,SportNameIt = SportName
	,SportNameTh = SportName
	,SportNameKo = SportName
	,SportNameES = SportName
	,SportNameVN = SportName
	,SportNameEL = SportName
	,SportNameRU = SportName
	,SportNameID = SportName
	,SportNamePT = SportName
	,SportNameFR = SportName
	,SportNameMMR = SportName
	,SportNamePL = SportName
	,SportNameHI = SportName
where SportType = 245



-- 3. bettype
insert into dbo.bettype (typeid,typenamee,creator,typenamec_uni,typenamecn,ParentTypeid,DisplayedTypeID)
select 4601,'Baccarat',8,N'百家樂',N'百家乐',4601,4601 union all
select 4602,'Sic Bo',8,N'骰寶',N'骰宝',4602,4602 union all
select 4603,'Fish Prawn Crab',8,N'魚蝦蟹',N'鱼虾蟹',4603,4603 union all
select 4604,'Xoc Dia',8,N'色碟',N'色碟',4604,4604

update dbo.bettype with (rowlock)
set typenamec = typenamee
	,typedesc = typenamee
	,typenamcn = typenamee
	,typenameth = typenamee
	,typenameit = typenamee
	,typenameko = typenamee
	,typenameES = typenamee
	,typenameVN = typenamee
	,typenameEL = typenamee
	,typenamee_Eu = typenamee
	,typenameRU = typenamee
	,typenameID = typenamee
	,typenamePT = typenamee
	,typenameFR = typenamee
	,typenameMMR = typenamee
	,typenameHI = typenamee
where typeid between 4601 and 4604



-- 4. SportBettypeMatrix
insert into dbo.SportBettypeMatrix (SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct,RefTable)
select 245, bettype, 0, 38, 1, 0, 0, '', 1
from (
	select 4601 as bettype union all
	select 4602 union all
	select 4603 union all
	select 4604
) a