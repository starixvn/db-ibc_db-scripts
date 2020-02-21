use bodb02
GO 
 /*
 Create: 20200221@Sophia
 DB: DBPRO-bodb02
 Task: SA Gaming  [Redmine: #128057]
1. Change product name Live Casino-[4] --> SLI Live Casino 
2. Add product dummy Live Casino - [41]
3. Add new product SA Gaming --[39]
4. Add SportbettypeMatrix 

*/

---------------------Products---------------------------------
---1. Update 4
UPDATE Products
SET  ProductName = 'SLI Live Casino'
	,Description = 'SLI Live Casino'
WHERE ProductID = 4

---2. Insert dummy 41
INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (41,'Live Casino','Live Casino','LC2',1,NULL,NULL,1,2,0,NULL)
 
---3. insert 39
INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun, VendorId) VALUES (39,'SA Gaming','SA Gaming','SAG',1,3,NULL,0,2,0,39)


--------------Ref Resource---------------------------------------
---4
UPDATE RefResource 
SET	  Resource_en = 'SLI Live Casino'
WHERE RefId = 'Product' AND ResourceId = 4

---41
INSERT INTO RefResource (RefId,ResourceId,Resource_en,Resource_ch,Resource_cs,Resource_jp,Resource_it,Resource_th,Resource_ko,Resource_es,Sort1,Sort2,
						Resource_el,Resource_vn,Resource_pl,Resource_id,Resource_hi,Resource_mm,Resource_fr,Resource_ru,Resource_pt,Resource_de)

SELECT RefId, 41 AS ResourceId,Resource_en,Resource_ch,Resource_cs,Resource_jp,Resource_it,Resource_th,Resource_ko,Resource_es,Sort1,Sort2,
	   Resource_el,Resource_vn,Resource_pl,Resource_id,Resource_hi,Resource_mm,Resource_fr,Resource_ru,Resource_pt,Resource_de
FROM RefResource 
WHERE RefId = 'Product' AND ResourceId = 4
 
  
---39
--Insert Remoting ref Product
DECLARE @RefId		VARCHAR(20)		= 'Product',
	@ResourceId		VARCHAR(20)		= 39,
	@Resource_en	NVARCHAR(50)	= 'SA Gaming',
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

----------------------------------sportbettypematrix-------------------------------------------
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3001,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3002,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3003,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3004,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3005,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3006,0,39,1,0,0,'',2)
insert into sportbettypematrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable) values (244,3007,0,39,1,0,0,'',2)