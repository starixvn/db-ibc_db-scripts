use bodb02
GO 
/*
Create : 20200326@Sophia
Task: SportbettypeMarix /Productcs/ RefResource of Product of Table Games[redmine :#126666]
DB: DBPRO.bodb02

*/


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (40,'Table Games','Table Games','TG',1,4,NULL,0,0,0,40)


insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4901,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4902,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4903,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4904,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4905,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4906,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4907,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4908,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4909,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4910,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4911,0,40,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (222,4912,0,40,1,0,0,'',3)


/*	

	DB: DBPRO/bodb02
*/
USE bodb02
GO

--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 40,
	@Resource_en	NVARCHAR(50)	= 'Table Games',
	@Resource_ch	NVARCHAR(50)	= 'Table Games',
	@Resource_cs	NVARCHAR(50)	= 'Table Games',
	@Resource_jp	NVARCHAR(50)	= 'Table Games',
	@Resource_it	NVARCHAR(50)	= 'Table Games',
	@Resource_th	NVARCHAR(50)	= 'Table Games',
	@Resource_ko	NVARCHAR(50)	= 'Table Games',
	@Resource_es	NVARCHAR(50)	= 'Table Games',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= 'Table Games',
	@Resource_vn	NVARCHAR(50)	= 'Table Games',
	@Resource_pl	NVARCHAR(50)	= 'Table Games',
	@Resource_id	NVARCHAR(50)	= 'Table Games',
	@Resource_hi	NVARCHAR(50)	= 'Table Games',
	@Resource_mm	NVARCHAR(50)	= 'Table Games',
	@Resource_fr	NVARCHAR(50)	= 'Table Games',
	@Resource_ru	NVARCHAR(50)	= 'Table Games',
	@Resource_pt	NVARCHAR(50)	= 'Table Games',
	@Resource_de	NVARCHAR(50)	= 'Table Games'
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de

SELECT * FROM RefResource WHERE RefId = 'Product'
