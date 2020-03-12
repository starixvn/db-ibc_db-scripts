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
 
--------------Ref Resource---------------------------------------
---4
UPDATE RefResource 
SET	  Resource_en = 'Live Casino'
WHERE RefId = 'Product' AND ResourceId = 41
