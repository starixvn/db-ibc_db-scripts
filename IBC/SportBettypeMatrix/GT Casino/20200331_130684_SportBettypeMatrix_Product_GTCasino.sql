Use bodb02
GO 
/*
Create : 20200331@Sophia 
Task: SportbettypeMatrix, product of GT - local test [redmineID: #130684]
DB: DBPRO.bodb02
*/


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (46,'GT Casino','GT Casino','GTC',1,3,NULL,0,2,0,46)

insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3201,0,46,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3202,0,46,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3203,0,46,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3204,0,46,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3205,0,46,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (242,3206,0,46,1,0,0,'',2)


/*	
	DB: DBPRO/bodb02
*/
USE bodb02
GO

--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 46,
	@Resource_en	NVARCHAR(50)	= 'GT Casino',
	@Resource_ch	NVARCHAR(50)	= 'GT Casino',
	@Resource_cs	NVARCHAR(50)	= 'GT Casino',
	@Resource_jp	NVARCHAR(50)	= 'GT Casino',
	@Resource_it	NVARCHAR(50)	= 'GT Casino',
	@Resource_th	NVARCHAR(50)	= 'GT Casino',
	@Resource_ko	NVARCHAR(50)	= 'GT Casino',
	@Resource_es	NVARCHAR(50)	= 'GT Casino',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= 'GT Casino',
	@Resource_vn	NVARCHAR(50)	= 'GT Casino',
	@Resource_pl	NVARCHAR(50)	= 'GT Casino',
	@Resource_id	NVARCHAR(50)	= 'GT Casino',
	@Resource_hi	NVARCHAR(50)	= 'GT Casino',
	@Resource_mm	NVARCHAR(50)	= 'GT Casino',
	@Resource_fr	NVARCHAR(50)	= 'GT Casino',
	@Resource_ru	NVARCHAR(50)	= 'GT Casino',
	@Resource_pt	NVARCHAR(50)	= 'GT Casino',
	@Resource_de	NVARCHAR(50)	= 'GT Casino'
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de

SELECT * FROM RefResource WHERE RefId = 'Product'
