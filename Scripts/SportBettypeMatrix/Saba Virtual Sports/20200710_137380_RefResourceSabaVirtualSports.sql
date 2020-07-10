/*<info serverAlias="DBPRO-bodb02" step="1"></info>*/
/*	

	DB: DBPRO/bodb02
	Create: 20200710@Sophia
	Task: Add product dummy for Saba Virtual Sports [redmine: #137380]
*/ 
USE bodb02
GO

--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 54,
	@Resource_en	NVARCHAR(50)	= 'Saba Virtual Sports',
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
 