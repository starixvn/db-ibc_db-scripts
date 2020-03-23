/*	
	Create : 20200322@Sophia
	Task: Sexy Gaming - Products, SportbettypeMatrix [redmine: #130809]
	DB: DBPRO/bodb02
*/
USE bodb02
GO 

INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (45,'Sexy Gaming','Sexy Gaming','SXG',1,3,NULL,0,2,0,45)

insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (243,3101,0,45,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (243,3102,0,45,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (243,3103,0,45,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (243,3104,0,45,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (243,3105,0,45,1,0,0,'',2)




--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 45,
	@Resource_en	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_ch	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_cs	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_jp	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_it	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_th	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_ko	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_es	NVARCHAR(50)	= 'Sexy Gaming',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_vn	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_pl	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_id	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_hi	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_mm	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_fr	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_ru	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_pt	NVARCHAR(50)	= 'Sexy Gaming',
	@Resource_de	NVARCHAR(50)	= 'Sexy Gaming'
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de
 

