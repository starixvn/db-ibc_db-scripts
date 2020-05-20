use bodb02
GO 
/*
Create : 20200520@Sophia
Task: Add RNG War[redmine :#132001]
DB: DBPRO.bodb02
*/


INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (50,'RNG War','RNG War','RNGW',1,4,NULL,0,0,0,50)


insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (224,5500,0,50,1,0,0,'',1)


 
--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 50,
	@Resource_en	NVARCHAR(50)	= 'RNG War',
	@Resource_ch	NVARCHAR(50)	= N'',
	@Resource_cs	NVARCHAR(50)	= N'',
	@Resource_jp	NVARCHAR(50)	= N'',
	@Resource_it	NVARCHAR(50)	= N'',
	@Resource_th	NVARCHAR(50)	= N'',
	@Resource_ko	NVARCHAR(50)	= N'',
	@Resource_es	NVARCHAR(50)	= N'',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= N'',
	@Resource_vn	NVARCHAR(50)	= N'',
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
 

