/*<info serverAlias="DBPRO-bodb02" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/
/*	
	Create : 20200514@Malcolm
	Task:  insert RNGCasino into refresource and new product[redmine: #132760]
	DB: DBPRO/bodb02
*/
USE bodb02
GO 

--insert new product

INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) 
VALUES (53,'RNG Casino','RNG Casino','RNGC2',1,NULL,NULL,1,1,0,NULL)

--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 53,
	@Resource_en	NVARCHAR(50)	= 'RNG Casino',
	@Resource_ch	NVARCHAR(50)	= '娛樂城',
	@Resource_cs	NVARCHAR(50)	= '娱乐城',
	@Resource_jp	NVARCHAR(50)	= '',
	@Resource_it	NVARCHAR(50)	= '',
	@Resource_th	NVARCHAR(50)	= 'คาสิโน',
	@Resource_ko	NVARCHAR(50)	= '',
	@Resource_es	NVARCHAR(50)	= '',
	@Sort1			INT				= NULL,
	@Sort2			INT				= NULL,
	@Resource_el	NVARCHAR(50)	= '',
	@Resource_vn	NVARCHAR(50)	= '',
	@Resource_pl	NVARCHAR(50)	= '',
	@Resource_id	NVARCHAR(50)	= '',
	@Resource_hi	NVARCHAR(50)	= '',
	@Resource_mm	NVARCHAR(50)	= '',
	@Resource_fr	NVARCHAR(50)	= '',
	@Resource_ru	NVARCHAR(50)	= '',
	@Resource_pt	NVARCHAR(50)	= '',
	@Resource_de	NVARCHAR(50)	= ''
							   
INSERT INTO RefResource (RefId, ResourceId, Resource_en, Resource_ch, Resource_cs, Resource_jp, Resource_it, Resource_th, Resource_ko, Resource_es, Sort1, Sort2, Resource_el, Resource_vn, Resource_pl, Resource_id, Resource_hi, Resource_mm, Resource_fr, Resource_ru, Resource_pt, Resource_de)
SELECT @RefId, @ResourceId, @Resource_en, @Resource_ch, @Resource_cs, @Resource_jp, @Resource_it, @Resource_th, @Resource_ko, @Resource_es, @Sort1, @Sort2, @Resource_el, @Resource_vn, @Resource_pl, @Resource_id, @Resource_hi, @Resource_mm, @Resource_fr, @Resource_ru, @Resource_pt, @Resource_de
 

