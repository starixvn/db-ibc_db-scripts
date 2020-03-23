/*	
    Create : 20200323
	DB: DBPRO/bodb02
	Task: Product Indo 4D [Redmine: #130236]
*/
USE bodb02
GO


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (43,'Indo 4D','Indo 4D','I4D',1,4,NULL,0,0,0,43)


insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5001,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5002,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5003,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5004,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5005,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5006,0,43,1,0,0,'',3)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (223,5007,0,43,1,0,0,'',3)


--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 43,
	@Resource_en	NVARCHAR(50)	= 'Indo 4D',
	@Resource_ch	NVARCHAR(50)	= '',
	@Resource_cs	NVARCHAR(50)	= '',
	@Resource_jp	NVARCHAR(50)	= '',
	@Resource_it	NVARCHAR(50)	= '',
	@Resource_th	NVARCHAR(50)	= '',
	@Resource_ko	NVARCHAR(50)	= '',
	@Resource_es	NVARCHAR(50)	= '',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= '',
	@Resource_vn	NVARCHAR(50)	= '',
	@Resource_pl	NVARCHAR(50)	= NULL,
	@Resource_id	NVARCHAR(50)	= NULL,
	@Resource_hi	NVARCHAR(50)	= NULL,
	@Resource_mm	NVARCHAR(50)	= NULL,
	@Resource_fr	NVARCHAR(50)	= NULL,
	@Resource_ru	NVARCHAR(50)	= NULL,
	@Resource_pt	NVARCHAR(50)	= NULL,
	@Resource_de	NVARCHAR(50)	= NULL
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de

SELECT * FROM RefResource WHERE RefId = 'Product'
